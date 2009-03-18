require 'libxml'
require 'libxslt'

module Schematron

  # The location of the ISO schematron implemtation lives
  ISO_IMPL_DIR = 'iso_impl'

  # The file names of the compilation stages
  ISO_FILES = [ 'iso_dsdl_include.xsl',
                'iso_abstract_expand.xsl',
                'iso_svrl.xsl' ]

  # Namespace prefix declarations for use in XPaths
  NS_PREFIXES = {
    'svrl' => 'http://purl.oclc.org/dsdl/svrl'
  }

  class Schema

    def initialize(doc)
      @schema_doc = doc
    end

    def validate(instance_doc)

      # Tell the parse to remember the line numbers for each node
      # TODO make a new parse for this and not mess with defaults
      old_line_numbers = XML::Parser::default_line_numbers
      XML::Parser::default_line_numbers = true

      # Compile schematron into xsl that maps to svrl
      xforms = ISO_FILES.map do |file|
        doc = Dir.chdir(ISO_IMPL_DIR) { XML::Document.file file }
        XSLT::Stylesheet.new doc
      end

      validator_doc = xforms.inject(schema_doc) { |xml, xsl| xsl.apply xml }
      validator_xsl = XSLT::Stylesheet.new validator_doc

      # Validate the xml
      results_doc = validator_xsl.apply instance_doc

      # restore old state
      XML::Parser::default_line_numbers = old_line_numbers

      # compile the errors
      results = []
      results_doc.root.find('//svrl:failed-assert', NS_PREFIXES).each do |assert|
        context = instance_doc.root.find_first assert['location']

        assert.find('svrl:text/text()', NS_PREFIXES).each do |message|
          results << {
            :type => context.node_type_name,
            :name => context.name,
            :line => context.line_num,
            :message => message.content.strip
          }
        end

        results
      end

    end

  end

end
