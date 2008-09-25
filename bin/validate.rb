#!/usr/bin/ruby

require 'libxml'
require 'libxslt'

include LibXML
include LibXSLT

ISO_IMPL_DIR = 'iso_impl'
ISO_FILES = [ 'iso_dsdl_include.xsl',
              'iso_abstract_expand.xsl',
              'iso_svrl.xsl' ]

# Tell the parse to remember the line numbers for each node
XML::Parser::default_line_numbers = true

# Get sch and xml from command line
schema_doc = XML::Document.file ARGV[0]
instance_doc = XML::Document.file ARGV[1]

# Compile schematron into xsl
validator_xsl = Dir.chdir ISO_IMPL_DIR do

  xforms = ISO_FILES.map do |file|
    doc = XML::Document.file file
    xsl = XSLT::Stylesheet.new doc
  end

  validator_doc = xforms.inject(schema_doc) { |xml, xsl| xsl.apply xml }
  XSLT::Stylesheet.new validator_doc
end

# Validate the xml with the
results_doc = validator_xsl.apply instance_doc

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
