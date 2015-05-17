<?xml version="1.0" encoding="UTF-8"?>
<!--
B3P Metadata Editor is a ISO 19139 compliant metadata editor, 
that is preconfigured to use the Dutch profile for geography

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Metadata Editor.

B3P Kaartenbalie is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Kaartenbalie is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Kaartenbalie.  If not, see <http://www.gnu.org/licenses/>.
-->
<!-- 
Invoer voor deze file moet de file "ML_gmxCodelists.xml" of "gmxCodelists.xml" zijn.
Die zijn allebei onderdeel van de ISO 19115 geografische metadata standaard.
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gml="http://www.opengis.net/gml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="anything" exclude-result-prefixes="gmx gml">
	<!-- de waarde van xmlns:x mag alles zijn -->
	<xsl:output method="xml" indent="yes"/>
	<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl"/>
	<!-- Deze variabele wordt nog niet gebruikt; Nog geen Nederlandse vertaling gevonden -->
	<xsl:variable name="locale">nl-nl</xsl:variable>
	<!--
everything between the xsl:template tags
is outputted to the new stylesheet
-->
	<xsl:template match="/">
		<x:stylesheet version="1.0">
			<xsl:apply-templates select="gmx:CT_CodelistCatalogue/gmx:codelistItem"/>
		</x:stylesheet>
	</xsl:template>
	<xsl:template match="versionNumber">

	</xsl:template>
	<xsl:template match="versionDate">
	
	</xsl:template>
	<xsl:template match="language">
	
	</xsl:template>
	<xsl:template match="characterSet">
	
	</xsl:template>
	<xsl:template match="codelistItem">
		<xsl:apply-templates select="gmx:ML_CodeListDictionary | gmx:CodeListDictionary"/>
	</xsl:template>
	<xsl:template match="gmx:ML_CodeListDictionary | gmx:CodeListDictionary">
		<xsl:variable name="picklistId" select="concat('picklist_', @gml:id)"/>
		<x:template name="{$picklistId}">
			<select id="{$picklistId}" name="{$picklistId}" onchange="selectPickListValue(event)" onblur="destroyPickList(event)" onkeypress="pickListKeyPress(event)" onkeydown="pickListKeyPress(event)">
				<!--<option value="default">[huidige waarde]</option>-->
				<xsl:apply-templates select="gmx:codeEntry"/>
			</select>
		</x:template>
	</xsl:template>
	<xsl:template match="gmx:codeEntry">
		<xsl:apply-templates select="gmx:ML_CodeDefinition | gmx:CodeDefinition"/>
	</xsl:template>
	<xsl:template match="gmx:ML_CodeDefinition | gmx:CodeDefinition">
		<xsl:choose>
			<xsl:when test="string-length($locale)>0">
				<xsl:variable name="optionId">
					<xsl:value-of select="gmx:alternativeExpression/gmx:CodeAlternativeExpression[@codeSpace=$locale]/gml:identifier"/>
				</xsl:variable>
				<xsl:variable name="optionName">
					<xsl:choose>
						<xsl:when test="string-length(gmx:alternativeExpression/gmx:CodeAlternativeExpression[@codeSpace=$locale]/gml:name)>0">
							<xsl:value-of select="gmx:alternativeExpression/gmx:CodeAlternativeExpression[@codeSpace=$locale]/gml:name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gmx:alternativeExpression/gmx:CodeAlternativeExpression[@codeSpace=$locale]/gml:identifier"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="optionDescription" select="gmx:alternativeExpression/gmx:CodeAlternativeExpression[@codeSpace=$locale]/gml:description"/>
				<option value="{$optionId}" title="{$optionDescription}">
					<xsl:value-of select="$optionName"/>
				</option>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="optionId">
					<xsl:value-of select="gml:identifier"/>2222
				</xsl:variable>
				<xsl:variable name="optionName">
					<xsl:choose>
						<xsl:when test="string-length(gml:name)>0">
							<xsl:value-of select="gml:name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gml:identifier"/>
						</xsl:otherwise>
					</xsl:choose>333
				</xsl:variable>
				<xsl:variable name="optionDescription" select="gml:description"/>
				<option value="{$optionId}" title="{$optionDescription}">
					<xsl:value-of select="$optionName"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
