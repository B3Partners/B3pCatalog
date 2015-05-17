<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" exclude-result-prefixes="csw gmd gco">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:for-each select="csw:GetRecordsResponse/csw:SearchResults">
			<html>
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<title>CSW resultaten</title>
					<script type="text/javascript">
						function showWindow() {
							parent.document.getElementById('result2Div').style.display = 'block';
						}
						function attachUrl(domid, identifier) {
              // url-escaped versions of special characters:
              var questionMark = "%3F";
              var ampersand = "%26";
              // create the url:
              var url = "/mdez/scc" + questionMark +
                        "p=AnyText" + ampersand +
                        "x=md-response.xsl" + ampersand +
                        "mdxsl=wStartMDE.xslt" + ampersand +
                        "q=" + encodeURIComponent(identifier);
              // assign the url:
							var elem = document.getElementById(domid);
							elem.href = decodeURIComponent(url);
						}
                    </script>
					<link href="js/metadataEditor/styles/metadataEdit.css" rel="stylesheet" type="text/css"/>
					<!--[if lte IE 7]> <link href="js/metadataEditor/styles/metadataEdit-ie.css" rel="stylesheet" type="text/css" /> <![endif]-->
				</head>
				<body>
					<xsl:for-each select="gmd:MD_Metadata">
            <xsl:call-template name="writeResults"/>
					</xsl:for-each>
					<xsl:for-each select="metadata/gmd:MD_Metadata">
            <xsl:call-template name="writeResults"/>
					</xsl:for-each>
				</body>
			</html>
		</xsl:for-each>
	</xsl:template>

  <xsl:template name="writeResults">
    <xsl:variable name="nummer" select="position()"/>
    <xsl:variable name="alttekst">
      <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
        <xsl:for-each select="gmd:MD_DigitalTransferOptions/gmd:online/gmd:CI_OnlineResource |
                              gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
          <xsl:for-each select="gmd:linkage">
            <xsl:value-of select="gmd:URL"/>
            <br/>
          </xsl:for-each>
          <xsl:for-each select="gmd:protocol">
            <xsl:value-of select="gmd:SV_ServiceType"/>
            <br/>
          </xsl:for-each>
          <xsl:for-each select="gmd:name">
            <xsl:value-of select="gco:CharacterString"/>
            <br/>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="identifier">
      <xsl:for-each select="gmd:fileIdentifier">
        <xsl:value-of select="gco:CharacterString"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification">
      <fieldset>
        <legend>
          <xsl:element name="a">
            <xsl:attribute name="target">result2Window</xsl:attribute>
            <xsl:attribute name="onClick">showWindow();</xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="$alttekst"/></xsl:attribute>
            <xsl:attribute name="id"><xsl:text>href</xsl:text><xsl:value-of select="$nummer"/></xsl:attribute>
            <xsl:value-of select="$nummer"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="gmd:citation/gmd:CI_Citation/gmd:title">
              <xsl:value-of select="gco:CharacterString"/>
            </xsl:for-each>
            <xsl:text> bekijken</xsl:text>
          </xsl:element>
          <script type="text/javascript">
            <xsl:text>attachUrl("</xsl:text>
            <xsl:text>href</xsl:text><xsl:value-of select="$nummer"/>
            <xsl:text>", "</xsl:text>
            <xsl:value-of select="$identifier"/>
            <xsl:text>");</xsl:text>
          </script>
        </legend>
        <xsl:for-each select="gmd:abstract">
          <xsl:value-of select="gco:CharacterString"/>
        </xsl:for-each>
      </fieldset>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
