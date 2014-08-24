<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:gml="http://www.opengis.net/gml" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="xsl pbl b3p gml xlink xsi">
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="dcPblMode_init">true</xsl:param>
	<xsl:param name="dcPblMode" select="$dcPblMode_init = 'true'"/>
	<xsl:template match="/">
		<xsl:element name="xsl:stylesheet">
			<xsl:attribute name="version">1.0</xsl:attribute>
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
			<xsl:if test="$dcPblMode">
				<xsl:call-template name="pbl-normenkaderPBL"/>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!-- this fragment should be copied as-is
	<xsl:template name="pbl-normenkaderPBL-structure">
			<div id="normenkader" class="ui-mde-tab-definition">
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">Bronlijst</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkBronlijstItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">Invulhulp</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkInvulhulpItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">Algemeen</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkAlgemeenItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">A Beheer</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkBeheerItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">B Dataobject</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkDataobjectItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">C Gebruik</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkGebruikItems"/>
					</div>
				</div>
				<div class="ui-mde-section">
					<xsl:call-template name="section-title">
						<xsl:with-param name="title">H Referenties</xsl:with-param>
					</xsl:call-template>
					<div class="ui-mde-section-content">
						<xsl:call-template name="pbl-nkReferentiesItems"/>
					</div>
				</div>
			</div>
	</xsl:template -->
	<xsl:template name="pbl-normenkaderPBL">
		<xsl:for-each select="/*/b3p:B3Partners/pbl:normenkaderPBL">
			<xsl:for-each select="child::*">
				<!-- start template hoofdstuk -->
				<xsl:element name="xsl:template">
					<xsl:attribute name="name"><xsl:value-of select="translate(name(),':','-')"/></xsl:attribute>
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select"><xsl:text>/metadata/b3p:B3Partners/pbl:normenkaderPBL/</xsl:text><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:for-each select="child::*">
							<xsl:element name="xsl:apply-templates">
								<xsl:attribute name="select"><xsl:value-of select="name()"/></xsl:attribute>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
				<!-- einde template hoofdstuk -->
				<xsl:for-each select="child::*">
					<xsl:variable name="nk-title">
						<xsl:for-each select="pbl:nkTitle">
							<xsl:value-of select="."/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="type">
						<xsl:value-of select="@type"/>
					</xsl:variable>
					<xsl:variable name="help">
						<xsl:text>'Help voor </xsl:text>
						<xsl:value-of select="name()"/>
						<xsl:text>'</xsl:text>
					</xsl:variable>
					<!-- start template question -->
					<xsl:element name="xsl:template">
						<xsl:attribute name="match"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:for-each select="pbl:nkTitle">
							<xsl:if test="not(../pbl:nkValue)">
								<xsl:element name="div">
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="pbl:nkValue">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">element</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'title'"/>
									<xsl:attribute name="select"><xsl:text>'</xsl:text><xsl:value-of select="$nk-title"/><xsl:text>'</xsl:text></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'path'"/>
									<xsl:attribute name="select">pbl:nkValue</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'help-text'"/>
									<xsl:attribute name="select"><xsl:value-of select="$help"/></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'optionality'"/>
									<xsl:attribute name="select"><xsl:text>'mandatory'</xsl:text></xsl:attribute>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="$type = 'yesno'">
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name" select="'picklist'"/>
											<xsl:attribute name="select"><xsl:text>'picklist_yesno'</xsl:text></xsl:attribute>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$type = 'yesnona'">
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name" select="'picklist'"/>
											<xsl:attribute name="select"><xsl:text>'picklist_yesnona'</xsl:text></xsl:attribute>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$type = 'checkbox'">
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name" select="'picklist'"/>
											<xsl:attribute name="select"><xsl:text>'picklist_yesno'</xsl:text></xsl:attribute>
										</xsl:element>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="../name() = 'pbl:nkh'">
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name" select="'repeatable'"/>
											<xsl:attribute name="select"><xsl:text>true()</xsl:text></xsl:attribute>
										</xsl:element>
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name" select="'repeateble-path'"/>
											<xsl:attribute name="select"><xsl:text>..</xsl:text></xsl:attribute>
										</xsl:element>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="pbl:nkComment">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">element</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'title'"/>
									<xsl:attribute name="select"><xsl:text>'Commentaar'</xsl:text></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'path'"/>
									<xsl:attribute name="select">pbl:nkComment</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'help-text'"/>
									<xsl:attribute name="select"><xsl:value-of select="$help"/></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'optionality'"/>
									<xsl:attribute name="select"><xsl:text>'mandatory'</xsl:text></xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name" select="'type'"/>
									<xsl:attribute name="select"><xsl:text>'rich-text'</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="pbl:nkChecks">
							<xsl:element name="div">
								<xsl:attribute name="class">ui-mde-section</xsl:attribute>
								<xsl:element name="xsl:call-template">
									<xsl:attribute name="name">section-title</xsl:attribute>
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">expanded</xsl:attribute>
										<xsl:attribute name="select">false()</xsl:attribute>
									</xsl:element>
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">title</xsl:attribute>
										<xsl:text>Checks</xsl:text>
									</xsl:element>
								</xsl:element>
								<xsl:element name="div">
									<xsl:attribute name="class">ui-mde-section-content</xsl:attribute>
									<xsl:attribute name="style">display:none;</xsl:attribute>
									<xsl:for-each select="child::*">
										<xsl:element name="xsl:apply-templates">
											<xsl:attribute name="select"><xsl:text>pbl:nkChecks/</xsl:text><xsl:value-of select="name()"/></xsl:attribute>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<!-- end template question -->
					<xsl:for-each select="child::*">
						<xsl:choose>
							<xsl:when test="fn:ends-with(name(),'Checks')">
								<xsl:for-each select="child::*">
									<xsl:variable name="nk-check-title">
										<xsl:for-each select="child::*">
											<xsl:if test="fn:ends-with(name(),'Title')">
												<xsl:value-of select="."/>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<xsl:variable name="type">
										<xsl:value-of select="@type"/>
									</xsl:variable>
									<xsl:variable name="help">
										<xsl:text>'Help voor commentaar op </xsl:text>
										<xsl:value-of select="name()"/>
										<xsl:text>'</xsl:text>
									</xsl:variable>
									<!-- start template check -->
									<xsl:element name="xsl:template">
										<xsl:attribute name="match"><xsl:value-of select="name()"/></xsl:attribute>
										<xsl:for-each select="pbl:nkValue">
											<xsl:element name="xsl:call-template">
												<xsl:attribute name="name">element</xsl:attribute>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'title'"/>
													<xsl:attribute name="select"><xsl:text>'</xsl:text><xsl:value-of select="$nk-check-title"/><xsl:text>'</xsl:text></xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'path'"/>
													<xsl:attribute name="select">pbl:nkValue</xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'help-text'"/>
													<xsl:attribute name="select"><xsl:value-of select="$help"/></xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'optionality'"/>
													<xsl:attribute name="select"><xsl:text>'optional'</xsl:text></xsl:attribute>
												</xsl:element>
												<xsl:choose>
													<xsl:when test="$type = 'yesno'">
														<xsl:element name="xsl:with-param">
															<xsl:attribute name="name" select="'picklist'"/>
															<xsl:attribute name="select"><xsl:text>'picklist_yesno'</xsl:text></xsl:attribute>
														</xsl:element>
													</xsl:when>
													<xsl:when test="$type = 'yesnona'">
														<xsl:element name="xsl:with-param">
															<xsl:attribute name="name" select="'picklist'"/>
															<xsl:attribute name="select"><xsl:text>'picklist_yesnona'</xsl:text></xsl:attribute>
														</xsl:element>
													</xsl:when>
													<xsl:when test="$type = 'checkbox'">
														<xsl:element name="xsl:with-param">
															<xsl:attribute name="name" select="'picklist'"/>
															<xsl:attribute name="select"><xsl:text>'picklist_yesno'</xsl:text></xsl:attribute>
														</xsl:element>
													</xsl:when>
												</xsl:choose>
											</xsl:element>
										</xsl:for-each>
										<xsl:for-each select="pbl:nkComment">
											<xsl:element name="xsl:call-template">
												<xsl:attribute name="name">element</xsl:attribute>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'title'"/>
													<xsl:attribute name="select"><xsl:text>'Commentaar'</xsl:text></xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'path'"/>
													<xsl:attribute name="select">pbl:nkComment</xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'help-text'"/>
													<xsl:attribute name="select"><xsl:value-of select="$help"/></xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'optionality'"/>
													<xsl:attribute name="select"><xsl:text>'optional'</xsl:text></xsl:attribute>
												</xsl:element>
												<xsl:element name="xsl:with-param">
													<xsl:attribute name="name" select="'type'"/>
													<xsl:attribute name="select"><xsl:text>'rich-text'</xsl:text></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
									<!-- end template check -->
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
