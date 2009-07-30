<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>
    Florida Digital Archive SIP Validation
  </title>
  
  <ns prefix="mets" uri="http://www.loc.gov/METS/"/>
  <ns prefix="pre" uri="info:lc/xmlns/premis-v2"/>
  <ns prefix="dts" uri="http://www.fcla.edu/dls/md/daitss/"/>

  <pattern name="PREMIS object should bein the proper buckets">
    
    <rule context="//pre:event">
      <assert test="parent::mets:xmlData/parent::mets:mdWrap/parent::mets:digiprovMD">
	PREMIS events must be contained in a METS digiprovMD
      </assert>
    </rule>

    <rule context="//pre:object">
      <assert test="parent::mets:xmlData/parent::mets:mdWrap/parent::mets:techMD">
	PREMIS objects must be contained in a METS techMD
      </assert> 
    </rule>

  </pattern>
  
  <pattern name="METS should have embedded PREMIS">
    <rule context="mets:mets">
      <report test="not(//mets:mdWrap[@MDTYPE='PREMIS'])">
        This METS file has no embedded PREMIS
      </report>
    </rule>
  </pattern>

</schema>
