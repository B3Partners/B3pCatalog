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
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:description">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:title">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Subjects are always saved in 19115 with the first thesaurus -->
	<xsl:template match="/*/b3p:B3Partners/*/dc:subject">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:description">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:creator">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact">
					<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<!-- We do not implement the synchronized 19115 value in our editor (yet) -->
	<xsl:template match="/*/b3p:B3Partners/*/dc:publisher">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact">
					<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:contributor">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:contact">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:contact">
					<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:date">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:Date |
										   /*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation']/gmd:date/gco:DateTime"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:type">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:format">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:name/gco:CharacterString"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:identifier">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identifier"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:source">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:language">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:relation">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo">
					<xsl:value-of select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:coverage">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/dc:rights">
		<xsl:if test="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue">
			<xsl:copy>
				<xsl:for-each select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode">
					<xsl:value-of select="@codeListValue"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/*/b3p:B3Partners/*/pbl:frequency">
		<xsl:copy>
			<xsl:value-of select="/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*/b3p:B3Partners/*/pbl:testsPerformed">
		<!-- do nothing -->
	</xsl:template>
	
</xsl:stylesheet>