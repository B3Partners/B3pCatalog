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
			<xsl:element name="xs:param">
				<xsl:attribute name="name">dcPblMode_init</xsl:attribute>
				<xsl:attribute name="select">true</xsl:attribute>
			</xsl:element>
			<xsl:element name="xs:param">
				<xsl:attribute name="name">dcPblMode</xsl:attribute>
				<xsl:attribute name="select">$dcPblMode_init = 'true'</xsl:attribute>
			</xsl:element>
			<xsl:element name="xs:template">
				<xsl:attribute name="match">b3p:B3Partners</xsl:attribute>
				<xsl:element name="xs:copy">
					<xsl:element name="xs:choose">
						<xsl:element name="xs:when">
							<xsl:attribute name="test">$dcPblMode = 'true'</xsl:attribute>
							<xsl:element name="xs:apply-templates">
								<xsl:attribute name="select">@*|node()[not(self::pbl:normenkaderPBL)]</xsl:attribute>
							</xsl:element>
							<xsl:element name="xs:choose">
								<xsl:element name="xs:when">
									<xsl:attribute name="test">not(pbl:normenkaderPBL)</xsl:attribute>
									<xsl:element name="xs:call-template">
										<xsl:attribute name="name">add-pbl-normenkaderPBL</xsl:attribute>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xs:otherwise">
									<xsl:element name="xs:apply-templates">
										<xsl:attribute name="select">pbl:normenkaderPBL</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="xs:otherwise">
							<xsl:element name="xs:apply-templates">
								<xsl:attribute name="select">@*|node()</xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<!-- xs:template match="b3p:B3Partners">
				<xs:copy>
					<xs:choose>
						<xs:when test="$dcPblMode = 'true'">
							<xs:apply-templates select="@*|node()[not(self::pbl:normenkaderPBL)]"/>
							<xs:choose>
								<xs:when test="not(pbl:normenkaderPBL)">
									<xs:call-template name="add-pbl-normenkaderPBL"/>
								</xs:when>
								<xs:otherwise>
									<xs:apply-templates select="pbl:normenkaderPBL"/>
								</xs:otherwise>
							</xs:choose>
						</xs:when>
						<xs:otherwise>
							<xs:apply-templates select="@*|node()"/>
						</xs:otherwise>
					</xs:choose>
				</xs:copy>
			</xs:template -->
			</xsl:element>
		</xsl:element>
		<xsl:element name="xs:template">
			<xsl:attribute name="match">@*|node()</xsl:attribute>
			<xsl:element name="xs:copy">
				<xsl:element name="xs:apply-templates">
					<xsl:attribute name="select">@*|node()</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="xs:template">
			<xsl:attribute name="match">metadata</xsl:attribute>
			<xsl:element name="xsl:element">
				<xsl:attribute name="name">metadata</xsl:attribute>
				<xsl:element name="xs:apply-templates">
					<xsl:attribute name="select">@*|node()</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:for-each select="*">
			<xsl:call-template name="copyTemplate"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="copyTemplate">
		<xsl:comment>create <xsl:value-of select="name()"/> template</xsl:comment>
		<xsl:element name="xs:template">
			<xsl:attribute name="match"><xsl:value-of select="name()"/></xsl:attribute>
			<!-- xsl:element name="xs:copy" -->
			<xsl:element name="xs:element">
				<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
				<!-- xsl:comment>Copy everthing else under this node</xsl:comment -->
				<xsl:variable name="copy-rest">
					<xsl:text>@*|node()</xsl:text>
					<xsl:if test="child::*">
						<xsl:text>[</xsl:text>
						<xsl:for-each select="child::*">
							<xsl:text> </xsl:text>
							<xsl:if test="position()!=1">
								<xsl:text>and </xsl:text>
							</xsl:if>
							<xsl:text>not(self::</xsl:text>
							<xsl:value-of select="name()"/>
							<xsl:text>)</xsl:text>
						</xsl:for-each>
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:element name="xs:apply-templates">
					<xsl:attribute name="select"><xsl:value-of select="$copy-rest"/></xsl:attribute>
				</xsl:element>
				<xsl:for-each select="child::*">
					<xsl:element name="xs:choose">
						<xsl:element name="xs:when">
							<xsl:attribute name="test">not(<xsl:value-of select="name()"/>)</xsl:attribute>
							<xsl:comment>Child element missing, create it</xsl:comment>
							<xsl:variable name="name-add-sub">
								<xsl:text>add-</xsl:text>
								<xsl:value-of select="translate(name(),':','-')"/>
							</xsl:variable>
							<xsl:element name="xs:call-template">
								<xsl:attribute name="name"><xsl:value-of select="$name-add-sub"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
						<xsl:element name="xs:otherwise">
							<xsl:comment>Child element exists, copy it</xsl:comment>
							<xsl:element name="xs:apply-templates">
								<xsl:attribute name="select"><xsl:value-of select="name()"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			<!-- /xsl:element -->
		</xsl:element>
		<xsl:call-template name="add-element"/>
		<xsl:call-template name="create-sub-element"/>
	</xsl:template>
	<xsl:template name="add-element">
		<xsl:variable name="name-add">
			<xsl:text>add-</xsl:text>
			<xsl:value-of select="translate(name(),':','-')"/>
		</xsl:variable>
		<xsl:comment>create <xsl:value-of select="$name-add"/> template</xsl:comment>
		<xsl:element name="xs:template">
			<xsl:attribute name="name"><xsl:value-of select="$name-add"/></xsl:attribute>
			<xsl:element name="xs:element">
				<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
				<xsl:if test="attribute::*">
					<xsl:for-each select="attribute::*">
						<xsl:element name="xs:attribute">
							<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not(child::*)">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="child::*">
							<xsl:variable name="name-add-sub">
								<xsl:text>add-</xsl:text>
								<xsl:value-of select="translate(name(),':','-')"/>
							</xsl:variable>
							<xsl:comment>call <xsl:value-of select="$name-add-sub"/> template</xsl:comment>
							<xsl:element name="xs:call-template">
								<xsl:attribute name="name"><xsl:value-of select="$name-add-sub"/></xsl:attribute>
							</xsl:element>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="create-sub-element">
		<xsl:for-each select="child::*">
			<xsl:call-template name="copyTemplate"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
