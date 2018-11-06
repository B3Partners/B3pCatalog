<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml" xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srv="http://www.isotc211.org/2005/srv" exclude-result-prefixes="xlink gmd gfc gmx gco gml b3p pbl dc srv">
	<!-- These parameters must be set by the transformer -->
	<xsl:param name="basePath"/>
	<xsl:param name="displayMode">simple</xsl:param>
	<xsl:param name="colorScheme">light</xsl:param>
	<xsl:param name="dateFormatUserHint">dd-mm-jjjj</xsl:param>
	<xsl:param name="globalReadonly_init">false</xsl:param>
	<xsl:param name="commentMode_init">true</xsl:param>
	<xsl:param name="dcMode_init">true</xsl:param>
	<xsl:param name="serviceMode_init">true</xsl:param>
	<xsl:param name="datasetMode_init">true</xsl:param>
	<xsl:param name="fcMode_init">true</xsl:param>
	<xsl:param name="dcPblMode_init">false</xsl:param>
	<xsl:param name="synchroniseDC_init">false</xsl:param>
	<xsl:param name="globalReadonly" select="$globalReadonly_init = 'true'"/>
	<xsl:param name="commentMode" select="$commentMode_init = 'true'"/>
	<xsl:param name="dcMode" select="$dcMode_init = 'true'"/>
	<xsl:param name="serviceMode" select="$serviceMode_init = 'true'"/>
	<xsl:param name="datasetMode" select="$datasetMode_init = 'true'"/>
	<xsl:param name="fcMode" select="$fcMode_init = 'true'"/>
	<xsl:param name="dcPblMode" select="$dcPblMode_init = 'true'"/>
	<xsl:param name="synchroniseDC" select="$synchroniseDC_init = 'true'"/>
	<xsl:output method="html" indent="no" version="4.0"/>
	<!--
	Auteur: Erik van de Pol. B3Partners.
	Adapted: Chris van Lith

    Beschrijving stylesheet:
    In het algemeen geldt dat voor elke property (waarde/xml-node/xml-tag) een apart template is gemaakt.
    -->
	<xsl:template match="node()[@xlink:href]">
		<xsl:apply-templates select="id(@xlink:href)"/>
	</xsl:template>
	<xsl:template match="node()[@xlink:href]">
		<xsl:apply-templates select="id(@xlink:href)"/>
	</xsl:template>
	<xsl:template match="/">
		<div id="metadataEditor">
			<xsl:call-template name="editDocRoot"/>
		</div>
	</xsl:template>
	<xsl:template name="editDocRoot">
		<xsl:element name="div">
			<xsl:attribute name="id">edit-doc-root</xsl:attribute>
			<xsl:attribute name="class">
                        color-scheme-<xsl:value-of select="$colorScheme"/><xsl:if test="$displayMode = 'simple'"> ui-mde-simple</xsl:if></xsl:attribute>
			<div id="ui-mde-tabs-container">
				<ul id="ui-mde-tabs" class="ui-helper-reset">
					<li class="ui-corner-top">
						<a href="#algemeen" title="Algemeen">Algemeen</a>
					</li>
				</ul>
			</div>
			<xsl:call-template name="elements"/>
			<div class="hidden">
				<xsl:call-template name="picklists"/>
			</div>
		</xsl:element>
	</xsl:template>
	<xsl:template name="elements">
		<div id="algemeen" class="ui-mde-tab-definition">
			<xsl:for-each select="/gmd:MD_Metadata | /*/gmd:MD_Metadata">
			<div class="ui-mde-section color-1">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Algemeen</xsl:with-param>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<!-- Titel van de bron ISO 360 (groter lettertype, gecentreerd)  -->
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
					<!-- Samenvatting ISO 25  -->
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract"/>
					<!-- Verantwoordelijke organisatie bron ISO 29, daaronder ingesprongen: -->        
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">
						<xsl:with-param name="individualNameReadonly" select="$globalReadonly"/>
						<xsl:with-param name="help-description" select="'De  naam van de (overheids)organisatie die verantwoordelijk is voor de dataset. Voluit geschreven. Bijvoorbeeld: Gemeente Haarlem; Rijkswaterstaat (RWS). '"/>
					</xsl:apply-templates>
					<!-- ISO 9 Metadata datum MD_Metadata.dateStamp -->
					<xsl:apply-templates select="gmd:dateStamp"/>
					<!-- ISO 2 Metadata ID MD_Metadata.fileIdentifier -->
					<xsl:apply-templates select="gmd:fileIdentifier"/>
				</div>
			</div>
			<div class="ui-mde-section color-2">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Kenmerken</xsl:with-param>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<!-- Doel van vervaardiging ISO 26  -->
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose"/>
					<!-- Algemene beschrijving herkomst  ISO 83  -->
					<xsl:apply-templates select="gmd:dataQualityInfo//gmd:lineage//gmd:statement"/>
					<!-- Volledigheid/Nauwkeurigheid van de dataset ISO 137-->
					<!-- Compleetheid -->
					<xsl:apply-templates select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_CompletenessOmission/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record"/>
						<!-- Trefwoorden ISO 53 (mogen kommagescheiden weergegeven worden)  -->
						<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString"/>
				</div>
			</div>
			<div class="ui-mde-section color-3">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Actualiteit</xsl:with-param>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<!-- ISO 394 Dataset referentie datum -->
					<!-- ISO 395 Creatie-, publicatie-, of wijzigingsdatum -->
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date">
						<xsl:with-param name="readonly" select="$globalReadonly"/>
						<xsl:with-param name="optionality">optional</xsl:with-param>
					</xsl:apply-templates>
					<!-- ISO 143 Herzieningsfrequentie -->
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode"/>
				</div>
			</div>
		<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
			<div class="ui-mde-section color-4">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Naar de dataset  <xsl:call-template name="position"/>
					</xsl:with-param>
					<xsl:with-param name="repeatable" select="true()"/>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:linkage"/>
					<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:name/gco:CharacterString"/>
					<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString"/>			
					</div>
			</div>
		</xsl:for-each>
			<div class="ui-mde-section color-5">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Openheid</xsl:with-param>
				</xsl:call-template>
				<div class="ui-mde-section-content">
				<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints">
				<!--
					<xsl:apply-templates select="gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString"/>
					<xsl:apply-templates select="gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/>
				-->
					<xsl:apply-templates select="gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString"/>
				</xsl:for-each>
				</div>
			</div>
		<xsl:for-each select="gmd:contact">
			<div class="ui-mde-section color-6">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Contactgegevens dataset</xsl:with-param>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<xsl:apply-templates select="gmd:CI_ResponsibleParty">
						<xsl:with-param name="individualNameReadonly" select="$globalReadonly"/>
						<xsl:with-param name="help-description" select="'Het gaat hier om de organisatie met wie contact opgenomen kan worden bij vragen over de dataset. Deze organisatie is in staat om alle vragen over de dataset te adresseren.'"/>
					</xsl:apply-templates>
				</div>
			</div>
		</xsl:for-each>
		</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template name="picklists">
		<!-- CI_DateTypeCode (B.5.2)-->
		<xsl:call-template name="picklist_CI_DateTypeCode"/>
		<!-- CI_RoleCode (B.5.5)-->
		<xsl:call-template name="picklist_CI_RoleCode"/>
		<!-- MD_CharacterSetCode (B.5.10) -->
		<xsl:call-template name="picklist_MD_CharacterSetCode"/>
		<!-- MD_ClassificationCode (B.5.11) -->
		<xsl:call-template name="picklist_MD_ClassificationCode"/>
		<!-- MD_ProgressCode (B.5.23)-->
		<xsl:call-template name="picklist_MD_ProgressCode"/>
		<!-- MD_RestrictionCode (B.5.24)-->
		<xsl:call-template name="picklist_MD_RestrictionCode"/>
		<!-- MD_ScopeCode (B.5.25) -->
		<xsl:call-template name="picklist_MD_ScopeCode"/>
		<!-- MD_SpatialRepresentation TypeCode (B.5.26) -->
		<xsl:call-template name="picklist_MD_SpatialRepresentationTypeCode"/>
		<!-- MD_TopicCategoryCode (B.5.27) -->
		<xsl:call-template name="picklist_MD_TopicCategoryCode"/>
		<!-- languageCode: eigen lijst -->
		<xsl:call-template name="picklist_LanguageCode"/>
		<!-- SV_ServiceType: eigen lijst -->
		<xsl:call-template name="picklist_SV_ServiceType"/>
		<xsl:call-template name="picklist_SV_ServiceTypeIR"/>
		<!-- SV_CouplingType: eigen lijst -->
		<xsl:call-template name="picklist_SV_CouplingType"/>
		<!-- DCPList: eigen lijst -->
		<xsl:call-template name="picklist_DCPList"/>
		<!-- picklist_Boolean: eigen lijst -->
		<xsl:call-template name="picklist_Boolean"/>
		<xsl:call-template name="picklist_codeSpace"/>
		<xsl:call-template name="picklist_code"/>
		<xsl:call-template name="picklist_metadataStandardName"/>
		<xsl:call-template name="picklist_metadataStandardVersion"/>
		<xsl:call-template name="picklist_MD_MaintenanceFrequencyCode"/>
		<xsl:call-template name="picklist_MandatoryKeywords"/>
		<xsl:call-template name="picklist_DS_AssociationTypeCode"/>
		<!-- unused
        <xsl:call-template name="picklist_CI_OnLineFunctionCode"/>
        <xsl:call-template name="picklist_CI_PresentationFormCode"/>
        <xsl:call-template name="picklist_DQ_EvaluationMethodTypeCode"/>
        <xsl:call-template name="picklist_DS_InitiativeTypeCode"/>
        <xsl:call-template name="picklist_MD_CellGeometryCode"/>
        <xsl:call-template name="picklist_MD_CoverageContentTypeCode"/>
        <xsl:call-template name="picklist_MD_DatatypeCode"/>
        <xsl:call-template name="picklist_MD_DimensionNameTypeCode"/>
        <xsl:call-template name="picklist_MD_GeometricObjectTypeCode"/>
        <xsl:call-template name="picklist_MD_ImagingConditionCode"/>
        <xsl:call-template name="picklist_MD_KeywordTypeCode"/>
        <xsl:call-template name="picklist_MD_MediumFormatCode"/>
        <xsl:call-template name="picklist_MD_MediumNameCode"/>
        <xsl:call-template name="picklist_MD_ObligationCode"/>
        <xsl:call-template name="picklist_MD_PixelOrientationCode"/>
        <xsl:call-template name="picklist_MD_TopologyLevelCode"/>
        -->
		<xsl:call-template name="picklist_yesno"/>
		<xsl:call-template name="picklist_yesnona"/>
	</xsl:template>
	<xsl:template name="picklist_yesno">
		<select id="picklist_yesno">
			<option value="ja" title="Ja">ja</option>
			<option value="nee" title="Nee">nee</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_yesnona">
		<select id="picklist_yesnona">
			<option value="ja" title="Ja">ja</option>
			<option value="nee" title="Nee">nee</option>
			<option value="nvt" title="Niet van toepassing">nvt</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_CI_DateTypeCode">
		<select id="picklist_CI_DateTypeCode">
			<option value="" title="Niet ingesteld"/>
			<option value="creation" title="Datum waarop de dataset of dataset serie is gecreëerd.">creatie</option>
			<option value="publication" title="Datum waarop de dataset of dataset serie is gepubliceerd.">publicatie</option>
			<option value="revision" title="Datum waarop de dataset of dataset serie is gecontroleerd, verbeterd of is gewijzigd.">revisie</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_CI_RoleCode">
		<select id="picklist_CI_RoleCode">
			<option value="resourceProvider" title="Organisatie die de data verstrekt.">verstrekker</option>
			<option value="custodian" title="Partij die verantwoordelijkheid heeft geaccepteerd en zorg draagt voor het beheer van de data.">beheerder</option>
			<option value="owner" title="Partij die eigenaar is van de data.">eigenaar</option>
			<option value="user" title="Partij die de data gebruikt.">gebruiker</option>
			<option value="distributor" title="Partij die de data verstrekt.">distributeur</option>
			<option value="originator" title="Partij die de data heeft gecreëerd.">maker</option>
			<option value="pointOfContact" title="Partij waarmee contact kan worden opgenomen voor het vergaren van kennis of verstrekking van de data.">contactpunt</option>
			<option value="principalInvestigator" title="Sleutelpartij verantwoordelijk voor verzamelen van data en de uitvoering van onderzoek.">inwinner</option>
			<option value="processor" title="Partij die de data heeft bewerkt, zodanig dat de data is gewijzigd.">bewerker</option>
			<option value="publisher" title="Partij die de data publiceert.">uitgever</option>
			<option value="author" title="Partij die auteur is van de data.">auteur</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_CharacterSetCode">
		<select id="picklist_MD_CharacterSetCode">
			<option value="ucs2" title="16 bits ISO/IEC 10646">ucs2</option>
			<option value="ucs4" title="32 bits ISO/IEC 10646">ucs4</option>
			<option value="utf7" title="7 bits ISO/IEC 10646">utf7</option>
			<option value="utf8" title="8 bits ISO/IEC 10646">utf8</option>
			<option value="utf16" title="16 bits ISO/IEC 10646">utf16</option>
			<option value="8859part1" title="ISO/IEC 8859-1, alphabet latin 1">8859part1</option>
			<option value="8859part2" title="ISO/IEC 8859-2, alphabet latin 2">8859part2</option>
			<option value="8859part3" title="ISO/IEC 8859-3, alphabet latin 3">8859part3</option>
			<option value="8859part4" title="ISO/IEC 8859-4, alphabet latin 4">8859part4</option>
			<option value="8859part5" title="ISO/IEC 8859-5, alphabet latin/cyrillique">8859part5</option>
			<option value="8859part6" title="ISO/IEC 8859-6, alphabet latin/arabe">8859part6</option>
			<option value="8859part7" title="ISO/IEC 8859-7, alphabet latin/grec">8859part7</option>
			<option value="8859part8" title="ISO/IEC 8859-8, alphabet latin/hébreu">8859part8</option>
			<option value="8859part9" title="ISO/IEC 8859-9, alphabet latin 5">8859part9</option>
			<option value="8859part10" title="ISO/IEC 8859-10, alphabet latin 6">8859part10</option>
			<option value="8859part11" title="ISO/IEC 8859-11, alphabet latin/Thaï">8859part11</option>
			<option value="8859part13" title="ISO/IEC 8859-13, alphabet latin 7">8859part13</option>
			<option value="8859part14" title="ISO/IEC 8859-14, alphabet latin 8 (celtique)">8859part14</option>
			<option value="8859part15" title="ISO/IEC 8859-15, alphabet latin 9">8859part15</option>
			<option value="8859part16" title="ISO/IEC 8859-16, alphabet latin 10">8859part16</option>
			<option value="jis" title="Japonais">jis</option>
			<option value="shiftJIS" title="Japonais pour MS-DOS">shiftJIS</option>
			<option value="eucJP" title="Japonais pour UNIX">eucJP</option>
			<option value="usAscii" title="ISO 646 US">usAscii</option>
			<option value="ebcdic" title="IBM">ebcdic</option>
			<option value="eucKR" title="Koréen">eucKR</option>
			<option value="big5" title="Chinois traditionel (Taiwan, Hong Kong, Chine)">big5</option>
			<option value="GB2312" title="Chinois simplifié">GB2312</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_ClassificationCode">
		<select id="picklist_MD_ClassificationCode">
			<option value="unclassified" title="Beschikbaar voor algemene ontsluiting.">vrij toegankelijk</option>
			<option value="restricted" title="Niet geschikt voor algemene ontsluiting.">niet toegankelijk</option>
			<option value="confidential" title="Beschikbaar voor personen die vertrouwd kan omgaan met de informatie.">vertrouwelijk</option>
			<option value="secret" title="Dient geheim en verborgen te worden gehouden voor iedereen behalve een geselecteerde groep personen.">geheim</option>
			<option value="topSecret" title="Hoogste geheimhouding verplicht.">zeer geheim</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_MaintenanceFrequencyCode">
		<select id="picklist_MD_MaintenanceFrequencyCode">
			<option value="continual" title="Data wordt herhaaldelijk en vaak geactualiseerd.">continu</option>
			<option value="daily" title="Data wordt elke dag geactualiseerd.">dagelijks</option>
			<option value="weekly" title="Data wordt wekelijks geactualiseerd.">wekelijks</option>
			<option value="fortnightly" title="Data wordt 2-wekelijks geactualiseerd.">2-wekelijks</option>
			<option value="monthly" title="Data wordt maandelijks geactualiseerd.">maandelijks</option>
			<option value="quarterly" title="Data wordt elke kwartaal geactualiseerd.">1 x per kwartaal</option>
			<option value="biannually" title="Data wordt half jaarlijks geactualiseerd.">1 x per half jaar</option>
			<option value="annually" title="Data wordt jaarlijks geactualiseerd.">jaarlijks</option>
			<option value="2annually" title="Data wordt één keer per 2 jaar geactualiseerd.">2-jaarlijks</option>
			<option value="3annually" title="Data wordt één keer per 3 jaar geactualiseerd.">3-jaarlijks</option>
			<option value="4annually" title="Data wordt één keer per 4 jaar geactualiseerd.">4-jaarlijks</option>
			<option value="5annually" title="Data wordt één keer per 5 jaar geactualiseerd.">5-jaarlijks</option>
			<option value="6annually" title="Data wordt één keer per 6 jaar geactualiseerd.">6-jaarlijks</option>
			<option value="7annually" title="Data wordt één keer per 7 jaar geactualiseerd.">7-jaarlijks</option>
			<option value="8annually" title="Data wordt één keer per 8 jaar geactualiseerd.">8-jaarlijks</option>
			<option value="9annually" title="Data wordt één keer per 9 jaar geactualiseerd.">9-jaarlijks</option>
			<option value="10annually" title="Data wordt één keer per 10 jaar geactualiseerd.">10-jaarlijks</option>
			<option value="moreThan10annually" title="Data wordt niet binnen 10 jaar geactualiseerd.">Meer dan 10-jaarlijks</option>
			<option value="asNeeded" title="Data wordt geactualiseerd indien nodig.">indien nodig</option>
			<option value="irregular" title="Data wordt geactualiseerd in intervallen die niet even lang duren.">onregelmatig</option>
			<option value="notPlanned" title="Er zijn geen plannen om de data te actualiseren.">niet gepland</option>
			<option value="unknown" title="Herzieningsfrequentie is niet bekend.">onbekend</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_MediumNameCode">
		<select id="picklist_MD_MediumNameCode">
			<option value="cdRom " title="Read only optical disk">cdRom</option>
			<option value="dvd " title="Digital versatile disk">dvd</option>
			<option value="dvdRom " title="Digital versatile disk, read only">dvdRom</option>
			<option value="3halfInchFloppy " title="3,5 inch magnetic disk">3halfInchFloppy</option>
			<option value="5quarterInchFloppy " title="5,25 inch magnetic disk">5quarterInchFloppy</option>
			<option value="7trackTape " title="7 track magnetic tape">7trackTape</option>
			<option value="9trackTape " title="9 track magnetic tape">9trackTape</option>
			<option value="3480Cartridge " title="3480 cartridge tape drive">3480Cartridge</option>
			<option value="3490Cartridge " title="3490 cartridge tape drive">3490Cartridge</option>
			<option value="3580Cartridge " title="3580 cartridge tape drive">3580Cartridge</option>
			<option value="4mmCartridgeTape " title="4 millimetre magnetic tape">4mmCartridgeTape</option>
			<option value="8mmCartridgeTape " title="8 millimetre magnetic tape">8mmCartridgeTape</option>
			<option value="1quarterInchCartridgeTape " title="0,25 inch magnetic tape">1quarterInchCartridgeTape</option>
			<option value="digitalLinearTape " title="Half inch cartridge streaming tape drive">digitalLinearTape</option>
			<option value="onLine " title="Direct computer linkage">onLine</option>
			<option value="satellite " title="Linkage through a satelite communication system">satellite</option>
			<option value="telephoneLink " title="Communication trough a telephone network">telephoneLink</option>
			<option value="hardcopy " title="Pamphlet or leaflet giving descriptive information">hardcopy</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_ProgressCode">
		<select id="picklist_MD_ProgressCode">
			<option value="completed" title="Productie van de data is compleet / afgerond.">compleet</option>
			<option value="historicalArchive" title="De data is opgeslagen in een offline opslagmedium.">historisch archief</option>
			<option value="obsolete" title="Data is niet langer relevant.">niet relevant</option>
			<option value="onGoing" title="Data wordt continu geactualiseerd.">continu geactualiseerd</option>
			<option value="planned" title="Datum is al bekend wanneer de data gecreëerd of geactualiseerd moet zijn.">gepland</option>
			<option value="required" title="Data moet nog gegenereerd of geactualiseerd worden.">actualisatie vereist</option>
			<option value="underDevelopment" title="Data wordt momenteel gecreëerd.">in ontwikkeling</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_RestrictionCode">
		<select id="picklist_MD_RestrictionCode">
			<option value="copyright" title="Exclusief recht voor publicatie, productie, of verkoop van rechten op een literair, theater, muzikaal of artistiek werk, of op het gebruik van een commerciële druk of label, toegekend bij wet voor een specifieke periode of tijd aan een auteur, componist, artiest of distributeur.">copyright</option>
			<option value="patent" title="Overheid heeft een exclusief recht toegekend om een uitvinding te maken, verkopen, gebruiken of in licentie uit te geven.">patent</option>
			<option value="patentPending" title="Geproduceerde of verkochte informatie wachtend op een patent.">patent in wording</option>
			<option value="trademark" title="Een naam, symbool of ander object om een product te identificeren, wat officieel geregistreerd is en gebruik wettelijk voorbehouden is aan de eigenaar of fabrikant.">merknaam</option>
			<option value="license" title="Formele toestemming of iets te doen.">licentie</option>
			<option value="intellectualPropertyRights" title="Recht op een financieel voordeel van en controle hebben op de distributie een niet tastbaar eigendom wat het resultaat is van creativiteit.">intellectueel eigendom</option>
			<option value="restricted" title="Verbod op distributie en gebruik.">niet toegankelijk</option>
			<option value="otherRestrictions" title="Restrictie niet opgenomen in lijst.">anders</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_ScopeCode">
		<select id="picklist_MD_ScopeCode">
			<!-- iso 19115 -->
			<option value="dataset" title="Informatie heeft betrekking op de dataset.">dataset</option>
			<option value="series" title="Informatie heeft betrekking op de serie.">series</option>
			<!-- iso 19119 -->
			<option value="service" title="Informatie heeft betrekking op een service.">service</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_SpatialRepresentationTypeCode">
		<select id="picklist_MD_SpatialRepresentationTypeCode">
			<option value="vector" title="Vector data wordt gebruikt om geografische data te representeren.">vector</option>
			<option value="grid" title="grid data is used to represent geographic data">grid</option>
			<option value="textTable" title="Tekstuele of tabel data wordt gebruikt om geografische data te representeren">teksttabel</option>
			<option value="tin" title="triangulated irregular network">TIN</option>
			<option value="stereoModel" title="3D overzicht wordt gevormd door intersectie van twee kernstralen van twee overlappende beelden.">stereomodel</option>
			<option value="video" title="Scène uit een video opname.">video</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MD_TopicCategoryCode">
		<select id="picklist_MD_TopicCategoryCode">
			<option value="farming" title="Houden van dieren en/of verbouwen van planten. Vb: landbouw, irrigatie, ziekten die gewassen aantasten.">landbouw en veeteelt</option>
			<option value="biota" title="Flora en fauna in natuurlijke omgeving. Vb: habitats, ecologie.">biota</option>
			<option value="boundaries" title="Wettelijke gebiedsbeschrijvingen. Vb: politieke en administratieve grenzen.">grenzen</option>
			<option value="climatologyMeteorologyAtmosphere" title="Processen en fenomenen in de atmosfeer. Vb: wolkbedekking, weer, klimaat verandering.">klimatologie, meteorologie, atmosfeer</option>
			<option value="economy" title="Economische activiteiten, condities en werkgelegenheid. Vb: Werkgelegenheid, industrie, toerisme, olie- en gasvelden, bosbouw, visserij.">economie</option>
			<option value="elevation" title="Hoogte boven of onder zeeniveau. Vb: hoogtekaart, DEM, hellingen.">hoogte</option>
			<option value="environment" title="Natuurlijke bronnen, bescherming en beheer. Vb: milieuverontreiniging, landschap, natuurlijke reserves, vuilopslag.">natuur en milieu</option>
			<option value="geoscientificInformation" title="Data die behoort tot een aardwetenschap. Vb: geologie, mineralen, structuur van de aarde, zwaartekrachtskaart, grondstoffen, erosie.">geowetenschappelijke data</option>
			<option value="health" title="Gezondheid(szorg), menselijke ecologie en veiligheid. Vb: ziekten, hygiëne, gezondheidszorg.">gezondheid</option>
			<option value="imageryBaseMapsEarthCover" title="Basiskaarten. Vb: landbedekking, topografische kaarten, foto’s, ongeclassificeerde kaarten.">referentie materiaal aardbedekking</option>
			<option value="intelligenceMilitary" title="Militaire basissen, structuren en activiteiten. Vb: barakken, oefenterreinen, militaire transporten.">militair</option>
			<option value="inlandWaters" title="Binnenwater, drainagesystemen en hun karakteristieken. Vb: Rivieren en gletsjers, dijken, stromen, waterzuiveringsinstallaties, overloopgebieden.">binnenwater</option>
			<option value="location" title="Positionele informatie en services. Vb: adressen, geodetisch netwerk, postcode gebieden, plaatsnamen, controlepunten.">locatie</option>
			<option value="oceans" title="Gebieden met zoutwaterlichamen (niet binnenlands). Vb: Getijden, tsunami’s, kustinformatie, riffen.">oceanen</option>
			<option value="planningCadastre" title="Informatie die gebruikt wordt voor nodige planmatige activiteiten. Vb: Landgebruik, kadastrale informatie.">planning kadaster</option>
			<option value="society" title="Kenmerken van maatschappij en culturen. Vb: antropologie, archeologie, criminaliteit, gewoonten, nederzettingen, onderwijs.">maatschappij</option>
			<option value="structure" title="Civiele werken (door mensen gemaakte structuren). Gebouwen, musea, kerken, winkels, torens.">(civiele) structuren</option>
			<option value="transportation" title="Middelen voor vervoer van goederen en/of personen. Vb: Wegen, Vliegvelden, tunnels, spoorwegen.">transport</option>
			<option value="utilities" title="Communication Energie, waterleidingen en riolering en communicatie infrastructuren en services. Vb: elektriciteit- en gasdistributie, waterzuivering en verstrekking, telecommunicatie, radio.">nutsbedrijven communicatie</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_LanguageCode">
		<select id="picklist_LanguageCode">
			<option value="dut" title="Nederlands">Nederlands</option>
			<option value="eng" title="Engels">English</option>
			<option value="ger" title="Duits">German</option>
			<option value="fre" title="Frans">French</option>
			<option value="ita" title="Italiaans">Italian</option>
			<option value="slo" title="Slovaaks/Slowaaks">Slovak</option>
			<option value="bul" title="Bulgarian">Bulgarian</option>
			<option value="cze" title="Czech">Czech</option>
			<option value="lav" title="Latvian">Latvian</option>
			<option value="dan" title="Danish">Danish</option>
			<option value="lit" title="Lithuanian">Lithuanian</option>
			<option value="mlt" title="Maltese">Maltese</option>
			<option value="pol" title="Polish">Polish</option>
			<option value="est" title="Estonian">Estonian</option>
			<option value="por" title="Portuguese">Portuguese</option>
			<option value="fin" title="Finnish">Finnish</option>
			<option value="rum" title="Romanian">Romanian</option>
			<option value="slv" title="Slovenian">Slovenian</option>
			<option value="gre" title="Greek">Greek</option>
			<option value="spa" title="Spanish">Spanish</option>
			<option value="hun" title="Hungarian">Hungarian</option>
			<option value="swe" title="Swedish">Swedish</option>
			<option value="gle" title="Irish">Irish</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_Country">
		<select id="picklist_Country">
			<option value="UK" title="Verenigd Koninkrijk">UK</option>
			<option value="NL" title="The Netherlands">NL</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_SV_ServiceType">
		<select id="picklist_SV_ServiceType">
			<optgroup label="(veel gebruikt)">
			<option value="download" title="download">download</option>
			<option value="OGC:WMS" title="Web Map service">Web Map service</option>
			<option value="OGC:WFS" title="Web Feature Service">Web Feature Service</option>
			<option value="website" title="website">website</option>
			</optgroup>
			<optgroup label="(rest)">
			<option value="OGC:WMTS" title="Web Mapping Tiling Service">Web Mapping Tiling Service</option>
			<option value="OGC:WCS" title="Web Coverage Service">Web Coverage Service</option>
			<option value="INSPIRE Atom" title="Atom Service Feed">Atom Service Feed</option>
			<option value="OGC:WCTS" title="Web Coordinate Transformation Service">Web Coordinate Transformation Service</option>
			<option value="OGC:WPS" title="Web Processing Service">Web Processing Service</option>
			<option value="UKST" title="Unknown Service Type">Unknown Service Type</option>
			<option value="OGC:WMC" title="Web Map Context">Web Map Context</option>
			<option value="OGC:KML" title="Keyhole Mark-up Language">Keyhole Mark-up Language</option>
			<option value="OGC:GML" title="Geography Markup Language">Geography Markup Language</option>
			<option value="OGC:WFS-G" title="Gazzetteer service">Gazzetteer service</option>
			<option value="OGC:SOS" title="Sensor Observation Service">Sensor Observation Service</option>
			<option value="OGC:SPS" title="Sensor Planning Service">Sensor Planning Service</option>
			<option value="OGC:SAS" title="Sensor Alert Service">Sensor Alert Service</option>
			<option value="OGC:WNS" title="Web Notification Service">Web Notification Service</option>
			<option value="OGC:ODS" title="OpenLS Directory Service">OpenLS Directory Service</option>
			<option value="OGC:OGS" title="OpenLS Gateway Service">OpenLS Gateway Service</option>
			<option value="OGC:OUS" title="OpenLS Utility Service">OpenLS Utility Service</option>
			<option value="OGC:OPS" title="OpenLS Presentation Service">OpenLS Presentation Service</option>
			<option value="OGC:ORS" title="OpenLS Route Service">OpenLS Route Service</option>
			</optgroup>
		</select>
	</xsl:template>
	<xsl:template name="picklist_SV_ServiceTypeIR">
		<select id="picklist_SV_ServiceTypeIR">
			<option value="download" title="download">download</option>
			<option value="discovery" title="discovery">discovery</option>
			<option value="view" title="view">view</option>
			<option value="transformation" title="transformation">transformation</option>
			<option value="invoke" title="invoke">invoke</option>
			<option value="other" title="other">other</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_DCPList">
		<select id="picklist_DCPList">
			<option value="WebServices" title="WebServices">WebServices</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_SV_CouplingType">
		<select id="picklist_SV_CouplingType">
			<!-- andere waarden opzoeken -->
			<option value="loose" title="loose">loose</option>
			<option value="mixed" title="mixed">mixed</option>
			<option value="tight" title="tight">tight</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_Boolean">
		<select id="picklist_Boolean">
			<option value="true" title="Waar">waar</option>
			<option value="false" title="Onwaar">onwaar</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_codeSpace">
		<select id="picklist_codeSpace">
			<option value="EPSG" title="EPSG">EPSG</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_code">
		<select id="picklist_code">
			<option value="28992" title="28992 (Amersfoort / Rijksdriehoekstelsel nieuw)">28992 (RD nieuw)</option>
			<option value="28991" title="28991 (Amersfoort / Rijksdriehoekstelsel oud)">28991 (RD oud)</option>
			<option value="4937" title="4937 (ETRS89)">4937 (ETRS89)</option>
			<option value="4326" title="4326 (WGS84)">4326 (WGS84)</option>
			<option value="5709" title="5709 (Normaal Amsterdams Peil)">5709 (Normaal Amsterdams Peil)</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_MandatoryKeywords">
		<select id="picklist_MandatoryKeywords">
			<option value="EPSG" title="EPSG">EPSG</option>
			<option value="infoManagementService" title="200 Geografische dienst voor model- en informatiebeheer (infoManagementService)">infoManagementService</option>
			<option value="infoFeatureAccessService" title="201. Dienst objecttoegang (infoFeatureAccessService)">infoFeatureAccessService</option>
			<option value="infoMapAccessService" title="202. Dienst kaarttoegang (infoMapAccessService)">infoMapAccessService</option>
			<option value="infoCoverageAccessService" title="203. Dienst rastergegevenstoegang (infoCoverageAccessService)">infoCoverageAccessService</option>
			<option value="infoSensorDescriptionService" title="204. Dienst sensorbeschrijving (infoSensorDescriptionService)">infoSensorDescriptionService</option>
			<option value="infoProductAccessService" title="205. Dienst producttoegang (infoProductAccessService)">infoProductAccessService</option>
			<option value="infoFeatureTypeService" title="206. Dienst objecteigenschappen (infoFeatureTypeService)">infoFeatureTypeService</option>
			<option value="infoCatalogueService" title="207. Catalogusdienst (infoCatalogueService)">infoCatalogueService</option>
			<option value="infoRegistryService" title="208. Registerdienst (infoRegistryService)">infoRegistryService</option>
			<option value="infoGazetteerService" title="209. Dienst geografische index (infoGazetteerService)">infoGazetteerService</option>
			<option value="infoOrderHandlingService" title="210. Besteldienst (infoOrderHandlingService)">infoOrderHandlingService</option>
			<option value="infoStandingOrderService" title="211. Dienst voorbestelling (infoStandingOrderService)">infoStandingOrderService</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_metadataStandardVersion">
		<select id="picklist_metadataStandardVersion">
			<option value="" title=""/>
			<option value="Nederlandse metadata profiel op ISO 19115 voor geografie 1.3.1" title="Nederlandse metadata profiel op ISO 19115 voor geografie 1.3.1">Nederlandse metadata profiel op ISO 19115 voor geografie 1.3.1</option>
			<option value="Nederlands metadata profiel op ISO 19119 voor services 1.2" title="Nederlands metadata profiel op ISO 19119 voor services 1.2">Nederlands metadata profiel op ISO 19119 voor services 1.2</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_metadataStandardName">
		<select id="picklist_metadataStandardName">
			<option value="" title=""/>
			<option value="ISO 19115" title="ISO 19115">ISO 19115</option>
			<option value="ISO 19119" title="ISO 19119">ISO 19119</option>
		</select>
	</xsl:template>
	<xsl:template name="picklist_DS_AssociationTypeCode">
		<select id="picklist_DS_AssociationTypeCode">
			<option value="" title=""/>
			<option value="crossReference" title="crossReference">crossReference</option>
		</select>
	</xsl:template>
	<xsl:template name="position">
		<xsl:if test="count(../*[name(.) = name(current())]) > 1">
            [<xsl:value-of select="position()"/>]
        </xsl:if>
	</xsl:template>
	<xsl:template name="add-comments-content">
		<xsl:choose>
			<xsl:when test="not(b3p:comment)">
				<div class="ui-mde-no-comments">Nog geen commentaar geleverd.</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="ui-mde-comments">
					<xsl:apply-templates select="b3p:comment"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<hr/>
		<div class="ui-mde-margin-top-bottom-area">
            Voeg commentaar toe:
            <xsl:call-template name="wikiHelpPopupLink"/>
		</div>
		<textarea id="ui-mde-comment-textarea" cols="80" rows="10"/>
		<div class="ui-mde-margin-top-bottom-area">
			<button id="ui-mde-comment-submit">Toevoegen</button>
		</div>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/b3p:comments/b3p:comment">
		<div class="ui-widget ui-widget-content ui-corner-all ui-mde-comment">
			<div class="ui-widget-header ui-corner-top ui-mde-comment-header">
				<!-- moet eerst voor IE 7 (float: right gaat anders niet goed) -->
				<div class="ui-mde-comment-dateTime">
					<div class="ui-mde-comment-date">
						<xsl:value-of select="substring-before(b3p:dateTime, 'T')"/>
					</div>
                    om
                    <div class="ui-mde-comment-time">
						<xsl:value-of select="substring-after(b3p:dateTime, 'T')"/>
					</div>
				</div>
				<div class="ui-mde-comment-username">
					<xsl:value-of select="b3p:username"/>
				</div>
			</div>
			<xsl:variable name="fullpath">
				<xsl:call-template name="full-path">
					<xsl:with-param name="theParmNodes" select="b3p:content"/>
				</xsl:call-template>
			</xsl:variable>
			<div class="ui-mde-comment-content" ui-mde-fullpath="{$fullpath}">
				<!-- value (rich text) is retrieved in javascript -->
				<xsl:value-of select="b3p:content"/>
				<!-- nodig voor IE:
                <xsl:text>dummy text</xsl:text -->
			</div>
		</div>
	</xsl:template>
	<!--
            Onderstaande templates zijn specifiek voor de ISO nummers
            Door de match nader te specificeren wordt zeker gesteld dat het
            juiste element gevonden wordt.
    -->
	<!-- ISO 2 Metadata ID MD_Metadata.fileIdentifier -->
	<xsl:template match="gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Metadata unieke identifier</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 2 Metadata ID. In de vorm van een UUID.'"/>
			<xsl:with-param name="help-description" select="'Unieke code die bij deze metadata hoort. Deze code wordt automatisch gegenereerd; graag alleen wijzigen indien het expliciet bekend is dat de code een andere waarde moet hebben.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.40_Metadata_unieke_identifier</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 3 language -->
	<xsl:template match="gmd:MD_Metadata/gmd:language/gmd:LanguageCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Metadata taal</xsl:with-param>
			<xsl:with-param name="picklist">picklist_LanguageCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 3 taal [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.46_Taal_van_de_metadata</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 39 language ISO 639.2 -->
	<xsl:template match="gmd:identificationInfo/*/gmd:language/gmd:LanguageCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Taal van de bron</xsl:with-param>
			<xsl:with-param name="picklist">picklist_LanguageCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 39 (639.2) taal [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.9_Taal_van_de_bron</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 5 Metadata ID MD_Metadata.parentIdentifier -->
	<xsl:template match="gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Parent unieke identifier</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 5 Parent ID Verplicht als er een dataset met hogere hiërarchie bestaat'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.41_Parent_unieke_identifier</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 6 Metadata hiërarchieniveau MD_Metadata.hierarchyLevel Codelijst: MD_ScopeCode (B.5.25) -->
	<xsl:template match="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Hiërarchieniveau</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_ScopeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 6 Hiërarchieniveau (service voor ISO 19119)'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.4_Hi%C3%ABrarchieniveau</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 7 Beschrijving hiërarchisch niveau MD_Metadata.hierarchyLevelName 
    <xsl:template match="gmd:MD_Metadata/gmd:hierarchyLevelName/gco:CharacterString">
        <xsl:call-template name="element">
            <xsl:with-param name="title">Beschrijving hiërarchisch niveau</xsl:with-param>
        </xsl:call-template>
    </xsl:template> -->
	<!-- ISO 9 Metadata datum MD_Metadata.dateStamp -->
	<xsl:template match="gmd:dateStamp/*">
		<!-- gmd:dateStamp/gco:Date or gmd:dateStamp/gco:DateTime -->
		<xsl:call-template name="element">
			<xsl:with-param name="title">Metadata datum</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 9 Metadata datum'"/>
			<xsl:with-param name="help-description" select="'De datum waarop dit metadatabestand is aangemaakt.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.45_Metadata_datum</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 10 Metadatastandaard naam MD_Metadata.metadataStandardName -->
	<xsl:template match="gmd:metadataStandardName/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Metadata standaard naam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="picklist">picklist_metadataStandardName</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 10 Metadata standaard naam'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.47_Metadata_standaard_naam</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 11 Versie metadatastandaard naam  MD_Metadata.metadataStandardVersion -->
	<xsl:template match="gmd:metadataStandardVersion/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Metadata standaard versie</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="picklist">picklist_metadataStandardVersion</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 11 Metadata standaard versie'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.48_Metadata_standaard_versie</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 25 Samenvatting MD_Metadata.identificationInfo>MD_DataIdentification.abstract -->
	<xsl:template match="gmd:abstract/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Samenvatting</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 25 Samenvatting'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.2_Samenvatting</xsl:with-param>
                        <xsl:with-param name="help-description">Een korte beschrijving van de inhoud van de dataset. Denk aan de  aard, omvang, tijdsperiode, scope, dekking, belangrijkste variabelen en andere relevante  eigenschappen van de data.</xsl:with-param>
			<xsl:with-param name="type" select="'rich-text'"/>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 26 Doel van de vervaardiging Samenvatting MD_Metadata.identificationInfo>MD_DataIdentification.purpose -->
	<xsl:template match="gmd:purpose/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Doel van de vervaardiging</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 26 Doel van de vervaardiging'"/>
			<xsl:with-param name="help-description" select="'Het doel waarvoor de data oorspronkelijk is gemaakt, voor welk doel de data door de datahoudende organisatie wordt gebruikt.'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 28 Status MD_Metadata.identificationInfo>MD_DataIdentification.status Codelijst MD_ProgressCode (B.5.23)-->
	<xsl:template match="gmd:status/gmd:MD_ProgressCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Status</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_ProgressCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 28 Status [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.3_Status</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 37 Ruimtelijk schema 
    MD_Metadata.identificationInfo>MD_DataIdentification.spatialRepresentationType Codelijst: MD_SpatialRepresentation TypeCode (B.5.26) -->
	<xsl:template match="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Ruimtelijk schema</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_SpatialRepresentationTypeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 37 Ruimtelijk schema [keuzelijst]'"/>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 40 karakterset characterSet Codelijst: MD_CharacterSetCode (B.5.10)-->
	<xsl:template match="gmd:characterSet/gmd:MD_CharacterSetCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Dataset karakterset</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_CharacterSetCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 40 karakterset [keuzelijst] Optioneel aangezien zowel utf 8 als utf16 voldoen aan de ISO/IEC 10646-1 standaard.'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 41 Onderwerp MD_Metadata.identificationInfo>MD_DataIdentification.topicCategory Enumeratie: MD_TopicCategoryCode (B.5.27) -->
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Onderwerp</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_TopicCategoryCode</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 41 Onderwerp [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.10_Onderwerp</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 53 + 55 +394 +395 Keywords and thesaurus -->
	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Trefwoorden uit thesaurus <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:MD_Keywords/gmd:keyword/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 53 Trefwoorden MD_Metadata.identificationInfo>MD_DataIdentification.descriptiveKeywords>MD_Keywords.keyword-->
	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords[1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
		<xsl:call-template name="element">
			<!-- count(preceding-sibling::gmd:descriptiveKeywords) = 0 -->
			<xsl:with-param name="title">Trefwoord</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 53 Trefwoorden, kies ook minimaal een trefwoord dat het soort service beschrijft zoals infoMapAccessService of infoFeatureAccessService'"/>
			<xsl:with-param name="help-description" select="'De meest relevante trefwoorden die op de dataset van toepassing zijn. Waarmee de dataset beter gevonden kan worden. Houd het aantal trefwoorden beperkt. Twijfel = nee.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.11_Trefwoord</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Only first thesaurus/keyword section is synced with dc and should be read only if synced -->
	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords[position() > 1]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Trefwoord</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 53 Trefwoorden'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 55 MD_Metadata.identificationInfo>MD_DataIdentification.descriptiveKeywords>MD_Keywords.thesaurusName>CI_Citation.title -->
	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Thesaurus</xsl:with-param>
			<xsl:with-param name="repeatable" select="false()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 55 Thesaurus Verplicht als een keyword uit een thesaurus afkomstig is (voor INSPIRE datasets verplicht), bijbehorende datum en type dan ook verplicht.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.12_Thesaurus</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Thesaurus date -->
	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Thesaurus datum <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_Date"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 57 Toepassingsschaal 
    MD_Metadata.identificationInfo>MD_DataIdentification.spatialResolution>MD_Resolution.equivalentScale>MD_RepresentativeFraction.denominator -->
	<xsl:template match="gmd:denominator/gco:Integer">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Toepassingsschaal</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select="../../../../.."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO  57 Toepassingsschaal Verplicht als er een toepassingsschaal gespecificeerd kan worden (multipliciteit 2)'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.24_Toepassingsschaal</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 61 Resolution 
    MD_Metadata.identificationInfo>MD_DataIdentification.spatialResolution>MD_Resolution.distance -->
	<xsl:template match="gmd:distance/gco:Distance">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Resolutie</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select="../../.."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 61 Resolutie Verplicht als er een resolutie gespecificeerd kan worden (multipliciteit 2)'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.25_Resolutie</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- beperkingen -->
	<xsl:template name="resourceConstraints">
		<xsl:param name="resourceConstraints"/>
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Beperkingen</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:for-each select="$resourceConstraints">
					<xsl:apply-templates select="gmd:MD_LegalConstraints"/>
					<xsl:apply-templates select="gmd:MD_Constraints"/>
					<xsl:apply-templates select="gmd:MD_SecurityConstraints"/>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 68 Gebruiksbeperkingen MD_Metadata.identificationInfo>MD_DataIdentification.resourceConstraints>MD_Constraints.useLimitation-->
	<xsl:template match="gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Gebruiksbeperkingen</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 68 Gebruiksbeperkingen'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.36_Gebruiksbeperkingen</xsl:with-param>
			<xsl:with-param name="type" select="'rich-text'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:resourceConstraints/gmd:MD_LegalConstraints">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Juridische beperkingen <xsl:call-template name="position"/>
				</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:useLimitation/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:accessConstraints/gmd:MD_RestrictionCode"/>
				<xsl:apply-templates select="gmd:otherConstraints/gco:CharacterString"/>
			</div>
		</div>
	</xsl:template>
		<!-- ISO 68 Gebruiksbeperkingen MD_Metadata.identificationInfo>MD_DataIdentification.resourceConstraints>MD_LegalConstraints.useLimitation-->
	<xsl:template match="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Gebruiksbeperkingen</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 68 Gebruiksbeperkingen'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.36_Gebruiksbeperkingen</xsl:with-param>
			<xsl:with-param name="type" select="'rich-text'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ISO 70 (Juridische) toegangsrestricties MD_Metadata.identificationInfo>MD_DataIdentification.resourceConstraints>MD_LegalConstraints.accessConstraints Codelijst MD_RestrictionCode (B.5.24)-->
	<xsl:template match="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">(Juridische) toegangsrestricties</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_RestrictionCode</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 70 (juridische) toegangsrestricties [keuzelijst] Het is verplicht op zijn minst één van de drie elementen (juridische) toegangsrestricties, overige beperkingen of veiligheidsrestricties op te nemen.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.33_Juridische_toegangsrestricties</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 72 resourceConstraints>MD_LegalConstraints.otherConstraints -->
	<xsl:template match="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Overige beperkingen</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 72 Overige beperkingen Het is verplicht op zijn minst één van de drie elementen (juridische) toegangsrestricties, overige beperkingen of veiligheidsrestricties op te nemen.'"/>
			<xsl:with-param name="help-description" select="'Wie data hergebruikt, moet weten welke voorwaarden er gelden. De Nederlandse overheid wil overheidsinformatie zoveel mogelijk gratis en zonder voorwaarden beschikbaar stellen. Bij voorkeur via de Creative Commons Zero (CC0) Publiek Domein Verklaring. Met deze verklaring wordt afstand gedaan van alle rechten. '"/>			
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.34_Overige_beperkingen</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
			<xsl:with-param name="readonly" select="'true'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 74 resourceConstraints>MD_LegalConstraints.classification Codelijst MD_ClassificationCode (B.5.11)-->
	<xsl:template match="gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification/gmd:MD_ClassificationCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Veiligheidsrestricties</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_ClassificationCode</xsl:with-param>
			<xsl:with-param name="repeatable" select="false()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 74 Veiligheidsrestricties [keuzelijst]  Het is verplicht op zijn minst één van de drie elementen (juridische) toegangsrestricties, overige beperkingen of veiligheidsrestricties op te nemen.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.35_Veiligheidsrestricties</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 83 Algemene beschrijving herkomst MD_Metadata.dataQualityInfo>DQ_DataQuality.lineage>LI_Lineage.statement -->
	<xsl:template match="gmd:lineage//gmd:statement/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Algemene beschrijving herkomst</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 83 Algemene beschrijving herkomst'"/>
			<xsl:with-param name="help-description" select="'De wijze waarop de data zijn verzameld, de herkomst van de data, het productieproces.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.23_Algemene_beschrijving_herkomst</xsl:with-param>
			<xsl:with-param name="type" select="'rich-text'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo" mode="dataService">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Specificatie kwaliteit</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<!-- ISO 139 Niveau kwaliteitsbeschrijving
                MD_Metadata.dataQualityInfo>DQ_DataQuality.scope>DQ_Scope.level -->
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:scope//gmd:level"/>
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass"/>
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation"/>
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title"/>
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo" mode="data">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Specificatie kwaliteit (data)</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep/gmd:description/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source"/>
				<!-- Geometrische nauwkeurigheid -->
				<xsl:apply-templates select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record"/>
				<!-- Compleetheid -->
				<xsl:apply-templates select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_CompletenessOmission/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep/gmd:description/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Beschrijving uitgevoerde bewerkingen</xsl:with-param>
			<xsl:with-param name="repeatable" select="true()"/>
			<xsl:with-param name="repeatable-path" select="../../.."/>
			<xsl:with-param name="help-text">Beschrijving uitgevoerde bewerkingen</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Bron <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:LI_Source/gmd:description/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:LI_Source/gmd:sourceStep"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:description/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Beschrijving brondata</xsl:with-param>
			<xsl:with-param name="help-text">Dit veld kan gebruikt worden om een algemene beschrijving of opmerking te geven betreft de kwaliteit van de (verschillende) brongegevens.</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceStep">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Inwinningsstap <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:LI_ProcessStep/gmd:description/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:LI_ProcessStep/gmd:dateTime/gco:DateTime"/>
				<xsl:apply-templates select="gmd:LI_ProcessStep/gmd:processor"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceStep/gmd:LI_ProcessStep/gmd:description/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Inwinningsmethode</xsl:with-param>
			<xsl:with-param name="help-text">Methode die gebruikt is om de brongegevens in te winnen</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceStep/gmd:LI_ProcessStep/gmd:dateTime/gco:DateTime">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datum inwinning brondata</xsl:with-param>
			<xsl:with-param name="help-text">Datum en/of periode waarin de brongegevens zijn ingewonnen</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceStep/gmd:LI_ProcessStep/gmd:processor">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Inwinnende organisatie <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Datum van de specificatie titel</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_Date"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 130 Specificatie 
    MD_Metadata.dataQualityInfo>DQ_DataQuality.report>DQ_DomainConsistency.result>DQ_ConformanceResult.specification>CI_Citation.title -->
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Specificatie titel</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 130 Specificatie Verplicht als de dataset een INSPIRE bron is of als de informatie is gemodelleerd volgens een specifiek informatie model.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.30_Specificatie</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 131 Verklaring 
    MD_Metadata.dataQualityInfo>DQ_DataQuality.report>DQ_DomainConsistency.result>DQ_ConformanceResult.explanation -->
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Verklaring</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 131 Verklaring Verplicht als de dataset een INSPIRE bron is of als de informatie is gemodelleerd volgens een specifiek informatie model.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.29_Verklaring</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 132 Conformiteitsindicatie met de specificatie 
    MD_Metadata.dataQualityInfo>DQ_DataQuality.report>DQ_DomainConsistency.result>DQ_ConformanceResult.pass -->
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass/gco:Boolean">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Conformiteitsindicatie</xsl:with-param>
			<xsl:with-param name="picklist">picklist_Boolean</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 132 Conformiteitsindicatie met de specificatie [keuzelijst] Verplicht als de dataset een INSPIRE bron is of als de informatie is gemodelleerd volgens een specifiek informatie model.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.28_Conformiteitindicatie_met_de_specificatie</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 137 -->
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Geometrische nauwkeurigheid</xsl:with-param>
			<xsl:with-param name="repeatable" select="false()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="help-text">ISO nr. 137 Afwijking van de x- en y-coördinaten ten opzichte van de werkelijke plaats op aarde.</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_CompletenessOmission/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Compleetheid</xsl:with-param>
			<xsl:with-param name="repeatable" select="false()"/>
			<xsl:with-param name="repeatable-path" select=".."/>
			<xsl:with-param name="help-description" select="'De volledigheid van de dataset. Bijvoorbeeld: De dataset bevat alle bomen in de openbare ruimte van de gemeente Utrecht behalve die van Leidsche Rijn omdat deze wijk in ontwikkeling nog door de projectorganisatie beheerd wordt. '"/>
			<xsl:with-param name="help-text">De volledigheid van de dataset</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 139 Niveau kwaliteitsbeschrijving 
    MD_Metadata.dataQualityInfo>DQ_DataQuality.scope>DQ_Scope.level Codelijst: MD_ScopeCode (B.5.25)-->
	<xsl:template match="gmd:scope//gmd:level/gmd:MD_ScopeCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Niveau kwaliteitsbeschrijving</xsl:with-param>
			<xsl:with-param name="picklist">picklist_MD_ScopeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 139 Niveau kwaliteitsbeschrijving [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.22_Niveau_kwaliteitsbeschrijving</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:referenceSystemInfo">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Referentiesysteem <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 208.1 Verantwoordelijke organisatie voor namespace referentiesysteem MD_Metadata.referenceSystemInfo>MD_ReferenceSystem.referenceSystemIdentifier>RS_Identifier.codeSpace-->
	<xsl:template match="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Verantwoordelijke organisatie voor namespace referentiesysteem</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 208.1 Verantwoordelijke organisatie voor namespace referentiesysteem'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.27_Verantwoordelijke_organisatie_voor_namespace_referentiesysteem</xsl:with-param>
			<xsl:with-param name="picklist">picklist_codeSpace</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 207 Code referentiesysteem  MD_Metadata.referenceSystemInfo>MD_ReferenceSystem.referenceSystemIdentifier>RS_Identifier.code EPSG codes-->
	<xsl:template match="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Code referentiesysteem</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 207 Code referentiesysteem'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.26_Code_Referentiesysteem</xsl:with-param>
			<xsl:with-param name="picklist">picklist_code</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 344-347 omgrenzende rechthoek -->
	<xsl:template name="omgrenzendeRechthoek">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Omgrenzende rechthoek</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:westBoundLongitude/gco:Decimal"/>
				<xsl:apply-templates select="gmd:eastBoundLongitude/gco:Decimal"/>
				<xsl:apply-templates select="gmd:southBoundLatitude/gco:Decimal"/>
				<xsl:apply-templates select="gmd:northBoundLatitude/gco:Decimal"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 344 Minimum x-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.westBoundLongitude -->
	<xsl:template match="gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Minimum x</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 344 Minimum x-coördinaat De bounding box wordt in plaats van in WGS 84 weergegeven in ETRS 89 om aan te sluiten bij INSPIRE'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.15_Minimum_x-co%C3%B6rdinaat</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 345 Maximum x-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.eastBoundLongitude -->
	<xsl:template match="gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Maximum x</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 345 Maximum x-coördinaat De bounding box wordt in plaats van in WGS 84 weergegeven in ETRS 89 om aan te sluiten bij INSPIRE'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.16_Maximum_x-co%C3%B6rdinaat</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 346 Minimum y-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.southBoundLatitude -->
	<xsl:template match="gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Minimum y</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 346 Minimum y-coördinaat De bounding box wordt in plaats van in WGS 84 weergegeven in ETRS 89 om aan te sluiten bij INSPIRE'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.17_Minimum_y-co%C3%B6rdinaat</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 347 Maximum y-coördinaat MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.geographicElement>EX_GeographicBoundingBox.northBoundLatitude -->
	<xsl:template match="gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Maximum y</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 347 Maximum y-coördinaat De bounding box wordt in plaats van in WGS 84 weergegeven in ETRS 89 om aan te sluiten bij INSPIRE'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.18_Maximum_y-co%C3%B6rdinaat</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 351 Temporele dekking - BeginDatum/einddatum MD_Metadata.identificationInfo>MD_DataIdentification.extent>EX_Extent.temporalElement>EX_TemporalExtent.extent TM_Primitive(B.4.5) -->
	<xsl:template match="gmd:EX_Extent/gmd:temporalElement">
		<!--name="temporeleDekking"-->
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Temporele dekking</xsl:with-param>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="*/gmd:description/gco:CharacterString"/>
				<xsl:apply-templates select="*/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
				<xsl:apply-templates select="*/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/*/gmd:description/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Beschrijving</xsl:with-param>
			<xsl:with-param name="help-text" select="'Beschrijving Temporele dekking'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Begindatum</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 351 Temporele dekking - begindatum'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.19_Temporele_dekking</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Einddatum</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 351 Temporele dekking - einddatum'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.19_Temporele_dekking</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 360 titel citation>title -->
	<xsl:template match="gmd:citation//gmd:title/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Titel</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 360 titel'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.1_Titel_van_de_bron</xsl:with-param>
                        <xsl:with-param name="help-description">De herkenbare naam van de dataset waarmee de gebruiker de dataset voldoende kan herkennen. <em>Bijvoorbeeld: Strooiroutes; oplaadpunten elektrisch vervoer; Verkeersintensiteiten op lokale wegen; Gemeentelijk vastgoed.</em></xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 361 Alternatieve titel citation>alternateTitle -->
	<xsl:template match="gmd:citation//gmd:alternateTitle/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Alternatieve titel</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 361 Alternatieve titel'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 363 Versie -->
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Versie</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 363 versie: Versienummer of -naam.'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 365 MD_Metadata.identificationInfo>MD_DataIdentification.citation>CI_Citation.identifier>MD_Identifier.code -->
	<xsl:template match="gmd:identificationInfo//gmd:identifier//gmd:code/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Unieke identifier van de bron</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 365 Unieke Identifier. In de vorm van een UUID.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.8_Unieke_Identifier_van_de_bron</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 376 Naam organisatie metadata MD_Metadata.contact>CI_ResponsibleParty.organisationName -->
	<xsl:template match="gmd:MD_Metadata/gmd:contact">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Verantwoordelijke organisatie metadata <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_ResponsibleParty">
					<xsl:with-param name="individualNameReadonly" select="$globalReadonly"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 376 Naam organisatie MD_Metadata.identificationInfo>MD_DataIdentification.pointOfContact>CI_ResponsibleParty.organisationName-->
	<xsl:template match="gmd:identificationInfo/*/gmd:pointOfContact">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Verantwoordelijke organisatie bron <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_ResponsibleParty">
					<xsl:with-param name="individualNameReadonly" select="$globalReadonly"/>
					<!--xsl:with-param name="organisationNameReadonly" select="$globalReadonly"/-->
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 376 Naam distribuerende organisatie MD_Metadata.distributionInfo>MD_Distribution.distributor>MD_Distributor.distributorContact>CI_ResponsibleParty.organisationName -->
	<xsl:template match="gmd:distributionInfo//gmd:distributor">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Distribuerende organisatie <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty">
					<xsl:with-param name="individualNameReadonly" select="$globalReadonly"/>
					<!--xsl:with-param name="organisationNameReadonly" select="$globalReadonly"/-->
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 394+395 dataset datum en referentie  -->
	<xsl:template match="gmd:citation/*/gmd:date">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Datum van de bron <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_Date">
					<xsl:with-param name="readonly" select="$globalReadonly"/>
					<xsl:with-param name="optionality">optional</xsl:with-param>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Distributie formaat <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:MD_Format/gmd:name/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_Format/gmd:version/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_Format/gmd:specification/gco:CharacterString"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam</xsl:with-param>
			<xsl:with-param name="optionality">conditional</xsl:with-param>
			<xsl:with-param name="help-text">Naam van het distributie formaat. Verplicht als de versie van het distributie formaat ingevuld is.</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Versie</xsl:with-param>
			<xsl:with-param name="optionality">conditional</xsl:with-param>
			<xsl:with-param name="help-text">Versie van het distributie formaat. Verplicht als de naam van het distributie formaat ingevuld is.</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:distributionFormat/gmd:MD_Format/gmd:specification/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Specificatie</xsl:with-param>
			<xsl:with-param name="optionality">conditional</xsl:with-param>
			<xsl:with-param name="help-text">Versie van het distributie formaat. Verplicht als de naam van het distributie formaat ingevuld is.</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Backwards compatibility: "online" vs. "onLine": online is verkeerd, maar zat in een oude versie van de mde  -->
	<!-- ISO 397 URL dataset MD_Metadata.distributionInfo>MD_Distribution.transferOptions>MD_DigitalTransferOptions.online>CI_OnlineResource.linkage -->
	<xsl:template match="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">URL dataset <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:linkage"/>
				<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:name/gco:CharacterString"/>
				<xsl:choose>
					<xsl:when test="gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString">
						<!-- This is the correct one: -->
						<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- If non-standard gmd:protocol/gmd:SV_ServiceType exist we use it. -->
						<xsl:apply-templates select="gmd:CI_OnlineResource/gmd:protocol/gmd:SV_ServiceType"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 19119 URL dataset gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata -->
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Service operaties <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage"/>
				<xsl:apply-templates select="srv:operationName/gco:CharacterString"/>
				<xsl:apply-templates select="srv:DCP"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 398 Protocol-->
	<xsl:template match="gmd:CI_OnlineResource/gmd:protocol/gmd:SV_ServiceType/gco:LocalName | gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
			<xsl:with-param name="title">Protocol</xsl:with-param>
			<xsl:with-param name="picklist">picklist_SV_ServiceType</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 398 protocol [keuzelijst] Verplicht als er een URL is opgegeven.'"/>
			<xsl:with-param name="help-description" select="'Het type service waarmee de data wordt aangeroepen of gedownload kan worden. De meest bekende services voor geodata bijvoorbeeld zijn WMS (Web Map Service) en WFS (Web Feature Service). Hiermee kan via een weblink (URL), een directe en actuele koppeling met de brondata tot stand gebracht worden.'"/>			
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.6_Protocol</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 400 Naam -->
	<xsl:template match="gmd:CI_OnlineResource/gmd:name/gco:CharacterString">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 400 naam Verplicht gesteld voor de OGC:WMS, OGC:WFS en OGC:WCS.'"/>
			<xsl:with-param name="help-description" select="'De bestandsnaam inclusief de extensie of de kaartlaagnaam voor gebruik bij WMS en WFS.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.7_Naam</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 19119 Naam van operatie-->
	<xsl:template match="srv:operationName/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Functie naam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 19119 operatie naam verplicht gesteld in ISO 19119.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.5_Connect_Point_Linkage</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 19119 DCP van operatie-->
	<xsl:template match="srv:DCP/srv:DCPList">
		<xsl:call-template name="element">
			<xsl:with-param name="title">DCP</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="picklist" select="'picklist_DCPList'"/>
			<xsl:with-param name="help-text" select="'ISO 19119 Distributed Computing Platforms'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.12_DCP</xsl:with-param>
			<xsl:with-param name="path" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="srv:SV_CoupledResource/srv:identifier/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Identifier</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 19119 identifier.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.6_Coupled_resource</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="srv:SV_CoupledResource/gco:ScopedName">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Layer/FeatureType</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 19119 operatie naam'"/>
			<xsl:with-param name="help-link">hhttp://wiki.geonovum.nl/index.php?title=2.5.6_Coupled_resource</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 19119 operates on template 2.2.6-->
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Dataset <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
				<xsl:with-param name="repeatable-path" select="."/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:call-template name="element">
					<xsl:with-param name="title">Uuid</xsl:with-param>
					<xsl:with-param name="path" select="./@uuidref"/>
					<xsl:with-param name="attrName" select="'uuidref'"/>
					<xsl:with-param name="optionality" select="'optional'"/>
					<xsl:with-param name="help-text" select="'ISO 19110 operatesOn'"/>
					<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.27_De_link_naar_de_metadata_van_de_dataset_en_dataset_series_vanuit_de_service</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="element">
					<xsl:with-param name="title">URL</xsl:with-param>
					<xsl:with-param name="path" select="./@xlink:href"/>
					<xsl:with-param name="attrName" select="'xlink:href'"/>
					<xsl:with-param name="optionality" select="'optional'"/>
					<xsl:with-param name="help-text" select="'ISO 19110 operatesOn'"/>
					<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.27_De_link_naar_de_metadata_van_de_dataset_en_dataset_series_vanuit_de_service</xsl:with-param>
					<xsl:with-param name="link">false</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 19119 coupled resources / gekoppelde datasets conditioneel-->
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:coupledResource">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Gekoppelde dataset <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
				<xsl:with-param name="repeatable-path" select="."/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="srv:SV_CoupledResource"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="srv:SV_CoupledResource">
		<xsl:apply-templates select="srv:operationName"/>
		<xsl:apply-templates select="srv:identifier"/>
		<xsl:apply-templates select="gco:ScopedName"/>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:couplingType/srv:SV_CouplingType">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Koppeling type</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="picklist" select="'picklist_SV_CouplingType'"/>
			<xsl:with-param name="help-text" select="'ISO 19119 couplingtype verplicht gesteld in ISO 19119.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.8_Coupling_Type</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Service type</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="picklist" select="'picklist_SV_ServiceTypeIR'"/>
			<xsl:with-param name="help-text" select="'Het element spatial service type bevat het type van de service.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.9_Spatial_data_service_type</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceTypeVersion">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Service type versie</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'Service Type Version is in ISO 19119 optioneel, maar wordt in Nederland verplicht gesteld.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.5.9_Spatial_data_service_type</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 
            Onderstaande templates worden op meerdere plaatsen gebruikt.
            De titels moeten algemeen blijven
    -->
	<!-- deze worden 3x gebruikt voor: distributor, pointOfContact, ResponsibleParty ! -->
	<!-- ISO 376 + 375 + 379 + 381 - 386 + 397 -->
	<xsl:template match="gmd:CI_ResponsibleParty">
		<xsl:param name="individualNameReadonly" select="$globalReadonly"/>
		<xsl:param name="organisationNameReadonly" select="$globalReadonly"/>
		<xsl:param name="help-description" select="''"/>
		<xsl:apply-templates select="gmd:organisationName/gco:CharacterString">
			<xsl:with-param name="readonly" select="$organisationNameReadonly"/>
			<xsl:with-param name="help-description" select="$help-description"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="gmd:individualName/gco:CharacterString">
			<xsl:with-param name="readonly" select="$individualNameReadonly"/>
		</xsl:apply-templates>
		<!-- wordt vanuit defaults gevuld
		<xsl:apply-templates select="gmd:role"/>
		-->
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
	</xsl:template>
		<!--
		<xsl:apply-templates select="gmd:positionName/gco:CharacterString"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage"/>
		-->

	<!-- ISO 376 naam organisatie -->
	<xsl:template match="gmd:organisationName/gco:CharacterString">
		<xsl:param name="readonly" select="$globalReadonly"/>
		<xsl:param name="help-description" select="''"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam organisatie</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 376 naam organisatie'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.37_Verantwoordelijke_organisatie_bron</xsl:with-param>
			<xsl:with-param name="picklist" select="'picklist_organisations'"/>
			<xsl:with-param name="help-description" select="$help-description"/>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 375 naam contactpersoon -->
	<xsl:template match="gmd:individualName/gco:CharacterString">
		<xsl:param name="readonly" select="$globalReadonly"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam contactpersoon</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 375 naam contactpersoon'"/>
			<xsl:with-param name="picklist" select="'picklist_contacts'"/>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 377 rol contactpersoon -->
	<xsl:template match="gmd:positionName/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Rol contactpersoon</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 377 rol contactpersoon'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 379 rol organisatie -->
	<xsl:template match="gmd:role/gmd:CI_RoleCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Rol organisatie</xsl:with-param>
			<xsl:with-param name="picklist">picklist_CI_RoleCode</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 379 Rol organisatie [keuzelijst]'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.39_Verantwoordelijke_organisatie_bron:_rol</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 381 -->
	<xsl:template match="gmd:deliveryPoint/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Adres</xsl:with-param>
			<xsl:with-param name="optionality">optional</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 381 adres'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 382 -->
	<xsl:template match="gmd:city/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Plaats</xsl:with-param>
			<xsl:with-param name="optionality">optional</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 382 plaats'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 383 -->
	<xsl:template match="gmd:administrativeArea/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Provincie</xsl:with-param>
			<xsl:with-param name="optionality">optional</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 383 provincie'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 384 -->
	<xsl:template match="gmd:postalCode/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Postcode</xsl:with-param>
			<xsl:with-param name="optionality">optional</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 384 postcode'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 385 -->
	<xsl:template match="gmd:country/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Land</xsl:with-param>
			<xsl:with-param name="optionality">optional</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 385 land'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 386 -->
	<xsl:template match="gmd:electronicMailAddress/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">E-mail</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 386 e-mail'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.38_Verantwoordelijke_organisatie_bron:_e-mail</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 408 -->
	<xsl:template match="gmd:voice/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Telefoonnummer</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 408 telefoonnummer'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO nr. 397 -->
	<xsl:template match="gmd:linkage/gmd:URL">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title">URL</xsl:with-param>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 397 link'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.5_URL</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:call-template name="element">
			<xsl:with-param name="title">URL</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'ISO 397 link'"/>
			<xsl:with-param name="help-description" select="'De link naar de service of naar het te downloaden bestand.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.5_URL</xsl:with-param>
			<xsl:with-param name="no-bold-title" select="$no-bold-title"/>
		</xsl:call-template>
	</xsl:template>
	<!-- einde ISO 381 - 386 + 397 -->
	<!-- ISO 394-395 CI_Date-->
	<xsl:template match="gmd:CI_Date">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:apply-templates select="gmd:date/gco:Date | gmd:date/gco:DateTime">
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:apply-templates>
		<!-- wordt via defaults gevuld
		<xsl:apply-templates select="gmd:dateType/gmd:CI_DateTypeCode">
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:apply-templates>
		-->
	</xsl:template>
	<!-- ISO 394 CI_Date.date-->
	<xsl:template match="gmd:date/gco:Date">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.13_Thesaurus_datum</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-description" select="'De datum waarop de originele dataset, de brondata voor het eerst is gemaakt. Geeft informatie over de historie en gecombineerd met de updatefrequentie over de tijdspanne van de dataset.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.20_Datum_van_de_bron</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.31_Specificatie_datum</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- DateTime -->
	<xsl:template match="gmd:date/gco:DateTime">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.13_Thesaurus_datum</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.20_Datum_van_de_bron</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:param name="title">Datum</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 394 Datum Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.31_Specificatie_datum</xsl:with-param>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 395 CI_Date.dateType Codelijst: CI_DateTypeCode (B.5.2)-->
	<xsl:template match="gmd:dateType/gmd:CI_DateTypeCode">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datumtype</xsl:with-param>
			<xsl:with-param name="picklist">picklist_CI_DateTypeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 395 Datumtype [keuzelijst] Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datumtype</xsl:with-param>
			<xsl:with-param name="picklist">picklist_CI_DateTypeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 395 Datumtype [keuzelijst] Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.14_Thesaurus_datum_type</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datumtype</xsl:with-param>
			<xsl:with-param name="picklist">picklist_CI_DateTypeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 395 Datumtype [keuzelijst] Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.21_Datum_type_van_de_bron</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode">
		<xsl:param name="readonly" select="false()"/>
		<xsl:param name="optionality">optional</xsl:param>
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datumtype</xsl:with-param>
			<xsl:with-param name="picklist">picklist_CI_DateTypeCode</xsl:with-param>
			<xsl:with-param name="optionality" select="$optionality"/>
			<xsl:with-param name="help-text" select="'ISO 395 Datumtype [keuzelijst] Verplicht indien element waarvoor datum geldt verplicht is.'"/>
			<xsl:with-param name="help-link">http://wiki.geonovum.nl/index.php?title=2.4.32_Specificatie_datum_type</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $readonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- einde ISO 394-395 CI_Date-->
	<xsl:template match="gmd:aggregationInfo">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Gerelateerde dataset <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
				<xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:date"/>
				<xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:associationType/gmd:DS_AssociationTypeCode"/>
			</div>
		</div>
	</xsl:template>
	<!-- ISO 360 titel  -->
	<xsl:template match="gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam van de gerelateerde dataset</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 360 titel. Als dit veld is ingevuld is bijbehorende datum ook verplicht om in te vullen.'"/>
			<!-- only readonly if globalReadonly or if we are synchronising with DC and dealing with the first gerelateerde dataset (cannot use position for that) -->
			<!--xsl:with-param name="readonly" select="$globalReadonly or ((count(../../../../../preceding-sibling::gmd:aggregationInfo) + 1) = 1)"/-->
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmd:aggregateDataSetName/gmd:CI_Citation/gmd:date">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Datum van de gerelateerde dataset <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_Date">
					<!-- only readonly if globalReadonly or if we are synchronising with DC and dealing with the first gerelateerde dataset (cannot use position for that) -->
					<!--xsl:with-param name="readonly" select="$globalReadonly or ((count(../../../../preceding-sibling::gmd:aggregationInfo) + 1) = 1)"/-->
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gmd:associationType/gmd:DS_AssociationTypeCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Type relatie</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 360 titel. Als dit veld is ingevuld is bijbehorende datum ook verplicht om in te vullen.'"/>
			<xsl:with-param name="picklist" select="'picklist_DS_AssociationTypeCode'"/>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 143 Herzieningsfrequentie -->
	<xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Herzieningsfrequentie</xsl:with-param>
			<xsl:with-param name="help-text" select="'ISO 143 Herzieningsfrequentie. Frequentie waarmee de data herzien wordt.'"/>
			<xsl:with-param name="help-description" select="'Frequentie waarmee de data herzien wordt.'"/>
			<xsl:with-param name="picklist" select="'picklist_MD_MaintenanceFrequencyCode'"/>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ISO 19110 elementen -->
	<xsl:template match="gmx:name/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'B1.1 name for this feature catalogue'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmx:scope/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Scope</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'B1.2 subject domain(s) of feature types defined in this feature catalogue'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmx:versionNumber/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Versienummer</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'B1.4 version number of this feature catalogue, which may include both a major version number or letter and a sequence of minor release numbers or letters, such as “3.2.4a.” The format of this attribute may differ between cataloguing authorities.'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gmx:versionDate/gco:Date">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Versiedatum</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="default-value">Klik om te bewerken [<xsl:value-of select="$dateFormatUserHint"/>]</xsl:with-param>
			<xsl:with-param name="help-text" select="'B1.5 effective date of this feature catalogue.'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gfc:producer">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Verantwoordelijke organisatie</xsl:with-param>
				<xsl:with-param name="repeatable" select="false()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="gfc:featureType">
		<div class="ui-mde-section">
			<xsl:call-template name="section-title">
				<xsl:with-param name="title">Feature type <xsl:call-template name="position"/>
				</xsl:with-param>
				<xsl:with-param name="repeatable" select="true()"/>
			</xsl:call-template>
			<div class="ui-mde-section-content">
				<xsl:apply-templates select="gfc:FC_FeatureType/gfc:typeName"/>
				<xsl:apply-templates select="gfc:FC_FeatureType/gfc:definition"/>
				<xsl:call-template name="cocs">
					<xsl:with-param name="object" select="."/>
					<xsl:with-param name="ftpos" select="position()"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="cocs">
		<xsl:param name="object"/>
		<xsl:param name="ftpos"/>
		<xsl:for-each select="$object/gfc:FC_FeatureType/gfc:carrierOfCharacteristics">
			<div class="ui-mde-section">
				<xsl:call-template name="section-title">
					<xsl:with-param name="title">Attribuut [<xsl:value-of select="$ftpos"/>.<xsl:value-of select="position()"/>]</xsl:with-param>
					<xsl:with-param name="repeatable" select="true()"/>
				</xsl:call-template>
				<div class="ui-mde-section-content">
					<xsl:apply-templates select="gfc:FC_FeatureAttribute/gfc:memberName/gco:LocalName"/>
					<xsl:apply-templates select="gfc:FC_FeatureAttribute/gfc:valueType/gco:TypeName/gco:aName/gco:CharacterString"/>
					<xsl:apply-templates select="gfc:FC_FeatureAttribute/gfc:definition/gco:CharacterString"/>
				</div>
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="gfc:typeName/gco:LocalName">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Typenaam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'B2.1 text string that uniquely identifies this feature type within the feature catalogue that contains this feature type'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gfc:memberName/gco:LocalName">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Naam</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'B4.1 member name that locates this member within a feature type'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gco:aName/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Type</xsl:with-param>
			<xsl:with-param name="help-text" select="'Type van dit attribuut.'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gfc:definition/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Definitie</xsl:with-param>
			<xsl:with-param name="help-text" select="'B2.2/B4.2 definition in a natural language.'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="gfc:cardinality/gco:Integer">
            
    </xsl:template>
	<xsl:template match="gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Voorbeeldplaatje</xsl:with-param>
			<xsl:with-param name="optionality" select="'optional'"/>
			<xsl:with-param name="help-text" select="'Bestandsnaam van een figuur waarin een voorbeeldweergave te zien is. De naam moet beginnen met http of ftp. Het plaatje dient namelijk ook buiten uw netwerk bereikbaar te zijn.'"/>
			<xsl:with-param name="type" select="'image-url'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Dublin Core metadata -->
	<xsl:template match="b3p:B3Partners/*/dc:title">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Titel</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:creator">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Maker/Producent</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:subject">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Trefwoord</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:description">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Samenvatting</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:publisher">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Uitgever/Leverancier</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:contributor">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Kennismakelaar/Contactpersoon</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:date">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Datum van de bron</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:type">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Type</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:format">
		<xsl:call-template name="element">
			<xsl:with-param name="title">(Data)Formaat/Grootte/Resolutie</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:identifier">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Identiteitkenmerk</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:source">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Bron</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:language">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Taal van de bron</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:relation">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Relatie</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
			<xsl:with-param name="repeatable" select="true()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:coverage">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Dekking</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/*/dc:rights">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Rechten/Voorwaarden</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly or $synchroniseDC"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/pbl:metadataPBL/pbl:frequency">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Herzieningsfrequentie</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="b3p:B3Partners/pbl:metadataPBL/pbl:testsPerformed">
		<xsl:call-template name="element">
			<xsl:with-param name="title">Uitgevoerde Testen</xsl:with-param>
			<xsl:with-param name="readonly" select="$globalReadonly"/>
		</xsl:call-template>
	</xsl:template>
	<!-- default text for elements with no default value specified -->
	<xsl:variable name="GLOBAL_DEFAULT">Klik om te bewerken.</xsl:variable>
	<xsl:variable name="GLOBAL_DEFAULT_VIEW">-</xsl:variable>
	<!-- add/delete elements/sections menu text -->
	<xsl:variable name="ADD_ELEMENT_ABOVE_TEXT">Voeg element hierboven toe</xsl:variable>
	<xsl:variable name="ADD_ELEMENT_BELOW_TEXT">Voeg element hieronder toe</xsl:variable>
	<xsl:variable name="DELETE_ELEMENT_TEXT">Verwijder dit element</xsl:variable>
	<xsl:variable name="ADD_SECTION_ABOVE_TEXT">Voeg sectie hierboven toe</xsl:variable>
	<xsl:variable name="ADD_SECTION_BELOW_TEXT">Voeg sectie hieronder toe</xsl:variable>
	<xsl:variable name="DELETE_SECTION_TEXT">Verwijder deze sectie</xsl:variable>
	<!-- expand/collapse section and menu image paths -->
	<xsl:variable name="EXPAND_TEXT">Klap deze sectie in/uit</xsl:variable>
	<xsl:variable name="PLUS_IMAGE">
		<xsl:value-of select="$basePath"/>scripts/mde/images/xp_plus.gif</xsl:variable>
	<xsl:variable name="MINUS_IMAGE">
		<xsl:value-of select="$basePath"/>scripts/mde/images/xp_minus.gif</xsl:variable>
	<xsl:variable name="MENU_IMAGE">
		<xsl:value-of select="$basePath"/>scripts/mde/images/arrow.gif</xsl:variable>
	<xsl:variable name="MENU_TOOLTIP">Klik om opties te zien</xsl:variable>
	<!-- ============================================ -->
	<!-- TEMPLATE FUNCTIONS FOR FULLXML STYLESHEETS -->
	<!-- ============================================ -->
	<!-- TEMPLATE: voor een element dat veranderd kan worden door de gebruiker. Het kiest per default het huidige pad als element dat geëdit kan worden -->
	<xsl:template name="element">
		<xsl:param name="title"/>
		<!-- verplicht voor mooie weergave -->
		<xsl:param name="picklist"/>
		<xsl:param name="path" select="."/>
		<xsl:param name="attrName" select="''"/>
		<xsl:param name="default-value"/>
		<xsl:param name="optionality">optional</xsl:param>
		<!-- 'conditional' of 'mandatory' of 'optional' of leeg (= optional). Dit is feedback voor de user. -->
		<xsl:param name="repeatable" select="false()"/>
		<xsl:param name="repeatable-path" select="."/>
		<!-- For 19115/19139 fields, the parent (..) should be passed here. This is not the case for, for example, DC -->
		<xsl:param name="readonly" select="$globalReadonly"/>
		<!-- $globalReadonly-->
		<xsl:param name="type">normal</xsl:param>
		<!-- speciaal type: normal, rich-text of image-url (dit zijn allemaal gco:CharacterString's; uit het data-type is dus niets af te leiden) -->
		<xsl:param name="help-text"/>
		<xsl:param name="help-link"/>
        <xsl:param name="help-description"/>
		<xsl:param name="link">false</xsl:param>
		<xsl:param name="no-bold-title" select="false()"/>
		<xsl:param name="bold-value" select="false()"/>
		<xsl:variable name="element-class">
			<xsl:text>ui-mde-element</xsl:text>
			<xsl:if test="$readonly and not($globalReadonly)">
				<xsl:text> ui-mde-element-ro</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="key-class">
			<xsl:choose>
				<xsl:when test="$no-bold-title = true()">
					<xsl:text>ui-mde-key not-bold</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>ui-mde-key</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$optionality = 'mandatory' and not($readonly)">
					<xsl:choose>
						<xsl:when test="$no-bold-title = true()">
							<xsl:text> ui-mde-key-mandatory not-bold</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> ui-mde-key-mandatory</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$optionality = 'conditional' and not($readonly)">
					<xsl:choose>
						<xsl:when test="$no-bold-title = true()">
							<xsl:text> ui-mde-key-conditional not-bold</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> ui-mde-key-conditional</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="value-class">
			<xsl:text>ui-mde-value</xsl:text>
			<xsl:if test="not($readonly)">
				<xsl:text> ui-mde-clickable</xsl:text>
			</xsl:if>
			<xsl:if test="$picklist = '' and normalize-space($path) = '' ">
				<xsl:text> ui-mde-default-value</xsl:text>
			</xsl:if>
			<xsl:if test="$type = 'rich-text'">
				<xsl:text> ui-mde-rich-text-value</xsl:text>
			</xsl:if>
		</xsl:variable>
		<div class="{$element-class}">
			<!-- strange layout (in this xslt-file) to get whitespace right -->
			<div class="{$key-class}">
				<xsl:call-template name="element-title">
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="help-link" select="$help-link"/>
					<xsl:with-param name="read-only" select="$readonly"/>
					<xsl:with-param name="key-class" select="$key-class"/>
				</xsl:call-template>
				<xsl:if test="$type = 'rich-text'">
					<xsl:call-template name="wikiHelpPopupLink"/>
				</xsl:if>
				<xsl:if test="$repeatable and not($readonly)">
					<xsl:call-template name="repeatable-menu">
						<xsl:with-param name="type" select="'element'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$title != ''">: <!-- whitespace issue -->
					</xsl:when>
					<xsl:otherwise>
                            &#160;
                    </xsl:otherwise>
				</xsl:choose>
			</div>
			<xsl:element name="div">
				<xsl:attribute name="class"><xsl:value-of select="$value-class"/><xsl:if test="$bold-value = true()">_bold</xsl:if></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="$help-text"/></xsl:attribute>
				<xsl:attribute name="attrname"><xsl:value-of select="$attrName"/></xsl:attribute>
				<!-- custom attributes -->
				<xsl:attribute name="ui-mde-fullpath"><xsl:call-template name="full-path"><xsl:with-param name="theParmNodes" select="$path"/></xsl:call-template></xsl:attribute>
				<xsl:attribute name="ui-mde-repeatablepath"><xsl:call-template name="full-path"><xsl:with-param name="theParmNodes" select="$repeatable-path"/></xsl:call-template></xsl:attribute>
				<xsl:attribute name="ui-mde-default"><xsl:value-of select="$default-value"/></xsl:attribute>
				<!--xsl:attribute name="ui-mde-optionality"><xsl:value-of select="$optionality" /></xsl:attribute-->
				<xsl:attribute name="ui-mde-type"><xsl:value-of select="$type"/></xsl:attribute>
				<xsl:if test="$picklist != '' ">
					<xsl:attribute name="ui-mde-picklist"><xsl:value-of select="$picklist"/></xsl:attribute>
				</xsl:if>
				<!-- do special extra stuff depending on data-type -->
				<xsl:apply-templates select="." mode="data-type"/>
				<xsl:variable name="currentval">
					<xsl:choose>
						<xsl:when test="$picklist != '' and $path/@codeListValue and normalize-space($path/@codeListValue) != '' ">
							<xsl:value-of select="$path/@codeListValue"/>
						</xsl:when>
						<xsl:when test="normalize-space($path) != '' ">
							<xsl:value-of select="$path"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$currentval != '' ">
						<xsl:attribute name="ui-mde-current-value"><xsl:value-of select="$currentval"/></xsl:attribute>
						<xsl:if test="$picklist != '' ">
							<xsl:attribute name="ui-mde-codelistvalue"><xsl:value-of select="normalize-space($currentval)"/></xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$link = 'true'">
								<xsl:element name="a">
									<!--<xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute>-->
									<xsl:attribute name="href"><xsl:value-of select="normalize-space($currentval)"/></xsl:attribute>
									<xsl:attribute name="target">_blank</xsl:attribute>
									<xsl:value-of select="normalize-space($currentval)"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$type = 'rich-text'">
								<!-- do not use normalize-space here in $path; we need all spaces and newlines -->
								<xsl:value-of select="$currentval"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space($currentval)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$readonly">
								<xsl:value-of select="$GLOBAL_DEFAULT_VIEW"/>
							</xsl:when>
							<xsl:when test="$default-value != '' ">
								<xsl:value-of select="$default-value"/>
							</xsl:when>
							<xsl:when test="$type = 'rich-text' ">
								<xsl:value-of select="$GLOBAL_DEFAULT"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$GLOBAL_DEFAULT"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:comment/>
			</xsl:element>
            <xsl:if test="$help-description != '' and position()=1">
				<div class="help-description">
                    <xsl:value-of select="$help-description" disable-output-escaping="yes" />
                </div>
            </xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="element-title">
		<xsl:param name="title"/>
		<xsl:param name="help-link"/>
		<xsl:param name="read-only" select="true()"/>
		<xsl:param name="key-class"/>
		<xsl:choose>
			<xsl:when test="$read-only or not($help-link)">
				<xsl:value-of select="$title"/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$help-link}" class="{$key-class}" target="_blank" title="Klik hier voor de invulinstructie">
					<xsl:value-of select="$title"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- TEMPLATE: for section-title -->
	<!-- 
    Gebruik voor een "section" het template "section-title" in combinatie met
een <div class="ui-mde-section-content"/> met daarin de content van de section
    om custom content toe te voegen aan de sectie
(of in de praktijk vaak om de volgorde van de content-tags te veranderen).
    -->
	<xsl:template name="section-title">
		<xsl:param name="title"/>
		<xsl:param name="expanded" select="true()"/>
		<xsl:param name="expandable" select="true()"/>
		<xsl:param name="repeatable" select="false()"/>
		<xsl:param name="repeatable-path" select="."/>
		<xsl:param name="readonly" select="$globalReadonly"/>
		<xsl:if test="$repeatable and not($readonly)">
			<xsl:attribute name="ui-mde-fullpath"><xsl:call-template name="full-path"><xsl:with-param name="theParmNodes" select="."/></xsl:call-template></xsl:attribute>
			<xsl:attribute name="ui-mde-repeatablepath"><xsl:call-template name="full-path"><xsl:with-param name="theParmNodes" select="$repeatable-path"/><!--xsl:with-param name="extraLeadingString">/</xsl:with-param--></xsl:call-template></xsl:attribute>
		</xsl:if>
		<xsl:element name="div">
			<xsl:attribute name="class">ui-mde-section-header<xsl:if test="$expandable = true()"> expandable</xsl:if></xsl:attribute>
			<xsl:if test="$repeatable and not($readonly)">
				<xsl:call-template name="repeatable-menu">
					<xsl:with-param name="type" select="'section'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$expandable = true()">
					<a href="#" class="expandable" title="{$EXPAND_TEXT}">
						<xsl:if test="$displayMode != 'simple'">
							<xsl:choose>
								<xsl:when test="$expanded = true()">
									<img class="plus-minus" src="{$MINUS_IMAGE}"/>
								</xsl:when>
								<xsl:otherwise>
									<img class="plus-minus" src="{$PLUS_IMAGE}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<span class="ui-mde-section-title">
							<xsl:value-of select="$title"/>
						</span>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<span class="ui-mde-section-title">
						<xsl:value-of select="$title"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="repeatable-menu">
		<xsl:param name="type" select="'element'"/>
		<!-- allowed values: 'element' or 'section'-->
		<span class="menu-wrapper">
			<xsl:if test="$displayMode != 'simple'">
				<xsl:element name="img">
					<xsl:attribute name="src"><xsl:value-of select="$MENU_IMAGE"/></xsl:attribute>
					<xsl:attribute name="title"><xsl:value-of select="$MENU_TOOLTIP"/></xsl:attribute>
					<xsl:attribute name="class">menu-img</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:element name="ul">
				<xsl:attribute name="class">menu</xsl:attribute>
				<xsl:attribute name="style"><xsl:if test="$displayMode != 'simple'">display: none;</xsl:if></xsl:attribute>
				<li class="menuaddabove">
					<a href="#">
						<xsl:choose>
							<xsl:when test="$displayMode = 'simple'">
								<i class="icon-insert-above"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$type = 'element'">
										<xsl:value-of select="$ADD_ELEMENT_ABOVE_TEXT"/>
									</xsl:when>
									<xsl:when test="$type = 'section'">
										<xsl:value-of select="$ADD_SECTION_ABOVE_TEXT"/>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</li>
				<li class="menuaddbelow">
					<a href="#">
						<xsl:choose>
							<xsl:when test="$displayMode = 'simple'">
								<i class="icon-insert-below"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$type = 'element'">
										<xsl:value-of select="$ADD_ELEMENT_BELOW_TEXT"/>
									</xsl:when>
									<xsl:when test="$type = 'section'">
										<xsl:value-of select="$ADD_SECTION_BELOW_TEXT"/>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</li>
				<li class="menudelete">
					<a href="#">
						<xsl:choose>
							<xsl:when test="$displayMode = 'simple'">
								<i class="icon-bin"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$type = 'element'">
										<xsl:value-of select="$DELETE_ELEMENT_TEXT"/>
									</xsl:when>
									<xsl:when test="$type = 'section'">
										<xsl:value-of select="$DELETE_SECTION_TEXT"/>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</li>
			</xsl:element>
		</span>
	</xsl:template>
	<!-- TEMPLATE: geeft een anchor weer -->
	<xsl:template name="anchor">
		<xsl:param name="href" select="."/>
		<xsl:param name="name-shown">no name</xsl:param>
		<xsl:param name="target">viewer</xsl:param>
		<xsl:element name="a">
			<!--<xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute>-->
			<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			<xsl:value-of select="$name-shown"/>
		</xsl:element>
	</xsl:template>
	<!-- TEMPLATE: geeft een mailto-anchor weer -->
	<xsl:template name="mailtoAnchor">
		<xsl:param name="email" select="."/>
		<xsl:param name="name-shown">no name</xsl:param>
		<xsl:element name="a">
			<!--<xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute>-->
			<xsl:attribute name="href">mailto:<xsl:value-of select="$email"/></xsl:attribute>
			<xsl:value-of select="$name-shown"/>
		</xsl:element>
	</xsl:template>
	<!-- TEMPLATE: geeft een base64 img weer 
<img src="data:image/gif;base64,R0lGODlhDwAPAKECAAAAzMzM/////wAAACwAAAAADwAPAAACIISPeQHsrZ5ModrLlN48CXF8m2iQ3YmmKqVlRtW4MLwWACH+H09wdGltaXplZCBieSBVbGVhZCBTbWFydFNhdmVyIQAAOw==" alt="base64 encoded image" width="150" height="150"/>
    -->
	<xsl:template name="base64Img">
		<xsl:param name="base64string" select="."/>
		<xsl:param name="alt">thumbnail</xsl:param>
		<xsl:param name="width">150</xsl:param>
		<xsl:param name="height">150</xsl:param>
		<xsl:element name="img">
			<xsl:attribute name="src">data:image/gif;base64,<xsl:value-of select="$base64string"/></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
			<!-- xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute -->
			<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="full-path">
		<xsl:param name="theParmNodes" select="."/>
		<xsl:param name="extraLeadingString"/>
		<xsl:value-of select="$extraLeadingString"/>
		<xsl:for-each select="$theParmNodes/ancestor-or-self::*">
			<xsl:text>/</xsl:text>
			<xsl:call-template name="prefix"/>
			<xsl:value-of select="local-name()"/>
			<xsl:variable name="precedingSiblingsWithSameNodeName" select="count(preceding-sibling::*[name(current()) = name(.)])"/>
			<xsl:variable name="followingSiblingsWithSameNodeName" select="count(following-sibling::*[name(current()) = name(.)])"/>
			<xsl:if test="$precedingSiblingsWithSameNodeName + $followingSiblingsWithSameNodeName > 0">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="1 + $precedingSiblingsWithSameNodeName"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- 
    Writes the prefix of the current node, according to the namespace-uri(). 
    These namespaces and prefices must be the same as in metadataEditor.js's setXpathNamespaces(xmlDoc) function.
    -->
	<xsl:template name="prefix">
		<xsl:choose>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/gmd'">
				<xsl:text>gmd:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/gmx'">
				<xsl:text>gmx:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/gfc'">
				<xsl:text>gfc:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/gts'">
				<xsl:text>gts:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/gco'">
				<xsl:text>gco:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.opengis.net/gml'">
				<xsl:text>gml:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.w3.org/1999/xlink'">
				<xsl:text>xlink:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.w3.org/2001/XMLSchema-instance'">
				<xsl:text>xsi:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.b3partners.nl/xsd/metadata'">
				<xsl:text>b3p:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.pbl.nl/xsd/metadata'">
				<xsl:text>pbl:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://purl.org/dc/elements/1.1/'">
				<xsl:text>dc:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = 'http://www.isotc211.org/2005/srv'">
				<xsl:text>srv:</xsl:text>
			</xsl:when>
			<xsl:when test="namespace-uri() = ''">
				<xsl:text/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="wikiHelpPopupLink">
		<xsl:if test="not($globalReadonly)">
			<a href="#" class="ui-mde-wiki-help-link icon-info"></a>
		</xsl:if>
	</xsl:template>
	<!-- EvdP: Doet speciale extra acties voor types van ISO 19139. -->
	<xsl:template match="gco:TypeName" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:MemberName" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Measure" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Length" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Angle" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Scale" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Distance" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:CharacterString" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Boolean" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:LocalName" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:ScopedName" mode="data-type">

    </xsl:template>
	<!-- Numeric types -->
	<xsl:template match="gco:Date" mode="data-type">
		<xsl:attribute name="ui-mde-field-type">date</xsl:attribute>
	</xsl:template>
	<xsl:template match="gco:DateTime" mode="data-type">
		<xsl:attribute name="ui-mde-field-type">date</xsl:attribute>
	</xsl:template>
	<xsl:template match="gco:Decimal" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Real" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Integer" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:UnlimitedInteger" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Record" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:RecordType" mode="data-type">

    </xsl:template>
	<xsl:template match="gco:Binary" mode="data-type">

    </xsl:template>
	<xsl:template match="gmd:URL" mode="data-type">
		<xsl:attribute name="ui-mde-field-type">url</xsl:attribute>
	</xsl:template>
	<xsl:template match="gml:timePosition" mode="data-type">
		<xsl:attribute name="ui-mde-field-type">date</xsl:attribute>
	</xsl:template>
	<xsl:template match="dc:date" mode="data-type">
		<xsl:attribute name="ui-mde-field-type">date</xsl:attribute>
	</xsl:template>
	<!-- General template to catch all other nodes not listed above (picklist nodes etc.); If omitted, FF wil break on prefilled picklists -->
	<xsl:template match="*" mode="data-type">

    </xsl:template>
</xsl:stylesheet>
