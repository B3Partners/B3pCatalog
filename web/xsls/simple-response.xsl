<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" exclude-result-prefixes="csw gmd gco">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
	<xsl:template match="/">
		<xsl:for-each select="csw:GetRecordsResponse/csw:SearchResults">
			<response>
				<xsl:for-each select="gmd:MD_Metadata">
          <xsl:call-template name="writeResults"/>
				</xsl:for-each>
				<xsl:for-each select="metadata/gmd:MD_Metadata">
          <xsl:call-template name="writeResults"/>
				</xsl:for-each>
			</response>
		</xsl:for-each>
	</xsl:template>

  <xsl:template name="writeResults">
    <item>
      <xsl:for-each select="gmd:fileIdentifier">
        <identifier>
          <xsl:value-of select="gco:CharacterString"/>
        </identifier>
      </xsl:for-each>
      <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification">
        <xsl:for-each select="gmd:citation/gmd:CI_Citation/gmd:title">
          <title>
            <xsl:value-of select="gco:CharacterString"/>
          </title>
        </xsl:for-each>
        <xsl:for-each select="gmd:abstract">
          <abstract>
            <xsl:value-of select="gco:CharacterString"/>
          </abstract>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:online/gmd:CI_OnlineResource |
                            gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
        <resource>
          <xsl:for-each select="gmd:linkage">
            <linkage>
              <xsl:value-of select="gmd:URL"/>
            </linkage>
          </xsl:for-each>
          <xsl:for-each select="gmd:protocol/gmd:SV_ServiceType">
            <protocol>
              <xsl:value-of select="."/>
            </protocol>
          </xsl:for-each>
          <xsl:for-each select="gmd:protocol/gco:CharacterString">
            <protocol>
              <xsl:value-of select="."/>
            </protocol>
          </xsl:for-each>
          <xsl:for-each select="gmd:name">
            <name>
              <xsl:value-of select="gco:CharacterString"/>
            </name>
          </xsl:for-each>
        </resource>
      </xsl:for-each>
    </item>
  </xsl:template>

</xsl:stylesheet>
