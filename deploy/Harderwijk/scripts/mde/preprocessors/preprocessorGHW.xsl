<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gfc="http://www.isotc211.org/2005/gfc"
        xmlns:gmx="http://www.isotc211.org/2005/gmx"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:b3p="http://www.b3partners.nl/xsd/metadata"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        >
            
	<xsl:output method="xml" indent="yes"/>

	<!-- Vult defaults in voor GEMET thesaurus -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="copyWithNewText">
		<xsl:param name="newCodeListValue"/>
		<xsl:param name="newText"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="normalize-space($newCodeListValue) != '' and normalize-space(@codeListValue) = '' ">
					<!-- 'apply-templates' moet voor 'attribute' uitgeoverd worden!! -->
					<xsl:apply-templates select="@*"/><!-- no mixed nodes supported -->
					<xsl:attribute name="codeListValue"><xsl:value-of select="$newCodeListValue"/></xsl:attribute>
					<xsl:value-of select="$newText"/>
				</xsl:when>
				<xsl:when test="normalize-space(.) = '' ">
					<xsl:apply-templates select="@*"/><!-- no mixed nodes supported -->
					<xsl:value-of select="$newText"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:call-template name="copyWithNewText">
			<xsl:with-param name="newText">GEMET (Dutch), version 3.0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date">
		<xsl:call-template name="copyWithNewText">
			<xsl:with-param name="newText">2011-07-13</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode">
		<xsl:call-template name="copyWithNewText">
			<xsl:with-param name="newCodeListValue">publication</xsl:with-param>
			<xsl:with-param name="newText">publicatie</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	
</xsl:stylesheet>