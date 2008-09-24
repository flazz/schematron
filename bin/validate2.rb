#!/usr/bin/ruby

require 'libxml'

include LibXML

# TODO make the namespace prefixes transparant

XML::Parser::default_line_numbers=true

results_doc = XML::Document.file('output.xml')
instance_doc = XML::Document.file('instances/Example2.xml')

locations = results_doc.root.find('//svrl:failed-assert').map do |assert|
  i_node = instance_doc.root.find_first assert['location']

  assert.find('svrl:text/text()').each do |message|
    puts '%s "%s" on line %d: %s' % [i_node.node_type_name, 
                                     i_node.name, 
                                     i_node.line_num,
                                     message.content.strip]
  end

end
