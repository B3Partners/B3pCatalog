<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gfc="http://www.isotc211.org/2005/gfc"
        xmlns:gmx="http://www.isotc211.org/2005/gmx"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:b3p="http://www.b3partners.nl/xsd/metadata"
        xmlns:pbl="http://www.pbl.nl/xsd/metadata"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        >
            
	<xsl:output method="xml" indent="yes"/>
	
	
	<!-- 
		Syncs ISO19115 metadata to DC metadata by B3Partners.
		This stylesheet assumes there are nodes present for every template. 
		Therefore it is best to create empty nodes for every possible element before running this sheet. 
	-->


	<!-- default template: copy all nodes and attributes-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*/b3p:B3Partners/b3p:metadataDC">
		<xsl:copy>
			<xsl:call-template name="add-DC-elems"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*/b3p:B3Partners/pbl:metadataPBL">
		<xsl:copy>
			<xsl:call-template name="add-DC-elems"/>
			<xsl:call-template name="add-PBL-frequency"/>
			<xsl:call-template name="add-PBL-testsPerformed"/>
			<xsl:apply-templates select="@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="add-DC-elems">
		<xsl:call-template name="add-DC-title"/>
		<xsl:call-template name="add-DC-creator"/>
		<xsl:call-template name="add-DC-subject"/>
		<xsl:call-template name="add-DC-description"/>
		<xsl:call-template name="add-DC-publisher"/>
		<xsl:call-template name="add-DC-contributor"/>
		<xsl:call-template name="add-DC-date"/>
		<xsl:call-template name="add-DC-type"/>
		<xsl:call-template name="add-DC-format"/>
		<xsl:call-template name="add-DC-identifier"/>
		<xsl:call-template name="add-DC-language"/>
		<xsl:call-template name="add-DC-source"/>
		<xsl:call-template name="add-DC-relation"/>
		<xsl:call-template name="add-DC-coverage"/>
		<xsl:call-template name="add-DC-rights"/>
	</xsl:template>

	<xsl:template name="add-DC-title">
		<xsl:element name="dc:title">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Subjects are always saved in 19115 with the first thesaurus -->
	<xsl:template name="add-DC-subject">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
					<xsl:element name="dc:subject">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:subject"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="add-DC-description">
		<xsl:element name="dc:description">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-DC-creator">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact">
					<xsl:element name="dc:creator">
						<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:creator"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- We do not implement the synchronized 19115 value in our editor (yet) -->
	<xsl:template name="add-DC-publisher">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact">
					<xsl:element name="dc:publisher">
						<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:publisher"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="add-DC-contributor">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:contact">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:contact">
					<xsl:element name="dc:contributor">
						<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:contributor"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="add-DC-date">
		<xsl:element name="dc:date">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:Date |
												/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:DateTime"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-DC-type">
		<xsl:element name="dc:type">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-DC-format">
		<xsl:element name="dc:format">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:name/gco:CharacterString"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-DC-identifier">
		<xsl:apply-templates select="dc:identifier"/>
	</xsl:template>
	
	<xsl:template name="add-DC-source">
		<xsl:apply-templates select="dc:source"/>
	</xsl:template>
	
	<xsl:template name="add-DC-language">
		<xsl:element name="dc:language">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-DC-relation">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo">
					<xsl:element name="dc:relation">
						<xsl:value-of select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:relation"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="add-DC-coverage">
		<xsl:apply-templates select="dc:coverage"/>
	</xsl:template>
	
	<xsl:template name="add-DC-rights">
		<xsl:choose>
			<xsl:when test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue">
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode">
					<xsl:element name="dc:rights">
						<xsl:value-of select="@codeListValue"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="dc:rights"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="add-PBL-frequency">
		<xsl:element name="pbl:frequency">
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-PBL-testsPerformed">
		<xsl:apply-templates select="pbl:testsPerformed"/>
	</xsl:template>
	
</xsl:stylesheet>