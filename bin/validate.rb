#!/usr/bin/ruby

require 'libxml'
require 'libxslt'

include LibXML
include LibXSLT

ISO_IMPL_DIR='iso_impl'
ISO_FILES = [ 'iso_dsdl_include.xsl', 
                    'iso_abstract_expand.xsl', 
                    'iso_svrl.xsl' ]

XML::Parser::default_line_numbers = true
instance_doc = XML::Document.file ARGV[1]

# Compile schematron into xsl
instance_doc = XML::Document.file ARGV[1]
schema_doc = XML::Document.file ARGV[0]

validator = Dir.chdir ISO_IMPL_DIR do
  
  v = ISO_FILES.inject(schema_doc) do |stage,file|
    doc = XML::Document.file file
    stylesheet = XSLT::Stylesheet.new doc
    stylesheet.apply stage
  end
  
  XSLT::Stylesheet.new v

end

results_doc = validator.apply instance_doc

errors = []
results_doc.root.find('//svrl:failed-assert', 'svrl' => 'http://purl.oclc.org/dsdl/svrl').each do |assert|
  context = instance_doc.root.find_first assert['location']

  assert.find('svrl:text/text()', 'svrl' => 'http://purl.oclc.org/dsdl/svrl').each do |message|
    errors << '%s "%s" on line %d: %s' % [ context.node_type_name,
                                           context.name, 
                                           context.line_num,
                                           message.content.strip ]
  end

end

errors.each do |error|
  puts error
end
