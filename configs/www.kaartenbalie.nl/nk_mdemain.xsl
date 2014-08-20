<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:gml="http://www.opengis.net/gml" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="xsl pbl b3p gml xlink xsi">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="/">
		<xsl:element name="xsl:stylesheet">
			<xsl:attribute name="version">2.0</xsl:attribute>
			<xsl:attribute name="exclude-result-prefixes">xsl pbl b3p gml xlink xsi</xsl:attribute>
			<xsl:namespace name="xsl" select="'http://www.w3.org/1999/XSL/Transform'"/>
			<xsl:namespace name="pbl" select="'http://www.pbl.nl/xsd/metadata'"/>
			<xsl:namespace name="b3p" select="'http://www.b3partners.nl/xsd/metadata'"/>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
			<xsl:element name="xsl:output">
				<xsl:attribute name="method">xml</xsl:attribute>
				<xsl:attribute name="indent">yes</xsl:attribute>
			</xsl:element>
			<xsl:call-template name="pbl-normenkaderPBL-aggregation"/>
			<xsl:call-template name="pbl-normenkaderPBL"/>
		</xsl:element>
	</xsl:template>
	<!--create pbl-normenkaderPBL templates-->
	<xsl:template name="pbl-normenkaderPBL">
		<xsl:for-each select="/*/b3p:B3Partners/pbl:normenkaderPBL">
			<xsl:for-each select="child::*">
				<xsl:for-each select="child::*">
					<xsl:variable name="nk-title">
						<xsl:for-each select="child::*">
							<xsl:if test="fn:ends-with(name(),'Title')">
								<xsl:value-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="child::*">
						<xsl:choose>
							<xsl:when test="fn:ends-with(name(),'Value')">
								<xsl:call-template name="nk-element">
									<xsl:with-param name="title" select="$nk-title"/>
									<xsl:with-param name="help">
										<xsl:text>normenkader </xsl:text>
										<xsl:value-of select="name()"/>
										<xsl:text>!</xsl:text>
									</xsl:with-param>
									<xsl:with-param name="type" select="../@type"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="fn:ends-with(name(),'Comment')">
								<xsl:call-template name="nk-element">
									<xsl:with-param name="title" select="$nk-title"/>
									<xsl:with-param name="help">
										<xsl:text>normenkader </xsl:text>
										<xsl:value-of select="name()"/>
										<xsl:text>!</xsl:text>
									</xsl:with-param>
									<xsl:with-param name="type" select="../@type"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="child::*">
						<xsl:if test="fn:ends-with(name(),'Checks')">
							<xsl:for-each select="child::*">
								<xsl:variable name="nk-comment-title">
									<xsl:for-each select="child::*">
										<xsl:if test="fn:ends-with(name(),'Title')">
											<xsl:value-of select="."/>
										</xsl:if>
									</xsl:for-each>
								</xsl:variable>
								<xsl:for-each select="child::*">
									<xsl:choose>
										<xsl:when test="fn:ends-with(name(),'Value')">
											<xsl:call-template name="nk-element">
												<xsl:with-param name="title" select="$nk-comment-title"/>
												<xsl:with-param name="help">
													<xsl:text>normenkader </xsl:text>
													<xsl:value-of select="name()"/>
													<xsl:text>!</xsl:text>
												</xsl:with-param>
												<xsl:with-param name="type" select="../@type"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="fn:ends-with(name(),'Comment')">
											<xsl:call-template name="nk-element">
												<xsl:with-param name="title" select="$nk-comment-title"/>
												<xsl:with-param name="help">
													<xsl:text>normenkader </xsl:text>
													<xsl:value-of select="name()"/>
													<xsl:text>!</xsl:text>
												</xsl:with-param>
												<xsl:with-param name="type" select="../@type"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<!--create pbl-normenkaderPBL aggregation templates-->
	<xsl:template name="pbl-normenkaderPBL-aggregation">
		<xsl:for-each select="/*/b3p:B3Partners/pbl:normenkaderPBL">
			<xsl:for-each select="child::*">
				<xsl:element name="xsl:template">
					<xsl:attribute name="name"><xsl:value-of select="translate(name(),':','-')"/></xsl:attribute>
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select"><xsl:text>/metadata/b3p:B3Partners/pbl:normenkaderPBL/</xsl:text><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:element name="xsl:apply-templates"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:for-each>
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
	<xsl:template name="nk-element">
		<xsl:param name="path" select="."/>
		<xsl:param name="title"/>
		<xsl:param name="help"/>
		<xsl:param name="type"/>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match"><xsl:value-of select="$path/name()"/></xsl:attribute>
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name" select="'element'"/>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name" select="'title'"/>
					<xsl:attribute name="select"><xsl:text>'</xsl:text><xsl:value-of select="$title"/><xsl:text>'</xsl:text></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name" select="'help'"/>
					<xsl:attribute name="select"><xsl:text>'</xsl:text><xsl:value-of select="$help"/><xsl:text>'</xsl:text></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name" select="'optionality'"/>
					<xsl:attribute name="select"><xsl:text>'optional'</xsl:text></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name" select="'type'"/>
					<xsl:attribute name="select"><xsl:text>'</xsl:text><xsl:value-of select="$type"/><xsl:text>'</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
