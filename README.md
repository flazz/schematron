ISO Schematron
==============

Ruby gem for validating XML against schematron schema

Uses [ISO Schematron](http://www.schematron.com) version: 2010-01-25

Installation
------------

    % gem install schematron

Command line example
-------------------

    % stron my_schema.stron my_xml_document.xml

Ruby API example
----------------

    # overhead
    require "libxml"
    require "schematron"
    
    include LibXML
    
    # load the schematron xml
    stron_doc = XML::Document.file "/path/to/my_schema.stron"
    
    # make a schematron object
    stron = Schematron::Schema.new stron_doc
    
    # load the xml document you wish to validate
    xml_doc = XML::Document.file "/path/to/my_xml_document.xml"
    
    # validate it
    results = stron.validate xml_doc
    
    # print out the results
    stron.validate(instance_doc).each do |error|
      puts "#{error[:line]}: #{error[:message]}"
    end
    
---

Copyright © 2009-2010 [Francesco Lazzarino](mailto:flazzarino@gmail.com).

Sponsored by [Florida Center for Library Automation](http://www.fcla.edu).

See LICENSE.txt for terms.
