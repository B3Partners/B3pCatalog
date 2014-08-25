<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:srv="http://www.isotc211.org/2005/srv"
        xmlns:gfc="http://www.isotc211.org/2005/gfc"
        xmlns:gmx="http://www.isotc211.org/2005/gmx"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:b3p="http://www.b3partners.nl/xsd/metadata"
        xmlns:pbl="http://www.pbl.nl/xsd/metadata"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        >
            
    <xsl:output method="xml" indent="yes"/>
    
    <!-- do we want default values filled in. -->
    <xsl:param name="fillDefaults_init">true</xsl:param>
    <!-- do we want to synchronise with esri tags. only checked if fillDefaults is set to true. -->
    <xsl:param name="synchroniseEsri_init">true</xsl:param>
    <xsl:param name="dcMode_init">true</xsl:param>
    <xsl:param name="fcMode_init">true</xsl:param>
    <xsl:param name="commentMode_init">true</xsl:param>
    <xsl:param name="dcPblMode_init">true</xsl:param>
    <xsl:param name="serviceMode_init">false</xsl:param>
    <xsl:param name="datasetMode_init">true</xsl:param>

    <!-- do we want default values filled in. -->
    <xsl:param name="fillDefaults" select="$fillDefaults_init = 'true'"/>
    <!-- do we want to synchronise with esri tags. only checked if fillDefaults is set to true. -->
    <xsl:param name="synchroniseEsri" select="$synchroniseEsri_init = 'true'"/>
    <xsl:param name="dcMode" select="$dcMode_init = 'true'"/>
    <xsl:param name="commentMode" select="$commentMode_init = 'true'"/>
    <xsl:param name="fcMode" select="$fcMode_init = 'true'"/>
    <xsl:param name="dcPblMode" select="$dcPblMode_init = 'true'"/>
    <xsl:param name="serviceMode" select="$serviceMode_init = 'true'"/>
    <xsl:param name="datasetMode" select="$datasetMode_init = 'true'"/>

	<!--
	Auteur: Erik van de Pol. B3Partners.
	Adapted: Chris van Lith
	
	Beschrijving stylesheet:
	Preprocessor die alle nodes kopieert en ontbrekende nodes toevoegd om de mogelijkheid te bieden deze te editen in de stylesheet.
	De templates voor het toevoegen van nodes bevindt zich in "metadataEditPreprocessorTemplates.xsl".
	-->
	<!-- default template: copy all nodes and attributes-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
    <xsl:template match="metadata">
		<xsl:element name="metadata">
			<!-- gmd:MD_Metadata should be added before b3p:B3Partners, since DC-members within b3p:B3Partners may want to sync with gmd:MD_Metadata -->
			<xsl:choose>
				<xsl:when test="not($datasetMode) and not($serviceMode)"><!-- skip --></xsl:when>
				<xsl:when test="not(gmd:MD_Metadata)">
					<xsl:call-template name="add-MD_Metadata"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gmd:MD_Metadata"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not($fcMode)"><!-- skip --></xsl:when>
				<xsl:when test="not(gfc:FC_FeatureCatalogue) ">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_FC_FeatureCatalogue"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:FC_FeatureCatalogue"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not($commentMode) and not($dcMode)"><!-- skip --></xsl:when>
				<xsl:when test="not(b3p:B3Partners)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-B3Partners"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="b3p:B3Partners"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Metadata)
                                 and not(self::gfc:FC_FeatureCatalogue)
                                 and not(self::b3p:B3Partners)
            ]"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="b3p:B3Partners">
		<xsl:copy>

			<xsl:choose>
				<xsl:when test="not(b3p:comments)">
					<xsl:call-template name="add-comments"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="b3p:comments"/>
				</xsl:otherwise>
			</xsl:choose>

            <xsl:choose>
                <xsl:when test="not($dcMode)">
					<!--Copy everthing else under this node-->
					<xsl:apply-templates select="@*|node()[
										 not(self::b3p:comments)
					]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$dcPblMode = 'true'">
							<xsl:choose>
								<xsl:when test="not(pbl:metadataPBL)">
									<xsl:call-template name="add-metadataPBL"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="pbl:metadataPBL"/>
								</xsl:otherwise>
							</xsl:choose>
							<!--Copy everthing else under this node-->
							<xsl:apply-templates select="@*|node()[
												 not(self::b3p:comments) 
												 and not(self::pbl:metadataPBL)
							]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="not(b3p:metadataDC)">
									<xsl:call-template name="add-metadataDC"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="b3p:metadataDC"/>
								</xsl:otherwise>
							</xsl:choose>
							<!--Copy everthing else under this node-->
							<xsl:apply-templates select="@*|node()[
												 not(self::b3p:comments)
												 and not(self::b3p:metadataDC)
							]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
            </xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="checkDC">
			<xsl:choose>
				<xsl:when test="not(dc:title)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-title"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:creator)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-creator"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:creator"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:subject)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-subject"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:subject"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:description)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-description"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:description"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:publisher)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-publisher"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:publisher"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:contributor)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-contributor"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:contributor"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:date)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-date"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:type)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-type"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:type"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:format)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-format"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:format"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:identifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-identifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:identifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:language)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-language"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:language"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:source)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-source"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:source"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:relation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-relation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:relation"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:coverage)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-coverage"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:coverage"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(dc:rights)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DC-rights"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="dc:rights"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
    
	
	<xsl:template match="b3p:metadataDC">
		<xsl:copy>
			<xsl:call-template name="checkDC"/>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::dc:title) 
                                 and not(self::dc:creator)
                                 and not(self::dc:subject) 
                                 and not(self::dc:description) 
                                 and not(self::dc:publisher) 
                                 and not(self::dc:contributor) 
                                 and not(self::dc:date) 
                                 and not(self::dc:type) 
                                 and not(self::dc:format) 
                                 and not(self::dc:identifier) 
                                 and not(self::dc:language) 
                                 and not(self::dc:source) 
                                 and not(self::dc:relation) 
                                 and not(self::dc:coverage) 
                                 and not(self::dc:rights) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="pbl:metadataPBL">
		<xsl:copy>
			<xsl:call-template name="checkDC"/>
			<xsl:choose>
				<xsl:when test="not(pbl:frequency)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-PBL-frequency"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="pbl:frequency"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(pbl:testsPerformed)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-PBL-testsPerformed"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="pbl:testsPerformed"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::dc:title) 
                                 and not(self::dc:creator)
                                 and not(self::dc:subject) 
                                 and not(self::dc:description) 
                                 and not(self::dc:publisher) 
                                 and not(self::dc:contributor) 
                                 and not(self::dc:date) 
                                 and not(self::dc:type) 
                                 and not(self::dc:format) 
                                 and not(self::dc:identifier) 
                                 and not(self::dc:language) 
                                 and not(self::dc:source) 
                                 and not(self::dc:relation) 
                                 and not(self::dc:coverage) 
                                 and not(self::dc:rights) 
                                 
                                 and not(self::pbl:frequency) 
                                 and not(self::pbl:testsPerformed) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="b3p:comments">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
    
	<xsl:template match="gmd:MD_Metadata">
		<xsl:copy>
                        <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd http://www.isotc211.org/2005/gmd http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd</xsl:attribute>
			<!-- ISO 2 Metadata ID MD_Metadata.fileIdentifier -->
			<xsl:choose>
				<xsl:when test="not(gmd:fileIdentifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-fileIdentifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:fileIdentifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 3 Metadata taal MD_Metadata.language -->
			<xsl:choose>
				<xsl:when test="not(gmd:language)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-language"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:language"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 4 Metadata karakterset MD_Metadata.characterSet Codelijst: MD_CharacterSetCode (B.5.10)-->
			<xsl:choose>
				<xsl:when test="not(gmd:characterSet)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-characterSet"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:characterSet"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 5 Metadata ID MD_Metadata.parentIdentifier -->
			<xsl:choose>
				<xsl:when test="not(gmd:parentIdentifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-parentIdentifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:parentIdentifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 6 Metadata hiërarchieniveau MD_Metadata.hierarchyLevel Codelijst: MD_ScopeCode (B.5.25) -->
			<xsl:choose>
				<xsl:when test="not(gmd:hierarchyLevel)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-hierarchyLevel"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:hierarchyLevel"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 7 Beschrijving hiërarchisch niveau MD_Metadata.hierarchyLevelName -->
			<xsl:choose>
				<xsl:when test="not(gmd:hierarchyLevelName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-hierarchyLevelName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:hierarchyLevelName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:contact)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-contact"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:contact"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 9 Metadata datum MD_Metadata.dateStamp -->
			<xsl:choose>
				<xsl:when test="not(gmd:dateStamp)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-dateStamp"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:dateStamp"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 10 Metadatastandaard naam MD_Metadata.metadataStandardName -->
			<xsl:choose>
				<xsl:when test="not(gmd:metadataStandardName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-metadataStandardName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:metadataStandardName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ISO 11 Versie metadatastandaard naam  MD_Metadata.metadataStandardVersion -->
			<xsl:choose>
				<xsl:when test="not(gmd:metadataStandardVersion)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-metadataStandardVersion"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:metadataStandardVersion"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:referenceSystemInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-referenceSystemInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:referenceSystemInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:identificationInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-identificationInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:identificationInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:distributionInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-distributionInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:distributionInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:dataQualityInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-dataQualityInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:dataQualityInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:fileIdentifier)
                                 and not(self::gmd:parentIdentifier)
                                 and not(self::gmd:language)
                                 and not(self::gmd:contact) 
                                 and not(self::gmd:characterSet) 
                                 and not(self::gmd:hierarchyLevelName) 
                                 and not(self::gmd:hierarchyLevel)
                                 and not(self::gmd:dateStamp) 
                                 and not(self::gmd:metadataStandardName)
                                 and not(self::gmd:metadataStandardVersion)
                                 and not(self::gmd:referenceSystemInfo)
                                 and not(self::gmd:identificationInfo)
                                 and not(self::gmd:distributionInfo)
                                 and not(self::gmd:dataQualityInfo)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:language">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="gmd:LanguageCode">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LanguageCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:LanguageCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:LanguageCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:characterSet">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_CharacterSetCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_CharacterSetCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_CharacterSetCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_CharacterSetCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:hierarchyLevel">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_ScopeCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_ScopeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_ScopeCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_ScopeCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:contact">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_ResponsibleParty)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_ResponsibleParty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_ResponsibleParty) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:dateStamp">
		<xsl:copy>
            <xsl:call-template name="handleDateDateTime"/>
        </xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:metadataStandardName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
                    <!-- check old default. for backwards compatibility -->
                    <xsl:choose>
                        <xsl:when test="gco:CharacterString = 'ISO 19115:2003'">
                            <xsl:call-template name="add-metadataStandardName-default"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="gco:CharacterString"/>
                        </xsl:otherwise>
                    </xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
                    <!-- check old default. for backwards compatibility -->
                    <xsl:choose>
                        <xsl:when test="gco:CharacterString = 'Nederlandse metadatastandaard voor geografie 1.2'">
                            <xsl:call-template name="add-metadataStandardVersion-default"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="gco:CharacterString"/>
                        </xsl:otherwise>
                    </xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:referenceSystemInfo">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_ReferenceSystem)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_ReferenceSystem"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_ReferenceSystem"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_ReferenceSystem) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_ReferenceSystem">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:referenceSystemIdentifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-referenceSystemIdentifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:referenceSystemIdentifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:referenceSystemIdentifier) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:referenceSystemIdentifier">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:RS_Identifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-RS_Identifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:RS_Identifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:RS_Identifier) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:RS_Identifier">
		<!-- ISO 207 Code referentiesysteem  MD_Metadata.referenceSystemInfo>MD_ReferenceSystem.referenceSystemIdentifier>RS_Identifier.code EPSG codes-->
		<!-- ISO 208.1 Verantwoordelijke organisatie voor namespace referentiesysteem MD_Metadata.referenceSystemInfo>MD_ReferenceSystem.referenceSystemIdentifier>RS_Identifier.codeSpace -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:code)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-code"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:code"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:code)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-codeSpace"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:codeSpace"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:code) 
                                 and not(self::gmd:codeSpace) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not($datasetMode)"/>
				<xsl:when test="not(gmd:MD_DataIdentification)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_DataIdentification"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_DataIdentification"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not($serviceMode)"/>
				<xsl:when test="not(srv:SV_ServiceIdentification)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-SV_ServiceIdentification"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:SV_ServiceIdentification"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_DataIdentification) 
                                and not(self::srv:SV_ServiceIdentification) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_DataIdentification">
		<!-- ISO 360 Dataset titel MD_Metadata.identificationInfo>MD_DataIdentification.citation>CI_Citation.title-->
		<!-- ISO 394 Dataset referentie datum MD_Metadata.identificationInfo>MD_DataIdentification.citation>CI_Citation.date>CI_Date.date-->
		<!-- ISO 395 Creatie-, publicatie-, of wijzigingsdatum MD_Metadata.identificationInfo>MD_DataIdentification.citation>CI_Citation.date>CI_Date.dateType Codelijst: CI_DateTypeCode (B.5.2) -->
		<!-- ISO 25 Samenvatting MD_Metadata.identificationInfo>MD_DataIdentification.abstract -->
		<!-- ISO 28 Status MD_Metadata.identificationInfo>MD_DataIdentification.status Codelijst MD_ProgressCode (B.5.23)-->
		<!-- ISO 376 Naam organisatie MD_Metadata.identificationInfo>MD_DataIdentification.pointOfContact>CI_ResponsibleParty.organisationName-->
		<!-- ISO 397 URL organisatie MD_Metadata.identificationInfo>MD_DataIdentification.pointOfContact>CI_ResponsibleParty.contactInfo>CI_Contract.onlineResource>CI_OnlineResource.linkage-->
		<!-- ISO 379 Rol organisatie MD_Metadata.identificationInfo>MD_DataIdentification.pointOfContact>CI_ResponsibleParty.role Codelijst: CI_RoleCode (B.5.5)-->
		<!-- ISO 53 Trefwoorden MD_Metadata.identificationInfo>MD_DataIdentification.descriptiveKeywords>MD_Keywords.keyword-->
		<!-- ISO 68 Gebruiksbeperkingen MD_Metadata.identificationInfo>MD_DataIdentification.resourceConstraints>MD_Constraints.useLimitation-->
		<!-- ISO 70 (Juridische) toegangsrestricties MD_Metadata.identificationInfo>MD_DataIdentification.resourceConstraints>MD_LegalConstraints.accessConstraints Codelijst MD_RestrictionCode (B.5.24)-->
		<!-- ISO 37 Ruimtelijk schema MD_Metadata.identificationInfo>MD_DataIdentification.spatialRepresentationType Codelijst: MD_SpatialRepresentation TypeCode (B.5.26) -->
		<!-- ISO 57 Toepassingsschaal MD_Metadata.identificationInfo>MD_DataIdentification.spatialResolution>MD_Resolution.equivalentScale>MD_RepresentativeFraction.denominator -->
		<!-- ISO 39 Dataset taal MD_Metadata.identificationInfo>MD_DataIdentification.language ISO 639-2 -->
		<!-- ISO 40 Dataset karakterset MD_Metadata.identificationInfo>MD_DataIdentification.characterSet Codelijst: MD_CharacterSetCode (B.5.10) -->
		<!-- ISO 41 Thema's MD_Metadata.identificationInfo>MD_DataIdentification.topicCategory Enumeratie: MD_TopicCategoryCode (B.5.27) -->
		<!-- ISO 344 Minimum x-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.westBoundLongitude -->
		<!-- ISO 345 Maximum x-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.eastBoundLongitude -->
		<!-- ISO 346 Minimum y-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.southBoundLatitude -->
		<!-- ISO 347 Maximum y-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.northBoundLatitude -->
		<!-- ISO 351 Temporele dekking - BeginDatum/einddatum MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.temporalElement>EX_TemporalExtent.extent TM_Primitive(B.4.5) -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:abstract)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-abstract"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:abstract"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:purpose)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-purpose"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:purpose"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:status)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-status"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:status"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:pointOfContact)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-pointOfContact"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:pointOfContact"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:resourceMaintenance)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-resourceMaintenance"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:resourceMaintenance"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:graphicOverview)">
					<!--Child element missing, create it -->
					<xsl:call-template name="add-graphicOverview"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it -->
					<xsl:apply-templates select="gmd:graphicOverview"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:descriptiveKeywords)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-descriptiveKeywords"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:descriptiveKeywords"/>
				</xsl:otherwise>
			</xsl:choose>

            <!-- add/use 3 mandatory subelements: -->
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_Constraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_Constraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints/gmd:MD_Constraints">
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_LegalConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints[count(preceding-sibling::gmd:resourceConstraints/gmd:MD_LegalConstraints) = 0]/gmd:MD_LegalConstraints"><!-- we doen maar één gmd:MD_LegalConstraints en halen alle gmd:MD_LegalConstraints elems binnen de eerste -->
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_SecurityConstraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_SecurityConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints/gmd:MD_SecurityConstraints">
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="not(gmd:aggregationInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-aggregationInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:aggregationInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:spatialRepresentationType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-spatialRepresentationType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:spatialRepresentationType"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:spatialResolution/*/gmd:equivalentScale)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-spatialResolution-equivalentScale"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:spatialResolution[*/gmd:equivalentScale]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:spatialResolution/*/gmd:distance)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-spatialResolution-distance"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:spatialResolution[*/gmd:distance]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:language)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-language"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:language"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:characterSet)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-characterSet"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:characterSet"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:topicCategory)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-topicCategory"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:topicCategory"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:extent)">
					<!--Child element missing, create it -->
					<xsl:call-template name="add-extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it -->
					<xsl:apply-templates select="gmd:extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node -->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:citation) 
                                 and not(self::gmd:characterSet) 
                                 and not(self::gmd:abstract) 
                                 and not(self::gmd:purpose) 
                                 and not(self::gmd:status) 
                                 and not(self::gmd:pointOfContact) 
                                 and not(self::gmd:language) 
                                 and not(self::gmd:spatialRepresentationType) 
                                 and not(self::gmd:spatialResolution)
                                 and not(self::gmd:topicCategory) 
                                 and not(self::gmd:resourceConstraints) 		
                                 and not(self::gmd:aggregationInfo)												
                                 and not(self::gmd:descriptiveKeywords) 														
                                 and not(self::gmd:extent) 
                                 and not(self::gmd:graphicOverview) 
                                 and not(self::gmd:resourceMaintenance)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:SV_ServiceIdentification">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:abstract)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-abstract"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:abstract"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:pointOfContact)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-pointOfContact"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:pointOfContact"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:graphicOverview)">
					<!--Child element missing, create it -->
					<xsl:call-template name="add-graphicOverview"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it -->
					<xsl:apply-templates select="gmd:graphicOverview"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:descriptiveKeywords)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-descriptiveKeywords"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:descriptiveKeywords"/>
				</xsl:otherwise>
			</xsl:choose>

            <!-- add/use 3 mandatory subelements: -->
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_Constraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_Constraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints/gmd:MD_Constraints">
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_LegalConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints[count(preceding-sibling::gmd:resourceConstraints/gmd:MD_LegalConstraints) = 0]/gmd:MD_LegalConstraints"><!-- we doen maar één gmd:MD_LegalConstraints en halen alle gmd:MD_LegalConstraints elems binnen de eerste -->
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:resourceConstraints/gmd:MD_SecurityConstraints)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-resourceConstraints-MD_SecurityConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:resourceConstraints/gmd:MD_SecurityConstraints">
						<xsl:element name="gmd:resourceConstraints">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="not(srv:serviceType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_serviceType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:serviceType"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:serviceTypeVersion)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_serviceTypeVersion"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:serviceTypeVersion"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:extent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:coupledResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_coupledResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:coupledResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:couplingType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_couplingType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:couplingType"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:containsOperations)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_containsOperations"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:containsOperations"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:operatesOn)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_operatesOn"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:operatesOn"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node -->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:citation) 
                                 and not(self::gmd:abstract) 
                                 and not(self::gmd:pointOfContact) 
                                 and not(self::gmd:resourceConstraints) 		
                                 and not(self::gmd:descriptiveKeywords) 														
                                 and not(self::gmd:graphicOverview) 
                                 and not(self::srv:serviceType)
                                 and not(self::srv:serviceTypeVersion)
                                 and not(self::srv:extent)
                                 and not(self::srv:coupledResource)
                                 and not(self::srv:couplingType)
                                 and not(self::srv:containsOperations)
                                 and not(self::srv:operatesOn)
            ]"/>
		</xsl:copy>
	</xsl:template>
        
	<xsl:template match="gmd:resourceMaintenance">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_MaintenanceInformation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_MaintenanceInformation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_MaintenanceInformation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_MaintenanceInformation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_MaintenanceInformation">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:maintenanceAndUpdateFrequency)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-maintenanceAndUpdateFrequency"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:maintenanceAndUpdateFrequency"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:maintenanceAndUpdateFrequency) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:maintenanceAndUpdateFrequency">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_MaintenanceFrequencyCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_MaintenanceFrequencyCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_MaintenanceFrequencyCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_MaintenanceFrequencyCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:aggregationInfo">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_AggregateInformation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_AggregateInformation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_AggregateInformation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_AggregateInformation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_AggregateInformation">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:aggregateDataSetName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-aggregateDataSetName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:aggregateDataSetName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:associationType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-associationType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:associationType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:aggregateDataSetName)
                                 and not(self::gmd:associationType) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:aggregateDataSetName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Citation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:associationType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:DS_AssociationTypeCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DS_AssociationTypeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:DS_AssociationTypeCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:DS_AssociationTypeCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:graphicOverview">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_BrowseGraphic)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_BrowseGraphic"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_BrowseGraphic"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_BrowseGraphic) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_BrowseGraphic">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:fileName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-fileName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:fileName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:fileName) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_DataIdentification/gmd:extent">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:EX_Extent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_Extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:EX_Extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:EX_Extent) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:SV_ServiceIdentification/srv:extent">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:EX_Extent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_Extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:EX_Extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:EX_Extent) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:EX_Extent">
		<xsl:copy>
            <xsl:choose>
				<xsl:when test="not(gmd:description)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-description"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:description"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:geographicElement)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-geographicElement"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:geographicElement"/>
				</xsl:otherwise>
			</xsl:choose>
            <xsl:choose>
				<xsl:when test="not(gmd:temporalElement)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-temporalElement"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:temporalElement"/>
				</xsl:otherwise>
			</xsl:choose>
            <!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:description) 
                                 and not(self::gmd:geographicElement) 
                                 and not(self::gmd:temporalElement) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:geographicElement">
			<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:EX_GeographicBoundingBox)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_GeographicBoundingBox"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:EX_GeographicBoundingBox"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:EX_GeographicBoundingBox)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:temporalElement">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:EX_TemporalExtent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_TemporalExtent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:EX_TemporalExtent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:EX_TemporalExtent) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:EX_TemporalExtent">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:extent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_TemporalExtent-extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it TODO -->
					<xsl:apply-templates select="gmd:extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:extent) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:EX_TemporalExtent/gmd:extent">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gml:TimePeriod)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-TimePeriod"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gml:TimePeriod"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gml:TimePeriod) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gml:TimePeriod">
		<xsl:copy>
                        <xsl:if test="not(@gml:id)">
                                <!--fix for missing gml:id, value not relevant-->
                                <xsl:attribute name="gml:id">t1</xsl:attribute>
                        </xsl:if>
			<xsl:choose>
				<xsl:when test="not(gml:begin)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-beginPosition"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gml:begin"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gml:end)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-endPosition"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gml:end"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gml:begin) 
                                 and not(self::gml:end) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:EX_GeographicBoundingBox">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:westBoundLongitude)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-westBoundLongitude"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:westBoundLongitude"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:eastBoundLongitude)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-eastBoundLongitude"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:eastBoundLongitude"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:southBoundLatitude)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-southBoundLatitude"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:southBoundLatitude"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:northBoundLatitude)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-northBoundLatitude"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:northBoundLatitude"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:westBoundLongitude) 
                                 and not(self::gmd:eastBoundLongitude) 
                                 and not(self::gmd:southBoundLatitude) 
                                 and not(self::gmd:northBoundLatitude) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:citation">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Citation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Citation">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:title)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-title"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:alternateTitle)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-alternateTitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:alternateTitle"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:date)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-date"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:edition)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-edition"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:edition"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:identifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-identifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:identifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:title) 
                                 and not(self::gmd:alternateTitle) 
                                 and not(self::gmd:date) 
                                 and not(self::gmd:edition) 
                                 and not(self::gmd:identifier)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Citation/gmd:date">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Date)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Date"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Date"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Date) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Date">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:date)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-inner-date"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:dateType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-dateType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:dateType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:date) 
                                 and not(self::gmd:dateType) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Date/gmd:date">
		<xsl:copy>
            <xsl:call-template name="handleDateDateTime"/>
        </xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Date/gmd:dateType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_DateTypeCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_DateTypeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_DateTypeCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_DateTypeCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Citation/gmd:identifier">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Identifier) and not(gmd:RS_Identifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_Identifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Identifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Identifier) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Identifier">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:code)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-identifier_code"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:code"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:code) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:status">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_ProgressCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_ProgressCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:MD_ProgressCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:MD_ProgressCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:pointOfContact">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_ResponsibleParty)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_ResponsibleParty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_ResponsibleParty) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_ResponsibleParty">
		<!-- ISO 376 Naam organisatie metadata MD_Metadata.contact>CI_ResponsibleParty.organisationName -->
		<!-- v1.2 ISO 386 e-mail  MD_Metadata.contact>CI_ResponsibleParty.contactInfo>CI_Contact.address>CI_Address.electronicMailAddress -->
		<!-- ISO 397 URL metadata organisatie MD_Metadata.contact>CI_ResponsibleParty.contactInfo>CI_Contact.onlineResource>CI_OnlineResource.linkage-->
		<!-- ISO 379 Rol organisatie metadata MD_Metadata.contact>CI_ResponsibleParty.role Codelijst: CI_RoleCode (B.5.5) -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:individualName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-individualName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:individualName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:organisationName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-organisationName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:organisationName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:positionName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-positionName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:positionName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:contactInfo)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-contactInfo"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:contactInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:role)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-role"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:role"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:organisationName) 
                                 and not(self::gmd:individualName) 
                                 and not(self::gmd:positionName)
                                 and not(self::gmd:role) 
                                 and not(self::gmd:contactInfo) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:role">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_RoleCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_RoleCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_RoleCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_RoleCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:contactInfo">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Contact)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Contact"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Contact"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Contact) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Contact">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:phone)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-phone"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:phone"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:address)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-address"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:address"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:onlineResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-onlineResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:onlineResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:phone)
                                 and not(self::gmd:address)
                                 and not(self::gmd:onlineResource)
           ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:onlineResource">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_OnlineResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_OnlineResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_OnlineResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_OnlineResource) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_OnlineResource">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:linkage)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-linkage"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:linkage"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:protocol)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-protocol"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:protocol"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:name)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-name"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:name"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:linkage) 
                                 and not(self::gmd:protocol) 
                                 and not(self::gmd:name) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:linkage">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:URL)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-URL"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:URL"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:URL) 
            ]"/>
		</xsl:copy>
	</xsl:template>
<!-- fout corrigeren: -->
<!-- zet alles uit "gco:CharacterString" in nieuwe "gmd:SV_ServiceType" -->
<!-- EvdP (27-9-2010): volgens alle xsds van ISO 19139 is gco:CharacterString (ook) correct;
gmd:SV_ServiceType heb ik alleen gevonden in de NL Metadatastandaard 1.2

EvdP (2-11-2010): Nou, we blijven lekker heen en weer gaan: volgens de nieuwe validator van Geonovum
moet het toch gewoon gco:CharacterString zijn zoals in de xsd staat.
-->
	<xsl:template match="gmd:protocol">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="gco:CharacterString">
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:when>

				<xsl:when test="gmd:SV_ServiceType">
                    <xsl:for-each select="gmd:SV_ServiceType">
                        <xsl:element name="gco:CharacterString">
                            <xsl:value-of select="./@codeListValue"/>
                        </xsl:element>
                    </xsl:for-each>
				</xsl:when>
        
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:SV_ServiceType)
                                 and not(self::gco:CharacterString)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:address">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Address)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Address"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Address"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Address) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Address">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:deliveryPoint)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-deliveryPoint"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:deliveryPoint"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:city)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-city"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:city"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:administrativeArea)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-administrativeArea"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:administrativeArea"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:postalCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-postalCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:postalCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:country)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-country"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:country"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:electronicMailAddress)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-electronicMailAddress"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:electronicMailAddress"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:deliveryPoint) 
                                 and not(self::gmd:city) 
                                 and not(self::gmd:administrativeArea) 
                                 and not(self::gmd:postalCode) 
                                 and not(self::gmd:country) 
                                 and not(self::gmd:electronicMailAddress)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:phone">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Telephone)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Telephone"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Telephone"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Telephone)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:CI_Telephone">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:voice)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-voice"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:voice"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:voice)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:spatialRepresentationType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_SpatialRepresentationTypeCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_SpatialRepresentationTypeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_SpatialRepresentationTypeCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_SpatialRepresentationTypeCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:spatialResolution">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Resolution)">
					<!--Child element missing, create it. Xml is bogged, we just choose one of the "choice" -->
					<xsl:call-template name="add-MD_Resolution-equivalentScale"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Resolution"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Resolution) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Resolution">
		<xsl:copy>
            <!-- Dit is een "choice" in de xsd;
            Wij implementeren alleen "Toepassingsschaal" op het moment,
            aangezien een choice nog niet standaard zit ingebakken in de MDE. -->
			<xsl:choose>
				<xsl:when test="gmd:equivalentScale">
					<xsl:apply-templates select="gmd:equivalentScale"/>
				</xsl:when>
				<xsl:when test="gmd:distance">
					<xsl:apply-templates select="gmd:distance"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-equivalentScale"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--xsl:choose>
				<xsl:when test="not(gmd:distance)">
					<xsl:call-template name="add-distance"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gmd:distance"/>
				</xsl:otherwise>
			</xsl:choose-->
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:equivalentScale) 
                                 and not(self::gmd:distance) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:distance">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Distance)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Distance"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Distance"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Distance) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:equivalentScale">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_RepresentativeFraction)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_RepresentativeFraction"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_RepresentativeFraction"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_RepresentativeFraction) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_RepresentativeFraction">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:denominator)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-denominator"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:denominator"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:denominator) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:denominator">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Integer)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Integer"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Integer"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Integer) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:topicCategory">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_TopicCategoryCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_TopicCategoryCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_TopicCategoryCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_TopicCategoryCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:descriptiveKeywords">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Keywords)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_Keywords"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Keywords"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Keywords) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Keywords">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:keyword)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-keyword"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:keyword"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:thesaurusName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-thesaurusName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:thesaurusName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:keyword) 
                                 and not(self::gmd:thesaurusName)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:thesaurusName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Citation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:resourceConstraints">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="gmd:MD_Constraints">
					<xsl:apply-templates select="gmd:MD_Constraints"/>
				</xsl:when>
				<xsl:when test="gmd:MD_LegalConstraints">
					<xsl:apply-templates select="gmd:MD_LegalConstraints"/>
				</xsl:when>
				<xsl:when test="gmd:MD_SecurityConstraints">
					<xsl:apply-templates select="gmd:MD_SecurityConstraints"/>
				</xsl:when>
			</xsl:choose>
            <!-- kan problemen veroorzaken:
            1. extra nodes die niet terugkomen in de mde, wellicht wel in andere editors
            2. het kan zijn dat klanten de gmd:MD_LegalConstraints en gmd:MD_SecurityConstraints
            dus opnieuw moeten invullen.
            -->
			<!--Copy everthing else under this node-->
			<!--xsl:apply-templates select="@*|node()[
                                     not(self::gmd:MD_Constraints) 
									 and not(self::gmd:MD_LegalConstraints) 
									 and not(self::gmd:MD_SecurityConstraints) 
            ]"/-->
		</xsl:copy>
	</xsl:template>

	<xsl:template match="gmd:MD_Constraints">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-useLimitation"/>
				</xsl:when>
				<xsl:when test="gmd:useLimitation">
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:useLimitation"/>
				</xsl:when>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:useLimitation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_LegalConstraints">
		<xsl:copy>
			<!-- Niet gebruikt in MDE: gmd:useLimitation -->
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-useLimitation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="../../gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-accessConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Niet gebruikt in MDE: gmd:useConstraints -->
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-useConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-otherConstraints"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="../../gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:useLimitation)
                                 and not(self::gmd:accessConstraints)
								 and not(self::gmd:useConstraints)
								 and not(self::gmd:otherConstraints)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:accessConstraints | gmd:useConstraints">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_RestrictionCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_RestrictionCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_RestrictionCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_RestrictionCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_SecurityConstraints">
		<xsl:copy>
			<!-- Niet gebruikt in MDE: gmd:useLimitation -->
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:useLimitation)">
					<!--Child element missing, create it-->
					<!--xsl:call-template name="add-useLimitation"/-->
				</xsl:when>
				<xsl:when test="gmd:useLimitation">
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:useLimitation"/>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(../../gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-classification"/>
				</xsl:when>
				<xsl:when test="gmd:classification">
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:classification"/>
				</xsl:when>
			</xsl:choose>
			<!-- 
				Niet gebruikte elementen in MDE die hierna komen: 
				gmd:userNote
				gmd:classificationSystem
				gmd:handlingDescription
			-->
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:useLimitation) 
                                 and not(self::gmd:classification) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:classification">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_ClassificationCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_ClassificationCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_ClassificationCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_ClassificationCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:distributionInfo">
		<!-- ISO 376 Naam distribuerende organisatie MD_Metadata.distributionInfo>MD_Distribution.distributor>MD_Distributor.distributorContact>CI_ResponsibleParty.organisationName -->
		<!-- ISO 397 URL organisatie MD_Metadata.distributionInfo>MD_Distribution.distributor>MD_Distributor.distributorContact>CI_ResponsibleParty.contactInfo>CI_Contact.onlineResource>CI_OnlineResource.linkage -->
		<!-- ISO 379 Rol organisatie MD_Metadata.distributionInfo>MD_Distribution.distributor>MD_Distributor.distributorContact>CI_ResponsibleParty.role Codelijst: CI_RoleCode (B.5.5) -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Distribution)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_Distribution"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Distribution"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Distribution) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Distribution">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:distributionFormat)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-distributionFormat"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:distributionFormat"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:distributor)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-distributor"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:distributor"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:transferOptions)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-transferOptions"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:transferOptions"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:distributionFormat) 
                                 and not(self::gmd:distributor) 
                                 and not(self::gmd:transferOptions) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:distributionFormat">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Format)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_Format"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Format"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Format) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Format">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:name)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-name"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:name"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:version)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-version"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:version"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:specification)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-specification"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:specification"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:name) 
                                 and not(self::gmd:version) 
                                 and not(self::gmd:specification)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:distributor">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_Distributor)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_Distributor"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_Distributor"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_Distributor) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:MD_Distributor">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:distributorContact)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-distributorContact"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:distributorContact"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:distributorContact) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:distributorContact">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_ResponsibleParty)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_ResponsibleParty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_ResponsibleParty) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:transferOptions">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_DigitalTransferOptions)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_DigitalTransferOptions"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_DigitalTransferOptions"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_DigitalTransferOptions) 
            ]"/>
		</xsl:copy>
	</xsl:template>
  <!-- nieuw: "online" altijd converteren naar "onLine" (Dit maakt onze oude md valide volgens nl md-standaard 1.2) -->
  	<xsl:template match="gmd:MD_DigitalTransferOptions">
    <xsl:copy>
      <xsl:choose>
        <!-- we don't support multiple versions in 1 metadata document. Either all onLine or all online. -->
        <xsl:when test="gmd:onLine">
          <!--Child element exists, copy it-->
          <xsl:apply-templates select="gmd:onLine"/>
        </xsl:when>
        
        <xsl:when test="gmd:online">
          <!-- fout corrigeren: -->
          <!-- zet alles uit "online" in nieuwe "onLine" -->
          <xsl:for-each select="gmd:online">
            <xsl:element name="gmd:onLine">
              <xsl:apply-templates select="./*"/>
            </xsl:element>
          </xsl:for-each>
          <!-- gebruik onderstaande uitgecommente lijn ipv bovenstaande in deze when 
          als je oude "online" elementen wilt behouden bij opslaan (niet gewenst). -->
          <!--xsl:apply-templates select="gmd:online"/-->
        </xsl:when>
        
        <xsl:otherwise>
          <!--Child element missing, create it-->
          <xsl:call-template name="add-onLine"/>
       </xsl:otherwise>
      </xsl:choose>
      <!--Copy everthing else under this node-->
      <xsl:apply-templates select="@*|node()[
                                 not(self::gmd:onLine)
                                 and not(self::gmd:online)
            ]"/>
    </xsl:copy>
	</xsl:template>
  <!-- Hou "online" (tov onLine) erin om extra online resources te bouwen in gui met oude metadata docs (die dus "online" bevatten)-->
	<xsl:template match="gmd:onLine | gmd:online">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_OnlineResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-transferOptions-CI_OnlineResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_OnlineResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_OnlineResource) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo">
		<!-- ISO 83 Algemene beschrijving herkomst MD_Metadata.dataQualityInfo>DQ_DataQuality.lineage>LI_Lineage.statement -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:DQ_DataQuality)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DQ_DataQuality"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:DQ_DataQuality"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:DQ_DataQuality) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_DataQuality">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:scope)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-scope"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:scope"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="not(gmd:report/gmd:DQ_CompletenessOmission)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-report-DQ_CompletenessOmission"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:report/gmd:DQ_CompletenessOmission">
						<xsl:element name="gmd:report">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="not(gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-report-DQ_AbsoluteExternalPositionalAccuracy"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
						<xsl:element name="gmd:report">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="not(gmd:report/gmd:DQ_DomainConsistency)">
					<!--Child element missing, create it-->
                    <xsl:call-template name="add-report-DQ_DomainConsistency"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="gmd:report/gmd:DQ_DomainConsistency">
						<xsl:element name="gmd:report">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="gmd:report[
								not(gmd:DQ_CompletenessOmission)
								and not(gmd:DQ_AbsoluteExternalPositionalAccuracy)
								and not(gmd:DQ_DomainConsistency)
			]"/>
			
			<xsl:choose>
				<xsl:when test="not(gmd:lineage)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-lineage"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:lineage"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:scope) 
                                 and not(self::gmd:lineage) 
                                 and not(self::gmd:report) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:scope">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:DQ_Scope)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DQ_Scope"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:DQ_Scope"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:DQ_Scope) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_Scope">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:level)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-level"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:level"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:level) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:level">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:MD_ScopeCode)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-MD_ScopeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:MD_ScopeCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:MD_ScopeCode) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:DQ_AbsoluteExternalPositionalAccuracy | gmd:DQ_CompletenessOmission">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:result)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-result-DQ_QuantitativeResult"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:result"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:result) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result | gmd:DQ_CompletenessOmission/gmd:result">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:DQ_QuantitativeResult)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DQ_QuantitativeResult"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:DQ_QuantitativeResult"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:DQ_QuantitativeResult) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_QuantitativeResult">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:valueUnit)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-valueUnit-nilReason"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:valueUnit"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:value)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-value"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:value"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:valueUnit) 
                                 and not(self::gmd:value) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:value">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Record)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Record"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Record"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Record) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:DQ_DomainConsistency">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:result)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-result-DQ_ConformanceResult"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:result"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:result) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_DomainConsistency/gmd:result">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:DQ_ConformanceResult)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DQ_ConformanceResult"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:DQ_ConformanceResult"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:DQ_ConformanceResult) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:DQ_ConformanceResult">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:specification)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-specification-specification-services"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:specification"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:explanation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-explanation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:explanation"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:pass)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-pass"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:pass"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:pass) 
                                 and not(self::gmd:explanation) 
                                 and not(self::gmd:specification) 
           ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:pass">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Boolean)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Boolean"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Boolean"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Boolean) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:specification">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_Citation)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_Citation"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_Citation"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_Citation) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="add-CI_Citation-specification-services">
		<xsl:element name="gmd:CI_Citation">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
						<xsl:element name="gmd:title">
							<xsl:element name="gco:CharacterString">Technical Guidance for the implementation of INSPIRE View Services v3.0</xsl:element>
						</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-alternateTitle"/>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:element name="gmd:date">
						<xsl:element name="gmd:CI_Date">
							<xsl:element name="gmd:date">
								<xsl:element name="gco:Date">2011-03-30</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:dateType">
								<xsl:element name="gmd:CI_DateTypeCode">
									<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
									<xsl:attribute name="codeListValue">publication</xsl:attribute>
									<xsl:text>publicatie</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-edition"/>
			<xsl:call-template name="add-identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Citation-specification-datasets">
		<xsl:element name="gmd:CI_Citation">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
						<xsl:element name="gmd:title">
							<xsl:element name="gco:CharacterString">"INSPIRE Data Specification on Administrative Units – Guidelines v3.0.1".</xsl:element>
						</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-alternateTitle"/>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:element name="gmd:CI_Date">
						<xsl:element name="gmd:date">
							<xsl:element name="gco:Date">2010-05-03</xsl:element>
						</xsl:element>
						<xsl:element name="gmd:dateType">
							<xsl:element name="gmd:CI_DateTypeCode">
								<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
								<xsl:attribute name="codeListValue">publication</xsl:attribute>
								<xsl:text>publicatie</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-edition"/>
			<xsl:call-template name="add-identifier"/>
		</xsl:element>
	</xsl:template>	
	<xsl:template name="add-CI_Citation-Thesaurus">
		<xsl:element name="gmd:CI_Citation">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
						<xsl:element name="gmd:title">
							<xsl:element name="gco:CharacterString">GEMET - INSPIRE themes, version 1.0</xsl:element>
						</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-alternateTitle"/>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:element name="gmd:date">
						<xsl:element name="gmd:CI_Date">
							<xsl:element name="gmd:date">
								<xsl:element name="gco:Date">2008-06-01</xsl:element>
							</xsl:element>
							<xsl:element name="gmd:dateType">
								<xsl:element name="gmd:CI_DateTypeCode">
									<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
									<xsl:attribute name="codeListValue">publication</xsl:attribute>
									<xsl:text>publicatie</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-date"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add-edition"/>
			<xsl:call-template name="add-identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="gmd:lineage">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:LI_Lineage)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LI_Lineage"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:LI_Lineage"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:LI_Lineage) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:LI_Lineage">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:statement)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-statement"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:statement"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:processStep)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-processStep"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:processStep"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:source)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-source"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:source"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:statement) 
                                 and not(self::gmd:processStep) 
                                 and not(self::gmd:source) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:processStep">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:LI_ProcessStep)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LI_ProcessStep"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:LI_ProcessStep"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:LI_ProcessStep) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:LI_ProcessStep">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:description)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-description"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:description"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:dateTime)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-dateTime"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:dateTime"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:processor)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-processor"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:processor"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:description) 
                                 and not(self::gmd:dateTime) 
                                 and not(self::gmd:processor) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:dateTime">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:DateTime)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-DateTime"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:DateTime"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:DateTime) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:processor">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_ResponsibleParty)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_ResponsibleParty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_ResponsibleParty) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:source">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:LI_Source)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LI_Source"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:LI_Source"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:LI_Source) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:LI_Source">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:description)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-description"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:description"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:sourceStep)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-sourceStep"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:sourceStep"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:description) 
                                 and not(self::gmd:sourceStep) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmd:sourceStep">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:LI_ProcessStep)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LI_ProcessStep"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:LI_ProcessStep"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:LI_ProcessStep) 
            ]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="srv:serviceType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:LocalName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LocalName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:LocalName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:LocalName) 
            ]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="srv:serviceTypeVersion">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="srv:SV_ServiceIdentification/srv:extent">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:EX_Extent)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-EX_Extent"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:EX_Extent"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:EX_Extent) 
            ]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="srv:coupledResource">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:SV_CoupledResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-SV_CoupledResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:SV_CoupledResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:SV_CoupledResource) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:SV_CoupledResource">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:operationName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_operationName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:operationName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:identifier)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_identifier"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:identifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gco:ScopedName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-ScopedName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:ScopedName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:operationName) 
                                 and not(self::srv:identifier) 
                                 and not(self::gco:ScopedName) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:operationName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:identifier">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:couplingType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:SV_CouplingType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-SV_CouplingType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:SV_CouplingType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:SV_CouplingType) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:containsOperations">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:SV_OperationMetadata)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-SV_OperationMetadata"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:SV_OperationMetadata"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:SV_OperationMetadata) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:SV_OperationMetadata">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:operationName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_operationName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:operationName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:DCP)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_DCP"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:DCP"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(srv:connectPoint)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_connectPoint"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:connectPoint"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:operationName) 
                                 and not(self::srv:DCP) 
                                 and not(self::srv:connectPoint) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:operationName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:DCP">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(srv:DCPList)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-srv_DCPList"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="srv:DCPList"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::srv:DCPList) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="srv:connectPoint">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_OnlineResource)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_OnlineResource"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_OnlineResource"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_OnlineResource) 
            ]"/>
		</xsl:copy>
	</xsl:template>

	<!--xsl:template match="srv:operatesOn" -->

	
	<!-- ISO 19110 Feature Catalogue elements -->
	<xsl:template match="gfc:FC_FeatureCatalogue">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmx:name)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gmx_name"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmx:name"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmx:scope)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gmx_scope"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmx:scope"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmx:versionNumber)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gmx_versionNumber"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmx:versionNumber"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmx:versionDate)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gmx_versionDate"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmx:versionDate"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:producer)">
					<xsl:call-template name="add-gfc_producer"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gfc:producer"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:featureType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_featureType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:featureType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmx:name) 
                                 and not(self::gmx:scope) 
                                 and not(self::gmx:versionNumber) 
                                 and not(self::gmx:versionDate) 
                                 and not(self::gfc:producer) 
                                 and not(self::gfc:featureType) 
           ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gmx:versionDate">
		<xsl:copy>
            <xsl:call-template name="handleDateDateTime"/>
        </xsl:copy>
	</xsl:template>
	<!-- TODO mix-up of namespaces -->
	<xsl:template match="gfc:producer">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gmd:CI_ResponsibleParty)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CI_ResponsibleParty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gmd:CI_ResponsibleParty) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<!-- TODO mix-up of namespaces -->
	<xsl:template match="gfc:featureType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gfc:FC_FeatureType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_FC_FeatureType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:FC_FeatureType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gfc:FC_FeatureType) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:FC_FeatureType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gfc:typeName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_typeName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:typeName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:definition)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_definition"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:definition"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:isAbstract)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_isAbstract_empty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:isAbstract"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:featureCatalogue)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_featureCatalogue_empty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:featureCatalogue"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:carrierOfCharacteristics)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_carrierOfCharacteristics"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:carrierOfCharacteristics"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gfc:typeName) 
                                 and not(self::gfc:definition) 
                                 and not(self::gfc:isAbstract) 
                                 and not(self::gfc:featureCatalogue) 
                                 and not(self::gfc:carrierOfCharacteristics) 
          ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:typeName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:LocalName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LocalName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:LocalName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:LocalName) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:isAbstract">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Boolean)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Boolean"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Boolean"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Boolean) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:carrierOfCharacteristics">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gfc:FC_FeatureAttribute)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_FC_FeatureAttribute"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:FC_FeatureAttribute"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gfc:FC_FeatureAttribute) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:FC_FeatureAttribute">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gfc:memberName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_memberName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:memberName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:definition)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_definition"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:definition"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:cardinality)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_cardinality_empty"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:cardinality"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gfc:valueType)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gfc_valueType"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gfc:valueType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gfc:memberName) 
                                 and not(self::gfc:definition) 
                                 and not(self::gfc:cardinality) 
                                 and not(self::gfc:valueType) 
           ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:memberName">
		<xsl:copy>
			<xsl:choose>
				<!-- Backwards compatibility: eerst werd de waarde in gfc:memberName direct opgeslagen en niet in gco:LocalName -->
				<xsl:when test="not(gco:LocalName) and . != '' ">
					<xsl:element name="gco:LocalName">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="not(gco:LocalName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-LocalName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:LocalName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Do not copy everthing else under this node: Backwards compatibility. (We should actually never do this anywhere and just properly implement the entire ISO standard)  -->
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:cardinality">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:Integer)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-Integer"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:Integer"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:Integer) 
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gfc:valueType">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:TypeName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gco_TypeName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:TypeName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:TypeName)
            ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="gco:TypeName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:aName)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-gco_aName"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:aName"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:aName)
            ]"/>
		</xsl:copy>
	</xsl:template>

	<!-- backwards compatibility -->
    <xsl:template match="gco:Boolean">
		<xsl:copy>
			<xsl:choose>
                <xsl:when test="normalize-space(.) = 'TRUE' ">
					<xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'FALSE' ">
					<xsl:value-of select="false()"/>
                </xsl:when>
                <xsl:otherwise>
					<xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
		</xsl:copy>
	</xsl:template>
	
    <xsl:template name="handleDateDateTime">
        <xsl:choose>
            <xsl:when test="not(gco:Date) and not(gco:DateTime)">
                <!--Child element missing, create it-->
                <xsl:call-template name="add-Date"/>
            </xsl:when>
            <xsl:when test="gco:DateTime">
                <!--Child element exists, copy it-->
                <xsl:apply-templates select="gco:DateTime"/>
            </xsl:when>
            <xsl:otherwise>
                <!--Child element exists, copy it-->
                <xsl:apply-templates select="gco:Date"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--Copy everthing else under this node-->
        <xsl:apply-templates select="@*|node()[
                             not(self::gco:Date)
                             and not(self::gco:DateTime)
        ]"/>
    </xsl:template>

	<xsl:template match="gmd:fileIdentifier | gmd:parentIdentifier | gmd:code | gmd:codeSpace | gmd:MD_BrowseGraphic/gmd:fileName
									 | gmd:title | gmd:alternateTitle | gmd:edition | gmd:CI_Date/gmd:dateTypeCode | gmd:code
									 | gmd:abstract | gmd:purpose | gmd:organisationName | gmd:individualName | gmd:positionName | gmd:name
									 | gmd:deliveryPoint | gmd:city | gmd:administrativeArea | gmd:postalCode | gmd:country | gmd:electronicMailAddress | gmd:voice
									 | gmd:keyword | gmd:useLimitation | gmd:otherConstraints | gmd:version | gmd:explanation | gmd:statement | gmd:description
									 | gmx:name | gmx:scope | gmx:versionNumber
									 | gfc:definition
									 | gco:aName">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="not(gco:CharacterString)">
					<!--Child element missing, create it-->
					<xsl:call-template name="add-CharacterString"/>
				</xsl:when>
				<xsl:otherwise>
					<!--Child element exists, copy it-->
					<xsl:apply-templates select="gco:CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--Copy everthing else under this node-->
			<xsl:apply-templates select="@*|node()[
                                 not(self::gco:CharacterString)
            ]"/>
		</xsl:copy>
	</xsl:template>



<!-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// add-functions ////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

    <xsl:template name="add-MD_Metadata">
		<xsl:element name="gmd:MD_Metadata">
                        <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd http://www.isotc211.org/2005/gmd http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd</xsl:attribute>
			<xsl:call-template name="add-fileIdentifier"/> <!-- service en dataset-->
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-parentIdentifier"/> <!-- dataset -->
			</xsl:if>
			<xsl:call-template name="add-language"/> <!-- service en dataset -->
			<xsl:call-template name="add-characterSet"/> <!-- service en dataset -->
			<xsl:call-template name="add-hierarchyLevel"/> <!-- service en dataset -->
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-hierarchyLevelName"/> <!-- dataset -->
			</xsl:if>
			<xsl:call-template name="add-contact"/> <!-- service en dataset -->
			<xsl:call-template name="add-dateStamp"/> <!-- service en dataset -->
			<xsl:call-template name="add-metadataStandardName"/> <!-- service en dataset -->
			<xsl:call-template name="add-metadataStandardVersion"/> <!-- service en dataset -->
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-referenceSystemInfo"/> <!-- dataset -->
			</xsl:if>
			<xsl:call-template name="add-identificationInfo"/> <!-- service en dataset -->
			<xsl:call-template name="add-distributionInfo"/> <!-- service en dataset -->
			<xsl:call-template name="add-dataQualityInfo"/> <!-- service en dataset -->
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-fileIdentifier">
		<xsl:element name="gmd:fileIdentifier">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-fileIdentifier-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-parentIdentifier">
		<xsl:element name="gmd:parentIdentifier">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-language">
		<xsl:element name="gmd:language">
			<xsl:call-template name="add-LanguageCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-LanguageCode">
		<xsl:element name="gmd:LanguageCode">
			<xsl:attribute name="codeList">http://www.loc.gov/standards/iso639-2/</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-LanguageCode-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-characterSet">
		<xsl:element name="gmd:characterSet">
			<xsl:call-template name="add-MD_CharacterSetCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-hierarchyLevel">
		<xsl:element name="gmd:hierarchyLevel">
			<xsl:call-template name="add-MD_ScopeCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-hierarchyLevelName">
		<xsl:element name="gmd:hierarchyLevelName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-contact">
		<xsl:element name="gmd:contact">
			<xsl:call-template name="add-CI_ResponsibleParty"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-dateStamp">
		<xsl:element name="gmd:dateStamp">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-dateStamp-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-Date"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-metadataStandardName">
		<xsl:element name="gmd:metadataStandardName">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
                    <xsl:call-template name="add-metadataStandardName-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-metadataStandardVersion">
		<xsl:element name="gmd:metadataStandardVersion">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
                    <xsl:call-template name="add-metadataStandardVersion-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-referenceSystemInfo">
		<xsl:element name="gmd:referenceSystemInfo">
			<xsl:call-template name="add-MD_ReferenceSystem"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_ReferenceSystem">
		<xsl:element name="gmd:MD_ReferenceSystem">
			<xsl:call-template name="add-referenceSystemIdentifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-referenceSystemIdentifier">
		<xsl:element name="gmd:referenceSystemIdentifier">
			<xsl:call-template name="add-RS_Identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-RS_Identifier">
		<xsl:element name="gmd:RS_Identifier">
			<xsl:call-template name="add-code"/>
			<xsl:call-template name="add-codeSpace"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-code">
		<xsl:element name="gmd:code">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
                    <xsl:call-template name="add-code-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-codeSpace">
		<xsl:element name="gmd:codeSpace">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
                    <xsl:call-template name="add-codeSpace-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-identificationInfo">
		<xsl:element name="gmd:identificationInfo">
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-MD_DataIdentification"/>
			</xsl:if>
			<xsl:if test="$serviceMode">
				<xsl:call-template name="add-SV_ServiceIdentification"/>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_DataIdentification">
		<xsl:element name="gmd:MD_DataIdentification">
			<xsl:call-template name="add-citation"/>
			<xsl:call-template name="add-abstract"/>
			<xsl:call-template name="add-purpose"/>
			<xsl:call-template name="add-status"/>
			<xsl:call-template name="add-pointOfContact"/>
			<xsl:call-template name="add-resourceMaintenance"/>
			<xsl:call-template name="add-graphicOverview"/>
			<xsl:call-template name="add-descriptiveKeywords"/>

			<xsl:call-template name="add-resourceConstraints-MD_Constraints"/>
			<xsl:call-template name="add-resourceConstraints-MD_LegalConstraints"/>
			<xsl:call-template name="add-resourceConstraints-MD_SecurityConstraints"/>
                        
			<xsl:call-template name="add-aggregationInfo"/>
			<xsl:call-template name="add-spatialRepresentationType"/>
			<xsl:call-template name="add-spatialResolution-equivalentScale"/>
			<xsl:call-template name="add-spatialResolution-distance"/>
			<xsl:call-template name="add-language"/>
			<xsl:call-template name="add-characterSet"/>
			<xsl:call-template name="add-topicCategory"/>
			<xsl:call-template name="add-extent"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-SV_ServiceIdentification">
		<xsl:element name="srv:SV_ServiceIdentification">
			<xsl:call-template name="add-citation"/>
			<xsl:call-template name="add-abstract"/>
			<xsl:call-template name="add-pointOfContact"/>
			<xsl:call-template name="add-graphicOverview"/>
			<xsl:call-template name="add-descriptiveKeywords"/>

			<xsl:call-template name="add-resourceConstraints-MD_Constraints"/>
			<xsl:call-template name="add-resourceConstraints-MD_LegalConstraints"/>
			<xsl:call-template name="add-resourceConstraints-MD_SecurityConstraints"/>
                        
			<xsl:call-template name="add-srv_serviceType"/>
			<xsl:call-template name="add-srv_serviceTypeVersion"/>
			<xsl:call-template name="add-srv_extent"/>
			<xsl:call-template name="add-srv_coupledResource"/>
			<xsl:call-template name="add-srv_couplingType"/>
			<xsl:call-template name="add-srv_containsOperations"/>
			<xsl:call-template name="add-srv_operatesOn"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_serviceType">
		<xsl:element name="srv:serviceType">
			<xsl:call-template name="add-LocalName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_serviceTypeVersion">
		<xsl:element name="srv:serviceTypeVersion">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_extent">
		<xsl:element name="srv:extent">
			<xsl:call-template name="add-EX_Extent"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_coupledResource">
		<xsl:element name="srv:coupledResource">
			<xsl:call-template name="add-SV_CoupledResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-SV_CoupledResource">
		<xsl:element name="srv:SV_CoupledResource">
			<xsl:call-template name="add-srv_operationName"/>
			<xsl:call-template name="add-srv_identifier"/>
			<xsl:call-template name="add-ScopedName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_operationName">
		<xsl:element name="srv:operationName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_identifier">
		<xsl:element name="srv:identifier">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
    <xsl:template name="add-ScopedName">
		<xsl:element name="gco:ScopedName"/>
	</xsl:template>
 	<xsl:template name="add-srv_couplingType">
		<xsl:element name="srv:couplingType">
			<xsl:call-template name="add-SV_CouplingType"/>
		</xsl:element>
	</xsl:template>
    <xsl:template name="add-SV_CouplingType">
		<xsl:element name="srv:SV_CouplingType">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/iso19119/resources/Codelist/gmxCodelists.xml#SV_CouplingType</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-SV_CouplingType-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_containsOperations">
		<xsl:element name="srv:containsOperations">
			<xsl:call-template name="add-SV_OperationMetadata"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-SV_OperationMetadata">
		<xsl:element name="srv:SV_OperationMetadata">
			<xsl:call-template name="add-srv_operationName"/>
			<xsl:call-template name="add-srv_DCP"/>			
                        <xsl:call-template name="add-srv_connectPoint"/>
                </xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_DCP">
		<xsl:element name="srv:DCP">
			<xsl:call-template name="add-srv_DCPList"/>
		</xsl:element>
	</xsl:template>
       <xsl:template name="add-srv_DCPList">
		<xsl:element name="srv:DCPList">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/iso19119/resources/Codelist/gmxCodelists.xml#DCPList</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-DCPList-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_connectPoint">
		<xsl:element name="srv:connectPoint">
			<xsl:call-template name="add-CI_OnlineResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-srv_operatesOn">
		<xsl:element name="srv:operatesOn">
			<xsl:attribute name="uuidref"/>
            <xsl:attribute name="xlink:href"/>
		</xsl:element>
	</xsl:template>

    <xsl:template name="add-resourceMaintenance">
		<xsl:element name="gmd:resourceMaintenance">
			<xsl:call-template name="add-MD_MaintenanceInformation"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_MaintenanceInformation">
		<xsl:element name="gmd:MD_MaintenanceInformation">
			<xsl:call-template name="add-maintenanceAndUpdateFrequency"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-maintenanceAndUpdateFrequency">
		<xsl:element name="gmd:maintenanceAndUpdateFrequency">
			<xsl:call-template name="add-MD_MaintenanceFrequencyCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_MaintenanceFrequencyCode">
		<xsl:element name="gmd:MD_MaintenanceFrequencyCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_MaintenanceFrequencyCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-aggregationInfo">
		<xsl:element name="gmd:aggregationInfo">
			<xsl:call-template name="add-MD_AggregateInformation"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_AggregateInformation">
		<xsl:element name="gmd:MD_AggregateInformation">
			<xsl:call-template name="add-aggregateDataSetName"/>
			<xsl:call-template name="add-associationType"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-aggregateDataSetName">
		<xsl:element name="gmd:aggregateDataSetName">
			<xsl:call-template name="add-CI_Citation"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-associationType">
		<xsl:element name="gmd:associationType">
			<xsl:call-template name="add-DS_AssociationTypeCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DS_AssociationTypeCode">
		<xsl:element name="gmd:DS_AssociationTypeCode">
			<!-- Only allowed value according to NL profiel 1.2: crossReference. Fill in when Related dataset is filled  -->
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#DS_AssociationTypeCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-graphicOverview">
		<xsl:element name="gmd:graphicOverview">
			<xsl:call-template name="add-MD_BrowseGraphic"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_BrowseGraphic">
		<xsl:element name="gmd:MD_BrowseGraphic">
			<xsl:call-template name="add-fileName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-fileName">
		<xsl:element name="gmd:fileName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-citation">
		<xsl:element name="gmd:citation">
			<xsl:call-template name="add-citation-CI_Citation"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Citation">
		<xsl:element name="gmd:CI_Citation">
			<xsl:call-template name="add-title"/>
			<xsl:call-template name="add-alternateTitle"/>
			<xsl:call-template name="add-date"/>
			<xsl:call-template name="add-edition"/>
			<xsl:call-template name="add-identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-citation-CI_Citation">
		<xsl:element name="gmd:CI_Citation">
			<xsl:call-template name="add-citation-title"/>
			<xsl:call-template name="add-alternateTitle"/>
			<xsl:call-template name="add-date"/>
			<xsl:call-template name="add-edition"/>
			<xsl:call-template name="add-identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-citation-title">
		<xsl:element name="gmd:title">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-citation-title-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-title">
		<xsl:element name="gmd:title">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-alternateTitle">
		<xsl:element name="gmd:alternateTitle">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-edition">
		<xsl:element name="gmd:edition">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-date">
		<xsl:element name="gmd:date">
			<xsl:call-template name="add-CI_Date"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Date">
		<xsl:element name="gmd:CI_Date">
			<xsl:call-template name="add-inner-date"/>
			<xsl:call-template name="add-dateType"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-inner-date">
		<xsl:element name="gmd:date">
			<xsl:call-template name="add-Date"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-dateType">
		<xsl:element name="gmd:dateType">
			<xsl:call-template name="add-CI_DateTypeCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-dateTime">
		<xsl:element name="gmd:dateTime">
			<xsl:call-template name="add-DateTime"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-identifier">
		<xsl:element name="gmd:identifier">
			<xsl:call-template name="add-MD_Identifier"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Identifier">
		<xsl:element name="gmd:MD_Identifier">
			<xsl:call-template name="add-identifier_code"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-identifier_code">
		<xsl:element name="gmd:code">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-purpose">
		<xsl:element name="gmd:purpose">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-abstract">
		<xsl:element name="gmd:abstract">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-status">
		<xsl:element name="gmd:status">
			<xsl:call-template name="add-MD_ProgressCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-pointOfContact">
		<xsl:element name="gmd:pointOfContact">
			<xsl:call-template name="add-CI_ResponsibleParty"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_ResponsibleParty">
		<xsl:element name="gmd:CI_ResponsibleParty">
			<xsl:call-template name="add-individualName"/>
			<xsl:call-template name="add-organisationName"/>
			<xsl:call-template name="add-positionName"/>
			<xsl:call-template name="add-contactInfo"/>
			<xsl:call-template name="add-role"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-organisationName">
		<xsl:element name="gmd:organisationName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-individualName">
		<xsl:element name="gmd:individualName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-positionName">
		<xsl:element name="gmd:positionName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-role">
		<xsl:element name="gmd:role">
			<xsl:call-template name="add-CI_RoleCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-contactInfo">
		<xsl:element name="gmd:contactInfo">
			<xsl:call-template name="add-CI_Contact"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Contact">
		<xsl:element name="gmd:CI_Contact">
			<xsl:call-template name="add-phone"/>
			<xsl:call-template name="add-address"/>
			<xsl:call-template name="add-onlineResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-onlineResource">
		<xsl:element name="gmd:onlineResource">
			<xsl:call-template name="add-CI_OnlineResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_OnlineResource">
		<xsl:element name="gmd:CI_OnlineResource">
			<xsl:call-template name="add-linkage"/>
			<xsl:call-template name="add-protocol"/>
			<xsl:call-template name="add-name"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-linkage">
		<xsl:element name="gmd:linkage">
			<xsl:call-template name="add-URL"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-protocol">
		<xsl:element name="gmd:protocol">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-name">
		<xsl:element name="gmd:name">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-address">
		<xsl:element name="gmd:address">
			<xsl:call-template name="add-CI_Address"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Address">
		<xsl:element name="gmd:CI_Address">
			<xsl:call-template name="add-deliveryPoint"/>
			<xsl:call-template name="add-city"/>
			<xsl:call-template name="add-administrativeArea"/>
			<xsl:call-template name="add-postalCode"/>
			<xsl:call-template name="add-country"/>
			<xsl:call-template name="add-electronicMailAddress"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-deliveryPoint">
		<xsl:element name="gmd:deliveryPoint">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-city">
		<xsl:element name="gmd:city">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-administrativeArea">
		<xsl:element name="gmd:administrativeArea">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-postalCode">
		<xsl:element name="gmd:postalCode">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-country">
		<xsl:element name="gmd:country">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-electronicMailAddress">
		<xsl:element name="gmd:electronicMailAddress">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-phone">
		<xsl:element name="gmd:phone">
			<xsl:call-template name="add-CI_Telephone"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_Telephone">
		<xsl:element name="gmd:CI_Telephone">
			<xsl:call-template name="add-voice"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-voice">
		<xsl:element name="gmd:voice">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-spatialRepresentationType">
		<xsl:element name="gmd:spatialRepresentationType">
			<xsl:call-template name="add-MD_SpatialRepresentationTypeCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-spatialResolution-equivalentScale">
		<xsl:element name="gmd:spatialResolution">
			<xsl:call-template name="add-MD_Resolution-equivalentScale"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-spatialResolution-distance">
		<xsl:element name="gmd:spatialResolution">
			<xsl:call-template name="add-MD_Resolution-distance"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Resolution-equivalentScale">
		<xsl:element name="gmd:MD_Resolution">
			<xsl:call-template name="add-equivalentScale"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Resolution-distance">
		<xsl:element name="gmd:MD_Resolution">
			<xsl:call-template name="add-distance"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-distance">
		<xsl:element name="gmd:distance">
			<!-- TODO volgens ISO TS 1903-->
			<xsl:call-template name="add-Distance"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-equivalentScale">
		<xsl:element name="gmd:equivalentScale">
			<xsl:call-template name="add-MD_RepresentativeFraction"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_RepresentativeFraction">
		<xsl:element name="gmd:MD_RepresentativeFraction">
			<xsl:call-template name="add-denominator"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-denominator">
		<xsl:element name="gmd:denominator">
			<xsl:call-template name="add-Integer"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-topicCategory">
		<xsl:element name="gmd:topicCategory">
			<xsl:call-template name="add-MD_TopicCategoryCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-descriptiveKeywords">
		<xsl:if test="$serviceMode">
			<!-- 1 keyword mandatory -->
			<xsl:element name="gmd:descriptiveKeywords">
				<xsl:element name="gmd:MD_Keywords">
					<xsl:element name="gmd:keyword">
							<xsl:element name="gco:CharacterString">infoMapAccessService</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:element name="gmd:descriptiveKeywords">
			<xsl:call-template name="add-MD_Keywords"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Keywords">
		<xsl:element name="gmd:MD_Keywords">
			<xsl:call-template name="add-keyword"/>
			<xsl:call-template name="add-thesaurusName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-keyword">
		<xsl:element name="gmd:keyword">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-thesaurusName">
		<xsl:element name="gmd:thesaurusName">
			<xsl:call-template name="add-CI_Citation-Thesaurus"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-resourceConstraints-MD_Constraints">
		<xsl:element name="gmd:resourceConstraints">
			<xsl:call-template name="add-MD_Constraints"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-resourceConstraints-MD_LegalConstraints">
		<xsl:element name="gmd:resourceConstraints">
			<xsl:call-template name="add-MD_LegalConstraints"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-resourceConstraints-MD_SecurityConstraints">
		<xsl:element name="gmd:resourceConstraints">
			<xsl:call-template name="add-MD_SecurityConstraints"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Constraints">
		<xsl:element name="gmd:MD_Constraints">
			<xsl:call-template name="add-useLimitation"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-useLimitation">
		<xsl:element name="gmd:useLimitation">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_LegalConstraints">
		<xsl:element name="gmd:MD_LegalConstraints">
			<xsl:call-template name="add-accessConstraints"/>
			<xsl:call-template name="add-otherConstraints"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-accessConstraints">
		<xsl:element name="gmd:accessConstraints">
			<xsl:call-template name="add-MD_RestrictionCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-useConstraints">
		<xsl:element name="gmd:useConstraints">
			<xsl:call-template name="add-MD_RestrictionCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-otherConstraints">
		<xsl:element name="gmd:otherConstraints">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_SecurityConstraints">
		<xsl:element name="gmd:MD_SecurityConstraints">
			<xsl:call-template name="add-classification"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-classification">
		<xsl:element name="gmd:classification">
			<xsl:call-template name="add-MD_ClassificationCode"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-extent">
		<xsl:element name="gmd:extent">
			<xsl:call-template name="add-EX_Extent"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-EX_Extent">
		<xsl:element name="gmd:EX_Extent">
			<xsl:call-template name="add-description"/>
			<xsl:call-template name="add-geographicElement"/>
			<xsl:call-template name="add-temporalElement"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-geographicElement">
		<xsl:element name="gmd:geographicElement">
			<xsl:call-template name="add-EX_GeographicBoundingBox"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-EX_GeographicBoundingBox">
		<xsl:element name="gmd:EX_GeographicBoundingBox">
			<xsl:call-template name="add-westBoundLongitude"/>
			<xsl:call-template name="add-eastBoundLongitude"/>
			<xsl:call-template name="add-southBoundLatitude"/>
			<xsl:call-template name="add-northBoundLatitude"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-westBoundLongitude">
		<xsl:element name="gmd:westBoundLongitude">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-westBoundLongitude-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-Decimal"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-eastBoundLongitude">
		<xsl:element name="gmd:eastBoundLongitude">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-eastBoundLongitude-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-Decimal"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-southBoundLatitude">
		<xsl:element name="gmd:southBoundLatitude">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-southBoundLatitude-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-Decimal"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-northBoundLatitude">
		<xsl:element name="gmd:northBoundLatitude">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-northBoundLatitude-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-Decimal"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-temporalElement">
		<xsl:element name="gmd:temporalElement">
			<xsl:call-template name="add-EX_TemporalExtent"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-EX_TemporalExtent">
		<xsl:element name="gmd:EX_TemporalExtent">
			<xsl:call-template name="add-EX_TemporalExtent-extent"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-EX_TemporalExtent-extent">
		<xsl:element name="gmd:extent">
			<xsl:call-template name="add-TimePeriod"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-TimePeriod">
		<xsl:element name="gml:TimePeriod">
			<xsl:attribute name="gml:id">t1</xsl:attribute>
			<xsl:call-template name="add-beginPosition"/>
			<xsl:call-template name="add-endPosition"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-beginPosition">
		<xsl:element name="gml:begin">
			<xsl:element name="gml:TimeInstant">
				<xsl:attribute name="gml:id">t11</xsl:attribute>
				<xsl:element name="gml:timePosition"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-endPosition">
		<xsl:element name="gml:end">
			<xsl:element name="gml:TimeInstant">
				<xsl:attribute name="gml:id">t12</xsl:attribute>
				<xsl:element name="gml:timePosition"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-distributionInfo">
		<xsl:element name="gmd:distributionInfo">
			<xsl:call-template name="add-MD_Distribution"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Distribution">
		<xsl:element name="gmd:MD_Distribution">
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-distributionFormat"/>
				<xsl:call-template name="add-distributor"/>
			</xsl:if>
			<xsl:call-template name="add-transferOptions"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-distributionFormat">
		<xsl:element name="gmd:distributionFormat">
			<xsl:call-template name="add-MD_Format"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Format">
		<xsl:element name="gmd:MD_Format">
			<xsl:call-template name="add-name"/>
			<xsl:call-template name="add-version"/>
			<xsl:call-template name="add-specification"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-version">
		<xsl:element name="gmd:version">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-distributor">
		<xsl:element name="gmd:distributor">
			<xsl:call-template name="add-MD_Distributor"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_Distributor">
		<xsl:element name="gmd:MD_Distributor">
			<xsl:call-template name="add-distributorContact"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-distributorContact">
		<xsl:element name="gmd:distributorContact">
			<xsl:call-template name="add-CI_ResponsibleParty"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions">
		<xsl:element name="gmd:transferOptions">
			<xsl:call-template name="add-MD_DigitalTransferOptions"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_DigitalTransferOptions">
		<xsl:element name="gmd:MD_DigitalTransferOptions">
			<xsl:call-template name="add-onLine"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-online">
		<xsl:element name="gmd:online">
			<xsl:call-template name="add-transferOptions-CI_OnlineResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-onLine">
		<xsl:element name="gmd:onLine">
			<xsl:call-template name="add-transferOptions-CI_OnlineResource"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-CI_OnlineResource">
		<xsl:element name="gmd:CI_OnlineResource">
			<xsl:call-template name="add-transferOptions-linkage"/>
			<xsl:call-template name="add-transferOptions-protocol"/>
			<xsl:call-template name="add-transferOptions-name"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-linkage">
		<xsl:element name="gmd:linkage">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-transferOptions-linkage-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-URL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-protocol">
		<xsl:element name="gmd:protocol">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-transferOptions-protocol-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-name">
		<xsl:element name="gmd:name">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-transferOptions-name-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-dataQualityInfo">
		<xsl:element name="gmd:dataQualityInfo">
			<xsl:call-template name="add-DQ_DataQuality"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_DataQuality">
		<xsl:element name="gmd:DQ_DataQuality">
			<xsl:call-template name="add-scope"/>
			<xsl:call-template name="add-report-DQ_DomainConsistency"/>
			<xsl:call-template name="add-report-DQ_AbsoluteExternalPositionalAccuracy"/>
			<xsl:call-template name="add-report-DQ_CompletenessOmission"/>
			<xsl:if test="$datasetMode">
				<xsl:call-template name="add-lineage"/>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-scope">
		<xsl:element name="gmd:scope">
			<xsl:call-template name="add-DQ_Scope"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_Scope">
		<xsl:element name="gmd:DQ_Scope">
			<xsl:call-template name="add-level"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-level">
		<xsl:element name="gmd:level">
			<xsl:call-template name="add-MD_ScopeCode"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-report-DQ_DomainConsistency">
		<xsl:element name="gmd:report">
			<xsl:call-template name="add-DQ_DomainConsistency"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_DomainConsistency">
		<xsl:element name="gmd:DQ_DomainConsistency">
			<xsl:call-template name="add-result-DQ_ConformanceResult"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-result-DQ_ConformanceResult">
		<xsl:element name="gmd:result">
			<xsl:call-template name="add-DQ_ConformanceResult"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_ConformanceResult">
		<xsl:element name="gmd:DQ_ConformanceResult">
			<xsl:call-template name="add-specification-specification-services"/>
			<xsl:call-template name="add-explanation"/>
			<xsl:call-template name="add-pass"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-pass">
		<xsl:element name="gmd:pass">
			<xsl:call-template name="add-Boolean"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-explanation">
		<xsl:element name="gmd:explanation">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-specification">
		<xsl:element name="gmd:specification">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>	
	<xsl:template name="add-specification-specification-services">
		<xsl:element name="gmd:specification">
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-CI_Citation-specification-services"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CI_Citation"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>	
	<xsl:template name="add-report-DQ_AbsoluteExternalPositionalAccuracy">
		<xsl:element name="gmd:report">
			<xsl:call-template name="add-DQ_AbsoluteExternalPositionalAccuracy"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-report-DQ_CompletenessOmission">
		<xsl:element name="gmd:report">
			<xsl:call-template name="add-DQ_CompletenessOmission"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_AbsoluteExternalPositionalAccuracy">
		<xsl:element name="gmd:DQ_AbsoluteExternalPositionalAccuracy">
			<xsl:call-template name="add-result-DQ_QuantitativeResult"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_CompletenessOmission">
		<xsl:element name="gmd:DQ_CompletenessOmission">
			<xsl:call-template name="add-result-DQ_QuantitativeResult"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-result-DQ_QuantitativeResult">
		<xsl:element name="gmd:result">
			<xsl:call-template name="add-DQ_QuantitativeResult"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-DQ_QuantitativeResult">
		<xsl:element name="gmd:DQ_QuantitativeResult">
			<xsl:call-template name="add-valueUnit-nilReason"/>
			<xsl:call-template name="add-value"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-valueUnit-nilReason">
		<xsl:element name="gmd:valueUnit">
			<!-- chrome cannot handle namspaced attributes. added via javascript later -->
			<!--xsl:attribute name="gco:nilReason"></xsl:attribute-->
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-value">
		<xsl:element name="gmd:value">
			<xsl:call-template name="add-Record"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-lineage">
		<xsl:element name="gmd:lineage">
			<xsl:call-template name="add-LI_Lineage"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-LI_Lineage">
		<xsl:element name="gmd:LI_Lineage">
			<xsl:call-template name="add-statement"/>
			<xsl:call-template name="add-processStep"/>
			<xsl:call-template name="add-source"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-statement">
		<xsl:element name="gmd:statement">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-processStep">
		<xsl:element name="gmd:processStep">
			<xsl:call-template name="add-LI_ProcessStep"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-LI_ProcessStep">
		<xsl:element name="gmd:LI_ProcessStep">
			<xsl:call-template name="add-description"/>
			<xsl:call-template name="add-dateTime"/>
			<xsl:call-template name="add-processor"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-description">
		<xsl:element name="gmd:description">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-processor">
		<xsl:element name="gmd:processor">
			<xsl:call-template name="add-CI_ResponsibleParty"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-source">
		<xsl:element name="gmd:source">
			<xsl:call-template name="add-LI_Source"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-LI_Source">
		<xsl:element name="gmd:LI_Source">
			<xsl:call-template name="add-description"/>
			<xsl:call-template name="add-sourceStep"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-sourceStep">
		<xsl:element name="gmd:sourceStep">
			<xsl:call-template name="add-LI_ProcessStep"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Eindelementen -->
	<xsl:template name="add-CharacterString">
		<xsl:element name="gco:CharacterString"/>
	</xsl:template>
	<xsl:template name="add-LocalName">
		<xsl:element name="gco:LocalName"/>
	</xsl:template>
	<xsl:template name="add-Record">
		<xsl:element name="gco:Record"/>
	</xsl:template>
	<xsl:template name="add-Date">
		<xsl:element name="gco:Date"/>
	</xsl:template>
	<xsl:template name="add-DateTime">
		<xsl:element name="gco:DateTime"/>
	</xsl:template>
	<xsl:template name="add-Decimal">
		<xsl:element name="gco:Decimal"/>
	</xsl:template>
	<xsl:template name="add-Integer">
		<xsl:element name="gco:Integer"/>
	</xsl:template>
	<xsl:template name="add-Boolean">
		<xsl:element name="gco:Boolean">
			<xsl:call-template name="add-Boolean-default"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-Distance">
		<xsl:element name="gco:Distance">
			<xsl:attribute name="uom">meters</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-URL">
		<xsl:element name="gmd:URL"/>
	</xsl:template>
	<xsl:template name="add-CI_DateTypeCode">
		<xsl:element name="gmd:CI_DateTypeCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_CharacterSetCode">
		<xsl:element name="gmd:MD_CharacterSetCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_CharacterSetCode</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-MD_CharacterSetCode-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_ProgressCode">
		<xsl:element name="gmd:MD_ProgressCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_ProgressCode</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-MD_ProgressCode-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-CI_RoleCode">
		<xsl:element name="gmd:CI_RoleCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-CI_RoleCode-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_SpatialRepresentationTypeCode">
		<xsl:element name="gmd:MD_SpatialRepresentationTypeCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_SpatialRepresentationTypeCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_TopicCategoryCode">
		<xsl:element name="gmd:MD_TopicCategoryCode"/>
    </xsl:template>
	<xsl:template name="add-MD_ScopeCode">
		<xsl:element name="gmd:MD_ScopeCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_ScopeCode</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$fillDefaults">
					<xsl:call-template name="add-MD_ScopeCode-default"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_RestrictionCode">
		<xsl:element name="gmd:MD_RestrictionCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_RestrictionCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-MD_ClassificationCode">
		<xsl:element name="gmd:MD_ClassificationCode">
			<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#MD_ClassificationCode</xsl:attribute>
			<xsl:attribute name="codeListValue"/>
		</xsl:element>
	</xsl:template>
	<!-- Feature catalogue ISO 19110 -->
	<xsl:template name="add-gfc_FC_FeatureCatalogue">
		<xsl:element name="gfc:FC_FeatureCatalogue">
			<xsl:call-template name="add-gmx_name"/>
			<xsl:call-template name="add-gmx_scope"/>
			<xsl:call-template name="add-gmx_versionNumber"/>
			<xsl:call-template name="add-gmx_versionDate"/>
			<xsl:call-template name="add-gfc_producer"/>
			<xsl:call-template name="add-gfc_featureType"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gmx_name">
		<xsl:element name="gmx:name">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gmx_scope">
		<xsl:element name="gmx:scope">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gmx_versionNumber">
		<xsl:element name="gmx:versionNumber">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gmx_versionDate">
		<xsl:element name="gmx:versionDate">
			<xsl:call-template name="add-Date"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_producer">
		<xsl:element name="gfc:producer">
			<xsl:call-template name="add-CI_ResponsibleParty"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_featureType">
		<xsl:element name="gfc:featureType">
			<xsl:call-template name="add-gfc_FC_FeatureType"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_FC_FeatureType">
		<xsl:choose>
			<xsl:when test="$fillDefaults">
				<xsl:call-template name="add-gfc_FC_FeatureType-default"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add-gfc_FC_FeatureType-normal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="add-gfc_FC_FeatureType-normal">
		<xsl:element name="gfc:FC_FeatureType">
			<xsl:call-template name="add-gfc_typeName"/>
			<xsl:call-template name="add-gfc_definition"/>
			<xsl:call-template name="add-gfc_isAbstract_empty"/>
			<xsl:call-template name="add-gfc_featureCatalogue_empty"/>
			<xsl:call-template name="add-gfc_carrierOfCharacteristics"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_typeName">
		<xsl:element name="gfc:typeName">
			<xsl:call-template name="add-LocalName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_definition">
		<xsl:element name="gfc:definition">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_isAbstract_empty">
		<xsl:element name="gfc:isAbstract">
			<xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_featureCatalogue_empty">
		<xsl:element name="gfc:featureCatalogue">
			<xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_carrierOfCharacteristics">
		<xsl:element name="gfc:carrierOfCharacteristics">
			<xsl:call-template name="add-gfc_FC_FeatureAttribute"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_FC_FeatureAttribute">
		<xsl:element name="gfc:FC_FeatureAttribute">
			<xsl:call-template name="add-gfc_memberName"/>
			<xsl:call-template name="add-gfc_definition"/>
			<xsl:call-template name="add-gfc_cardinality_empty"/>
			<xsl:call-template name="add-gfc_valueType"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_memberName">
		<xsl:element name="gfc:memberName">
			<xsl:call-template name="add-LocalName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_cardinality_empty">
		<xsl:element name="gfc:cardinality">
			<xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_valueType">
		<xsl:element name="gfc:valueType">
			<xsl:call-template name="add-gco_TypeName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gco_TypeName">
		<xsl:element name="gco:TypeName">
			<xsl:call-template name="add-gco_aName"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gco_aName">
		<xsl:element name="gco:aName">
			<xsl:call-template name="add-CharacterString"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="add-B3Partners">
		<xsl:element name="b3p:B3Partners">
            <xsl:call-template name="add-comments"/>
            <xsl:if test="$dcMode">
				<xsl:choose>
					<xsl:when test="$dcPblMode">
						<xsl:call-template name="add-metadataPBL"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="add-metadataDC"/>
					</xsl:otherwise>
				</xsl:choose>
            </xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-comments">
		<xsl:element name="b3p:comments">
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-metadataDC">
		<xsl:element name="b3p:metadataDC">
			<xsl:call-template name="add-DC-elems"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-metadataPBL">
		<xsl:element name="pbl:metadataPBL">
			<xsl:call-template name="add-DC-elems"/>
			<xsl:call-template name="add-PBL-frequency"/>
			<xsl:call-template name="add-PBL-testsPerformed"/>
		</xsl:element>
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
		<xsl:element name="dc:title"/>
	</xsl:template>
	
	<xsl:template name="add-DC-creator">
		<xsl:element name="dc:creator"/>
	</xsl:template>
	
	<xsl:template name="add-DC-subject">
		<xsl:element name="dc:subject"/>
	</xsl:template>
	
	<xsl:template name="add-DC-description">
		<xsl:element name="dc:description"/>
	</xsl:template>
	
	<xsl:template name="add-DC-publisher">
		<xsl:element name="dc:publisher"/>
	</xsl:template>
	
	<xsl:template name="add-DC-contributor">
		<xsl:element name="dc:contributor"/>
	</xsl:template>
	
	<xsl:template name="add-DC-date">
		<xsl:element name="dc:date"/>
	</xsl:template>
	
	<xsl:template name="add-DC-type">
		<xsl:element name="dc:type"/>
	</xsl:template>
	
	<xsl:template name="add-DC-format">
		<xsl:element name="dc:format"/>
	</xsl:template>
	
	<xsl:template name="add-DC-identifier">
		<xsl:element name="dc:identifier"/>
	</xsl:template>
	
	<xsl:template name="add-DC-source">
		<xsl:element name="dc:source"/>
	</xsl:template>
	
	<xsl:template name="add-DC-language">
		<xsl:element name="dc:language"/>
	</xsl:template>
	
	<xsl:template name="add-DC-relation">
		<xsl:element name="dc:relation"/>
	</xsl:template>
	
	<xsl:template name="add-DC-coverage">
		<xsl:element name="dc:coverage"/>
	</xsl:template>
	
	<xsl:template name="add-DC-rights">
		<xsl:element name="dc:rights"/>
	</xsl:template>

	<xsl:template name="add-PBL-frequency">
		<xsl:element name="pbl:frequency"/>
	</xsl:template>
	
	<xsl:template name="add-PBL-testsPerformed">
		<xsl:element name="pbl:testsPerformed"/>
	</xsl:template>
	
	<!-- 
	Geosticker needs Booleans to have a value; i.e. they cannot be empty/null 
	The best solution would be to not create the Boolean value, but this is impossible in the setup we have chosen.
	-->
    <!-- Different solution: We remove empty nodes when exporting the metadata, therefore boolean can be empty by default. -->
	<xsl:template name="add-Boolean-default">
		<!--xsl:text>false</xsl:text-->
	</xsl:template>
	<xsl:template name="add-fileIdentifier-default">
		<xsl:element name="gco:CharacterString">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-MetaID-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-dateStamp-default">
		<xsl:element name="gco:Date">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="dateformat">
						<xsl:with-param name="date">
							<xsl:call-template name="add-ModDate-esri"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-metadataStandardName-default">
		<xsl:choose>
				<xsl:when test="$serviceMode">
					<xsl:element name="gco:CharacterString">ISO 19119</xsl:element>
				</xsl:when>
				<xsl:when test="$datasetMode">
					<xsl:element name="gco:CharacterString">ISO 19115</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template name="add-metadataStandardVersion-default">
		<xsl:choose>
				<xsl:when test="$serviceMode">
					<xsl:element name="gco:CharacterString"> Nederlands metadata profiel op ISO 19119 voor services 1.2</xsl:element>
				</xsl:when>
				<xsl:when test="$datasetMode">
					<xsl:element name="gco:CharacterString">Nederlandse metadata profiel op ISO 19115 voor geografie 1.3.1</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="add-CharacterString"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template name="add-code-default">
		<xsl:element name="gco:CharacterString">28992</xsl:element>
	</xsl:template>
	<xsl:template name="add-codeSpace-default">
		<xsl:element name="gco:CharacterString">EPSG</xsl:element>
	</xsl:template>
	<xsl:template name="add-citation-title-default">
		<xsl:element name="gco:CharacterString">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-resTitle-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-westBoundLongitude-default">
		<xsl:element name="gco:Decimal">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-westBL-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-eastBoundLongitude-default">
		<xsl:element name="gco:Decimal">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-eastBL-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-southBoundLatitude-default">
		<xsl:element name="gco:Decimal">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-southBL-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-northBoundLatitude-default">
		<xsl:element name="gco:Decimal">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-northBL-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-LanguageCode-default">
		<xsl:attribute name="codeListValue">dut</xsl:attribute>
		<xsl:text>Nederlands</xsl:text>
	</xsl:template>
	<xsl:template name="add-MD_CharacterSetCode-default">
		<xsl:attribute name="codeListValue">utf8</xsl:attribute>
		<xsl:text>utf8</xsl:text>
	</xsl:template>
	<xsl:template name="add-MD_ProgressCode-default">
		<xsl:attribute name="codeListValue">completed</xsl:attribute>
		<xsl:text>compleet</xsl:text>
	</xsl:template>
	<xsl:template name="add-MD_ScopeCode-default">
		<xsl:choose>
				<xsl:when test="$serviceMode">
					<xsl:attribute name="codeListValue">service</xsl:attribute>
					<xsl:text>service</xsl:text>
				</xsl:when>
				<xsl:when test="$datasetMode">
					<xsl:attribute name="codeListValue">dataset</xsl:attribute>
					<xsl:text>dataset</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="codeListValue">dataset</xsl:attribute>
					<xsl:text>dataset</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template name="add-SV_CouplingType-default">
		<xsl:attribute name="codeListValue">loose</xsl:attribute>
		<xsl:text>dataset</xsl:text>
	</xsl:template>
	<xsl:template name="add-DCPList-default">
		<xsl:attribute name="codeListValue">WebServices</xsl:attribute>
		<xsl:text>dataset</xsl:text>
	</xsl:template>
	<xsl:template name="add-CI_RoleCode-default">
		<xsl:attribute name="codeListValue">pointOfContact</xsl:attribute>
		<xsl:text>contactpunt</xsl:text>
	</xsl:template>
	<xsl:template name="add-transferOptions-linkage-default">
		<xsl:element name="gmd:URL">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-linkage-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-protocol-default">
		<xsl:element name="gco:CharacterString">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
                    <!-- only set protocol to a default if esri has an url for the online resource. -->
                    <xsl:if test="/*[name()='metadata']/*[name()='distInfo']/*[name()='distributor']/*[name()='distorTran']/*[name()='onLineSrc']/*[name()='linkage']">
                        <xsl:value-of select="'download'"/>
                    </xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-transferOptions-name-default">
		<xsl:element name="gco:CharacterString">
			<xsl:choose>
				<xsl:when test="$synchroniseEsri">
					<xsl:call-template name="add-resTitle-esri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="add-gfc_FC_FeatureType-default">
		<xsl:choose>
			<xsl:when test="$synchroniseEsri and /*[name()='metadata']/*[name()='dataset_description']/*[name()='data_definition']/*[name()='object_type']/*[name()='object_type_name']">
				<xsl:call-template name="add-gfc_FC_FeatureType-esri"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add-gfc_FC_FeatureType-normal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- paden naar esri gegevens tbv synchroniser -->
	<xsl:template name="add-MetaID-esri">
		<!-- xsl:value-of select="/gmd:metadata/gmd:Esri/gmd:MetaID"/ -->
		<!-- workaround because of varying namespace -->
		<xsl:for-each select="/*[name()='metadata']/*[name()='Esri']/*[name()='MetaID']">
			<xsl:value-of select="."/>
		</xsl:for-each>
		<!-- {B518C789-937A-4552-B1CA-2D2CC230C719} -->
	</xsl:template>
	<xsl:template name="add-CreaDate-esri">
		<!-- xsl:value-of select="/metadata/Esri/CreaDate"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='Esri']/*[name()='CreaDate']"/>
		<!-- 20090331 -->
	</xsl:template>
	<xsl:template name="add-CreaTime-esri">
		<!-- xsl:value-of select="/metadata/Esri/CreaTime"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='Esri']/*[name()='CreaTime']"/>
		<!-- 10294700 -->
	</xsl:template>
	<xsl:template name="add-ModDate-esri">
		<!-- xsl:value-of select="/metadata/Esri/ModDate"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='Esri']/*[name()='ModDate']"/>
		<!-- 20090331 -->
	</xsl:template>
	<xsl:template name="add-ModTime-esri">
		<!-- xsl:value-of select="/metadata/Esri/ModTime"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='Esri']/*[name()='ModTime']"/>
		<!-- 10294700 -->
	</xsl:template>
	<xsl:template name="add-resTitle-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/idCitation/resTitle"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='idCitation']/*[name()='resTitle']"/>
		<!-- test_mde -->
	</xsl:template>
	<xsl:template name="add-GeoBndBox-westBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/westBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='dataExt']/*[name()='geoEle']/*[name()='GeoBndBox']/*[name()='westBL']"/>
		<!-- 77236 -->
	</xsl:template>
	<xsl:template name="add-GeoBndBox-eastBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/eastBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='dataExt']/*[name()='geoEle']/*[name()='GeoBndBox']/*[name()='eastBL']"/>
		<!-- 140441 -->
	</xsl:template>
	<xsl:template name="add-GeoBndBox-northBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/northBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='dataExt']/*[name()='geoEle']/*[name()='GeoBndBox']/*[name()='northBL']"/>
		<!-- 426024 -->
	</xsl:template>
	<xsl:template name="add-GeoBndBox-southBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/southBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='dataExt']/*[name()='geoEle']/*[name()='GeoBndBox']/*[name()='southBL']"/>
		<!-- 381457 -->
	</xsl:template>
	<xsl:template name="add-westBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/geoBox/westBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='geoBox']/*[name()='westBL']"/>
		<!-- 4.25958 -->
	</xsl:template>
	<xsl:template name="add-eastBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/geoBox/eastBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='geoBox']/*[name()='eastBL']"/>
		<!-- 5.178165 -->
	</xsl:template>
	<xsl:template name="add-northBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/geoBox/northBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='geoBox']/*[name()='northBL']"/>
		<!-- 51.823564 -->
	</xsl:template>
	<xsl:template name="add-southBL-esri">
		<!-- xsl:value-of select="/metadata/dataIdInfo/geoBox/southBL"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='dataIdInfo']/*[name()='geoBox']/*[name()='southBL']"/>
		<!-- 51.417794 -->
	</xsl:template>
	<xsl:template name="add-mdHrLvName-esri">
		<!-- xsl:value-of select="/metadata/mdHrLvName"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='mdHrLvName']"/>
		<!-- dataset -->
	</xsl:template>
	<xsl:template name="add-linkage-esri">
		<!-- xsl:value-of select="/metadata/distInfo/distributor/distorTran/onLineSrc/linkage"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='distInfo']/*[name()='distributor']/*[name()='distorTran']/*[name()='onLineSrc']/*[name()='linkage']"/>
		<!-- file://\\GWLT2\D$\projdata\b3p_mde\testdata\test_mde.shp -->
	</xsl:template>
	<xsl:template name="add-protocol-esri">
		<!-- xsl:value-of select="/metadata/distInfo/distributor/distorTran/onLineSrc/protocol"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='distInfo']/*[name()='distributor']/*[name()='distorTran']/*[name()='onLineSrc']/*[name()='protocol']"/>
		<!-- Local Area Network -->
	</xsl:template>
	<xsl:template name="add-natvform-esri">
		<!-- xsl:value-of select="/metadata/idinfo/natvform"/ -->
		<xsl:value-of select="/*[name()='metadata']/*[name()='idinfo']/*[name()='natvform']"/>
		<!-- Shapefile -->
	</xsl:template>

	<xsl:template name="add-gfc_FC_FeatureType-esri">
		<xsl:element name="gfc:FC_FeatureType">
			<xsl:for-each select="/*[name()='metadata']/*[name()='dataset_description']/*[name()='data_definition']/*[name()='object_type']">
				<xsl:element name="gfc:typeName">
					<xsl:element name="gco:LocalName">
						<xsl:value-of select="*[name()='object_type_name']"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="gfc:definition">
					<xsl:element name="gco:CharacterString">
						<xsl:value-of select="*[name()='object_type_definition']"/>
					</xsl:element>
				</xsl:element>
				<xsl:call-template name="add-gfc_isAbstract_empty"/>
				<xsl:choose>
					<xsl:when test="*[name()='attribute_type']/*[name()='attribute_type_name']">
						<xsl:for-each select="*[name()='attribute_type']">
							<xsl:element name="gfc:carrierOfCharacteristics">
								<xsl:element name="gfc:FC_FeatureAttribute">
									<xsl:element name="gfc:memberName">
										<xsl:element name="gco:LocalName">
											<xsl:value-of select="*[name()='attribute_type_name']"/>
										</xsl:element>
									</xsl:element>
									<xsl:element name="gfc:definition">
										<xsl:element name="gco:CharacterString">
											<xsl:value-of select="*[name()='attribute_type_definition']"/>
										</xsl:element>
									</xsl:element>
									<xsl:call-template name="add-gfc_cardinality_empty"/>
									<xsl:call-template name="add-gfc_valueType"/>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="add-gfc_carrierOfCharacteristics"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="dateformat">
		<xsl:param name="date"/>
		<xsl:if test="string-length($date) &gt; 0">
			<xsl:value-of select="substring($date,1,4)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring($date,5,2)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring($date,7,2)"/>
		</xsl:if>
	</xsl:template>
	

</xsl:stylesheet>
