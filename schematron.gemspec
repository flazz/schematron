Gem::Specification.new do |spec|
  spec.name = "schematron"
  spec.version = '0.1.1'
  spec.summary = "ISO Schematron Validation"
  spec.email = "flazzarino@gmail.com"
  spec.homepage = 'http://github.com/flazz/schematron'
  spec.authors = ["Francesco Lazzarino"]
  #spec.rubyforge_project = 'schematron'
  
  spec.executables << 'stron'
    
  spec.files = ["Rakefile", "schematron.gemspec", "README.md", "LICENSE.txt",
                "bin/stron",
                "lib/schematron.rb",
                "iso_impl/iso_abstract_expand.xsl",
                "iso_impl/iso_dsdl_include.xsl",
                "iso_impl/iso_schematron_skeleton_for_saxon.xsl",
                "iso_impl/iso_schematron_skeleton_for_xslt1.xsl",
                "iso_impl/iso_schematron_text.xsl",
                "iso_impl/iso_svrl.xsl",
                "spec/command_spec.rb",
                "spec/feature_requests_spec.rb",
                "spec/instances",
                "spec/instances/daitss-sip",
                "spec/instances/daitss-sip/Example1.xml",
                "spec/instances/daitss-sip/Example2.xml",
                "spec/instances/premis-in-mets",
                "spec/instances/premis-in-mets/bad.xml",
                "spec/instances/premis-in-mets/good.xml",
                "spec/schema",
                "spec/schema/fda_sip.sch",
                "spec/schema/pim.sch",
                "spec/schema_spec.rb",
                "spec/spec_helper.rb"]

  spec.add_dependency 'libxml-ruby', '>= 1.1.3'
  spec.add_dependency 'libxslt-ruby', '>= 0.9.1'
end
