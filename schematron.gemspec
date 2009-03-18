Gem::Specification.new do |spec|
  spec.name = "schematron"
  spec.version = '0.0.0'
  spec.summary = "ISO Schematron Validation"
  spec.email = "flazzarino@gmail.com"
  spec.homepage = 'http://github.com/flazz/iso-schematron'
  spec.authors = ["Francesco Lazzarino"]
  
  spec.files = ["Rakefile", "schematron.gemspec",
                "bin/validate",
                "bin/validate-sh"]
  
  spec.has_rdoc = true
end
