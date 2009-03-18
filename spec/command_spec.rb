require 'spec_helper'
require 'schematron'

describe "validate executable" do
  
  it "should take only a schema and an instance document" do
    `ruby -Ilib bin/validate theschema`.should =~ /Usage: /
  end
  
  it "should validate a good instance doc" do
    schema = 'spec/schema/fda_sip.sch'
    instance = 'spec/instances/daitss-sip/Example1.xml'
    `ruby -Ilib bin/validate #{schema} #{instance}`.should be_empty
  end
  
  it "should print errors to standard out" do
    schema = 'spec/schema/fda_sip.sch'
    instance = 'spec/instances/daitss-sip/Example2.xml'
    `ruby -Ilib bin/validate #{schema} #{instance}`.should =~ /^element "file" on line 48/
  end
  
end
