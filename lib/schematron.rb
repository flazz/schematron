require 'libxml'
require 'libxslt'

module Schematron

  include LibXML
  include LibXSLT

  # The location of the ISO schematron implemtation lives
  ISO_IMPL_DIR = File.join File.dirname(__FILE__), "..", 'iso-schematron-xslt1'

  # The file names of the compilation stages
  ISO_FILES = [ 'iso_dsdl_include.xsl',
                'iso_abstract_expand.xsl',
                'iso_svrl_for_xslt1.xsl' ]

  # Namespace prefix declarations for use in XPaths
  NS_PREFIXES = {
    'svrl' => 'http://purl.oclc.org/dsdl/svrl'
  }

  class Schema

    def initialize(doc)
      schema_doc = doc

      xforms = ISO_FILES.map do |file|

        Dir.chdir(ISO_IMPL_DIR) do
          doc = open(file) { |io| XML::Document.string io.read }
          LibXSLT::XSLT::Stylesheet.new doc
        end

      end
      
      # Compile schematron into xsl that maps to svrl
      validator_doc = xforms.inject(schema_doc) { |xml, xsl| xsl.apply xml }
      @validator_xsl = LibXSLT::XSLT::Stylesheet.new validator_doc
    end

    def validate(instance_doc)

      # Validate the xml
      results_doc = @validator_xsl.apply instance_doc

      # compile the errors and log any messages
      rule_hits(results_doc, instance_doc, 'assert', '//svrl:failed-assert') +
      rule_hits(results_doc, instance_doc, 'report', '//svrl:successful-report')
    end
    
    # Look for reported or failed rules of a particular type in the instance doc
    def rule_hits(results_doc, instance_doc, rule_type, xpath)
      
      results = []
      
      results_doc.root.find(xpath, NS_PREFIXES).each do |hit|
        context = instance_doc.root.find_first hit['location']
        
        hit.find('svrl:text/text()', NS_PREFIXES).each do |message|
          results << {
            :rule_type => rule_type,
            :type => context.node_type_name,
            :name => context.name,
            :line => context.line_num,
            :message => message.content.strip }
        end
      end
      
      results
      
    end

  end

end
