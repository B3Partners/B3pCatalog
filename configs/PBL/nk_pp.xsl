<?xml version="1.0" encoding="UTF-8"?>
<xs:stylesheet xmlns:b3p="http://www.b3partners.nl/xsd/metadata" xmlns:gml="http://www.opengis.net/gml" xmlns:pbl="http://www.pbl.nl/xsd/metadata" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" exclude-result-prefixes="xs pbl b3p gml xlink xsi">
	<xs:output method="xml" indent="yes"/>
	<xs:param name="dcPblMode_init">true</xs:param>
	<xs:param name="dcPblMode" select="$dcPblMode_init = 'true'"/>
	<xs:template match="@*|node()">
		<xs:copy>
			<xs:apply-templates select="@*|node()"/>
		</xs:copy>
	</xs:template>
	<xs:template match="metadata">
		<xs:element name="metadata">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<xs:template match="b3p:B3Partners">
		<xs:copy>
			<xs:choose>
				<xs:when test="$dcPblMode = 'true'">
					<xs:apply-templates select="@*|node()[not(self::pbl:normenkaderPBL)]"/>
					<xs:choose>
						<xs:when test="not(pbl:normenkaderPBL)">
							<xs:call-template name="add-pbl-normenkaderPBL-"/>
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
	</xs:template>
	<!--create pbl:normenkaderPBL template-->
	<xs:template match="pbl:normenkaderPBL">
		<xs:element name="pbl:normenkaderPBL">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkAlgemeenItems) and not(self::pbl:nkBeheerItems) and not(self::pbl:nkBronlijstItems) and not(self::pbl:nkDataobjectItems) and not(self::pbl:nkGebruikItems) and not(self::pbl:nkInvulhulpItems) and not(self::pbl:nkReferentiesItems)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkAlgemeenItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkAlgemeenItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkAlgemeenItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkBeheerItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkBeheerItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkBeheerItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkBronlijstItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkBronlijstItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkBronlijstItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkDataobjectItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkDataobjectItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkDataobjectItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkGebruikItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkGebruikItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkGebruikItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkInvulhulpItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkInvulhulpItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkInvulhulpItems"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkReferentiesItems)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkReferentiesItems-pbl-normenkaderPBL"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkReferentiesItems"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-normenkaderPBL- template-->
	<xs:template name="add-pbl-normenkaderPBL-">
		<xs:element name="pbl:normenkaderPBL">
			<xs:attribute name="version">hh_12okt</xs:attribute>
			<!--call add-pbl-nkAlgemeenItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkAlgemeenItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkBeheerItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkBeheerItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkBronlijstItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkBronlijstItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkDataobjectItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkDataobjectItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkGebruikItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkGebruikItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkInvulhulpItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkInvulhulpItems-pbl-normenkaderPBL"/>
			<!--call add-pbl-nkReferentiesItems-pbl-normenkaderPBL template-->
			<xs:call-template name="add-pbl-nkReferentiesItems-pbl-normenkaderPBL"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkAlgemeenItems template-->
	<xs:template match="pbl:nkAlgemeenItems">
		<xs:element name="pbl:nkAlgemeenItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkalg1) and not(self::pbl:nkalg2) and not(self::pbl:nkalg3) and not(self::pbl:nkalg4) and not(self::pbl:nkalg5) and not(self::pbl:nkalg6) and not(self::pbl:nkalg7)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkalg1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg1-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg2-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg3-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg4-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg5-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg5"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg6)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg6-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg6"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkalg7)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkalg7-pbl-nkAlgemeenItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkalg7"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkAlgemeenItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkAlgemeenItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkAlgemeenItems">
			<!--call add-pbl-nkalg1-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg1-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg2-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg2-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg3-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg3-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg4-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg4-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg5-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg5-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg6-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg6-pbl-nkAlgemeenItems"/>
			<!--call add-pbl-nkalg7-pbl-nkAlgemeenItems template-->
			<xs:call-template name="add-pbl-nkalg7-pbl-nkAlgemeenItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkalg1 template-->
	<xs:template match="pbl:nkalg1">
		<xs:element name="pbl:nkalg1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg1-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg1-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg1"/>
			<!--call add-pbl-nkValue-pbl-nkalg1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg1">
		<xs:element name="pbl:nkTitle">Naam dataobject</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg2 template-->
	<xs:template match="pbl:nkalg2">
		<xs:element name="pbl:nkalg2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg2-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg2-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg2"/>
			<!--call add-pbl-nkValue-pbl-nkalg2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg2">
		<xs:element name="pbl:nkTitle">Locatie (dataobject + metadata)</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg3 template-->
	<xs:template match="pbl:nkalg3">
		<xs:element name="pbl:nkalg3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg3-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg3-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg3">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg3"/>
			<!--call add-pbl-nkValue-pbl-nkalg3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg3">
		<xs:element name="pbl:nkTitle">Korte omschrijving</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg4 template-->
	<xs:template match="pbl:nkalg4">
		<xs:element name="pbl:nkalg4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg4-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg4-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg4">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg4"/>
			<!--call add-pbl-nkValue-pbl-nkalg4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg4">
		<xs:element name="pbl:nkTitle">PBL Eigenaar inclusief contactpersoon</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg5 template-->
	<xs:template match="pbl:nkalg5">
		<xs:element name="pbl:nkalg5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg5-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg5-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg5">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg5 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg5"/>
			<!--call add-pbl-nkValue-pbl-nkalg5 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg5 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg5">
		<xs:element name="pbl:nkTitle">PBL Beheerder</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg5 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg5">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg6 template-->
	<xs:template match="pbl:nkalg6">
		<xs:element name="pbl:nkalg6">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg6-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg6-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg6">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg6 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg6"/>
			<!--call add-pbl-nkValue-pbl-nkalg6 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg6"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg6 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg6">
		<xs:element name="pbl:nkTitle">Datum opname</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg6 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg6">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkalg7 template-->
	<xs:template match="pbl:nkalg7">
		<xs:element name="pbl:nkalg7">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkalg7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkalg7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkalg7-pbl-nkAlgemeenItems template-->
	<xs:template name="add-pbl-nkalg7-pbl-nkAlgemeenItems">
		<xs:element name="pbl:nkalg7">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkalg7 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkalg7"/>
			<!--call add-pbl-nkValue-pbl-nkalg7 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkalg7"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkalg7 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkalg7">
		<xs:element name="pbl:nkTitle">Opgenomen door</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkalg7 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkalg7">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkBeheerItems template-->
	<xs:template match="pbl:nkBeheerItems">
		<xs:element name="pbl:nkBeheerItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1) and not(self::pbl:nka2) and not(self::pbl:nka3) and not(self::pbl:nka4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1-pbl-nkBeheerItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2-pbl-nkBeheerItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3-pbl-nkBeheerItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4-pbl-nkBeheerItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkBeheerItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkBeheerItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkBeheerItems">
			<!--call add-pbl-nka1-pbl-nkBeheerItems template-->
			<xs:call-template name="add-pbl-nka1-pbl-nkBeheerItems"/>
			<!--call add-pbl-nka2-pbl-nkBeheerItems template-->
			<xs:call-template name="add-pbl-nka2-pbl-nkBeheerItems"/>
			<!--call add-pbl-nka3-pbl-nkBeheerItems template-->
			<xs:call-template name="add-pbl-nka3-pbl-nkBeheerItems"/>
			<!--call add-pbl-nka4-pbl-nkBeheerItems template-->
			<xs:call-template name="add-pbl-nka4-pbl-nkBeheerItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1 template-->
	<xs:template match="pbl:nka1">
		<xs:element name="pbl:nka1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nka1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1-pbl-nkBeheerItems template-->
	<xs:template name="add-pbl-nka1-pbl-nkBeheerItems">
		<xs:element name="pbl:nka1">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka1"/>
			<!--call add-pbl-nkValue-pbl-nka1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka1"/>
			<!--call add-pbl-nkComment-pbl-nka1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka1"/>
			<!--call add-pbl-nkChecks-pbl-nka1 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nka1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka1">
		<xs:element name="pbl:nkTitle">Is het beheer van het dataobject belegd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka1c1) and not(self::pbl:nka1c2) and not(self::pbl:nka1c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka1c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka1c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka1c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nka1 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nka1">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nka1c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka1c1-pbl-nkChecks"/>
			<!--call add-pbl-nka1c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka1c2-pbl-nkChecks"/>
			<!--call add-pbl-nka1c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka1c3-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka1c1 template-->
	<xs:template match="pbl:nka1c1">
		<xs:element name="pbl:nka1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka1c1-pbl-nkChecks">
		<xs:element name="pbl:nka1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka1c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka1c1"/>
			<!--call add-pbl-nkValue-pbl-nka1c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka1c1"/>
			<!--call add-pbl-nkComment-pbl-nka1c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka1c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka1c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka1c1">
		<xs:element name="pbl:nkTitle">Het beheer van een dataobject kan centraal bij IDM, decentraal binnen de sector of binnen een projectteam belegd zijn. Het antwoord Ja gaat dus altijd vergezeld van de opmerking: bij IDM, bij sector X of bij projectteam Y en, indien van toepassing, door…</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka1c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka1c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka1c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka1c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka1c2 template-->
	<xs:template match="pbl:nka1c2">
		<xs:element name="pbl:nka1c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka1c2-pbl-nkChecks">
		<xs:element name="pbl:nka1c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka1c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka1c2"/>
			<!--call add-pbl-nkValue-pbl-nka1c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka1c2"/>
			<!--call add-pbl-nkComment-pbl-nka1c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka1c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka1c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka1c2">
		<xs:element name="pbl:nkTitle">De beheerder is geen persoon, maar een rol. Binnen IDM/de sectoren/het projectteam heeft iemand de rol van beheerder. Voor een projectdata geldt dat het instellen van een beheerder een vrije keuze is</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka1c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka1c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka1c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka1c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka1c3 template-->
	<xs:template match="pbl:nka1c3">
		<xs:element name="pbl:nka1c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka1c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka1c3-pbl-nkChecks">
		<xs:element name="pbl:nka1c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka1c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka1c3"/>
			<!--call add-pbl-nkValue-pbl-nka1c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka1c3"/>
			<!--call add-pbl-nkComment-pbl-nka1c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka1c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka1c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka1c3">
		<xs:element name="pbl:nkTitle">Is de metadata opgenomen worden in de PBL datazoekapplicatie? Andere gebruikers weten dan ook het dataobject beschibaar is.</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka1c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka1c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka1c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka1c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka2 template-->
	<xs:template match="pbl:nka2">
		<xs:element name="pbl:nka2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nka2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2-pbl-nkBeheerItems template-->
	<xs:template name="add-pbl-nka2-pbl-nkBeheerItems">
		<xs:element name="pbl:nka2">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka2"/>
			<!--call add-pbl-nkValue-pbl-nka2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka2"/>
			<!--call add-pbl-nkComment-pbl-nka2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka2"/>
			<!--call add-pbl-nkChecks-pbl-nka2 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nka2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka2">
		<xs:element name="pbl:nkTitle">Is het eigenaarschap van het dataobject belegd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka2c1) and not(self::pbl:nka2c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka2c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka2c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nka2 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nka2">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nka2c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka2c1-pbl-nkChecks"/>
			<!--call add-pbl-nka2c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka2c2-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka2c1 template-->
	<xs:template match="pbl:nka2c1">
		<xs:element name="pbl:nka2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka2c1-pbl-nkChecks">
		<xs:element name="pbl:nka2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka2c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka2c1"/>
			<!--call add-pbl-nkValue-pbl-nka2c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka2c1"/>
			<!--call add-pbl-nkComment-pbl-nka2c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka2c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka2c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka2c1">
		<xs:element name="pbl:nkTitle">Is de eigenaar op de hoogte van zijn/haar verantwoordelijkheden?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka2c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka2c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka2c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka2c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka2c2 template-->
	<xs:template match="pbl:nka2c2">
		<xs:element name="pbl:nka2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka2c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka2c2-pbl-nkChecks">
		<xs:element name="pbl:nka2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka2c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka2c2"/>
			<!--call add-pbl-nkValue-pbl-nka2c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka2c2"/>
			<!--call add-pbl-nkComment-pbl-nka2c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka2c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka2c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka2c2">
		<xs:element name="pbl:nkTitle">Is het eigenaarschap noodzakelijk? Vrij beschikbare dataobjecten hebben geen PBL eigenaar nodig, bestanden met gebruiksbeperkingen hebben wel een PBL eigenaar nodig. </xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka2c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka2c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka2c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka2c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka3 template-->
	<xs:template match="pbl:nka3">
		<xs:element name="pbl:nka3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nka3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3-pbl-nkBeheerItems template-->
	<xs:template name="add-pbl-nka3-pbl-nkBeheerItems">
		<xs:element name="pbl:nka3">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka3"/>
			<!--call add-pbl-nkValue-pbl-nka3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka3"/>
			<!--call add-pbl-nkComment-pbl-nka3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka3"/>
			<!--call add-pbl-nkChecks-pbl-nka3 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nka3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka3">
		<xs:element name="pbl:nkTitle">Is de dataexpert bekend?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka3c1) and not(self::pbl:nka3c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka3c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka3c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nka3 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nka3">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nka3c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka3c1-pbl-nkChecks"/>
			<!--call add-pbl-nka3c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka3c2-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka3c1 template-->
	<xs:template match="pbl:nka3c1">
		<xs:element name="pbl:nka3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka3c1-pbl-nkChecks">
		<xs:element name="pbl:nka3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka3c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka3c1"/>
			<!--call add-pbl-nkValue-pbl-nka3c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka3c1"/>
			<!--call add-pbl-nkComment-pbl-nka3c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka3c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka3c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka3c1">
		<xs:element name="pbl:nkTitle">Zijn aandachtspunten voor het gebruik opgenomen in de metadata?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka3c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka3c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka3c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka3c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka3c2 template-->
	<xs:template match="pbl:nka3c2">
		<xs:element name="pbl:nka3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka3c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka3c2-pbl-nkChecks">
		<xs:element name="pbl:nka3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka3c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka3c2"/>
			<!--call add-pbl-nkValue-pbl-nka3c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka3c2"/>
			<!--call add-pbl-nkComment-pbl-nka3c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka3c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka3c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka3c2">
		<xs:element name="pbl:nkTitle">Staan in de metadata de projecten waarvoor het dataobject eerder is gebruikt?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka3c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka3c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka3c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka3c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka4 template-->
	<xs:template match="pbl:nka4">
		<xs:element name="pbl:nka4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nka4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4-pbl-nkBeheerItems template-->
	<xs:template name="add-pbl-nka4-pbl-nkBeheerItems">
		<xs:element name="pbl:nka4">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka4"/>
			<!--call add-pbl-nkValue-pbl-nka4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka4"/>
			<!--call add-pbl-nkComment-pbl-nka4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka4"/>
			<!--call add-pbl-nkChecks-pbl-nka4 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nka4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka4">
		<xs:element name="pbl:nkTitle">Is er versiebeheer voor het dataobjectgeregeld (correcties, aanpassingen, etc)?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nka4c1) and not(self::pbl:nka4c2) and not(self::pbl:nka4c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nka4c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nka4c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nka4c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nka4c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nka4 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nka4">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nka4c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka4c1-pbl-nkChecks"/>
			<!--call add-pbl-nka4c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka4c2-pbl-nkChecks"/>
			<!--call add-pbl-nka4c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nka4c3-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nka4c1 template-->
	<xs:template match="pbl:nka4c1">
		<xs:element name="pbl:nka4c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka4c1-pbl-nkChecks">
		<xs:element name="pbl:nka4c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka4c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka4c1"/>
			<!--call add-pbl-nkValue-pbl-nka4c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka4c1"/>
			<!--call add-pbl-nkComment-pbl-nka4c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka4c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka4c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka4c1">
		<xs:element name="pbl:nkTitle">Is versiebeheer nodig?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka4c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka4c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka4c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka4c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka4c2 template-->
	<xs:template match="pbl:nka4c2">
		<xs:element name="pbl:nka4c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka4c2-pbl-nkChecks">
		<xs:element name="pbl:nka4c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka4c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka4c2"/>
			<!--call add-pbl-nkValue-pbl-nka4c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka4c2"/>
			<!--call add-pbl-nkComment-pbl-nka4c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka4c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka4c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka4c2">
		<xs:element name="pbl:nkTitle">Is er beschreven hoe om te gaan met actualisaties van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka4c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka4c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka4c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka4c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nka4c3 template-->
	<xs:template match="pbl:nka4c3">
		<xs:element name="pbl:nka4c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nka4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nka4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nka4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nka4c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nka4c3-pbl-nkChecks">
		<xs:element name="pbl:nka4c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nka4c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nka4c3"/>
			<!--call add-pbl-nkValue-pbl-nka4c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nka4c3"/>
			<!--call add-pbl-nkComment-pbl-nka4c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nka4c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nka4c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nka4c3">
		<xs:element name="pbl:nkTitle">Op welke manier wordt het versiebeheer voor het dataobject uitgevoerd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nka4c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nka4c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nka4c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nka4c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkBronlijstItems template-->
	<xs:template match="pbl:nkBronlijstItems">
		<xs:element name="pbl:nkBronlijstItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkbl1) and not(self::pbl:nkbl2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkbl1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl1-pbl-nkBronlijstItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkbl2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkbl2-pbl-nkBronlijstItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkbl2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkBronlijstItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkBronlijstItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkBronlijstItems">
			<!--call add-pbl-nkbl1-pbl-nkBronlijstItems template-->
			<xs:call-template name="add-pbl-nkbl1-pbl-nkBronlijstItems"/>
			<!--call add-pbl-nkbl2-pbl-nkBronlijstItems template-->
			<xs:call-template name="add-pbl-nkbl2-pbl-nkBronlijstItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkbl1 template-->
	<xs:template match="pbl:nkbl1">
		<xs:element name="pbl:nkbl1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkbl1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl1-pbl-nkBronlijstItems template-->
	<xs:template name="add-pbl-nkbl1-pbl-nkBronlijstItems">
		<xs:element name="pbl:nkbl1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkbl1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkbl1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkbl1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkbl1">
		<xs:element name="pbl:nkTitle">De bronlijst wordt aangemaakt bij aanvang van het project en wordt gedurende het project bijgewerkt (dataobjecten komen er bij en gaan er af). De checklist datakwaliteit wordt toegepast voor alle objecten op de bronlijst. De checklist wordt toegepast voordat een bestaand dataobject gebruikt wordt of voordat een geproduceerd dataobject uitgeleverd wordt.</xs:element>
	</xs:template>
	<!--create pbl:nkbl2 template-->
	<xs:template match="pbl:nkbl2">
		<xs:element name="pbl:nkbl2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkbl2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkbl2-pbl-nkBronlijstItems template-->
	<xs:template name="add-pbl-nkbl2-pbl-nkBronlijstItems">
		<xs:element name="pbl:nkbl2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkbl2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkbl2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkbl2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkbl2">
		<xs:element name="pbl:nkTitle">Het beheer van de bronlijst wordt uitgevoerd in het project en valt onder de verantwoordelijkheid van de projectleider.</xs:element>
	</xs:template>
	<!--create pbl:nkDataobjectItems template-->
	<xs:template match="pbl:nkDataobjectItems">
		<xs:element name="pbl:nkDataobjectItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1) and not(self::pbl:nkb2) and not(self::pbl:nkb3) and not(self::pbl:nkb4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1-pbl-nkDataobjectItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2-pbl-nkDataobjectItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3-pbl-nkDataobjectItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4-pbl-nkDataobjectItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkDataobjectItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkDataobjectItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkDataobjectItems">
			<!--call add-pbl-nkb1-pbl-nkDataobjectItems template-->
			<xs:call-template name="add-pbl-nkb1-pbl-nkDataobjectItems"/>
			<!--call add-pbl-nkb2-pbl-nkDataobjectItems template-->
			<xs:call-template name="add-pbl-nkb2-pbl-nkDataobjectItems"/>
			<!--call add-pbl-nkb3-pbl-nkDataobjectItems template-->
			<xs:call-template name="add-pbl-nkb3-pbl-nkDataobjectItems"/>
			<!--call add-pbl-nkb4-pbl-nkDataobjectItems template-->
			<xs:call-template name="add-pbl-nkb4-pbl-nkDataobjectItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1 template-->
	<xs:template match="pbl:nkb1">
		<xs:element name="pbl:nkb1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkb1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1-pbl-nkDataobjectItems template-->
	<xs:template name="add-pbl-nkb1-pbl-nkDataobjectItems">
		<xs:element name="pbl:nkb1">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb1"/>
			<!--call add-pbl-nkValue-pbl-nkb1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb1"/>
			<!--call add-pbl-nkComment-pbl-nkb1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb1"/>
			<!--call add-pbl-nkChecks-pbl-nkb1 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkb1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb1">
		<xs:element name="pbl:nkTitle">Is het dataobject voorzien van metadata?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb1c1) and not(self::pbl:nkb1c2) and not(self::pbl:nkb1c3) and not(self::pbl:nkb1c4)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb1c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb1c4-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb1c4"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkb1 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkb1">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkb1c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb1c1-pbl-nkChecks"/>
			<!--call add-pbl-nkb1c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb1c2-pbl-nkChecks"/>
			<!--call add-pbl-nkb1c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb1c3-pbl-nkChecks"/>
			<!--call add-pbl-nkb1c4-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb1c4-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb1c1 template-->
	<xs:template match="pbl:nkb1c1">
		<xs:element name="pbl:nkb1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb1c1-pbl-nkChecks">
		<xs:element name="pbl:nkb1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb1c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c1"/>
			<!--call add-pbl-nkValue-pbl-nkb1c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb1c1"/>
			<!--call add-pbl-nkComment-pbl-nkb1c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb1c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb1c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb1c1">
		<xs:element name="pbl:nkTitle">Is de metadata beschikbaar volgens de PBL richtlijnen? Richtlijnen maken het mogelijk dataobjecten te zoeken op meerdere ingangen, en om metadata gestructureerd toe te voegen.</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb1c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb1c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb1c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb1c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c2 template-->
	<xs:template match="pbl:nkb1c2">
		<xs:element name="pbl:nkb1c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb1c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb1c2-pbl-nkChecks">
		<xs:element name="pbl:nkb1c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb1c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c2"/>
			<!--call add-pbl-nkValue-pbl-nkb1c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb1c2"/>
			<!--call add-pbl-nkComment-pbl-nkb1c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb1c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb1c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb1c2">
		<xs:element name="pbl:nkTitle">Is de metadata voldoende om de waarde voor de gewenste toepassing te kunnen beoordelen?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb1c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb1c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb1c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb1c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c3 template-->
	<xs:template match="pbl:nkb1c3">
		<xs:element name="pbl:nkb1c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb1c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb1c3-pbl-nkChecks">
		<xs:element name="pbl:nkb1c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb1c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c3"/>
			<!--call add-pbl-nkValue-pbl-nkb1c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb1c3"/>
			<!--call add-pbl-nkComment-pbl-nkb1c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb1c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb1c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb1c3">
		<xs:element name="pbl:nkTitle">Is de metadata actueel, zijn eventuele datachecks en eerdere toepassingen er in opgenomen?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb1c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb1c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb1c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb1c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb1c4 template-->
	<xs:template match="pbl:nkb1c4">
		<xs:element name="pbl:nkb1c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb1c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb1c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb1c4-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb1c4-pbl-nkChecks">
		<xs:element name="pbl:nkb1c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb1c4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb1c4"/>
			<!--call add-pbl-nkValue-pbl-nkb1c4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb1c4"/>
			<!--call add-pbl-nkComment-pbl-nkb1c4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb1c4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb1c4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb1c4">
		<xs:element name="pbl:nkTitle">Indien er meerdere versies van het dataobject voorkomen, is dan duidelijk met welke versie gewerkt wordt?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb1c4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb1c4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb1c4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb1c4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb2 template-->
	<xs:template match="pbl:nkb2">
		<xs:element name="pbl:nkb2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkb2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2-pbl-nkDataobjectItems template-->
	<xs:template name="add-pbl-nkb2-pbl-nkDataobjectItems">
		<xs:element name="pbl:nkb2">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb2"/>
			<!--call add-pbl-nkValue-pbl-nkb2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb2"/>
			<!--call add-pbl-nkComment-pbl-nkb2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb2"/>
			<!--call add-pbl-nkChecks-pbl-nkb2 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkb2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb2">
		<xs:element name="pbl:nkTitle">Is er een beschrijving van het oorspronkelijke doel en toepassingsbereik van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb2c1) and not(self::pbl:nkb2c2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb2c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb2c2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkb2 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkb2">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkb2c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb2c1-pbl-nkChecks"/>
			<!--call add-pbl-nkb2c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb2c2-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb2c1 template-->
	<xs:template match="pbl:nkb2c1">
		<xs:element name="pbl:nkb2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb2c1-pbl-nkChecks">
		<xs:element name="pbl:nkb2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb2c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb2c1"/>
			<!--call add-pbl-nkValue-pbl-nkb2c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb2c1"/>
			<!--call add-pbl-nkComment-pbl-nkb2c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb2c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb2c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb2c1">
		<xs:element name="pbl:nkTitle">Is er informatie beschikbaar in de metadata over het oorspronkelijke doel waarvoor het dataobject is gemaakt? </xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb2c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb2c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb2c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb2c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb2c2 template-->
	<xs:template match="pbl:nkb2c2">
		<xs:element name="pbl:nkb2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb2c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb2c2-pbl-nkChecks">
		<xs:element name="pbl:nkb2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb2c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb2c2"/>
			<!--call add-pbl-nkValue-pbl-nkb2c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb2c2"/>
			<!--call add-pbl-nkComment-pbl-nkb2c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb2c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb2c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb2c2">
		<xs:element name="pbl:nkTitle">Is er informatie beschikbaar in de metadata over het toepassingsbereik waarvoor het dataobject is gecreëerd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb2c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb2c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb2c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb2c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3 template-->
	<xs:template match="pbl:nkb3">
		<xs:element name="pbl:nkb3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkb3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3-pbl-nkDataobjectItems template-->
	<xs:template name="add-pbl-nkb3-pbl-nkDataobjectItems">
		<xs:element name="pbl:nkb3">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb3"/>
			<!--call add-pbl-nkValue-pbl-nkb3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb3"/>
			<!--call add-pbl-nkComment-pbl-nkb3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb3"/>
			<!--call add-pbl-nkChecks-pbl-nkb3 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkb3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb3">
		<xs:element name="pbl:nkTitle">Zijn het datamodel en de attributen van het dataobject beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb3c1) and not(self::pbl:nkb3c2) and not(self::pbl:nkb3c3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb3c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb3c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb3c3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkb3 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkb3">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkb3c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb3c1-pbl-nkChecks"/>
			<!--call add-pbl-nkb3c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb3c2-pbl-nkChecks"/>
			<!--call add-pbl-nkb3c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb3c3-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb3c1 template-->
	<xs:template match="pbl:nkb3c1">
		<xs:element name="pbl:nkb3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb3c1-pbl-nkChecks">
		<xs:element name="pbl:nkb3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb3c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c1"/>
			<!--call add-pbl-nkValue-pbl-nkb3c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb3c1"/>
			<!--call add-pbl-nkComment-pbl-nkb3c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb3c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb3c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb3c1">
		<xs:element name="pbl:nkTitle">Is er een verklarende tekst en/of schema beschikbaar?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb3c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb3c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb3c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb3c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c2 template-->
	<xs:template match="pbl:nkb3c2">
		<xs:element name="pbl:nkb3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb3c2-pbl-nkChecks">
		<xs:element name="pbl:nkb3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb3c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c2"/>
			<!--call add-pbl-nkValue-pbl-nkb3c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb3c2"/>
			<!--call add-pbl-nkComment-pbl-nkb3c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb3c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb3c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb3c2">
		<xs:element name="pbl:nkTitle">Zijn de relaties tussen de verschillende onderdelen beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb3c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb3c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb3c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb3c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb3c3 template-->
	<xs:template match="pbl:nkb3c3">
		<xs:element name="pbl:nkb3c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb3c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb3c3-pbl-nkChecks">
		<xs:element name="pbl:nkb3c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb3c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb3c3"/>
			<!--call add-pbl-nkValue-pbl-nkb3c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb3c3"/>
			<!--call add-pbl-nkComment-pbl-nkb3c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb3c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb3c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb3c3">
		<xs:element name="pbl:nkTitle">Zijn de attributen voldoende beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb3c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb3c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb3c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb3c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4 template-->
	<xs:template match="pbl:nkb4">
		<xs:element name="pbl:nkb4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkb4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4-pbl-nkDataobjectItems template-->
	<xs:template name="add-pbl-nkb4-pbl-nkDataobjectItems">
		<xs:element name="pbl:nkb4">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4"/>
			<!--call add-pbl-nkValue-pbl-nkb4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4"/>
			<!--call add-pbl-nkComment-pbl-nkb4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4"/>
			<!--call add-pbl-nkChecks-pbl-nkb4 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkb4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4">
		<xs:element name="pbl:nkTitle">Zijn er tests uitgevoerd waarmee de eigen kwaliteit van het dataobject kan worden aangetoond?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkb4c1) and not(self::pbl:nkb4c2) and not(self::pbl:nkb4c3) and not(self::pbl:nkb4c4) and not(self::pbl:nkb4c5)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c4-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkb4c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkb4c5-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkb4c5"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkb4 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkb4">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkb4c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb4c1-pbl-nkChecks"/>
			<!--call add-pbl-nkb4c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb4c2-pbl-nkChecks"/>
			<!--call add-pbl-nkb4c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb4c3-pbl-nkChecks"/>
			<!--call add-pbl-nkb4c4-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb4c4-pbl-nkChecks"/>
			<!--call add-pbl-nkb4c5-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkb4c5-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkb4c1 template-->
	<xs:template match="pbl:nkb4c1">
		<xs:element name="pbl:nkb4c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb4c1-pbl-nkChecks">
		<xs:element name="pbl:nkb4c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c1"/>
			<!--call add-pbl-nkValue-pbl-nkb4c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4c1"/>
			<!--call add-pbl-nkComment-pbl-nkb4c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4c1">
		<xs:element name="pbl:nkTitle">Zijn de testresultaten in de metadata vastgelegd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c2 template-->
	<xs:template match="pbl:nkb4c2">
		<xs:element name="pbl:nkb4c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb4c2-pbl-nkChecks">
		<xs:element name="pbl:nkb4c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c2"/>
			<!--call add-pbl-nkValue-pbl-nkb4c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4c2"/>
			<!--call add-pbl-nkComment-pbl-nkb4c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4c2">
		<xs:element name="pbl:nkTitle">Zijn de tests bij binnenkomst/aanmaak van het dataobject uitgevoerd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c3 template-->
	<xs:template match="pbl:nkb4c3">
		<xs:element name="pbl:nkb4c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb4c3-pbl-nkChecks">
		<xs:element name="pbl:nkb4c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c3"/>
			<!--call add-pbl-nkValue-pbl-nkb4c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4c3"/>
			<!--call add-pbl-nkComment-pbl-nkb4c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4c3">
		<xs:element name="pbl:nkTitle">Zijn er geautomatiseerde controles uitgevoerd? Bij terugkerende dataobjecten (reeksen etc) kan er naar worden gestreefd om, waar mogelijk, controles op de eigenschappen van de data te automatiseren.</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c4 template-->
	<xs:template match="pbl:nkb4c4">
		<xs:element name="pbl:nkb4c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c4-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb4c4-pbl-nkChecks">
		<xs:element name="pbl:nkb4c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4c4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c4"/>
			<!--call add-pbl-nkValue-pbl-nkb4c4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4c4"/>
			<!--call add-pbl-nkComment-pbl-nkb4c4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4c4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4c4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4c4">
		<xs:element name="pbl:nkTitle">Hebben testresultaten aanleiding gegeven om het dataobject te corrigeren? Licht toe op welke manier de correcties in de metadata/versiebeheer zijn opgenomen.</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4c4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4c4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4c4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4c4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkb4c5 template-->
	<xs:template match="pbl:nkb4c5">
		<xs:element name="pbl:nkb4c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkb4c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkb4c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkb4c5-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkb4c5-pbl-nkChecks">
		<xs:element name="pbl:nkb4c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkb4c5 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkb4c5"/>
			<!--call add-pbl-nkValue-pbl-nkb4c5 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkb4c5"/>
			<!--call add-pbl-nkComment-pbl-nkb4c5 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkb4c5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkb4c5 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkb4c5">
		<xs:element name="pbl:nkTitle">Geven test resultaten aanleiding om het dataobject onder voorbehoud of in het geheel niet te gebruiken?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkb4c5 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkb4c5">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkb4c5 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkb4c5">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkGebruikItems template-->
	<xs:template match="pbl:nkGebruikItems">
		<xs:element name="pbl:nkGebruikItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1) and not(self::pbl:nkc2) and not(self::pbl:nkc3)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1-pbl-nkGebruikItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2-pbl-nkGebruikItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3-pbl-nkGebruikItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkGebruikItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkGebruikItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkGebruikItems">
			<!--call add-pbl-nkc1-pbl-nkGebruikItems template-->
			<xs:call-template name="add-pbl-nkc1-pbl-nkGebruikItems"/>
			<!--call add-pbl-nkc2-pbl-nkGebruikItems template-->
			<xs:call-template name="add-pbl-nkc2-pbl-nkGebruikItems"/>
			<!--call add-pbl-nkc3-pbl-nkGebruikItems template-->
			<xs:call-template name="add-pbl-nkc3-pbl-nkGebruikItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1 template-->
	<xs:template match="pbl:nkc1">
		<xs:element name="pbl:nkc1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkc1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1-pbl-nkGebruikItems template-->
	<xs:template name="add-pbl-nkc1-pbl-nkGebruikItems">
		<xs:element name="pbl:nkc1">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc1"/>
			<!--call add-pbl-nkValue-pbl-nkc1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc1"/>
			<!--call add-pbl-nkComment-pbl-nkc1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc1"/>
			<!--call add-pbl-nkChecks-pbl-nkc1 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkc1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc1">
		<xs:element name="pbl:nkTitle">Is structureel gebruik van het dataobject voorzien?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc1c1)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc1c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc1c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc1c1"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkc1 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkc1">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkc1c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc1c1-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc1c1 template-->
	<xs:template match="pbl:nkc1c1">
		<xs:element name="pbl:nkc1c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc1c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc1c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc1c1-pbl-nkChecks">
		<xs:element name="pbl:nkc1c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc1c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc1c1"/>
			<!--call add-pbl-nkValue-pbl-nkc1c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc1c1"/>
			<!--call add-pbl-nkComment-pbl-nkc1c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc1c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc1c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc1c1">
		<xs:element name="pbl:nkTitle">Is het aanemelijk dat het dataobject ook gebruikt kan worden voor andere toepassingen dan de huidige toepassing?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc1c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc1c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc1c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc1c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2 template-->
	<xs:template match="pbl:nkc2">
		<xs:element name="pbl:nkc2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkc2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2-pbl-nkGebruikItems template-->
	<xs:template name="add-pbl-nkc2-pbl-nkGebruikItems">
		<xs:element name="pbl:nkc2">
			<xs:attribute name="type">yesno</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2"/>
			<!--call add-pbl-nkValue-pbl-nkc2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2"/>
			<!--call add-pbl-nkComment-pbl-nkc2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2"/>
			<!--call add-pbl-nkChecks-pbl-nkc2 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkc2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2">
		<xs:element name="pbl:nkTitle">Is de motivatie achter het gebruik van het gekozen dataobject beschreven?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc2c1) and not(self::pbl:nkc2c2) and not(self::pbl:nkc2c3) and not(self::pbl:nkc2c4) and not(self::pbl:nkc2c5)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c4-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc2c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc2c5-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc2c5"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkc2 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkc2">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkc2c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc2c1-pbl-nkChecks"/>
			<!--call add-pbl-nkc2c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc2c2-pbl-nkChecks"/>
			<!--call add-pbl-nkc2c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc2c3-pbl-nkChecks"/>
			<!--call add-pbl-nkc2c4-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc2c4-pbl-nkChecks"/>
			<!--call add-pbl-nkc2c5-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc2c5-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc2c1 template-->
	<xs:template match="pbl:nkc2c1">
		<xs:element name="pbl:nkc2c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc2c1-pbl-nkChecks">
		<xs:element name="pbl:nkc2c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c1"/>
			<!--call add-pbl-nkValue-pbl-nkc2c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2c1"/>
			<!--call add-pbl-nkComment-pbl-nkc2c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2c1">
		<xs:element name="pbl:nkTitle">Als financiële redenen de keuze bepaalde, is het dan duidelijk waarom het dataobject voldoet aan de eisen? En wat eventuele tekortkomingen zijn? Zijn betere, maar niet toegankelijke (bijvoorbeeld te dure) alternatieven bekend?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c2 template-->
	<xs:template match="pbl:nkc2c2">
		<xs:element name="pbl:nkc2c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc2c2-pbl-nkChecks">
		<xs:element name="pbl:nkc2c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c2"/>
			<!--call add-pbl-nkValue-pbl-nkc2c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2c2"/>
			<!--call add-pbl-nkComment-pbl-nkc2c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2c2">
		<xs:element name="pbl:nkTitle">Als het gekozen dataobject goed/het beste (inhoudelijk en/of technisch) aansluit bij de doelen van het onderzoek, is dan duidelijk waarom het beter voldoet dan alternatieven?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c3 template-->
	<xs:template match="pbl:nkc2c3">
		<xs:element name="pbl:nkc2c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc2c3-pbl-nkChecks">
		<xs:element name="pbl:nkc2c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c3"/>
			<!--call add-pbl-nkValue-pbl-nkc2c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2c3"/>
			<!--call add-pbl-nkComment-pbl-nkc2c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2c3">
		<xs:element name="pbl:nkTitle">Is er bij de keuze van het dataobject gekeken naar continuïteit in onderzoek? Bijvoorbeeld naar dataobjecten gebruikt in eerdere of parallele onderzoeken (binnen PBL, maar ook binnen de overheid/wetenschap)?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c4 template-->
	<xs:template match="pbl:nkc2c4">
		<xs:element name="pbl:nkc2c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c4-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc2c4-pbl-nkChecks">
		<xs:element name="pbl:nkc2c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2c4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c4"/>
			<!--call add-pbl-nkValue-pbl-nkc2c4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2c4"/>
			<!--call add-pbl-nkComment-pbl-nkc2c4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2c4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2c4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2c4">
		<xs:element name="pbl:nkTitle">Is duidelijk omschreven wat de (eventuele) tekortkomingen van het dataobject voor het gebruiksdoel zijn?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2c4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2c4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2c4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2c4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc2c5 template-->
	<xs:template match="pbl:nkc2c5">
		<xs:element name="pbl:nkc2c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc2c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc2c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc2c5-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc2c5-pbl-nkChecks">
		<xs:element name="pbl:nkc2c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc2c5 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc2c5"/>
			<!--call add-pbl-nkValue-pbl-nkc2c5 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc2c5"/>
			<!--call add-pbl-nkComment-pbl-nkc2c5 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc2c5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc2c5 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc2c5">
		<xs:element name="pbl:nkTitle">Is de keuze voor een dataobject gemotiveerd met een evalautie van beschikbare opties?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc2c5 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc2c5">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc2c5 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc2c5">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3 template-->
	<xs:template match="pbl:nkc3">
		<xs:element name="pbl:nkc3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment) and not(self::pbl:nkChecks)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkChecks)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkChecks-pbl-nkc3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkChecks"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3-pbl-nkGebruikItems template-->
	<xs:template name="add-pbl-nkc3-pbl-nkGebruikItems">
		<xs:element name="pbl:nkc3">
			<xs:attribute name="type">yesnona</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3"/>
			<!--call add-pbl-nkValue-pbl-nkc3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3"/>
			<!--call add-pbl-nkComment-pbl-nkc3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3"/>
			<!--call add-pbl-nkChecks-pbl-nkc3 template-->
			<xs:call-template name="add-pbl-nkChecks-pbl-nkc3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3">
		<xs:element name="pbl:nkTitle">Is nagegaan of er gebruiksbeperkingen zijn?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkChecks template-->
	<xs:template match="pbl:nkChecks">
		<xs:element name="pbl:nkChecks">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkc3c1) and not(self::pbl:nkc3c2) and not(self::pbl:nkc3c3) and not(self::pbl:nkc3c4) and not(self::pbl:nkc3c5) and not(self::pbl:nkc3c6) and not(self::pbl:nkc3c7) and not(self::pbl:nkc3c8)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c1-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c2-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c2"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c3)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c3-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c3"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c4)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c4-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c4"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c5)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c5-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c5"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c6)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c6-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c6"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c7)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c7-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c7"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkc3c8)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkc3c8-pbl-nkChecks"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkc3c8"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkChecks-pbl-nkc3 template-->
	<xs:template name="add-pbl-nkChecks-pbl-nkc3">
		<xs:element name="pbl:nkChecks">
			<!--call add-pbl-nkc3c1-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c1-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c2-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c2-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c3-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c3-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c4-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c4-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c5-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c5-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c6-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c6-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c7-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c7-pbl-nkChecks"/>
			<!--call add-pbl-nkc3c8-pbl-nkChecks template-->
			<xs:call-template name="add-pbl-nkc3c8-pbl-nkChecks"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkc3c1 template-->
	<xs:template match="pbl:nkc3c1">
		<xs:element name="pbl:nkc3c1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c1-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c1-pbl-nkChecks">
		<xs:element name="pbl:nkc3c1">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c1"/>
			<!--call add-pbl-nkValue-pbl-nkc3c1 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c1"/>
			<!--call add-pbl-nkComment-pbl-nkc3c1 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c1">
		<xs:element name="pbl:nkTitle">Wordt in de onderzoeksopzet rekening gehouden met de gebruiksbeperkingen van het dataobject?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c1 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c1">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c1 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c1">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c2 template-->
	<xs:template match="pbl:nkc3c2">
		<xs:element name="pbl:nkc3c2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c2-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c2-pbl-nkChecks">
		<xs:element name="pbl:nkc3c2">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c2"/>
			<!--call add-pbl-nkValue-pbl-nkc3c2 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c2"/>
			<!--call add-pbl-nkComment-pbl-nkc3c2 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c2">
		<xs:element name="pbl:nkTitle">Is duidelijk of het dataobject voor een specifiek project of ook voor algemeen gebruik beschikbaar is?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c2 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c2">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c2 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c2">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c3 template-->
	<xs:template match="pbl:nkc3c3">
		<xs:element name="pbl:nkc3c3">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c3"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c3-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c3-pbl-nkChecks">
		<xs:element name="pbl:nkc3c3">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c3 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c3"/>
			<!--call add-pbl-nkValue-pbl-nkc3c3 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c3"/>
			<!--call add-pbl-nkComment-pbl-nkc3c3 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c3"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c3 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c3">
		<xs:element name="pbl:nkTitle">Is gezien de inwinningsmethode duidelijk of het dataobject alleen voor bepaalde toepassingen geschikt is (bijv. alleen op een bepaald schaalniveau)?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c3 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c3">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c3 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c3">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c4 template-->
	<xs:template match="pbl:nkc3c4">
		<xs:element name="pbl:nkc3c4">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c4"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c4-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c4-pbl-nkChecks">
		<xs:element name="pbl:nkc3c4">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c4 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c4"/>
			<!--call add-pbl-nkValue-pbl-nkc3c4 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c4"/>
			<!--call add-pbl-nkComment-pbl-nkc3c4 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c4"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c4 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c4">
		<xs:element name="pbl:nkTitle">Is duidelijk met welk doel het dataobject door de dataleverancier is verzameld en wat de eventuele discrepantie is met het toepassingdoel in het PBL-onderzoek (mag/kan het dataobject wel voor dit doel worden ingezet)?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c4 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c4">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c4 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c4">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c5 template-->
	<xs:template match="pbl:nkc3c5">
		<xs:element name="pbl:nkc3c5">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c5"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c5-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c5-pbl-nkChecks">
		<xs:element name="pbl:nkc3c5">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c5 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c5"/>
			<!--call add-pbl-nkValue-pbl-nkc3c5 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c5"/>
			<!--call add-pbl-nkComment-pbl-nkc3c5 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c5"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c5 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c5">
		<xs:element name="pbl:nkTitle">Is bekend op welk (aggregatie)niveau onderzoeksresultaten gepubliceerd en (digitaal) verspreid mogen worden?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c5 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c5">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c5 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c5">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c6 template-->
	<xs:template match="pbl:nkc3c6">
		<xs:element name="pbl:nkc3c6">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c6"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c6-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c6-pbl-nkChecks">
		<xs:element name="pbl:nkc3c6">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c6 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c6"/>
			<!--call add-pbl-nkValue-pbl-nkc3c6 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c6"/>
			<!--call add-pbl-nkComment-pbl-nkc3c6 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c6"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c6 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c6">
		<xs:element name="pbl:nkTitle">Is duidelijk wanneer er sprake is van afgeleide bestanden, en of deze afgeleide bestanden breder beschikbaar gesteld kunnen worden?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c6 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c6">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c6 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c6">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c7 template-->
	<xs:template match="pbl:nkc3c7">
		<xs:element name="pbl:nkc3c7">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c7"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c7-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c7-pbl-nkChecks">
		<xs:element name="pbl:nkc3c7">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c7 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c7"/>
			<!--call add-pbl-nkValue-pbl-nkc3c7 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c7"/>
			<!--call add-pbl-nkComment-pbl-nkc3c7 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c7"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c7 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c7">
		<xs:element name="pbl:nkTitle">Is duidelijk of er beperkingen gesteld worden aan het (tijdelijk) beschikbaar stellen van de dataset aan derden/opdrachtnemers? Is de duur van het gebruiksrecht duidelijk (oneiding of een bepaalde duur), is er nagedacht over een exit strategie bij doorlopende contracten?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c7 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c7">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c7 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c7">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkc3c8 template-->
	<xs:template match="pbl:nkc3c8">
		<xs:element name="pbl:nkc3c8">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue) and not(self::pbl:nkComment)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c8"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkc3c8"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkComment)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkComment-pbl-nkc3c8"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkComment"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkc3c8-pbl-nkChecks template-->
	<xs:template name="add-pbl-nkc3c8-pbl-nkChecks">
		<xs:element name="pbl:nkc3c8">
			<xs:attribute name="type">checkbox</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkc3c8 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkc3c8"/>
			<!--call add-pbl-nkValue-pbl-nkc3c8 template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkc3c8"/>
			<!--call add-pbl-nkComment-pbl-nkc3c8 template-->
			<xs:call-template name="add-pbl-nkComment-pbl-nkc3c8"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkc3c8 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkc3c8">
		<xs:element name="pbl:nkTitle">Worden bij het gebruik van de dataset de rechten en plichten rond de dataset bewaakt/gerespecteerd (bijv. geheimhouding; privacy, verspreiding kopieën, delen met derden/samenwerkingspartijen, etc.)? Worden eventuele geheimhoudingsverklaringen goed beheerd?</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkc3c8 template-->
	<xs:template name="add-pbl-nkValue-pbl-nkc3c8">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
	<!--create pbl:nkComment template-->
	<xs:template match="pbl:nkComment">
		<xs:element name="pbl:nkComment">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkComment-pbl-nkc3c8 template-->
	<xs:template name="add-pbl-nkComment-pbl-nkc3c8">
		<xs:element name="pbl:nkComment"></xs:element>
	</xs:template>
	<!--create pbl:nkInvulhulpItems template-->
	<xs:template match="pbl:nkInvulhulpItems">
		<xs:element name="pbl:nkInvulhulpItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkinv1) and not(self::pbl:nkinv2)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkinv1)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv1-pbl-nkInvulhulpItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv1"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkinv2)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkinv2-pbl-nkInvulhulpItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkinv2"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkInvulhulpItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkInvulhulpItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkInvulhulpItems">
			<!--call add-pbl-nkinv1-pbl-nkInvulhulpItems template-->
			<xs:call-template name="add-pbl-nkinv1-pbl-nkInvulhulpItems"/>
			<!--call add-pbl-nkinv2-pbl-nkInvulhulpItems template-->
			<xs:call-template name="add-pbl-nkinv2-pbl-nkInvulhulpItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkinv1 template-->
	<xs:template match="pbl:nkinv1">
		<xs:element name="pbl:nkinv1">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkinv1"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv1-pbl-nkInvulhulpItems template-->
	<xs:template name="add-pbl-nkinv1-pbl-nkInvulhulpItems">
		<xs:element name="pbl:nkinv1">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkinv1 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkinv1"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkinv1 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkinv1">
		<xs:element name="pbl:nkTitle">De checklist bij het normenkader bestaat uit 11 vragen, onderverdeeld in drie delen. De vragen moeten met ja of nee beantwoord worden; slechts in een enkel geval kan een vraag met ‘niet van toepassing’ beantwoord worden. Onder elke vraag is ruimte voor de verplichte toelichting (bewijsvoering). Indien aanwezig, refereer naar documentatie. Om het beantwoorden van de vragen te vereenvoudigen hebben we aandachtspunten toegevoegd. De aandachtspunten zijn optioneel, zet een kruis als voldaan wordt aan het betreffende aandachtspunt. Ook onder elk aandachtspunt is ruimte voor een optionele toelichting. Indien aanwezig, refereer naar documentatie. Om een vraag met ‘ja’ te kunnen beantwoorden hoeft niet aan de aandachtspunten te worden voldaan, maar een toelichting is verplicht.</xs:element>
	</xs:template>
	<!--create pbl:nkinv2 template-->
	<xs:template match="pbl:nkinv2">
		<xs:element name="pbl:nkinv2">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkinv2"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkinv2-pbl-nkInvulhulpItems template-->
	<xs:template name="add-pbl-nkinv2-pbl-nkInvulhulpItems">
		<xs:element name="pbl:nkinv2">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkinv2 template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkinv2"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkinv2 template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkinv2">
		<xs:element name="pbl:nkTitle">Om aan het normenkader te voldoen hoeft niet elke vraag met ‘ja’ of ‘nvt’ te worden beantwoord. Een vraag kan ook gemotiveerd met ‘nee’ beantwoord worden, terwijl er toch aan het normenkader wordt voldaan.</xs:element>
	</xs:template>
	<!--create pbl:nkReferentiesItems template-->
	<xs:template match="pbl:nkReferentiesItems">
		<xs:element name="pbl:nkReferentiesItems">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkh)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkh)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkh-pbl-nkReferentiesItems"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkh"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkReferentiesItems-pbl-normenkaderPBL template-->
	<xs:template name="add-pbl-nkReferentiesItems-pbl-normenkaderPBL">
		<xs:element name="pbl:nkReferentiesItems">
			<!--call add-pbl-nkh-pbl-nkReferentiesItems template-->
			<xs:call-template name="add-pbl-nkh-pbl-nkReferentiesItems"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkh template-->
	<xs:template match="pbl:nkh">
		<xs:element name="pbl:nkh">
			<xs:apply-templates select="@*|node()[ not(self::pbl:nkTitle) and not(self::pbl:nkValue)]"/>
			<xs:choose>
				<xs:when test="not(pbl:nkTitle)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkTitle-pbl-nkh"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkTitle"/>
				</xs:otherwise>
			</xs:choose>
			<xs:choose>
				<xs:when test="not(pbl:nkValue)">
					<!--Child element missing, create it-->
					<xs:call-template name="add-pbl-nkValue-pbl-nkh"/>
				</xs:when>
				<xs:otherwise>
					<!--Child element exists, copy it-->
					<xs:apply-templates select="pbl:nkValue"/>
				</xs:otherwise>
			</xs:choose>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkh-pbl-nkReferentiesItems template-->
	<xs:template name="add-pbl-nkh-pbl-nkReferentiesItems">
		<xs:element name="pbl:nkh">
			<xs:attribute name="type">text</xs:attribute>
			<!--call add-pbl-nkTitle-pbl-nkh template-->
			<xs:call-template name="add-pbl-nkTitle-pbl-nkh"/>
			<!--call add-pbl-nkValue-pbl-nkh template-->
			<xs:call-template name="add-pbl-nkValue-pbl-nkh"/>
		</xs:element>
	</xs:template>
	<!--create pbl:nkTitle template-->
	<xs:template match="pbl:nkTitle">
		<xs:element name="pbl:nkTitle">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkTitle-pbl-nkh template-->
	<xs:template name="add-pbl-nkTitle-pbl-nkh">
		<xs:element name="pbl:nkTitle">Referentie</xs:element>
	</xs:template>
	<!--create pbl:nkValue template-->
	<xs:template match="pbl:nkValue">
		<xs:element name="pbl:nkValue">
			<xs:apply-templates select="@*|node()"/>
		</xs:element>
	</xs:template>
	<!--create add-pbl-nkValue-pbl-nkh template-->
	<xs:template name="add-pbl-nkValue-pbl-nkh">
		<xs:element name="pbl:nkValue"></xs:element>
	</xs:template>
</xs:stylesheet>