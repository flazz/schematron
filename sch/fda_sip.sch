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

  <pattern name="All files must have a location">
    <rule context="//mets:file">
      <assert test="mets:FLocat">a file must have a location</assert>
      <assert test="mets:FLocat/@xlink:href">a file location must have a path reference</assert>
    </rule>
  </pattern>

  <pattern name="All file checksums must be proper MD5 or SHA-1">

    <rule context="//mets:file[@CHECKSUM and @CHECKSUMTYPE = 'MD5']">
      <assert test="string-length(@CHECKSUM) = 32">
	MD5 must be 32 characters
      </assert>
      <assert test="string-length(translate(@CHECKSUM, '0987654321abcdefABCDEF', '')) = 0">
	MD5 must be only characters 0-9, A-Z, a-z
      </assert>
    </rule>

    <rule context="//mets:file[@CHECKSUM and @CHECKSUMTYPE = 'SHA-1']">
      <assert test="string-length(@CHECKSUM) = 40">
	SHA-1 must be 40 characters
      </assert>
      <assert test="string-length(translate(@CHECKSUM, '0987654321abcdefABCDEF', '')) = 0">
	SHA-1 must be only characters 0-9, A-Z, a-z
      </assert>
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
