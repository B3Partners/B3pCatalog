<?xml version="1.0" encoding="UTF-8"?>
<xs:stylesheet xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:gml="http://www.opengis.net/gml" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" exclude-result-prefixes="xs pbl b3p gml xlink xsi">
	<xs:output method="xml" indent="yes"/>
	<xs:template match="@*|node()">
		<xs:copy>
			<xs:apply-templates select="@*|node()"/>
		</xs:copy>
	</xs:template>
	<!--create pbl:normenkaderPBL template-->
	<xs:template match="pbl:normenkaderPBL">
		<xs:element name="pbl:normenkaderPBL">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkAlgemeenItems) and not(self::pbl:nkBeheerItems) and not(self::pbl:nkBronlijstItems) and not(self::pbl:nkDataobjectItems) and not(self::pbl:nkGebruikItems) and not(self::pbl:nkInvulhulpItems) and not(self::pbl:nkReferentiesItems)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkAlgemeenItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkAlgemeenItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkBeheerItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkBeheerItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkBeheerItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkBronlijstItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkBronlijstItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkBronlijstItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkDataobjectItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkDataobjectItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkDataobjectItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkGebruikItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkGebruikItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkGebruikItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkInvulhulpItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkInvulhulpItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkInvulhulpItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkReferentiesItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkReferentiesItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkReferentiesItems"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-normenkaderPBL">
		<xs:element name="pbl:normenkaderPBL">
			<xs:attribute name="version">hh_12okt</xs:attribute>
			<!--call add-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkBeheerItems template-->
			<xs:call-template name="add-pbl-nkBeheerItems"/>
			<!--call add-pbl-nkBronlijstItems template-->
			<xs:call-template name="add-pbl-nkBronlijstItems"/>
			<!--call add-pbl-nkDataobjectItems template-->
			<xs:call-template name="add-pbl-nkDataobjectItems"/>
			<!--call add-pbl-nkGebruikItems template-->
			<xs:call-template name="add-pbl-nkGebruikItems"/>
			<!--call add-pbl-nkInvulhulpItems template-->
			<xs:call-template name="add-pbl-nkInvulhulpItems"/>
			<!--call add-pbl-nkReferentiesItems template-->
			<xs:call-template name="add-pbl-nkReferentiesItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkAlgemeenItems template-->
	<xs:template match="pbl:nkAlgemeenItems">
		<xs:element name="pbl:nkAlgemeenItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg1) and not(self::pbl:nkalg2) and not(self::pbl:nkalg3) and not(self::pbl:nkalg4) and not(self::pbl:nkalg5) and not(self::pbl:nkalg6) and not(self::pbl:nkalg7)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg5"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg6)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg6"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg7)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg7"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkAlgemeenItems">
			<!--call add-pbl-nkalg1 template-->
			<xs:call-template name="add-pbl-nkalg1"/>
			<!--call add-pbl-nkalg2 template-->
			<xs:call-template name="add-pbl-nkalg2"/>
			<!--call add-pbl-nkalg3 template-->
			<xs:call-template name="add-pbl-nkalg3"/>
			<!--call add-pbl-nkalg4 template-->
			<xs:call-template name="add-pbl-nkalg4"/>
			<!--call add-pbl-nkalg5 template-->
			<xs:call-template name="add-pbl-nkalg5"/>
			<!--call add-pbl-nkalg6 template-->
			<xs:call-template name="add-pbl-nkalg6"/>
			<!--call add-pbl-nkalg7 template-->
			<xs:call-template name="add-pbl-nkalg7"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg1 template-->
	<xs:template match="pbl:nkalg1">
		<xs:element name="pbl:nkalg1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg1Title) and not(self::pbl:nkalg1Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg1Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg1 template-->
	<xs:template name="add-pbl-nkalg1">
		<xs:element name="pbl:nkalg1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg1Title template-->
			<xs:call-template name="add-pbl-nkalg1Title"/>
			<!--call add-pbl-nkalg1Value template-->
			<xs:call-template name="add-pbl-nkalg1Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg1Title template-->
	<xs:template match="pbl:nkalg1Title">
		<xs:element name="pbl:nkalg1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg1Title template-->
	<xs:template name="add-pbl-nkalg1Title">
		<xs:element name="pbl:nkalg1Title">Naam dataobject</xs:element>
	</xs:template>
	<!--create pbl:nkalg1Value template-->
	<xs:template match="pbl:nkalg1Value">
		<xs:element name="pbl:nkalg1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg1Value template-->
	<xs:template name="add-pbl-nkalg1Value">
		<xs:element name="pbl:nkalg1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg2 template-->
	<xs:template match="pbl:nkalg2">
		<xs:element name="pbl:nkalg2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg2Title) and not(self::pbl:nkalg2Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg2Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg2 template-->
	<xs:template name="add-pbl-nkalg2">
		<xs:element name="pbl:nkalg2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg2Title template-->
			<xs:call-template name="add-pbl-nkalg2Title"/>
			<!--call add-pbl-nkalg2Value template-->
			<xs:call-template name="add-pbl-nkalg2Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg2Title template-->
	<xs:template match="pbl:nkalg2Title">
		<xs:element name="pbl:nkalg2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg2Title template-->
	<xs:template name="add-pbl-nkalg2Title">
		<xs:element name="pbl:nkalg2Title">Locatie (dataobject + metadata)</xs:element>
	</xs:template>
	<!--create pbl:nkalg2Value template-->
	<xs:template match="pbl:nkalg2Value">
		<xs:element name="pbl:nkalg2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg2Value template-->
	<xs:template name="add-pbl-nkalg2Value">
		<xs:element name="pbl:nkalg2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg3 template-->
	<xs:template match="pbl:nkalg3">
		<xs:element name="pbl:nkalg3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg3Title) and not(self::pbl:nkalg3Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg3Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg3 template-->
	<xs:template name="add-pbl-nkalg3">
		<xs:element name="pbl:nkalg3">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg3Title template-->
			<xs:call-template name="add-pbl-nkalg3Title"/>
			<!--call add-pbl-nkalg3Value template-->
			<xs:call-template name="add-pbl-nkalg3Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg3Title template-->
	<xs:template match="pbl:nkalg3Title">
		<xs:element name="pbl:nkalg3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg3Title template-->
	<xs:template name="add-pbl-nkalg3Title">
		<xs:element name="pbl:nkalg3Title">Korte omschrijving</xs:element>
	</xs:template>
	<!--create pbl:nkalg3Value template-->
	<xs:template match="pbl:nkalg3Value">
		<xs:element name="pbl:nkalg3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg3Value template-->
	<xs:template name="add-pbl-nkalg3Value">
		<xs:element name="pbl:nkalg3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg4 template-->
	<xs:template match="pbl:nkalg4">
		<xs:element name="pbl:nkalg4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg4Title) and not(self::pbl:nkalg4Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg4Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg4 template-->
	<xs:template name="add-pbl-nkalg4">
		<xs:element name="pbl:nkalg4">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg4Title template-->
			<xs:call-template name="add-pbl-nkalg4Title"/>
			<!--call add-pbl-nkalg4Value template-->
			<xs:call-template name="add-pbl-nkalg4Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg4Title template-->
	<xs:template match="pbl:nkalg4Title">
		<xs:element name="pbl:nkalg4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg4Title template-->
	<xs:template name="add-pbl-nkalg4Title">
		<xs:element name="pbl:nkalg4Title">PBL Eigenaar inclusief contactpersoon</xs:element>
	</xs:template>
	<!--create pbl:nkalg4Value template-->
	<xs:template match="pbl:nkalg4Value">
		<xs:element name="pbl:nkalg4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg4Value template-->
	<xs:template name="add-pbl-nkalg4Value">
		<xs:element name="pbl:nkalg4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg5 template-->
	<xs:template match="pbl:nkalg5">
		<xs:element name="pbl:nkalg5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg5Title) and not(self::pbl:nkalg5Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg5Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg5Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg5Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg5Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg5Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg5Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg5 template-->
	<xs:template name="add-pbl-nkalg5">
		<xs:element name="pbl:nkalg5">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg5Title template-->
			<xs:call-template name="add-pbl-nkalg5Title"/>
			<!--call add-pbl-nkalg5Value template-->
			<xs:call-template name="add-pbl-nkalg5Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg5Title template-->
	<xs:template match="pbl:nkalg5Title">
		<xs:element name="pbl:nkalg5Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg5Title template-->
	<xs:template name="add-pbl-nkalg5Title">
		<xs:element name="pbl:nkalg5Title">PBL Beheerder</xs:element>
	</xs:template>
	<!--create pbl:nkalg5Value template-->
	<xs:template match="pbl:nkalg5Value">
		<xs:element name="pbl:nkalg5Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg5Value template-->
	<xs:template name="add-pbl-nkalg5Value">
		<xs:element name="pbl:nkalg5Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg6 template-->
	<xs:template match="pbl:nkalg6">
		<xs:element name="pbl:nkalg6">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg6Title) and not(self::pbl:nkalg6Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg6Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg6Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg6Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg6Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg6Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg6Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg6 template-->
	<xs:template name="add-pbl-nkalg6">
		<xs:element name="pbl:nkalg6">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg6Title template-->
			<xs:call-template name="add-pbl-nkalg6Title"/>
			<!--call add-pbl-nkalg6Value template-->
			<xs:call-template name="add-pbl-nkalg6Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg6Title template-->
	<xs:template match="pbl:nkalg6Title">
		<xs:element name="pbl:nkalg6Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg6Title template-->
	<xs:template name="add-pbl-nkalg6Title">
		<xs:element name="pbl:nkalg6Title">Datum opname</xs:element>
	</xs:template>
	<!--create pbl:nkalg6Value template-->
	<xs:template match="pbl:nkalg6Value">
		<xs:element name="pbl:nkalg6Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg6Value template-->
	<xs:template name="add-pbl-nkalg6Value">
		<xs:element name="pbl:nkalg6Value"></xs:element>
	</xs:template>
	<!--create pbl:nkalg7 template-->
	<xs:template match="pbl:nkalg7">
		<xs:element name="pbl:nkalg7">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg7Title) and not(self::pbl:nkalg7Value)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg7Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg7Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg7Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg7Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg7Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg7Value"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg7 template-->
	<xs:template name="add-pbl-nkalg7">
		<xs:element name="pbl:nkalg7">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkalg7Title template-->
			<xs:call-template name="add-pbl-nkalg7Title"/>
			<!--call add-pbl-nkalg7Value template-->
			<xs:call-template name="add-pbl-nkalg7Value"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg7Title template-->
	<xs:template match="pbl:nkalg7Title">
		<xs:element name="pbl:nkalg7Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg7Title template-->
	<xs:template name="add-pbl-nkalg7Title">
		<xs:element name="pbl:nkalg7Title">Opgenomen door</xs:element>
	</xs:template>
	<!--create pbl:nkalg7Value template-->
	<xs:template match="pbl:nkalg7Value">
		<xs:element name="pbl:nkalg7Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg7Value template-->
	<xs:template name="add-pbl-nkalg7Value">
		<xs:element name="pbl:nkalg7Value"></xs:element>
	</xs:template>
	<!--create pbl:nkBeheerItems template-->
	<xs:template match="pbl:nkBeheerItems">
		<xs:element name="pbl:nkBeheerItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1) and not(self::pbl:nka2) and not(self::pbl:nka3) and not(self::pbl:nka4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkBeheerItems template-->
	<xs:template name="add-pbl-nkBeheerItems">
		<xs:element name="pbl:nkBeheerItems">
			<!--call add-pbl-nka1 template-->
			<xs:call-template name="add-pbl-nka1"/>
			<!--call add-pbl-nka2 template-->
			<xs:call-template name="add-pbl-nka2"/>
			<!--call add-pbl-nka3 template-->
			<xs:call-template name="add-pbl-nka3"/>
			<!--call add-pbl-nka4 template-->
			<xs:call-template name="add-pbl-nka4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1 template-->
	<xs:template match="pbl:nka1">
		<xs:element name="pbl:nka1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1Title) and not(self::pbl:nka1Value) and not(self::pbl:nka1Comment) and not(self::pbl:nka1Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1 template-->
	<xs:template name="add-pbl-nka1">
		<xs:element name="pbl:nka1">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nka1Title template-->
			<xs:call-template name="add-pbl-nka1Title"/>
			<!--call add-pbl-nka1Value template-->
			<xs:call-template name="add-pbl-nka1Value"/>
			<!--call add-pbl-nka1Comment template-->
			<xs:call-template name="add-pbl-nka1Comment"/>
			<!--call add-pbl-nka1Checks template-->
			<xs:call-template name="add-pbl-nka1Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1Title template-->
	<xs:template match="pbl:nka1Title">
		<xs:element name="pbl:nka1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1Title template-->
	<xs:template name="add-pbl-nka1Title">
		<xs:element name="pbl:nka1Title">Is het beheer van het dataobject belegd?</xs:element>
	</xs:template>
	<!--create pbl:nka1Value template-->
	<xs:template match="pbl:nka1Value">
		<xs:element name="pbl:nka1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1Value template-->
	<xs:template name="add-pbl-nka1Value">
		<xs:element name="pbl:nka1Value"></xs:element>
	</xs:template>
	<!--create pbl:nka1Comment template-->
	<xs:template match="pbl:nka1Comment">
		<xs:element name="pbl:nka1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1Comment template-->
	<xs:template name="add-pbl-nka1Comment">
		<xs:element name="pbl:nka1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka1Checks template-->
	<xs:template match="pbl:nka1Checks">
		<xs:element name="pbl:nka1Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1c1) and not(self::pbl:nka1c2) and not(self::pbl:nka1c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1Checks template-->
	<xs:template name="add-pbl-nka1Checks">
		<xs:element name="pbl:nka1Checks">
			<!--call add-pbl-nka1c1 template-->
			<xs:call-template name="add-pbl-nka1c1"/>
			<!--call add-pbl-nka1c2 template-->
			<xs:call-template name="add-pbl-nka1c2"/>
			<!--call add-pbl-nka1c3 template-->
			<xs:call-template name="add-pbl-nka1c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1c1 template-->
	<xs:template match="pbl:nka1c1">
		<xs:element name="pbl:nka1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1c1Title) and not(self::pbl:nka1c1Value) and not(self::pbl:nka1c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c1 template-->
	<xs:template name="add-pbl-nka1c1">
		<xs:element name="pbl:nka1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka1c1Title template-->
			<xs:call-template name="add-pbl-nka1c1Title"/>
			<!--call add-pbl-nka1c1Value template-->
			<xs:call-template name="add-pbl-nka1c1Value"/>
			<!--call add-pbl-nka1c1Comment template-->
			<xs:call-template name="add-pbl-nka1c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1c1Title template-->
	<xs:template match="pbl:nka1c1Title">
		<xs:element name="pbl:nka1c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c1Title template-->
	<xs:template name="add-pbl-nka1c1Title">
		<xs:element name="pbl:nka1c1Title">Het beheer van een dataobject kan centraal bij IDM, decentraal binnen de sector of binnen een projectteam belegd zijn. Het antwoord Ja gaat dus altijd vergezeld van de opmerking: bij IDM, bij sector X of bij projectteam Y en, indien van toepassing, door…</xs:element>
	</xs:template>
	<!--create pbl:nka1c1Value template-->
	<xs:template match="pbl:nka1c1Value">
		<xs:element name="pbl:nka1c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c1Value template-->
	<xs:template name="add-pbl-nka1c1Value">
		<xs:element name="pbl:nka1c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nka1c1Comment template-->
	<xs:template match="pbl:nka1c1Comment">
		<xs:element name="pbl:nka1c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c1Comment template-->
	<xs:template name="add-pbl-nka1c1Comment">
		<xs:element name="pbl:nka1c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka1c2 template-->
	<xs:template match="pbl:nka1c2">
		<xs:element name="pbl:nka1c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1c2Title) and not(self::pbl:nka1c2Value) and not(self::pbl:nka1c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c2 template-->
	<xs:template name="add-pbl-nka1c2">
		<xs:element name="pbl:nka1c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka1c2Title template-->
			<xs:call-template name="add-pbl-nka1c2Title"/>
			<!--call add-pbl-nka1c2Value template-->
			<xs:call-template name="add-pbl-nka1c2Value"/>
			<!--call add-pbl-nka1c2Comment template-->
			<xs:call-template name="add-pbl-nka1c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1c2Title template-->
	<xs:template match="pbl:nka1c2Title">
		<xs:element name="pbl:nka1c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c2Title template-->
	<xs:template name="add-pbl-nka1c2Title">
		<xs:element name="pbl:nka1c2Title">De beheerder is geen persoon, maar een rol. Binnen IDM/de sectoren/het projectteam heeft iemand de rol van beheerder. Voor een projectdata geldt dat het instellen van een beheerder een vrije keuze is</xs:element>
	</xs:template>
	<!--create pbl:nka1c2Value template-->
	<xs:template match="pbl:nka1c2Value">
		<xs:element name="pbl:nka1c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c2Value template-->
	<xs:template name="add-pbl-nka1c2Value">
		<xs:element name="pbl:nka1c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nka1c2Comment template-->
	<xs:template match="pbl:nka1c2Comment">
		<xs:element name="pbl:nka1c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c2Comment template-->
	<xs:template name="add-pbl-nka1c2Comment">
		<xs:element name="pbl:nka1c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka1c3 template-->
	<xs:template match="pbl:nka1c3">
		<xs:element name="pbl:nka1c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1c3Title) and not(self::pbl:nka1c3Value) and not(self::pbl:nka1c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c3 template-->
	<xs:template name="add-pbl-nka1c3">
		<xs:element name="pbl:nka1c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka1c3Title template-->
			<xs:call-template name="add-pbl-nka1c3Title"/>
			<!--call add-pbl-nka1c3Value template-->
			<xs:call-template name="add-pbl-nka1c3Value"/>
			<!--call add-pbl-nka1c3Comment template-->
			<xs:call-template name="add-pbl-nka1c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1c3Title template-->
	<xs:template match="pbl:nka1c3Title">
		<xs:element name="pbl:nka1c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c3Title template-->
	<xs:template name="add-pbl-nka1c3Title">
		<xs:element name="pbl:nka1c3Title">Is de metadata opgenomen worden in de PBL datazoekapplicatie? Andere gebruikers weten dan ook het dataobject beschibaar is.</xs:element>
	</xs:template>
	<!--create pbl:nka1c3Value template-->
	<xs:template match="pbl:nka1c3Value">
		<xs:element name="pbl:nka1c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c3Value template-->
	<xs:template name="add-pbl-nka1c3Value">
		<xs:element name="pbl:nka1c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nka1c3Comment template-->
	<xs:template match="pbl:nka1c3Comment">
		<xs:element name="pbl:nka1c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c3Comment template-->
	<xs:template name="add-pbl-nka1c3Comment">
		<xs:element name="pbl:nka1c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka2 template-->
	<xs:template match="pbl:nka2">
		<xs:element name="pbl:nka2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka2Title) and not(self::pbl:nka2Value) and not(self::pbl:nka2Comment) and not(self::pbl:nka2Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2 template-->
	<xs:template name="add-pbl-nka2">
		<xs:element name="pbl:nka2">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nka2Title template-->
			<xs:call-template name="add-pbl-nka2Title"/>
			<!--call add-pbl-nka2Value template-->
			<xs:call-template name="add-pbl-nka2Value"/>
			<!--call add-pbl-nka2Comment template-->
			<xs:call-template name="add-pbl-nka2Comment"/>
			<!--call add-pbl-nka2Checks template-->
			<xs:call-template name="add-pbl-nka2Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka2Title template-->
	<xs:template match="pbl:nka2Title">
		<xs:element name="pbl:nka2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2Title template-->
	<xs:template name="add-pbl-nka2Title">
		<xs:element name="pbl:nka2Title">Is het eigenaarschap van het dataobject belegd?</xs:element>
	</xs:template>
	<!--create pbl:nka2Value template-->
	<xs:template match="pbl:nka2Value">
		<xs:element name="pbl:nka2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2Value template-->
	<xs:template name="add-pbl-nka2Value">
		<xs:element name="pbl:nka2Value"></xs:element>
	</xs:template>
	<!--create pbl:nka2Comment template-->
	<xs:template match="pbl:nka2Comment">
		<xs:element name="pbl:nka2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2Comment template-->
	<xs:template name="add-pbl-nka2Comment">
		<xs:element name="pbl:nka2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka2Checks template-->
	<xs:template match="pbl:nka2Checks">
		<xs:element name="pbl:nka2Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka2c1) and not(self::pbl:nka2c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2Checks template-->
	<xs:template name="add-pbl-nka2Checks">
		<xs:element name="pbl:nka2Checks">
			<!--call add-pbl-nka2c1 template-->
			<xs:call-template name="add-pbl-nka2c1"/>
			<!--call add-pbl-nka2c2 template-->
			<xs:call-template name="add-pbl-nka2c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka2c1 template-->
	<xs:template match="pbl:nka2c1">
		<xs:element name="pbl:nka2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka2c1Title) and not(self::pbl:nka2c1Value) and not(self::pbl:nka2c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka2c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c1 template-->
	<xs:template name="add-pbl-nka2c1">
		<xs:element name="pbl:nka2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka2c1Title template-->
			<xs:call-template name="add-pbl-nka2c1Title"/>
			<!--call add-pbl-nka2c1Value template-->
			<xs:call-template name="add-pbl-nka2c1Value"/>
			<!--call add-pbl-nka2c1Comment template-->
			<xs:call-template name="add-pbl-nka2c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka2c1Title template-->
	<xs:template match="pbl:nka2c1Title">
		<xs:element name="pbl:nka2c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c1Title template-->
	<xs:template name="add-pbl-nka2c1Title">
		<xs:element name="pbl:nka2c1Title">Is de eigenaar op de hoogte van zijn/haar verantwoordelijkheden?</xs:element>
	</xs:template>
	<!--create pbl:nka2c1Value template-->
	<xs:template match="pbl:nka2c1Value">
		<xs:element name="pbl:nka2c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c1Value template-->
	<xs:template name="add-pbl-nka2c1Value">
		<xs:element name="pbl:nka2c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nka2c1Comment template-->
	<xs:template match="pbl:nka2c1Comment">
		<xs:element name="pbl:nka2c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c1Comment template-->
	<xs:template name="add-pbl-nka2c1Comment">
		<xs:element name="pbl:nka2c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka2c2 template-->
	<xs:template match="pbl:nka2c2">
		<xs:element name="pbl:nka2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka2c2Title) and not(self::pbl:nka2c2Value) and not(self::pbl:nka2c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka2c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c2 template-->
	<xs:template name="add-pbl-nka2c2">
		<xs:element name="pbl:nka2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka2c2Title template-->
			<xs:call-template name="add-pbl-nka2c2Title"/>
			<!--call add-pbl-nka2c2Value template-->
			<xs:call-template name="add-pbl-nka2c2Value"/>
			<!--call add-pbl-nka2c2Comment template-->
			<xs:call-template name="add-pbl-nka2c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka2c2Title template-->
	<xs:template match="pbl:nka2c2Title">
		<xs:element name="pbl:nka2c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c2Title template-->
	<xs:template name="add-pbl-nka2c2Title">
		<xs:element name="pbl:nka2c2Title">Is het eigenaarschap noodzakelijk? Vrij beschikbare dataobjecten hebben geen PBL eigenaar nodig, bestanden met gebruiksbeperkingen hebben wel een PBL eigenaar nodig. </xs:element>
	</xs:template>
	<!--create pbl:nka2c2Value template-->
	<xs:template match="pbl:nka2c2Value">
		<xs:element name="pbl:nka2c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c2Value template-->
	<xs:template name="add-pbl-nka2c2Value">
		<xs:element name="pbl:nka2c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nka2c2Comment template-->
	<xs:template match="pbl:nka2c2Comment">
		<xs:element name="pbl:nka2c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c2Comment template-->
	<xs:template name="add-pbl-nka2c2Comment">
		<xs:element name="pbl:nka2c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka3 template-->
	<xs:template match="pbl:nka3">
		<xs:element name="pbl:nka3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka3Title) and not(self::pbl:nka3Value) and not(self::pbl:nka3Comment) and not(self::pbl:nka3Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3 template-->
	<xs:template name="add-pbl-nka3">
		<xs:element name="pbl:nka3">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nka3Title template-->
			<xs:call-template name="add-pbl-nka3Title"/>
			<!--call add-pbl-nka3Value template-->
			<xs:call-template name="add-pbl-nka3Value"/>
			<!--call add-pbl-nka3Comment template-->
			<xs:call-template name="add-pbl-nka3Comment"/>
			<!--call add-pbl-nka3Checks template-->
			<xs:call-template name="add-pbl-nka3Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka3Title template-->
	<xs:template match="pbl:nka3Title">
		<xs:element name="pbl:nka3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3Title template-->
	<xs:template name="add-pbl-nka3Title">
		<xs:element name="pbl:nka3Title">Is de dataexpert bekend?</xs:element>
	</xs:template>
	<!--create pbl:nka3Value template-->
	<xs:template match="pbl:nka3Value">
		<xs:element name="pbl:nka3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3Value template-->
	<xs:template name="add-pbl-nka3Value">
		<xs:element name="pbl:nka3Value"></xs:element>
	</xs:template>
	<!--create pbl:nka3Comment template-->
	<xs:template match="pbl:nka3Comment">
		<xs:element name="pbl:nka3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3Comment template-->
	<xs:template name="add-pbl-nka3Comment">
		<xs:element name="pbl:nka3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka3Checks template-->
	<xs:template match="pbl:nka3Checks">
		<xs:element name="pbl:nka3Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka3c1) and not(self::pbl:nka3c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3Checks template-->
	<xs:template name="add-pbl-nka3Checks">
		<xs:element name="pbl:nka3Checks">
			<!--call add-pbl-nka3c1 template-->
			<xs:call-template name="add-pbl-nka3c1"/>
			<!--call add-pbl-nka3c2 template-->
			<xs:call-template name="add-pbl-nka3c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka3c1 template-->
	<xs:template match="pbl:nka3c1">
		<xs:element name="pbl:nka3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka3c1Title) and not(self::pbl:nka3c1Value) and not(self::pbl:nka3c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka3c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c1 template-->
	<xs:template name="add-pbl-nka3c1">
		<xs:element name="pbl:nka3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka3c1Title template-->
			<xs:call-template name="add-pbl-nka3c1Title"/>
			<!--call add-pbl-nka3c1Value template-->
			<xs:call-template name="add-pbl-nka3c1Value"/>
			<!--call add-pbl-nka3c1Comment template-->
			<xs:call-template name="add-pbl-nka3c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka3c1Title template-->
	<xs:template match="pbl:nka3c1Title">
		<xs:element name="pbl:nka3c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c1Title template-->
	<xs:template name="add-pbl-nka3c1Title">
		<xs:element name="pbl:nka3c1Title">Zijn aandachtspunten voor het gebruik opgenomen in de metadata?</xs:element>
	</xs:template>
	<!--create pbl:nka3c1Value template-->
	<xs:template match="pbl:nka3c1Value">
		<xs:element name="pbl:nka3c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c1Value template-->
	<xs:template name="add-pbl-nka3c1Value">
		<xs:element name="pbl:nka3c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nka3c1Comment template-->
	<xs:template match="pbl:nka3c1Comment">
		<xs:element name="pbl:nka3c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c1Comment template-->
	<xs:template name="add-pbl-nka3c1Comment">
		<xs:element name="pbl:nka3c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka3c2 template-->
	<xs:template match="pbl:nka3c2">
		<xs:element name="pbl:nka3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka3c2Title) and not(self::pbl:nka3c2Value) and not(self::pbl:nka3c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka3c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c2 template-->
	<xs:template name="add-pbl-nka3c2">
		<xs:element name="pbl:nka3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka3c2Title template-->
			<xs:call-template name="add-pbl-nka3c2Title"/>
			<!--call add-pbl-nka3c2Value template-->
			<xs:call-template name="add-pbl-nka3c2Value"/>
			<!--call add-pbl-nka3c2Comment template-->
			<xs:call-template name="add-pbl-nka3c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka3c2Title template-->
	<xs:template match="pbl:nka3c2Title">
		<xs:element name="pbl:nka3c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c2Title template-->
	<xs:template name="add-pbl-nka3c2Title">
		<xs:element name="pbl:nka3c2Title">Staan in de metadata de projecten waarvoor het dataobject eerder is gebruikt?</xs:element>
	</xs:template>
	<!--create pbl:nka3c2Value template-->
	<xs:template match="pbl:nka3c2Value">
		<xs:element name="pbl:nka3c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c2Value template-->
	<xs:template name="add-pbl-nka3c2Value">
		<xs:element name="pbl:nka3c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nka3c2Comment template-->
	<xs:template match="pbl:nka3c2Comment">
		<xs:element name="pbl:nka3c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c2Comment template-->
	<xs:template name="add-pbl-nka3c2Comment">
		<xs:element name="pbl:nka3c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka4 template-->
	<xs:template match="pbl:nka4">
		<xs:element name="pbl:nka4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4Title) and not(self::pbl:nka4Value) and not(self::pbl:nka4Comment) and not(self::pbl:nka4Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4 template-->
	<xs:template name="add-pbl-nka4">
		<xs:element name="pbl:nka4">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nka4Title template-->
			<xs:call-template name="add-pbl-nka4Title"/>
			<!--call add-pbl-nka4Value template-->
			<xs:call-template name="add-pbl-nka4Value"/>
			<!--call add-pbl-nka4Comment template-->
			<xs:call-template name="add-pbl-nka4Comment"/>
			<!--call add-pbl-nka4Checks template-->
			<xs:call-template name="add-pbl-nka4Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4Title template-->
	<xs:template match="pbl:nka4Title">
		<xs:element name="pbl:nka4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4Title template-->
	<xs:template name="add-pbl-nka4Title">
		<xs:element name="pbl:nka4Title">Is er versiebeheer voor het dataobjectgeregeld (correcties, aanpassingen, etc)?</xs:element>
	</xs:template>
	<!--create pbl:nka4Value template-->
	<xs:template match="pbl:nka4Value">
		<xs:element name="pbl:nka4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4Value template-->
	<xs:template name="add-pbl-nka4Value">
		<xs:element name="pbl:nka4Value"></xs:element>
	</xs:template>
	<!--create pbl:nka4Comment template-->
	<xs:template match="pbl:nka4Comment">
		<xs:element name="pbl:nka4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4Comment template-->
	<xs:template name="add-pbl-nka4Comment">
		<xs:element name="pbl:nka4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka4Checks template-->
	<xs:template match="pbl:nka4Checks">
		<xs:element name="pbl:nka4Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4c1) and not(self::pbl:nka4c2) and not(self::pbl:nka4c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4Checks template-->
	<xs:template name="add-pbl-nka4Checks">
		<xs:element name="pbl:nka4Checks">
			<!--call add-pbl-nka4c1 template-->
			<xs:call-template name="add-pbl-nka4c1"/>
			<!--call add-pbl-nka4c2 template-->
			<xs:call-template name="add-pbl-nka4c2"/>
			<!--call add-pbl-nka4c3 template-->
			<xs:call-template name="add-pbl-nka4c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4c1 template-->
	<xs:template match="pbl:nka4c1">
		<xs:element name="pbl:nka4c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4c1Title) and not(self::pbl:nka4c1Value) and not(self::pbl:nka4c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c1 template-->
	<xs:template name="add-pbl-nka4c1">
		<xs:element name="pbl:nka4c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka4c1Title template-->
			<xs:call-template name="add-pbl-nka4c1Title"/>
			<!--call add-pbl-nka4c1Value template-->
			<xs:call-template name="add-pbl-nka4c1Value"/>
			<!--call add-pbl-nka4c1Comment template-->
			<xs:call-template name="add-pbl-nka4c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4c1Title template-->
	<xs:template match="pbl:nka4c1Title">
		<xs:element name="pbl:nka4c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c1Title template-->
	<xs:template name="add-pbl-nka4c1Title">
		<xs:element name="pbl:nka4c1Title">Is versiebeheer nodig?</xs:element>
	</xs:template>
	<!--create pbl:nka4c1Value template-->
	<xs:template match="pbl:nka4c1Value">
		<xs:element name="pbl:nka4c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c1Value template-->
	<xs:template name="add-pbl-nka4c1Value">
		<xs:element name="pbl:nka4c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nka4c1Comment template-->
	<xs:template match="pbl:nka4c1Comment">
		<xs:element name="pbl:nka4c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c1Comment template-->
	<xs:template name="add-pbl-nka4c1Comment">
		<xs:element name="pbl:nka4c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka4c2 template-->
	<xs:template match="pbl:nka4c2">
		<xs:element name="pbl:nka4c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4c2Title) and not(self::pbl:nka4c2Value) and not(self::pbl:nka4c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c2 template-->
	<xs:template name="add-pbl-nka4c2">
		<xs:element name="pbl:nka4c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka4c2Title template-->
			<xs:call-template name="add-pbl-nka4c2Title"/>
			<!--call add-pbl-nka4c2Value template-->
			<xs:call-template name="add-pbl-nka4c2Value"/>
			<!--call add-pbl-nka4c2Comment template-->
			<xs:call-template name="add-pbl-nka4c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4c2Title template-->
	<xs:template match="pbl:nka4c2Title">
		<xs:element name="pbl:nka4c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c2Title template-->
	<xs:template name="add-pbl-nka4c2Title">
		<xs:element name="pbl:nka4c2Title">Is er beschreven hoe om te gaan met actualisaties van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nka4c2Value template-->
	<xs:template match="pbl:nka4c2Value">
		<xs:element name="pbl:nka4c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c2Value template-->
	<xs:template name="add-pbl-nka4c2Value">
		<xs:element name="pbl:nka4c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nka4c2Comment template-->
	<xs:template match="pbl:nka4c2Comment">
		<xs:element name="pbl:nka4c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c2Comment template-->
	<xs:template name="add-pbl-nka4c2Comment">
		<xs:element name="pbl:nka4c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nka4c3 template-->
	<xs:template match="pbl:nka4c3">
		<xs:element name="pbl:nka4c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4c3Title) and not(self::pbl:nka4c3Value) and not(self::pbl:nka4c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c3 template-->
	<xs:template name="add-pbl-nka4c3">
		<xs:element name="pbl:nka4c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nka4c3Title template-->
			<xs:call-template name="add-pbl-nka4c3Title"/>
			<!--call add-pbl-nka4c3Value template-->
			<xs:call-template name="add-pbl-nka4c3Value"/>
			<!--call add-pbl-nka4c3Comment template-->
			<xs:call-template name="add-pbl-nka4c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4c3Title template-->
	<xs:template match="pbl:nka4c3Title">
		<xs:element name="pbl:nka4c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c3Title template-->
	<xs:template name="add-pbl-nka4c3Title">
		<xs:element name="pbl:nka4c3Title">Op welke manier wordt het versiebeheer voor het dataobject uitgevoerd?</xs:element>
	</xs:template>
	<!--create pbl:nka4c3Value template-->
	<xs:template match="pbl:nka4c3Value">
		<xs:element name="pbl:nka4c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c3Value template-->
	<xs:template name="add-pbl-nka4c3Value">
		<xs:element name="pbl:nka4c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nka4c3Comment template-->
	<xs:template match="pbl:nka4c3Comment">
		<xs:element name="pbl:nka4c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c3Comment template-->
	<xs:template name="add-pbl-nka4c3Comment">
		<xs:element name="pbl:nka4c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkBronlijstItems template-->
	<xs:template match="pbl:nkBronlijstItems">
		<xs:element name="pbl:nkBronlijstItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkbl1) and not(self::pbl:nkbl2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkbl1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkbl2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkBronlijstItems template-->
	<xs:template name="add-pbl-nkBronlijstItems">
		<xs:element name="pbl:nkBronlijstItems">
			<!--call add-pbl-nkbl1 template-->
			<xs:call-template name="add-pbl-nkbl1"/>
			<!--call add-pbl-nkbl2 template-->
			<xs:call-template name="add-pbl-nkbl2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkbl1 template-->
	<xs:template match="pbl:nkbl1">
		<xs:element name="pbl:nkbl1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkbl1Title)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkbl1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl1Title"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl1 template-->
	<xs:template name="add-pbl-nkbl1">
		<xs:element name="pbl:nkbl1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkbl1Title template-->
			<xs:call-template name="add-pbl-nkbl1Title"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkbl1Title template-->
	<xs:template match="pbl:nkbl1Title">
		<xs:element name="pbl:nkbl1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl1Title template-->
	<xs:template name="add-pbl-nkbl1Title">
		<xs:element name="pbl:nkbl1Title">De bronlijst wordt aangemaakt bij aanvang van het project en wordt gedurende het project bijgewerkt (dataobjecten komen er bij en gaan er af). De checklist datakwaliteit wordt toegepast voor alle objecten op de bronlijst. De checklist wordt toegepast voordat een bestaand dataobject gebruikt wordt of voordat een geproduceerd dataobject uitgeleverd wordt.</xs:element>
	</xs:template>
	<!--create pbl:nkbl2 template-->
	<xs:template match="pbl:nkbl2">
		<xs:element name="pbl:nkbl2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkbl2Title)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkbl2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl2Title"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl2 template-->
	<xs:template name="add-pbl-nkbl2">
		<xs:element name="pbl:nkbl2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkbl2Title template-->
			<xs:call-template name="add-pbl-nkbl2Title"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkbl2Title template-->
	<xs:template match="pbl:nkbl2Title">
		<xs:element name="pbl:nkbl2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl2Title template-->
	<xs:template name="add-pbl-nkbl2Title">
		<xs:element name="pbl:nkbl2Title">Het beheer van de bronlijst wordt uitgevoerd in het project en valt onder de verantwoordelijkheid van de projectleider.</xs:element>
	</xs:template>
	<!--create pbl:nkDataobjectItems template-->
	<xs:template match="pbl:nkDataobjectItems">
		<xs:element name="pbl:nkDataobjectItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1) and not(self::pbl:nkb2) and not(self::pbl:nkb3) and not(self::pbl:nkb4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkDataobjectItems template-->
	<xs:template name="add-pbl-nkDataobjectItems">
		<xs:element name="pbl:nkDataobjectItems">
			<!--call add-pbl-nkb1 template-->
			<xs:call-template name="add-pbl-nkb1"/>
			<!--call add-pbl-nkb2 template-->
			<xs:call-template name="add-pbl-nkb2"/>
			<!--call add-pbl-nkb3 template-->
			<xs:call-template name="add-pbl-nkb3"/>
			<!--call add-pbl-nkb4 template-->
			<xs:call-template name="add-pbl-nkb4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1 template-->
	<xs:template match="pbl:nkb1">
		<xs:element name="pbl:nkb1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1Title) and not(self::pbl:nkb1Value) and not(self::pbl:nkb1Comment) and not(self::pbl:nkb1Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1 template-->
	<xs:template name="add-pbl-nkb1">
		<xs:element name="pbl:nkb1">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkb1Title template-->
			<xs:call-template name="add-pbl-nkb1Title"/>
			<!--call add-pbl-nkb1Value template-->
			<xs:call-template name="add-pbl-nkb1Value"/>
			<!--call add-pbl-nkb1Comment template-->
			<xs:call-template name="add-pbl-nkb1Comment"/>
			<!--call add-pbl-nkb1Checks template-->
			<xs:call-template name="add-pbl-nkb1Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1Title template-->
	<xs:template match="pbl:nkb1Title">
		<xs:element name="pbl:nkb1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1Title template-->
	<xs:template name="add-pbl-nkb1Title">
		<xs:element name="pbl:nkb1Title">Is het dataobject voorzien van metadata?</xs:element>
	</xs:template>
	<!--create pbl:nkb1Value template-->
	<xs:template match="pbl:nkb1Value">
		<xs:element name="pbl:nkb1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1Value template-->
	<xs:template name="add-pbl-nkb1Value">
		<xs:element name="pbl:nkb1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb1Comment template-->
	<xs:template match="pbl:nkb1Comment">
		<xs:element name="pbl:nkb1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1Comment template-->
	<xs:template name="add-pbl-nkb1Comment">
		<xs:element name="pbl:nkb1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1Checks template-->
	<xs:template match="pbl:nkb1Checks">
		<xs:element name="pbl:nkb1Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c1) and not(self::pbl:nkb1c2) and not(self::pbl:nkb1c3) and not(self::pbl:nkb1c4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1Checks template-->
	<xs:template name="add-pbl-nkb1Checks">
		<xs:element name="pbl:nkb1Checks">
			<!--call add-pbl-nkb1c1 template-->
			<xs:call-template name="add-pbl-nkb1c1"/>
			<!--call add-pbl-nkb1c2 template-->
			<xs:call-template name="add-pbl-nkb1c2"/>
			<!--call add-pbl-nkb1c3 template-->
			<xs:call-template name="add-pbl-nkb1c3"/>
			<!--call add-pbl-nkb1c4 template-->
			<xs:call-template name="add-pbl-nkb1c4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c1 template-->
	<xs:template match="pbl:nkb1c1">
		<xs:element name="pbl:nkb1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c1Title) and not(self::pbl:nkb1c1Value) and not(self::pbl:nkb1c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c1 template-->
	<xs:template name="add-pbl-nkb1c1">
		<xs:element name="pbl:nkb1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb1c1Title template-->
			<xs:call-template name="add-pbl-nkb1c1Title"/>
			<!--call add-pbl-nkb1c1Value template-->
			<xs:call-template name="add-pbl-nkb1c1Value"/>
			<!--call add-pbl-nkb1c1Comment template-->
			<xs:call-template name="add-pbl-nkb1c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c1Title template-->
	<xs:template match="pbl:nkb1c1Title">
		<xs:element name="pbl:nkb1c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c1Title template-->
	<xs:template name="add-pbl-nkb1c1Title">
		<xs:element name="pbl:nkb1c1Title">Is de metadata beschikbaar volgens de PBL richtlijnen? Richtlijnen maken het mogelijk dataobjecten te zoeken op meerdere ingangen, en om metadata gestructureerd toe te voegen.</xs:element>
	</xs:template>
	<!--create pbl:nkb1c1Value template-->
	<xs:template match="pbl:nkb1c1Value">
		<xs:element name="pbl:nkb1c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c1Value template-->
	<xs:template name="add-pbl-nkb1c1Value">
		<xs:element name="pbl:nkb1c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c1Comment template-->
	<xs:template match="pbl:nkb1c1Comment">
		<xs:element name="pbl:nkb1c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c1Comment template-->
	<xs:template name="add-pbl-nkb1c1Comment">
		<xs:element name="pbl:nkb1c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c2 template-->
	<xs:template match="pbl:nkb1c2">
		<xs:element name="pbl:nkb1c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c2Title) and not(self::pbl:nkb1c2Value) and not(self::pbl:nkb1c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c2 template-->
	<xs:template name="add-pbl-nkb1c2">
		<xs:element name="pbl:nkb1c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb1c2Title template-->
			<xs:call-template name="add-pbl-nkb1c2Title"/>
			<!--call add-pbl-nkb1c2Value template-->
			<xs:call-template name="add-pbl-nkb1c2Value"/>
			<!--call add-pbl-nkb1c2Comment template-->
			<xs:call-template name="add-pbl-nkb1c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c2Title template-->
	<xs:template match="pbl:nkb1c2Title">
		<xs:element name="pbl:nkb1c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c2Title template-->
	<xs:template name="add-pbl-nkb1c2Title">
		<xs:element name="pbl:nkb1c2Title">Is de metadata voldoende om de waarde voor de gewenste toepassing te kunnen beoordelen?</xs:element>
	</xs:template>
	<!--create pbl:nkb1c2Value template-->
	<xs:template match="pbl:nkb1c2Value">
		<xs:element name="pbl:nkb1c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c2Value template-->
	<xs:template name="add-pbl-nkb1c2Value">
		<xs:element name="pbl:nkb1c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c2Comment template-->
	<xs:template match="pbl:nkb1c2Comment">
		<xs:element name="pbl:nkb1c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c2Comment template-->
	<xs:template name="add-pbl-nkb1c2Comment">
		<xs:element name="pbl:nkb1c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c3 template-->
	<xs:template match="pbl:nkb1c3">
		<xs:element name="pbl:nkb1c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c3Title) and not(self::pbl:nkb1c3Value) and not(self::pbl:nkb1c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c3 template-->
	<xs:template name="add-pbl-nkb1c3">
		<xs:element name="pbl:nkb1c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb1c3Title template-->
			<xs:call-template name="add-pbl-nkb1c3Title"/>
			<!--call add-pbl-nkb1c3Value template-->
			<xs:call-template name="add-pbl-nkb1c3Value"/>
			<!--call add-pbl-nkb1c3Comment template-->
			<xs:call-template name="add-pbl-nkb1c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c3Title template-->
	<xs:template match="pbl:nkb1c3Title">
		<xs:element name="pbl:nkb1c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c3Title template-->
	<xs:template name="add-pbl-nkb1c3Title">
		<xs:element name="pbl:nkb1c3Title">Is de metadata actueel, zijn eventuele datachecks en eerdere toepassingen er in opgenomen?</xs:element>
	</xs:template>
	<!--create pbl:nkb1c3Value template-->
	<xs:template match="pbl:nkb1c3Value">
		<xs:element name="pbl:nkb1c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c3Value template-->
	<xs:template name="add-pbl-nkb1c3Value">
		<xs:element name="pbl:nkb1c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c3Comment template-->
	<xs:template match="pbl:nkb1c3Comment">
		<xs:element name="pbl:nkb1c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c3Comment template-->
	<xs:template name="add-pbl-nkb1c3Comment">
		<xs:element name="pbl:nkb1c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c4 template-->
	<xs:template match="pbl:nkb1c4">
		<xs:element name="pbl:nkb1c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c4Title) and not(self::pbl:nkb1c4Value) and not(self::pbl:nkb1c4Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c4Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c4 template-->
	<xs:template name="add-pbl-nkb1c4">
		<xs:element name="pbl:nkb1c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb1c4Title template-->
			<xs:call-template name="add-pbl-nkb1c4Title"/>
			<!--call add-pbl-nkb1c4Value template-->
			<xs:call-template name="add-pbl-nkb1c4Value"/>
			<!--call add-pbl-nkb1c4Comment template-->
			<xs:call-template name="add-pbl-nkb1c4Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c4Title template-->
	<xs:template match="pbl:nkb1c4Title">
		<xs:element name="pbl:nkb1c4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c4Title template-->
	<xs:template name="add-pbl-nkb1c4Title">
		<xs:element name="pbl:nkb1c4Title">Indien er meerdere versies van het dataobject voorkomen, is dan duidelijk met welke versie gewerkt wordt?</xs:element>
	</xs:template>
	<!--create pbl:nkb1c4Value template-->
	<xs:template match="pbl:nkb1c4Value">
		<xs:element name="pbl:nkb1c4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c4Value template-->
	<xs:template name="add-pbl-nkb1c4Value">
		<xs:element name="pbl:nkb1c4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c4Comment template-->
	<xs:template match="pbl:nkb1c4Comment">
		<xs:element name="pbl:nkb1c4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c4Comment template-->
	<xs:template name="add-pbl-nkb1c4Comment">
		<xs:element name="pbl:nkb1c4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb2 template-->
	<xs:template match="pbl:nkb2">
		<xs:element name="pbl:nkb2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb2Title) and not(self::pbl:nkb2Value) and not(self::pbl:nkb2Comment) and not(self::pbl:nkb2Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2 template-->
	<xs:template name="add-pbl-nkb2">
		<xs:element name="pbl:nkb2">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkb2Title template-->
			<xs:call-template name="add-pbl-nkb2Title"/>
			<!--call add-pbl-nkb2Value template-->
			<xs:call-template name="add-pbl-nkb2Value"/>
			<!--call add-pbl-nkb2Comment template-->
			<xs:call-template name="add-pbl-nkb2Comment"/>
			<!--call add-pbl-nkb2Checks template-->
			<xs:call-template name="add-pbl-nkb2Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb2Title template-->
	<xs:template match="pbl:nkb2Title">
		<xs:element name="pbl:nkb2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2Title template-->
	<xs:template name="add-pbl-nkb2Title">
		<xs:element name="pbl:nkb2Title">Is er een beschrijving van het oorspronkelijke doel en toepassingsbereik van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nkb2Value template-->
	<xs:template match="pbl:nkb2Value">
		<xs:element name="pbl:nkb2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2Value template-->
	<xs:template name="add-pbl-nkb2Value">
		<xs:element name="pbl:nkb2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb2Comment template-->
	<xs:template match="pbl:nkb2Comment">
		<xs:element name="pbl:nkb2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2Comment template-->
	<xs:template name="add-pbl-nkb2Comment">
		<xs:element name="pbl:nkb2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb2Checks template-->
	<xs:template match="pbl:nkb2Checks">
		<xs:element name="pbl:nkb2Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb2c1) and not(self::pbl:nkb2c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2Checks template-->
	<xs:template name="add-pbl-nkb2Checks">
		<xs:element name="pbl:nkb2Checks">
			<!--call add-pbl-nkb2c1 template-->
			<xs:call-template name="add-pbl-nkb2c1"/>
			<!--call add-pbl-nkb2c2 template-->
			<xs:call-template name="add-pbl-nkb2c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb2c1 template-->
	<xs:template match="pbl:nkb2c1">
		<xs:element name="pbl:nkb2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb2c1Title) and not(self::pbl:nkb2c1Value) and not(self::pbl:nkb2c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c1 template-->
	<xs:template name="add-pbl-nkb2c1">
		<xs:element name="pbl:nkb2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb2c1Title template-->
			<xs:call-template name="add-pbl-nkb2c1Title"/>
			<!--call add-pbl-nkb2c1Value template-->
			<xs:call-template name="add-pbl-nkb2c1Value"/>
			<!--call add-pbl-nkb2c1Comment template-->
			<xs:call-template name="add-pbl-nkb2c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb2c1Title template-->
	<xs:template match="pbl:nkb2c1Title">
		<xs:element name="pbl:nkb2c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c1Title template-->
	<xs:template name="add-pbl-nkb2c1Title">
		<xs:element name="pbl:nkb2c1Title">Is er informatie beschikbaar in de metadata over het oorspronkelijke doel waarvoor het dataobject is gemaakt? </xs:element>
	</xs:template>
	<!--create pbl:nkb2c1Value template-->
	<xs:template match="pbl:nkb2c1Value">
		<xs:element name="pbl:nkb2c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c1Value template-->
	<xs:template name="add-pbl-nkb2c1Value">
		<xs:element name="pbl:nkb2c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb2c1Comment template-->
	<xs:template match="pbl:nkb2c1Comment">
		<xs:element name="pbl:nkb2c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c1Comment template-->
	<xs:template name="add-pbl-nkb2c1Comment">
		<xs:element name="pbl:nkb2c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb2c2 template-->
	<xs:template match="pbl:nkb2c2">
		<xs:element name="pbl:nkb2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb2c2Title) and not(self::pbl:nkb2c2Value) and not(self::pbl:nkb2c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c2 template-->
	<xs:template name="add-pbl-nkb2c2">
		<xs:element name="pbl:nkb2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb2c2Title template-->
			<xs:call-template name="add-pbl-nkb2c2Title"/>
			<!--call add-pbl-nkb2c2Value template-->
			<xs:call-template name="add-pbl-nkb2c2Value"/>
			<!--call add-pbl-nkb2c2Comment template-->
			<xs:call-template name="add-pbl-nkb2c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb2c2Title template-->
	<xs:template match="pbl:nkb2c2Title">
		<xs:element name="pbl:nkb2c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c2Title template-->
	<xs:template name="add-pbl-nkb2c2Title">
		<xs:element name="pbl:nkb2c2Title">Is er informatie beschikbaar in de metadata over het toepassingsbereik waarvoor het dataobject is gecreëerd?</xs:element>
	</xs:template>
	<!--create pbl:nkb2c2Value template-->
	<xs:template match="pbl:nkb2c2Value">
		<xs:element name="pbl:nkb2c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c2Value template-->
	<xs:template name="add-pbl-nkb2c2Value">
		<xs:element name="pbl:nkb2c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb2c2Comment template-->
	<xs:template match="pbl:nkb2c2Comment">
		<xs:element name="pbl:nkb2c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c2Comment template-->
	<xs:template name="add-pbl-nkb2c2Comment">
		<xs:element name="pbl:nkb2c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3 template-->
	<xs:template match="pbl:nkb3">
		<xs:element name="pbl:nkb3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3Title) and not(self::pbl:nkb3Value) and not(self::pbl:nkb3Comment) and not(self::pbl:nkb3Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3 template-->
	<xs:template name="add-pbl-nkb3">
		<xs:element name="pbl:nkb3">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkb3Title template-->
			<xs:call-template name="add-pbl-nkb3Title"/>
			<!--call add-pbl-nkb3Value template-->
			<xs:call-template name="add-pbl-nkb3Value"/>
			<!--call add-pbl-nkb3Comment template-->
			<xs:call-template name="add-pbl-nkb3Comment"/>
			<!--call add-pbl-nkb3Checks template-->
			<xs:call-template name="add-pbl-nkb3Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3Title template-->
	<xs:template match="pbl:nkb3Title">
		<xs:element name="pbl:nkb3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3Title template-->
	<xs:template name="add-pbl-nkb3Title">
		<xs:element name="pbl:nkb3Title">Zijn het datamodel en de attributen van het dataobject beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkb3Value template-->
	<xs:template match="pbl:nkb3Value">
		<xs:element name="pbl:nkb3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3Value template-->
	<xs:template name="add-pbl-nkb3Value">
		<xs:element name="pbl:nkb3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb3Comment template-->
	<xs:template match="pbl:nkb3Comment">
		<xs:element name="pbl:nkb3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3Comment template-->
	<xs:template name="add-pbl-nkb3Comment">
		<xs:element name="pbl:nkb3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3Checks template-->
	<xs:template match="pbl:nkb3Checks">
		<xs:element name="pbl:nkb3Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3c1) and not(self::pbl:nkb3c2) and not(self::pbl:nkb3c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3Checks template-->
	<xs:template name="add-pbl-nkb3Checks">
		<xs:element name="pbl:nkb3Checks">
			<!--call add-pbl-nkb3c1 template-->
			<xs:call-template name="add-pbl-nkb3c1"/>
			<!--call add-pbl-nkb3c2 template-->
			<xs:call-template name="add-pbl-nkb3c2"/>
			<!--call add-pbl-nkb3c3 template-->
			<xs:call-template name="add-pbl-nkb3c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3c1 template-->
	<xs:template match="pbl:nkb3c1">
		<xs:element name="pbl:nkb3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3c1Title) and not(self::pbl:nkb3c1Value) and not(self::pbl:nkb3c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c1 template-->
	<xs:template name="add-pbl-nkb3c1">
		<xs:element name="pbl:nkb3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb3c1Title template-->
			<xs:call-template name="add-pbl-nkb3c1Title"/>
			<!--call add-pbl-nkb3c1Value template-->
			<xs:call-template name="add-pbl-nkb3c1Value"/>
			<!--call add-pbl-nkb3c1Comment template-->
			<xs:call-template name="add-pbl-nkb3c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3c1Title template-->
	<xs:template match="pbl:nkb3c1Title">
		<xs:element name="pbl:nkb3c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c1Title template-->
	<xs:template name="add-pbl-nkb3c1Title">
		<xs:element name="pbl:nkb3c1Title">Is er een verklarende tekst en/of schema beschikbaar?</xs:element>
	</xs:template>
	<!--create pbl:nkb3c1Value template-->
	<xs:template match="pbl:nkb3c1Value">
		<xs:element name="pbl:nkb3c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c1Value template-->
	<xs:template name="add-pbl-nkb3c1Value">
		<xs:element name="pbl:nkb3c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c1Comment template-->
	<xs:template match="pbl:nkb3c1Comment">
		<xs:element name="pbl:nkb3c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c1Comment template-->
	<xs:template name="add-pbl-nkb3c1Comment">
		<xs:element name="pbl:nkb3c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c2 template-->
	<xs:template match="pbl:nkb3c2">
		<xs:element name="pbl:nkb3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3cTitle) and not(self::pbl:nkb3cValue) and not(self::pbl:nkb3cComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3cTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3cTitle"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3cTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3cValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3cValue"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3cValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3cComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3cComment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3cComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c2 template-->
	<xs:template name="add-pbl-nkb3c2">
		<xs:element name="pbl:nkb3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb3cTitle template-->
			<xs:call-template name="add-pbl-nkb3cTitle"/>
			<!--call add-pbl-nkb3cValue template-->
			<xs:call-template name="add-pbl-nkb3cValue"/>
			<!--call add-pbl-nkb3cComment template-->
			<xs:call-template name="add-pbl-nkb3cComment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3cTitle template-->
	<xs:template match="pbl:nkb3cTitle">
		<xs:element name="pbl:nkb3cTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3cTitle template-->
	<xs:template name="add-pbl-nkb3cTitle">
		<xs:element name="pbl:nkb3cTitle">Zijn de relaties tussen de verschillende onderdelen beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkb3cValue template-->
	<xs:template match="pbl:nkb3cValue">
		<xs:element name="pbl:nkb3cValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3cValue template-->
	<xs:template name="add-pbl-nkb3cValue">
		<xs:element name="pbl:nkb3cValue"></xs:element>
	</xs:template>
	<!--create pbl:nkb3cComment template-->
	<xs:template match="pbl:nkb3cComment">
		<xs:element name="pbl:nkb3cComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3cComment template-->
	<xs:template name="add-pbl-nkb3cComment">
		<xs:element name="pbl:nkb3cComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c3 template-->
	<xs:template match="pbl:nkb3c3">
		<xs:element name="pbl:nkb3c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3c3Title) and not(self::pbl:nkb3c3Value) and not(self::pbl:nkb3c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c3 template-->
	<xs:template name="add-pbl-nkb3c3">
		<xs:element name="pbl:nkb3c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb3c3Title template-->
			<xs:call-template name="add-pbl-nkb3c3Title"/>
			<!--call add-pbl-nkb3c3Value template-->
			<xs:call-template name="add-pbl-nkb3c3Value"/>
			<!--call add-pbl-nkb3c3Comment template-->
			<xs:call-template name="add-pbl-nkb3c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3c3Title template-->
	<xs:template match="pbl:nkb3c3Title">
		<xs:element name="pbl:nkb3c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c3Title template-->
	<xs:template name="add-pbl-nkb3c3Title">
		<xs:element name="pbl:nkb3c3Title">Zijn de attributen voldoende beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkb3c3Value template-->
	<xs:template match="pbl:nkb3c3Value">
		<xs:element name="pbl:nkb3c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c3Value template-->
	<xs:template name="add-pbl-nkb3c3Value">
		<xs:element name="pbl:nkb3c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c3Comment template-->
	<xs:template match="pbl:nkb3c3Comment">
		<xs:element name="pbl:nkb3c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c3Comment template-->
	<xs:template name="add-pbl-nkb3c3Comment">
		<xs:element name="pbl:nkb3c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4 template-->
	<xs:template match="pbl:nkb4">
		<xs:element name="pbl:nkb4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4Title) and not(self::pbl:nkb4Value) and not(self::pbl:nkb4Comment) and not(self::pbl:nkb4Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4 template-->
	<xs:template name="add-pbl-nkb4">
		<xs:element name="pbl:nkb4">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkb4Title template-->
			<xs:call-template name="add-pbl-nkb4Title"/>
			<!--call add-pbl-nkb4Value template-->
			<xs:call-template name="add-pbl-nkb4Value"/>
			<!--call add-pbl-nkb4Comment template-->
			<xs:call-template name="add-pbl-nkb4Comment"/>
			<!--call add-pbl-nkb4Checks template-->
			<xs:call-template name="add-pbl-nkb4Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4Title template-->
	<xs:template match="pbl:nkb4Title">
		<xs:element name="pbl:nkb4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4Title template-->
	<xs:template name="add-pbl-nkb4Title">
		<xs:element name="pbl:nkb4Title">Zijn er tests uitgevoerd waarmee de eigen kwaliteit van het dataobject kan worden aangetoond?</xs:element>
	</xs:template>
	<!--create pbl:nkb4Value template-->
	<xs:template match="pbl:nkb4Value">
		<xs:element name="pbl:nkb4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4Value template-->
	<xs:template name="add-pbl-nkb4Value">
		<xs:element name="pbl:nkb4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4Comment template-->
	<xs:template match="pbl:nkb4Comment">
		<xs:element name="pbl:nkb4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4Comment template-->
	<xs:template name="add-pbl-nkb4Comment">
		<xs:element name="pbl:nkb4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4Checks template-->
	<xs:template match="pbl:nkb4Checks">
		<xs:element name="pbl:nkb4Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c1) and not(self::pbl:nkb4c2) and not(self::pbl:nkb4c3) and not(self::pbl:nkb4c4) and not(self::pbl:nkb4c5)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c5"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4Checks template-->
	<xs:template name="add-pbl-nkb4Checks">
		<xs:element name="pbl:nkb4Checks">
			<!--call add-pbl-nkb4c1 template-->
			<xs:call-template name="add-pbl-nkb4c1"/>
			<!--call add-pbl-nkb4c2 template-->
			<xs:call-template name="add-pbl-nkb4c2"/>
			<!--call add-pbl-nkb4c3 template-->
			<xs:call-template name="add-pbl-nkb4c3"/>
			<!--call add-pbl-nkb4c4 template-->
			<xs:call-template name="add-pbl-nkb4c4"/>
			<!--call add-pbl-nkb4c5 template-->
			<xs:call-template name="add-pbl-nkb4c5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c1 template-->
	<xs:template match="pbl:nkb4c1">
		<xs:element name="pbl:nkb4c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c1Title) and not(self::pbl:nkb4c1Value) and not(self::pbl:nkb4c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c1 template-->
	<xs:template name="add-pbl-nkb4c1">
		<xs:element name="pbl:nkb4c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb4c1Title template-->
			<xs:call-template name="add-pbl-nkb4c1Title"/>
			<!--call add-pbl-nkb4c1Value template-->
			<xs:call-template name="add-pbl-nkb4c1Value"/>
			<!--call add-pbl-nkb4c1Comment template-->
			<xs:call-template name="add-pbl-nkb4c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c1Title template-->
	<xs:template match="pbl:nkb4c1Title">
		<xs:element name="pbl:nkb4c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c1Title template-->
	<xs:template name="add-pbl-nkb4c1Title">
		<xs:element name="pbl:nkb4c1Title">Zijn de testresultaten in de metadata vastgelegd?</xs:element>
	</xs:template>
	<!--create pbl:nkb4c1Value template-->
	<xs:template match="pbl:nkb4c1Value">
		<xs:element name="pbl:nkb4c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c1Value template-->
	<xs:template name="add-pbl-nkb4c1Value">
		<xs:element name="pbl:nkb4c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c1Comment template-->
	<xs:template match="pbl:nkb4c1Comment">
		<xs:element name="pbl:nkb4c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c1Comment template-->
	<xs:template name="add-pbl-nkb4c1Comment">
		<xs:element name="pbl:nkb4c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c2 template-->
	<xs:template match="pbl:nkb4c2">
		<xs:element name="pbl:nkb4c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c2Title) and not(self::pbl:nkb4c2Value) and not(self::pbl:nkb4c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c2 template-->
	<xs:template name="add-pbl-nkb4c2">
		<xs:element name="pbl:nkb4c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb4c2Title template-->
			<xs:call-template name="add-pbl-nkb4c2Title"/>
			<!--call add-pbl-nkb4c2Value template-->
			<xs:call-template name="add-pbl-nkb4c2Value"/>
			<!--call add-pbl-nkb4c2Comment template-->
			<xs:call-template name="add-pbl-nkb4c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c2Title template-->
	<xs:template match="pbl:nkb4c2Title">
		<xs:element name="pbl:nkb4c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c2Title template-->
	<xs:template name="add-pbl-nkb4c2Title">
		<xs:element name="pbl:nkb4c2Title">Zijn de tests bij binnenkomst/aanmaak van het dataobject uitgevoerd?</xs:element>
	</xs:template>
	<!--create pbl:nkb4c2Value template-->
	<xs:template match="pbl:nkb4c2Value">
		<xs:element name="pbl:nkb4c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c2Value template-->
	<xs:template name="add-pbl-nkb4c2Value">
		<xs:element name="pbl:nkb4c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c2Comment template-->
	<xs:template match="pbl:nkb4c2Comment">
		<xs:element name="pbl:nkb4c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c2Comment template-->
	<xs:template name="add-pbl-nkb4c2Comment">
		<xs:element name="pbl:nkb4c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c3 template-->
	<xs:template match="pbl:nkb4c3">
		<xs:element name="pbl:nkb4c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c3Title) and not(self::pbl:nkb4c3Value) and not(self::pbl:nkb4c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c3 template-->
	<xs:template name="add-pbl-nkb4c3">
		<xs:element name="pbl:nkb4c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb4c3Title template-->
			<xs:call-template name="add-pbl-nkb4c3Title"/>
			<!--call add-pbl-nkb4c3Value template-->
			<xs:call-template name="add-pbl-nkb4c3Value"/>
			<!--call add-pbl-nkb4c3Comment template-->
			<xs:call-template name="add-pbl-nkb4c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c3Title template-->
	<xs:template match="pbl:nkb4c3Title">
		<xs:element name="pbl:nkb4c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c3Title template-->
	<xs:template name="add-pbl-nkb4c3Title">
		<xs:element name="pbl:nkb4c3Title">Zijn er geautomatiseerde controles uitgevoerd? Bij terugkerende dataobjecten (reeksen etc) kan er naar worden gestreefd om, waar mogelijk, controles op de eigenschappen van de data te automatiseren.</xs:element>
	</xs:template>
	<!--create pbl:nkb4c3Value template-->
	<xs:template match="pbl:nkb4c3Value">
		<xs:element name="pbl:nkb4c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c3Value template-->
	<xs:template name="add-pbl-nkb4c3Value">
		<xs:element name="pbl:nkb4c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c3Comment template-->
	<xs:template match="pbl:nkb4c3Comment">
		<xs:element name="pbl:nkb4c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c3Comment template-->
	<xs:template name="add-pbl-nkb4c3Comment">
		<xs:element name="pbl:nkb4c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c4 template-->
	<xs:template match="pbl:nkb4c4">
		<xs:element name="pbl:nkb4c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c4Title) and not(self::pbl:nkb4c4Value) and not(self::pbl:nkb4c4Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c4Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c4 template-->
	<xs:template name="add-pbl-nkb4c4">
		<xs:element name="pbl:nkb4c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb4c4Title template-->
			<xs:call-template name="add-pbl-nkb4c4Title"/>
			<!--call add-pbl-nkb4c4Value template-->
			<xs:call-template name="add-pbl-nkb4c4Value"/>
			<!--call add-pbl-nkb4c4Comment template-->
			<xs:call-template name="add-pbl-nkb4c4Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c4Title template-->
	<xs:template match="pbl:nkb4c4Title">
		<xs:element name="pbl:nkb4c4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c4Title template-->
	<xs:template name="add-pbl-nkb4c4Title">
		<xs:element name="pbl:nkb4c4Title">Hebben testresultaten aanleiding gegeven om het dataobject te corrigeren? Licht toe op welke manier de correcties in de metadata/versiebeheer zijn opgenomen.</xs:element>
	</xs:template>
	<!--create pbl:nkb4c4Value template-->
	<xs:template match="pbl:nkb4c4Value">
		<xs:element name="pbl:nkb4c4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c4Value template-->
	<xs:template name="add-pbl-nkb4c4Value">
		<xs:element name="pbl:nkb4c4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c4Comment template-->
	<xs:template match="pbl:nkb4c4Comment">
		<xs:element name="pbl:nkb4c4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c4Comment template-->
	<xs:template name="add-pbl-nkb4c4Comment">
		<xs:element name="pbl:nkb4c4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c5 template-->
	<xs:template match="pbl:nkb4c5">
		<xs:element name="pbl:nkb4c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c5Title) and not(self::pbl:nkb4c5Value) and not(self::pbl:nkb4c5Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c5Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c5Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c5Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c5Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c5Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c5Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c5Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c5Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c5Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c5 template-->
	<xs:template name="add-pbl-nkb4c5">
		<xs:element name="pbl:nkb4c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkb4c5Title template-->
			<xs:call-template name="add-pbl-nkb4c5Title"/>
			<!--call add-pbl-nkb4c5Value template-->
			<xs:call-template name="add-pbl-nkb4c5Value"/>
			<!--call add-pbl-nkb4c5Comment template-->
			<xs:call-template name="add-pbl-nkb4c5Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c5Title template-->
	<xs:template match="pbl:nkb4c5Title">
		<xs:element name="pbl:nkb4c5Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c5Title template-->
	<xs:template name="add-pbl-nkb4c5Title">
		<xs:element name="pbl:nkb4c5Title">Geven test resultaten aanleiding om het dataobject onder voorbehoud of in het geheel niet te gebruiken?</xs:element>
	</xs:template>
	<!--create pbl:nkb4c5Value template-->
	<xs:template match="pbl:nkb4c5Value">
		<xs:element name="pbl:nkb4c5Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c5Value template-->
	<xs:template name="add-pbl-nkb4c5Value">
		<xs:element name="pbl:nkb4c5Value"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c5Comment template-->
	<xs:template match="pbl:nkb4c5Comment">
		<xs:element name="pbl:nkb4c5Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c5Comment template-->
	<xs:template name="add-pbl-nkb4c5Comment">
		<xs:element name="pbl:nkb4c5Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkGebruikItems template-->
	<xs:template match="pbl:nkGebruikItems">
		<xs:element name="pbl:nkGebruikItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1) and not(self::pbl:nkc2) and not(self::pbl:nkc3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkGebruikItems template-->
	<xs:template name="add-pbl-nkGebruikItems">
		<xs:element name="pbl:nkGebruikItems">
			<!--call add-pbl-nkc1 template-->
			<xs:call-template name="add-pbl-nkc1"/>
			<!--call add-pbl-nkc2 template-->
			<xs:call-template name="add-pbl-nkc2"/>
			<!--call add-pbl-nkc3 template-->
			<xs:call-template name="add-pbl-nkc3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1 template-->
	<xs:template match="pbl:nkc1">
		<xs:element name="pbl:nkc1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1Title) and not(self::pbl:nkc1Value) and not(self::pbl:nkc1Comment) and not(self::pbl:nkc1Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc1Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1 template-->
	<xs:template name="add-pbl-nkc1">
		<xs:element name="pbl:nkc1">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkc1Title template-->
			<xs:call-template name="add-pbl-nkc1Title"/>
			<!--call add-pbl-nkc1Value template-->
			<xs:call-template name="add-pbl-nkc1Value"/>
			<!--call add-pbl-nkc1Comment template-->
			<xs:call-template name="add-pbl-nkc1Comment"/>
			<!--call add-pbl-nkc1Checks template-->
			<xs:call-template name="add-pbl-nkc1Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1Title template-->
	<xs:template match="pbl:nkc1Title">
		<xs:element name="pbl:nkc1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1Title template-->
	<xs:template name="add-pbl-nkc1Title">
		<xs:element name="pbl:nkc1Title">Is structureel gebruik van het dataobject voorzien?</xs:element>
	</xs:template>
	<!--create pbl:nkc1Value template-->
	<xs:template match="pbl:nkc1Value">
		<xs:element name="pbl:nkc1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1Value template-->
	<xs:template name="add-pbl-nkc1Value">
		<xs:element name="pbl:nkc1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc1Comment template-->
	<xs:template match="pbl:nkc1Comment">
		<xs:element name="pbl:nkc1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1Comment template-->
	<xs:template name="add-pbl-nkc1Comment">
		<xs:element name="pbl:nkc1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc1Checks template-->
	<xs:template match="pbl:nkc1Checks">
		<xs:element name="pbl:nkc1Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1c1)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1c1"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1Checks template-->
	<xs:template name="add-pbl-nkc1Checks">
		<xs:element name="pbl:nkc1Checks">
			<!--call add-pbl-nkc1c1 template-->
			<xs:call-template name="add-pbl-nkc1c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1c1 template-->
	<xs:template match="pbl:nkc1c1">
		<xs:element name="pbl:nkc1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1c1Title) and not(self::pbl:nkc1c1Value) and not(self::pbl:nkc1c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc1c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc1c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1c1 template-->
	<xs:template name="add-pbl-nkc1c1">
		<xs:element name="pbl:nkc1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc1c1Title template-->
			<xs:call-template name="add-pbl-nkc1c1Title"/>
			<!--call add-pbl-nkc1c1Value template-->
			<xs:call-template name="add-pbl-nkc1c1Value"/>
			<!--call add-pbl-nkc1c1Comment template-->
			<xs:call-template name="add-pbl-nkc1c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1c1Title template-->
	<xs:template match="pbl:nkc1c1Title">
		<xs:element name="pbl:nkc1c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1c1Title template-->
	<xs:template name="add-pbl-nkc1c1Title">
		<xs:element name="pbl:nkc1c1Title">Is het aanemelijk dat het dataobject ook gebruikt kan worden voor andere toepassingen dan de huidige toepassing?</xs:element>
	</xs:template>
	<!--create pbl:nkc1c1Value template-->
	<xs:template match="pbl:nkc1c1Value">
		<xs:element name="pbl:nkc1c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1c1Value template-->
	<xs:template name="add-pbl-nkc1c1Value">
		<xs:element name="pbl:nkc1c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc1c1Comment template-->
	<xs:template match="pbl:nkc1c1Comment">
		<xs:element name="pbl:nkc1c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1c1Comment template-->
	<xs:template name="add-pbl-nkc1c1Comment">
		<xs:element name="pbl:nkc1c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2 template-->
	<xs:template match="pbl:nkc2">
		<xs:element name="pbl:nkc2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2Title) and not(self::pbl:nkc2Value) and not(self::pbl:nkc2Comment) and not(self::pbl:nkc2Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2 template-->
	<xs:template name="add-pbl-nkc2">
		<xs:element name="pbl:nkc2">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkc2Title template-->
			<xs:call-template name="add-pbl-nkc2Title"/>
			<!--call add-pbl-nkc2Value template-->
			<xs:call-template name="add-pbl-nkc2Value"/>
			<!--call add-pbl-nkc2Comment template-->
			<xs:call-template name="add-pbl-nkc2Comment"/>
			<!--call add-pbl-nkc2Checks template-->
			<xs:call-template name="add-pbl-nkc2Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2Title template-->
	<xs:template match="pbl:nkc2Title">
		<xs:element name="pbl:nkc2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2Title template-->
	<xs:template name="add-pbl-nkc2Title">
		<xs:element name="pbl:nkc2Title">Is de motivatie achter het gebruik van het gekozen dataobject beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkc2Value template-->
	<xs:template match="pbl:nkc2Value">
		<xs:element name="pbl:nkc2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2Value template-->
	<xs:template name="add-pbl-nkc2Value">
		<xs:element name="pbl:nkc2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2Comment template-->
	<xs:template match="pbl:nkc2Comment">
		<xs:element name="pbl:nkc2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2Comment template-->
	<xs:template name="add-pbl-nkc2Comment">
		<xs:element name="pbl:nkc2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2Checks template-->
	<xs:template match="pbl:nkc2Checks">
		<xs:element name="pbl:nkc2Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c1) and not(self::pbl:nkc2c2) and not(self::pbl:nkc2c3) and not(self::pbl:nkc2c4) and not(self::pbl:nkc2c5)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c5"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2Checks template-->
	<xs:template name="add-pbl-nkc2Checks">
		<xs:element name="pbl:nkc2Checks">
			<!--call add-pbl-nkc2c1 template-->
			<xs:call-template name="add-pbl-nkc2c1"/>
			<!--call add-pbl-nkc2c2 template-->
			<xs:call-template name="add-pbl-nkc2c2"/>
			<!--call add-pbl-nkc2c3 template-->
			<xs:call-template name="add-pbl-nkc2c3"/>
			<!--call add-pbl-nkc2c4 template-->
			<xs:call-template name="add-pbl-nkc2c4"/>
			<!--call add-pbl-nkc2c5 template-->
			<xs:call-template name="add-pbl-nkc2c5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c1 template-->
	<xs:template match="pbl:nkc2c1">
		<xs:element name="pbl:nkc2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c1Title) and not(self::pbl:nkc2c1Value) and not(self::pbl:nkc2c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c1 template-->
	<xs:template name="add-pbl-nkc2c1">
		<xs:element name="pbl:nkc2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc2c1Title template-->
			<xs:call-template name="add-pbl-nkc2c1Title"/>
			<!--call add-pbl-nkc2c1Value template-->
			<xs:call-template name="add-pbl-nkc2c1Value"/>
			<!--call add-pbl-nkc2c1Comment template-->
			<xs:call-template name="add-pbl-nkc2c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c1Title template-->
	<xs:template match="pbl:nkc2c1Title">
		<xs:element name="pbl:nkc2c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c1Title template-->
	<xs:template name="add-pbl-nkc2c1Title">
		<xs:element name="pbl:nkc2c1Title">Als financiële redenen de keuze bepaalde, is het dan duidelijk waarom het dataobject voldoet aan de eisen? En wat eventuele tekortkomingen zijn? Zijn betere, maar niet toegankelijke (bijvoorbeeld te dure) alternatieven bekend?</xs:element>
	</xs:template>
	<!--create pbl:nkc2c1Value template-->
	<xs:template match="pbl:nkc2c1Value">
		<xs:element name="pbl:nkc2c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c1Value template-->
	<xs:template name="add-pbl-nkc2c1Value">
		<xs:element name="pbl:nkc2c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c1Comment template-->
	<xs:template match="pbl:nkc2c1Comment">
		<xs:element name="pbl:nkc2c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c1Comment template-->
	<xs:template name="add-pbl-nkc2c1Comment">
		<xs:element name="pbl:nkc2c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c2 template-->
	<xs:template match="pbl:nkc2c2">
		<xs:element name="pbl:nkc2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c2Title) and not(self::pbl:nkc2c2Value) and not(self::pbl:nkc2c2Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c2Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c2Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c2Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c2Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c2Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c2Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c2Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c2 template-->
	<xs:template name="add-pbl-nkc2c2">
		<xs:element name="pbl:nkc2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc2c2Title template-->
			<xs:call-template name="add-pbl-nkc2c2Title"/>
			<!--call add-pbl-nkc2c2Value template-->
			<xs:call-template name="add-pbl-nkc2c2Value"/>
			<!--call add-pbl-nkc2c2Comment template-->
			<xs:call-template name="add-pbl-nkc2c2Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c2Title template-->
	<xs:template match="pbl:nkc2c2Title">
		<xs:element name="pbl:nkc2c2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c2Title template-->
	<xs:template name="add-pbl-nkc2c2Title">
		<xs:element name="pbl:nkc2c2Title">Als het gekozen dataobject goed/het beste (inhoudelijk en/of technisch) aansluit bij de doelen van het onderzoek, is dan duidelijk waarom het beter voldoet dan alternatieven?</xs:element>
	</xs:template>
	<!--create pbl:nkc2c2Value template-->
	<xs:template match="pbl:nkc2c2Value">
		<xs:element name="pbl:nkc2c2Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c2Value template-->
	<xs:template name="add-pbl-nkc2c2Value">
		<xs:element name="pbl:nkc2c2Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c2Comment template-->
	<xs:template match="pbl:nkc2c2Comment">
		<xs:element name="pbl:nkc2c2Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c2Comment template-->
	<xs:template name="add-pbl-nkc2c2Comment">
		<xs:element name="pbl:nkc2c2Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c3 template-->
	<xs:template match="pbl:nkc2c3">
		<xs:element name="pbl:nkc2c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c3Title) and not(self::pbl:nkc2c3Value) and not(self::pbl:nkc2c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c3 template-->
	<xs:template name="add-pbl-nkc2c3">
		<xs:element name="pbl:nkc2c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc2c3Title template-->
			<xs:call-template name="add-pbl-nkc2c3Title"/>
			<!--call add-pbl-nkc2c3Value template-->
			<xs:call-template name="add-pbl-nkc2c3Value"/>
			<!--call add-pbl-nkc2c3Comment template-->
			<xs:call-template name="add-pbl-nkc2c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c3Title template-->
	<xs:template match="pbl:nkc2c3Title">
		<xs:element name="pbl:nkc2c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c3Title template-->
	<xs:template name="add-pbl-nkc2c3Title">
		<xs:element name="pbl:nkc2c3Title">Is er bij de keuze van het dataobject gekeken naar continuïteit in onderzoek? Bijvoorbeeld naar dataobjecten gebruikt in eerdere of parallele onderzoeken (binnen PBL, maar ook binnen de overheid/wetenschap)?</xs:element>
	</xs:template>
	<!--create pbl:nkc2c3Value template-->
	<xs:template match="pbl:nkc2c3Value">
		<xs:element name="pbl:nkc2c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c3Value template-->
	<xs:template name="add-pbl-nkc2c3Value">
		<xs:element name="pbl:nkc2c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c3Comment template-->
	<xs:template match="pbl:nkc2c3Comment">
		<xs:element name="pbl:nkc2c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c3Comment template-->
	<xs:template name="add-pbl-nkc2c3Comment">
		<xs:element name="pbl:nkc2c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c4 template-->
	<xs:template match="pbl:nkc2c4">
		<xs:element name="pbl:nkc2c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c4Title) and not(self::pbl:nkc2c4Value) and not(self::pbl:nkc2c4Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c4Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c4 template-->
	<xs:template name="add-pbl-nkc2c4">
		<xs:element name="pbl:nkc2c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc2c4Title template-->
			<xs:call-template name="add-pbl-nkc2c4Title"/>
			<!--call add-pbl-nkc2c4Value template-->
			<xs:call-template name="add-pbl-nkc2c4Value"/>
			<!--call add-pbl-nkc2c4Comment template-->
			<xs:call-template name="add-pbl-nkc2c4Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c4Title template-->
	<xs:template match="pbl:nkc2c4Title">
		<xs:element name="pbl:nkc2c4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c4Title template-->
	<xs:template name="add-pbl-nkc2c4Title">
		<xs:element name="pbl:nkc2c4Title">Is duidelijk omschreven wat de (eventuele) tekortkomingen van het dataobject voor het gebruiksdoel zijn?</xs:element>
	</xs:template>
	<!--create pbl:nkc2c4Value template-->
	<xs:template match="pbl:nkc2c4Value">
		<xs:element name="pbl:nkc2c4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c4Value template-->
	<xs:template name="add-pbl-nkc2c4Value">
		<xs:element name="pbl:nkc2c4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c4Comment template-->
	<xs:template match="pbl:nkc2c4Comment">
		<xs:element name="pbl:nkc2c4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c4Comment template-->
	<xs:template name="add-pbl-nkc2c4Comment">
		<xs:element name="pbl:nkc2c4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c5 template-->
	<xs:template match="pbl:nkc2c5">
		<xs:element name="pbl:nkc2c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c5Title) and not(self::pbl:nkc2c5Value) and not(self::pbl:nkc2c5Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c5Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c5Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c5Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c5Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c5Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c5Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c5Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c5Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c5Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c5 template-->
	<xs:template name="add-pbl-nkc2c5">
		<xs:element name="pbl:nkc2c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc2c5Title template-->
			<xs:call-template name="add-pbl-nkc2c5Title"/>
			<!--call add-pbl-nkc2c5Value template-->
			<xs:call-template name="add-pbl-nkc2c5Value"/>
			<!--call add-pbl-nkc2c5Comment template-->
			<xs:call-template name="add-pbl-nkc2c5Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c5Title template-->
	<xs:template match="pbl:nkc2c5Title">
		<xs:element name="pbl:nkc2c5Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c5Title template-->
	<xs:template name="add-pbl-nkc2c5Title">
		<xs:element name="pbl:nkc2c5Title">Is de keuze voor een dataobject gemotiveerd met een evalautie van beschikbare opties?</xs:element>
	</xs:template>
	<!--create pbl:nkc2c5Value template-->
	<xs:template match="pbl:nkc2c5Value">
		<xs:element name="pbl:nkc2c5Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c5Value template-->
	<xs:template name="add-pbl-nkc2c5Value">
		<xs:element name="pbl:nkc2c5Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c5Comment template-->
	<xs:template match="pbl:nkc2c5Comment">
		<xs:element name="pbl:nkc2c5Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c5Comment template-->
	<xs:template name="add-pbl-nkc2c5Comment">
		<xs:element name="pbl:nkc2c5Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3 template-->
	<xs:template match="pbl:nkc3">
		<xs:element name="pbl:nkc3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3Title) and not(self::pbl:nkc3Value) and not(self::pbl:nkc3Comment) and not(self::pbl:nkc3Checks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3Comment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3Checks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3Checks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3Checks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3 template-->
	<xs:template name="add-pbl-nkc3">
		<xs:element name="pbl:nkc3">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkc3Title template-->
			<xs:call-template name="add-pbl-nkc3Title"/>
			<!--call add-pbl-nkc3Value template-->
			<xs:call-template name="add-pbl-nkc3Value"/>
			<!--call add-pbl-nkc3Comment template-->
			<xs:call-template name="add-pbl-nkc3Comment"/>
			<!--call add-pbl-nkc3Checks template-->
			<xs:call-template name="add-pbl-nkc3Checks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3Title template-->
	<xs:template match="pbl:nkc3Title">
		<xs:element name="pbl:nkc3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3Title template-->
	<xs:template name="add-pbl-nkc3Title">
		<xs:element name="pbl:nkc3Title">Is nagegaan of er gebruiksbeperkingen zijn?</xs:element>
	</xs:template>
	<!--create pbl:nkc3Value template-->
	<xs:template match="pbl:nkc3Value">
		<xs:element name="pbl:nkc3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3Value template-->
	<xs:template name="add-pbl-nkc3Value">
		<xs:element name="pbl:nkc3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3Comment template-->
	<xs:template match="pbl:nkc3Comment">
		<xs:element name="pbl:nkc3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3Comment template-->
	<xs:template name="add-pbl-nkc3Comment">
		<xs:element name="pbl:nkc3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3Checks template-->
	<xs:template match="pbl:nkc3Checks">
		<xs:element name="pbl:nkc3Checks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c1) and not(self::pbl:nkc3c2) and not(self::pbl:nkc3c3) and not(self::pbl:nkc3c4) and not(self::pbl:nkc3c5) and not(self::pbl:nkc3c6) and not(self::pbl:nkc3c7) and not(self::pbl:nkc3c8)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c5"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c6)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c6"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c7)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c7"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c8)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c8"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c8"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3Checks template-->
	<xs:template name="add-pbl-nkc3Checks">
		<xs:element name="pbl:nkc3Checks">
			<!--call add-pbl-nkc3c1 template-->
			<xs:call-template name="add-pbl-nkc3c1"/>
			<!--call add-pbl-nkc3c2 template-->
			<xs:call-template name="add-pbl-nkc3c2"/>
			<!--call add-pbl-nkc3c3 template-->
			<xs:call-template name="add-pbl-nkc3c3"/>
			<!--call add-pbl-nkc3c4 template-->
			<xs:call-template name="add-pbl-nkc3c4"/>
			<!--call add-pbl-nkc3c5 template-->
			<xs:call-template name="add-pbl-nkc3c5"/>
			<!--call add-pbl-nkc3c6 template-->
			<xs:call-template name="add-pbl-nkc3c6"/>
			<!--call add-pbl-nkc3c7 template-->
			<xs:call-template name="add-pbl-nkc3c7"/>
			<!--call add-pbl-nkc3c8 template-->
			<xs:call-template name="add-pbl-nkc3c8"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c1 template-->
	<xs:template match="pbl:nkc3c1">
		<xs:element name="pbl:nkc3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c1Title) and not(self::pbl:nkc3c1Value) and not(self::pbl:nkc3c1Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c1Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c1Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c1Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c1Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c1Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c1Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c1Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c1 template-->
	<xs:template name="add-pbl-nkc3c1">
		<xs:element name="pbl:nkc3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c1Title template-->
			<xs:call-template name="add-pbl-nkc3c1Title"/>
			<!--call add-pbl-nkc3c1Value template-->
			<xs:call-template name="add-pbl-nkc3c1Value"/>
			<!--call add-pbl-nkc3c1Comment template-->
			<xs:call-template name="add-pbl-nkc3c1Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c1Title template-->
	<xs:template match="pbl:nkc3c1Title">
		<xs:element name="pbl:nkc3c1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c1Title template-->
	<xs:template name="add-pbl-nkc3c1Title">
		<xs:element name="pbl:nkc3c1Title">Wordt in de onderzoeksopzet rekening gehouden met de gebruiksbeperkingen van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c1Value template-->
	<xs:template match="pbl:nkc3c1Value">
		<xs:element name="pbl:nkc3c1Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c1Value template-->
	<xs:template name="add-pbl-nkc3c1Value">
		<xs:element name="pbl:nkc3c1Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c1Comment template-->
	<xs:template match="pbl:nkc3c1Comment">
		<xs:element name="pbl:nkc3c1Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c1Comment template-->
	<xs:template name="add-pbl-nkc3c1Comment">
		<xs:element name="pbl:nkc3c1Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c2 template-->
	<xs:template match="pbl:nkc3c2">
		<xs:element name="pbl:nkc3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3cTitle) and not(self::pbl:nkc3cValue) and not(self::pbl:nkc3cComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3cTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3cTitle"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3cTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3cValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3cValue"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3cValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3cComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3cComment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3cComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c2 template-->
	<xs:template name="add-pbl-nkc3c2">
		<xs:element name="pbl:nkc3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3cTitle template-->
			<xs:call-template name="add-pbl-nkc3cTitle"/>
			<!--call add-pbl-nkc3cValue template-->
			<xs:call-template name="add-pbl-nkc3cValue"/>
			<!--call add-pbl-nkc3cComment template-->
			<xs:call-template name="add-pbl-nkc3cComment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3cTitle template-->
	<xs:template match="pbl:nkc3cTitle">
		<xs:element name="pbl:nkc3cTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3cTitle template-->
	<xs:template name="add-pbl-nkc3cTitle">
		<xs:element name="pbl:nkc3cTitle">Is duidelijk of het dataobject voor een specifiek project of ook voor algemeen gebruik beschikbaar is?</xs:element>
	</xs:template>
	<!--create pbl:nkc3cValue template-->
	<xs:template match="pbl:nkc3cValue">
		<xs:element name="pbl:nkc3cValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3cValue template-->
	<xs:template name="add-pbl-nkc3cValue">
		<xs:element name="pbl:nkc3cValue"></xs:element>
	</xs:template>
	<!--create pbl:nkc3cComment template-->
	<xs:template match="pbl:nkc3cComment">
		<xs:element name="pbl:nkc3cComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3cComment template-->
	<xs:template name="add-pbl-nkc3cComment">
		<xs:element name="pbl:nkc3cComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c3 template-->
	<xs:template match="pbl:nkc3c3">
		<xs:element name="pbl:nkc3c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c3Title) and not(self::pbl:nkc3c3Value) and not(self::pbl:nkc3c3Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c3Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c3Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c3Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c3Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c3Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c3Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c3Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c3Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c3Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c3 template-->
	<xs:template name="add-pbl-nkc3c3">
		<xs:element name="pbl:nkc3c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c3Title template-->
			<xs:call-template name="add-pbl-nkc3c3Title"/>
			<!--call add-pbl-nkc3c3Value template-->
			<xs:call-template name="add-pbl-nkc3c3Value"/>
			<!--call add-pbl-nkc3c3Comment template-->
			<xs:call-template name="add-pbl-nkc3c3Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c3Title template-->
	<xs:template match="pbl:nkc3c3Title">
		<xs:element name="pbl:nkc3c3Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c3Title template-->
	<xs:template name="add-pbl-nkc3c3Title">
		<xs:element name="pbl:nkc3c3Title">Is gezien de inwinningsmethode duidelijk of het dataobject alleen voor bepaalde toepassingen geschikt is (bijv. alleen op een bepaald schaalniveau)?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c3Value template-->
	<xs:template match="pbl:nkc3c3Value">
		<xs:element name="pbl:nkc3c3Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c3Value template-->
	<xs:template name="add-pbl-nkc3c3Value">
		<xs:element name="pbl:nkc3c3Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c3Comment template-->
	<xs:template match="pbl:nkc3c3Comment">
		<xs:element name="pbl:nkc3c3Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c3Comment template-->
	<xs:template name="add-pbl-nkc3c3Comment">
		<xs:element name="pbl:nkc3c3Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c4 template-->
	<xs:template match="pbl:nkc3c4">
		<xs:element name="pbl:nkc3c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c4Title) and not(self::pbl:nkc3c4Value) and not(self::pbl:nkc3c4Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c4Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c4Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c4Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c4Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c4Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c4Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c4Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c4Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c4Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c4 template-->
	<xs:template name="add-pbl-nkc3c4">
		<xs:element name="pbl:nkc3c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c4Title template-->
			<xs:call-template name="add-pbl-nkc3c4Title"/>
			<!--call add-pbl-nkc3c4Value template-->
			<xs:call-template name="add-pbl-nkc3c4Value"/>
			<!--call add-pbl-nkc3c4Comment template-->
			<xs:call-template name="add-pbl-nkc3c4Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c4Title template-->
	<xs:template match="pbl:nkc3c4Title">
		<xs:element name="pbl:nkc3c4Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c4Title template-->
	<xs:template name="add-pbl-nkc3c4Title">
		<xs:element name="pbl:nkc3c4Title">Is duidelijk met welk doel het dataobject door de dataleverancier is verzameld en wat de eventuele discrepantie is met het toepassingdoel in het PBL-onderzoek (mag/kan het dataobject wel voor dit doel worden ingezet)?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c4Value template-->
	<xs:template match="pbl:nkc3c4Value">
		<xs:element name="pbl:nkc3c4Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c4Value template-->
	<xs:template name="add-pbl-nkc3c4Value">
		<xs:element name="pbl:nkc3c4Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c4Comment template-->
	<xs:template match="pbl:nkc3c4Comment">
		<xs:element name="pbl:nkc3c4Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c4Comment template-->
	<xs:template name="add-pbl-nkc3c4Comment">
		<xs:element name="pbl:nkc3c4Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c5 template-->
	<xs:template match="pbl:nkc3c5">
		<xs:element name="pbl:nkc3c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c5Title) and not(self::pbl:nkc3c5Value) and not(self::pbl:nkc3c5Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c5Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c5Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c5Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c5Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c5Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c5Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c5Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c5Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c5Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c5 template-->
	<xs:template name="add-pbl-nkc3c5">
		<xs:element name="pbl:nkc3c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c5Title template-->
			<xs:call-template name="add-pbl-nkc3c5Title"/>
			<!--call add-pbl-nkc3c5Value template-->
			<xs:call-template name="add-pbl-nkc3c5Value"/>
			<!--call add-pbl-nkc3c5Comment template-->
			<xs:call-template name="add-pbl-nkc3c5Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c5Title template-->
	<xs:template match="pbl:nkc3c5Title">
		<xs:element name="pbl:nkc3c5Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c5Title template-->
	<xs:template name="add-pbl-nkc3c5Title">
		<xs:element name="pbl:nkc3c5Title">Is bekend op welk (aggregatie)niveau onderzoeksresultaten gepubliceerd en (digitaal) verspreid mogen worden?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c5Value template-->
	<xs:template match="pbl:nkc3c5Value">
		<xs:element name="pbl:nkc3c5Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c5Value template-->
	<xs:template name="add-pbl-nkc3c5Value">
		<xs:element name="pbl:nkc3c5Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c5Comment template-->
	<xs:template match="pbl:nkc3c5Comment">
		<xs:element name="pbl:nkc3c5Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c5Comment template-->
	<xs:template name="add-pbl-nkc3c5Comment">
		<xs:element name="pbl:nkc3c5Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c6 template-->
	<xs:template match="pbl:nkc3c6">
		<xs:element name="pbl:nkc3c6">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c6Title) and not(self::pbl:nkc3c6Value) and not(self::pbl:nkc3c6Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c6Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c6Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c6Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c6Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c6Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c6Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c6Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c6Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c6Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c6 template-->
	<xs:template name="add-pbl-nkc3c6">
		<xs:element name="pbl:nkc3c6">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c6Title template-->
			<xs:call-template name="add-pbl-nkc3c6Title"/>
			<!--call add-pbl-nkc3c6Value template-->
			<xs:call-template name="add-pbl-nkc3c6Value"/>
			<!--call add-pbl-nkc3c6Comment template-->
			<xs:call-template name="add-pbl-nkc3c6Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c6Title template-->
	<xs:template match="pbl:nkc3c6Title">
		<xs:element name="pbl:nkc3c6Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c6Title template-->
	<xs:template name="add-pbl-nkc3c6Title">
		<xs:element name="pbl:nkc3c6Title">Is duidelijk wanneer er sprake is van afgeleide bestanden, en of deze afgeleide bestanden breder beschikbaar gesteld kunnen worden?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c6Value template-->
	<xs:template match="pbl:nkc3c6Value">
		<xs:element name="pbl:nkc3c6Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c6Value template-->
	<xs:template name="add-pbl-nkc3c6Value">
		<xs:element name="pbl:nkc3c6Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c6Comment template-->
	<xs:template match="pbl:nkc3c6Comment">
		<xs:element name="pbl:nkc3c6Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c6Comment template-->
	<xs:template name="add-pbl-nkc3c6Comment">
		<xs:element name="pbl:nkc3c6Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c7 template-->
	<xs:template match="pbl:nkc3c7">
		<xs:element name="pbl:nkc3c7">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c7Title) and not(self::pbl:nkc3c7Value) and not(self::pbl:nkc3c7Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c7Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c7Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c7Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c7Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c7Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c7Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c7Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c7Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c7Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c7 template-->
	<xs:template name="add-pbl-nkc3c7">
		<xs:element name="pbl:nkc3c7">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c7Title template-->
			<xs:call-template name="add-pbl-nkc3c7Title"/>
			<!--call add-pbl-nkc3c7Value template-->
			<xs:call-template name="add-pbl-nkc3c7Value"/>
			<!--call add-pbl-nkc3c7Comment template-->
			<xs:call-template name="add-pbl-nkc3c7Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c7Title template-->
	<xs:template match="pbl:nkc3c7Title">
		<xs:element name="pbl:nkc3c7Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c7Title template-->
	<xs:template name="add-pbl-nkc3c7Title">
		<xs:element name="pbl:nkc3c7Title">Is duidelijk of er beperkingen gesteld worden aan het (tijdelijk) beschikbaar stellen van de dataset aan derden/opdrachtnemers? Is de duur van het gebruiksrecht duidelijk (oneiding of een bepaalde duur), is er nagedacht over een exit strategie bij doorlopende contracten?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c7Value template-->
	<xs:template match="pbl:nkc3c7Value">
		<xs:element name="pbl:nkc3c7Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c7Value template-->
	<xs:template name="add-pbl-nkc3c7Value">
		<xs:element name="pbl:nkc3c7Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c7Comment template-->
	<xs:template match="pbl:nkc3c7Comment">
		<xs:element name="pbl:nkc3c7Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c7Comment template-->
	<xs:template name="add-pbl-nkc3c7Comment">
		<xs:element name="pbl:nkc3c7Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c8 template-->
	<xs:template match="pbl:nkc3c8">
		<xs:element name="pbl:nkc3c8">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c8Title) and not(self::pbl:nkc3c8Value) and not(self::pbl:nkc3c8Comment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c8Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c8Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c8Title"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c8Value)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c8Value"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c8Value"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c8Comment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c8Comment"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c8Comment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c8 template-->
	<xs:template name="add-pbl-nkc3c8">
		<xs:element name="pbl:nkc3c8">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkc3c8Title template-->
			<xs:call-template name="add-pbl-nkc3c8Title"/>
			<!--call add-pbl-nkc3c8Value template-->
			<xs:call-template name="add-pbl-nkc3c8Value"/>
			<!--call add-pbl-nkc3c8Comment template-->
			<xs:call-template name="add-pbl-nkc3c8Comment"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c8Title template-->
	<xs:template match="pbl:nkc3c8Title">
		<xs:element name="pbl:nkc3c8Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c8Title template-->
	<xs:template name="add-pbl-nkc3c8Title">
		<xs:element name="pbl:nkc3c8Title">Worden bij het gebruik van de dataset de rechten en plichten rond de dataset bewaakt/gerespecteerd (bijv. geheimhouding; privacy, verspreiding kopieën, delen met derden/samenwerkingspartijen, etc.)? Worden eventuele geheimhoudingsverklaringen goed beheerd?</xs:element>
	</xs:template>
	<!--create pbl:nkc3c8Value template-->
	<xs:template match="pbl:nkc3c8Value">
		<xs:element name="pbl:nkc3c8Value">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c8Value template-->
	<xs:template name="add-pbl-nkc3c8Value">
		<xs:element name="pbl:nkc3c8Value"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c8Comment template-->
	<xs:template match="pbl:nkc3c8Comment">
		<xs:element name="pbl:nkc3c8Comment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c8Comment template-->
	<xs:template name="add-pbl-nkc3c8Comment">
		<xs:element name="pbl:nkc3c8Comment"></xs:element>
	</xs:template>
	<!--create pbl:nkInvulhulpItems template-->
	<xs:template match="pbl:nkInvulhulpItems">
		<xs:element name="pbl:nkInvulhulpItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkinv1) and not(self::pbl:nkinv2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkinv1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkinv2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkInvulhulpItems template-->
	<xs:template name="add-pbl-nkInvulhulpItems">
		<xs:element name="pbl:nkInvulhulpItems">
			<!--call add-pbl-nkinv1 template-->
			<xs:call-template name="add-pbl-nkinv1"/>
			<!--call add-pbl-nkinv2 template-->
			<xs:call-template name="add-pbl-nkinv2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkinv1 template-->
	<xs:template match="pbl:nkinv1">
		<xs:element name="pbl:nkinv1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkinv1Title)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkinv1Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv1Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv1Title"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv1 template-->
	<xs:template name="add-pbl-nkinv1">
		<xs:element name="pbl:nkinv1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkinv1Title template-->
			<xs:call-template name="add-pbl-nkinv1Title"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkinv1Title template-->
	<xs:template match="pbl:nkinv1Title">
		<xs:element name="pbl:nkinv1Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv1Title template-->
	<xs:template name="add-pbl-nkinv1Title">
		<xs:element name="pbl:nkinv1Title">De checklist bij het normenkader bestaat uit 11 vragen, onderverdeeld in drie delen. De vragen moeten met ja of nee beantwoord worden; slechts in een enkel geval kan een vraag met ‘niet van toepassing’ beantwoord worden. Onder elke vraag is ruimte voor de verplichte toelichting (bewijsvoering). Indien aanwezig, refereer naar documentatie. Om het beantwoorden van de vragen te vereenvoudigen hebben we aandachtspunten toegevoegd. De aandachtspunten zijn optioneel, zet een kruis als voldaan wordt aan het betreffende aandachtspunt. Ook onder elk aandachtspunt is ruimte voor een optionele toelichting. Indien aanwezig, refereer naar documentatie. Om een vraag met ‘ja’ te kunnen beantwoorden hoeft niet aan de aandachtspunten te worden voldaan, maar een toelichting is verplicht.</xs:element>
	</xs:template>
	<!--create pbl:nkinv2 template-->
	<xs:template match="pbl:nkinv2">
		<xs:element name="pbl:nkinv2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkinv2Title)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkinv2Title)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv2Title"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv2Title"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv2 template-->
	<xs:template name="add-pbl-nkinv2">
		<xs:element name="pbl:nkinv2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkinv2Title template-->
			<xs:call-template name="add-pbl-nkinv2Title"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkinv2Title template-->
	<xs:template match="pbl:nkinv2Title">
		<xs:element name="pbl:nkinv2Title">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv2Title template-->
	<xs:template name="add-pbl-nkinv2Title">
		<xs:element name="pbl:nkinv2Title">Om aan het normenkader te voldoen hoeft niet elke vraag met ‘ja’ of ‘nvt’ te worden beantwoord. Een vraag kan ook gemotiveerd met ‘nee’ beantwoord worden, terwijl er toch aan het normenkader wordt voldaan.</xs:element>
	</xs:template>
	<!--create pbl:nkReferentiesItems template-->
	<xs:template match="pbl:nkReferentiesItems">
		<xs:element name="pbl:nkReferentiesItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkh)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkh)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkh"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkh"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkReferentiesItems template-->
	<xs:template name="add-pbl-nkReferentiesItems">
		<xs:element name="pbl:nkReferentiesItems">
			<!--call add-pbl-nkh template-->
			<xs:call-template name="add-pbl-nkh"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkh template-->
	<xs:template match="pbl:nkh">
		<xs:element name="pbl:nkh">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkhTitle) and not(self::pbl:nkhValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkhTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkhTitle"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkhTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkhValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkhValue"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkhValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkh template-->
	<xs:template name="add-pbl-nkh">
		<xs:element name="pbl:nkh">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkhTitle template-->
			<xs:call-template name="add-pbl-nkhTitle"/>
			<!--call add-pbl-nkhValue template-->
			<xs:call-template name="add-pbl-nkhValue"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkhTitle template-->
	<xs:template match="pbl:nkhTitle">
		<xs:element name="pbl:nkhTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkhTitle template-->
	<xs:template name="add-pbl-nkhTitle">
		<xs:element name="pbl:nkhTitle">Referentie</xs:element>
	</xs:template>
	<!--create pbl:nkhValue template-->
	<xs:template match="pbl:nkhValue">
		<xs:element name="pbl:nkhValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkhValue template-->
	<xs:template name="add-pbl-nkhValue">
		<xs:element name="pbl:nkhValue"></xs:element>
	</xs:template>
</xs:stylesheet>