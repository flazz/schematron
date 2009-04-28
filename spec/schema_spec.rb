require File.join(File.dirname(__FILE__), 'spec_helper')
require 'schematron'
require 'libxml'

include LibXML

describe Schematron::Schema do

  it "should load a schema from a libxml document" do
    file = File.join "spec", "schema", "pim.sch"
    parser = XML::Parser.file file
    doc = parser.parse
    XML.default_line_numbers = true
    lambda { Schematron::Schema.new doc }.should_not raise_error
  end

  it "should validate a good instance doc" do
    schema_file = File.join 'spec', 'schema', 'fda_sip.sch'
    instance_file = File.join 'spec', 'instances', 'daitss-sip', 'Example1.xml'

    schema_doc = XML::Parser.file(schema_file).parse
    instance_doc = XML::Parser.file(instance_file).parse

    stron = Schematron::Schema.new schema_doc
    results = stron.validate instance_doc
    
    results.should be_empty
  end
  
  it "should detect errors for a bad document" do
    schema_file = File.join 'spec', 'schema', 'fda_sip.sch'
    instance_file = File.join 'spec', 'instances', 'daitss-sip', 'Example2.xml'

    schema_doc = XML::Parser.file(schema_file).parse
    instance_doc = XML::Parser.file(instance_file).parse

    stron = Schematron::Schema.new schema_doc
    results = stron.validate instance_doc
    
    results.should_not be_empty
  end
  
end
