<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>
    Florida Digital Archive SIP Validation
  </title>

  <ns prefix="mets" uri="http://www.loc.gov/METS/"/>
  <ns prefix="dts" uri="http://www.fcla.edu/dls/md/daitss/"/>
  <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

  <pattern name="Descriptor should have Agreement Info">

    <rule context="/mets:mets">
      <assert test="mets:amdSec/mets:digiprovMD/mets:mdWrap/mets:xmlData/dts:daitss/dts:AGREEMENT_INFO">
	A digiprovMD wrapping an AGREEMENT_INFO element is required
      </assert> 
    </rule>

    <rule context="//dts:AGREEMENT_INFO">
      <assert test="@ACCOUNT">Agreement Info must have an account</assert> 
      <assert test="@PROJECT">Agreement Info must have a project</assert> 
    </rule>

  </pattern>

  <pattern name="All files must have a message digest and location">
    <rule context="//mets:file">
      <assert test="@CHECKSUM">a file must have a checksum</assert> 
      <assert test="@CHECKSUMTYPE">a file must have a checksum type</assert>
      <assert test="mets:FLocat">a file must have a location</assert>
      <assert test="mets:FLocat/@xlink:href">a file location must have a path reference</assert>
    </rule>
  </pattern>

  <pattern name="All checksums must be">
    <rule context="//mets:file">
      <assert test="@CHECKSUM">a file must have a CHECKSUM attribute</assert> 
      <assert test="@CHECKSUMTYPE">a file must have a CHECKSUMTYPE attribute</assert>
      <assert test="mets:FLocat">a file must have a FLocat child</assert>
      <assert test="mets:FLocat/@xlink:href">a FLocat must have a xlink:href attribute</assert>
    </rule>
  </pattern>
  
  <pattern name="All files must be referenced in the structMap">
    <rule context="//mets:file">
      <assert test="./@ID = //mets:fptr/@FILEID">
	file must be referenced in the structMap
      </assert>
    </rule>
  </pattern>

  <pattern name="All files must be referenced in the structMap">
    <rule context="//mets:fptr">
      <assert test="./@FILEID = //mets:file/@ID">
	file pointer must reference a file
      </assert>
    </rule>
  </pattern>


</schema>