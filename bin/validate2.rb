#!/usr/bin/ruby

require 'libxml'
require 'libxslt'

include LibXML
include LibXSLT

XML::Parser::default_line_numbers=true

def transform(stylesheet, instance)

  # Build the stylesheet
  stylesheet = XSLT::Stylesheet.new case stylesheet
                                    when LibXML::XML::Document 
                                      stylesheet
                                    when String
                                      XML::Document.file stylesheet
                                    end

  # Transform the instance
  stylesheet.apply case instance
                   when LibXML::XML::Document
                     instance
                   when String
                     XML::Document.file instance
                   end
end

def validate(sch, instance)
  p1 = transform 'iso_dsdl_include.xsl', sch
  p2 = transform 'iso_abstract_expand.xsl', p1
  p3 = transform 'iso_svrl.xsl', p2
  transform p3, instance
end

# TODO make the namespace prefixes transparant

instance_doc = XML::Document.file '../instances/Example2.xml'
results_doc = validate '../sch/fda_sip.sch', instance_doc

errors = []
results_doc.root.find('//svrl:failed-assert').each do |assert|
  context = instance_doc.root.find_first assert['location']

  assert.find('svrl:text/text()').each do |message|
    errors << '%s "%s" on line %d: %s' % [ context.node_type_name,
                                           context.name, 
                                           context.line_num,
                                           message.content.strip ]
  end

end

errors.each do |error|
  puts error
end
