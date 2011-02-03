<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" exclude-result-prefixes="csw gmd gco">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
    <xsl:for-each select="csw:GetRecordsResponse/csw:SearchResults/*">
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment>
            <xsl:value-of select="name()"/>
            <xsl:text>-tag </xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> removed</xsl:text>
          </xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
