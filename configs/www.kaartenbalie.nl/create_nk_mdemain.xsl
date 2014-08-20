<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/1999/XSL/Transform" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:element name="xs:stylesheet">
			<xsl:attribute name="version">2.0</xsl:attribute>
			<xsl:attribute name="exclude-result-prefixes">xs pbl b3p gml xlink xsi</xsl:attribute>
			<xsl:namespace name="xs" select="'http://www.w3.org/1999/XSL/Transform'"/>
			<xsl:namespace name="pbl" select="'http://www.pbl.nl/xsd/metadata'"/>
			<xsl:namespace name="b3p" select="'http://www.b3partners.nl/xsd/metadata'"/>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
			<xsl:element name="xs:output">
				<xsl:attribute name="method">xml</xsl:attribute>
				<xsl:attribute name="indent">yes</xsl:attribute>
			</xsl:element>
			<xsl:for-each select="*">
				<xsl:call-template name="createTemplate"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!--	
	<xsl:template name="nkBeheerItems">
		<xsl:for-each select="/*/b3p:B3Partners/pbl:normenkaderPBL/pbl:nkBeheerItems">
			<xsl:for-each select="pbl:nka1/pbl:nka1Value">
				<xsl:call-template name="element">
					<xsl:with-param name="title">
						<xsl:value-of select="../pbl:nka1Title"/>
					</xsl:with-param>
					<xsl:with-param name="optionality" select="'optional'"/>
					<xsl:with-param name="help-text" select="'pbl normenkader nka1'"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="pbl:nka1/pbl:nka1Comment">
				<xsl:call-template name="element">
					<xsl:with-param name="title">
						<xsl:value-of select="../pbl:nka1Title"/>
					</xsl:with-param>
					<xsl:with-param name="optionality" select="'optional'"/>
					<xsl:with-param name="help-text" select="'pbl normenkader nka1'"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="pbl:nka1Checks">
				<xsl:for-each select="pbl:nka1c1/pbl:nka1c1Value">
					<xsl:call-template name="element">
						<xsl:with-param name="title">
							<xsl:value-of select="../pbl:nka1c1Title"/>
						</xsl:with-param>
						<xsl:with-param name="optionality" select="'optional'"/>
						<xsl:with-param name="help-text" select="'pbl normenkader nka1c1'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
-->
	<xsl:template name="createTemplate">
		<xsl:variable name="template-name">
			<xsl:value-of select="translate(name(),':','-')"/>
		</xsl:variable>
		<xsl:comment>create <xsl:value-of select="$template-name"/> template</xsl:comment>
		<xsl:element name="xs:template">
			<xsl:attribute name="name"><xsl:value-of select="$template-name"/></xsl:attribute>
			<xsl:element name="xs:for-each">
				<xsl:attribute name="select">/*/b3p:B3Partners/pbl:normenkaderPBL/<xsl:value-of select="name()"/></xsl:attribute>
				<xsl:element name="xs:for-each">
					<xsl:attribute name="select"><xsl:value-of select="'child::*'"/></xsl:attribute>
					<xsl:element name="xs:value-of">
						<xsl:attribute name="select">.</xsl:attribute>
					</xsl:element>
					<xsl:element name="xs:for-each">
						<xsl:attribute name="select"><xsl:value-of select="'child::*'"/></xsl:attribute>
						<xsl:element name="xs:value-of">
							<xsl:attribute name="select">.</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
