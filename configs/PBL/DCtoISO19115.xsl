<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml" xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:output method="xml" indent="yes"/>
	<!-- 
		Syncs DC metadata by B3Partners to ISO19115. 
		This stylesheet assumes there are nodes present for every template. 
		Therefore it is best to create empty nodes for every possible element before running this sheet. 
	-->
	<!-- default template: copy all nodes and attributes-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:copy>
            <!-- jbd debugging. -->
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:title"/>
<!--            <xsl:value-of select="Title_set_in_xsl_sheet"/>-->
<!--            <xsl:text>Title_set_in_xsl_sheet</xsl:text>-->
            
            
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString">
		<xsl:copy>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:description"/>
		</xsl:copy>
	</xsl:template>
	<!-- Subjects are always saved in 19115 with the first thesaurus -->
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords">
		<xsl:copy>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:subject">
				<xsl:element name="gmd:keyword">
					<xsl:element name="gco:CharacterString">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="@*|node()[not(self::gmd:keyword)]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">
		<xsl:copy>
			<xsl:apply-templates select="gmd:title"/>
			<xsl:apply-templates select="gmd:alternateTitle"/>
			<xsl:choose>
				<xsl:when test="not(gmd:date[gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation'])">
					<xsl:element name="gmd:date">
						<xsl:element name="gmd:CI_Date">
							<xsl:element name="gmd:date">
								<xsl:element name="gco:Date">
									<xsl:value-of select="/*/b3p:B3Partners/*/dc:date"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:dateType">
								<xsl:element name="gmd:CI_DateTypeCode">
									<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
									<xsl:attribute name="codeListValue">creation</xsl:attribute>
									<xsl:text>creatie</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:apply-templates select="gmd:date[not(gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation')]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gmd:date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="gmd:identifier"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:Date |
										/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:DateTime">
		<xsl:copy>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:date"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString">
		<xsl:copy>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:language"/>
		</xsl:copy>
	</xsl:template>
	<!-- TODO: zoek keywords uit de juiste thesaurus op en vervang deze door de nieuwe uit DC -->
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords">
		<xsl:copy>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:subject">
				<xsl:element name="gmd:keyword">
					<xsl:element name="gco:CharacterString">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:type"/>
			<xsl:apply-templates select="gmd:thesaurusName"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode">
		<xsl:copy>
			<xsl:attribute name="codeList"><xsl:value-of select="@codeList"/></xsl:attribute>
			<xsl:attribute name="codeListValue"><xsl:value-of select="/*/b3p:B3Partners/*/dc:type"/></xsl:attribute>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:type"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata">
		<xsl:copy>
			<xsl:apply-templates select="gmd:fileIdentifier"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<xsl:apply-templates select="gmd:parentIdentifier"/>
			<xsl:apply-templates select="gmd:hierarchyLevel"/>
			<xsl:apply-templates select="gmd:hierarchyLevelName"/>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:contributor">
				<xsl:variable name="contact-position" select="position()"/>
				<xsl:variable name="contact" select="/*/gmd:MD_Metadata/gmd:contact[$contact-position]"/>
				<xsl:element name="gmd:contact">
					<xsl:choose>
						<xsl:when test="$contact">
							<xsl:apply-templates select="$contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="create-contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:dateStamp"/>
			<xsl:apply-templates select="gmd:metadataStandardName"/>
			<xsl:apply-templates select="gmd:metadataStandardVersion"/>
			<xsl:apply-templates select="gmd:referenceSystemInfo"/>
			<xsl:apply-templates select="gmd:identificationInfo"/>
			<xsl:apply-templates select="gmd:distributionInfo"/>
			<xsl:apply-templates select="gmd:dataQualityInfo"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
		<xsl:copy>
			<xsl:apply-templates select="gmd:citation"/>
			<xsl:apply-templates select="gmd:abstract"/>
			<xsl:apply-templates select="gmd:purpose"/>
			<xsl:apply-templates select="gmd:status"/>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:creator">
				<xsl:variable name="contact-position" select="position()"/>
				<xsl:variable name="contact" select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[$contact-position]"/>
				<xsl:element name="gmd:pointOfContact">
					<xsl:choose>
						<xsl:when test="$contact">
							<xsl:apply-templates select="$contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="create-contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:resourceMaintenance"/>
			<xsl:apply-templates select="gmd:graphicOverview"/>
			<xsl:apply-templates select="gmd:descriptiveKeywords"/>
			<xsl:apply-templates select="gmd:resourceConstraints"/>
			<xsl:variable name="MD_DataIdentification" select="."/>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:relation">
				<xsl:variable name="relation-position" select="position()"/>
				<xsl:choose>
					<xsl:when test="$MD_DataIdentification/gmd:aggregationInfo[$relation-position]">
						<xsl:apply-templates select="$MD_DataIdentification/gmd:aggregationInfo[$relation-position]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="gmd:aggregationInfo">
							<xsl:element name="gmd:MD_AggregateInformation">
								<xsl:element name="gmd:aggregateDataSetName">
									<xsl:element name="gmd:CI_Citation">
										<xsl:element name="gmd:title">
											<xsl:element name="gco:CharacterString">
												<xsl:value-of select="."/>
											</xsl:element>
										</xsl:element>
										<xsl:element name="gmd:date">
											<xsl:element name="gmd:CI_Date">
												<xsl:element name="gmd:date">
													<xsl:element name="gco:Date"/>
												</xsl:element>
												<xsl:element name="gmd:dateType">
													<xsl:element name="gmd:CI_DateTypeCode">
														<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
														<xsl:attribute name="codeListValue"/>
													</xsl:element>
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:element name="gmd:associationType">
									<xsl:element name="gmd:DS_AssociationTypeCode">
										<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#DS_AssociationTypeCode</xsl:attribute>
										<xsl:attribute name="codeListValue">crossReference</xsl:attribute>
										<xsl:text>crossReference</xsl:text>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:spatialRepresentationType"/>
			<xsl:apply-templates select="gmd:spatialResolution"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<xsl:apply-templates select="gmd:topicCategory"/>
			<xsl:apply-templates select="gmd:extent"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:copy>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:relation[count(current()/../../../../../preceding-sibling::gmd:aggregationInfo) + 1]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:associationType/gmd:DS_AssociationTypeCode">
		<xsl:copy>
			<xsl:if test="normalize-space(/*/b3p:B3Partners/*/dc:relation[count(current()/../../../preceding-sibling::gmd:aggregationInfo) + 1])">
				<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#DS_AssociationTypeCode</xsl:attribute>
				<xsl:attribute name="codeListValue">crossReference</xsl:attribute>
				<xsl:text>crossReference</xsl:text>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode">
		<xsl:copy>
			<xsl:attribute name="codeList"><xsl:value-of select="@codeList"/></xsl:attribute>
			<xsl:attribute name="codeListValue"><xsl:value-of select="/*/b3p:B3Partners/pbl:metadataPBL/pbl:frequency"/></xsl:attribute>
			<xsl:value-of select="/*/b3p:B3Partners/pbl:metadataPBL/pbl:frequency"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:name/gco:CharacterString">
		<xsl:copy>
			<xsl:value-of select="/*/b3p:B3Partners/*/dc:format"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:version/gco:CharacterString">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="normalize-space(.)">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="normalize-space(/*/b3p:B3Partners/*/dc:format)">
					<xsl:text>Onbekend</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor">
		<xsl:copy>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:publisher">
				<xsl:variable name="contact-position" select="position()"/>
				<xsl:variable name="contact" select="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact[$contact-position]"/>
				<xsl:element name="gmd:distributorContact">
					<xsl:choose>
						<xsl:when test="$contact">
							<xsl:apply-templates select="$contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="create-contact">
								<xsl:with-param name="individualName" select="."/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:distributionOrderProcess"/>
			<xsl:apply-templates select="gmd:distributorFormat"/>
			<xsl:apply-templates select="gmd:distributorTransferOptions"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="
			/*/gmd:MD_Metadata/gmd:contact | 
			/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact |
			/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact
			">
		<xsl:param name="individualName">
			<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
		</xsl:param>
		<xsl:param name="organisationName">
			<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
		</xsl:param>
		<xsl:call-template name="create-contact">
			<xsl:with-param name="individualName" select="$individualName"/>
			<xsl:with-param name="organisationName" select="$organisationName"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="create-contact">
		<xsl:param name="individualName">
			<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
		</xsl:param>
		<xsl:param name="organisationName">
			<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
		</xsl:param>
		<xsl:element name="gmd:CI_ResponsibleParty">
			<xsl:element name="gmd:individualName">
				<xsl:element name="gco:CharacterString">
					<xsl:value-of select="$individualName"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="gmd:organisationName">
				<xsl:element name="gco:CharacterString">
					<xsl:value-of select="$organisationName"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="gmd:contactInfo">
				<xsl:element name="gmd:CI_Contact">
					<xsl:element name="gmd:phone">
						<xsl:element name="gmd:CI_Telephone">
							<xsl:element name="gmd:voice">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="gmd:address">
						<xsl:element name="gmd:CI_Address">
							<xsl:element name="gmd:deliveryPoint">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:city">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:administrativeArea">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:postalCode">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:country">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:electronicMailAddress">
								<xsl:element name="gco:CharacterString">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="gmd:onlineResource">
						<xsl:element name="gmd:CI_OnlineResource">
							<xsl:element name="gmd:linkage">
								<xsl:element name="gmd:URL">
									<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="gmd:role">
				<xsl:element name="gmd:CI_RoleCode">
					<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode</xsl:attribute>
					<xsl:attribute name="codeListValue"><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue"/></xsl:attribute>
					<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints[count(preceding-sibling::gmd:resourceConstraints/gmd:MD_LegalConstraints) = 0]/gmd:MD_LegalConstraints">
		<xsl:copy>
			<xsl:for-each select="/*/b3p:B3Partners/*/dc:rights">
				<xsl:element name="gmd:accessConstraints">
					<xsl:element name="gmd:MD_RestrictionCode">
						<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_RestrictionCode</xsl:attribute>
						<xsl:attribute name="codeListValue"><xsl:value-of select="."/></xsl:attribute>
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:apply-templates select="gmd:useConstraints"/>
			<xsl:apply-templates select="gmd:otherConstraints"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
