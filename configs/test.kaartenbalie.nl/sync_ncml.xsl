<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gmi="http://www.isotc211.org/2005/gmi"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gfc="http://www.isotc211.org/2005/gfc"
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:b3p="http://www.b3partners.nl/xsd/metadata"
    xmlns:pbl="http://www.pbl.nl/xsd/metadata"
    xmlns:nc="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2"
>	
	<!-- Synchronize NCML (metadata from NetCDF in XML format) to ISO 19115 metadata and ISO 19110 Feature Catalog.

	Input document should contain all ISO 19115 elements as synchronization to this schema is implemented as an identity 
    transform with templates matched at specific destination elements to copy stuff over from NCML. It does not create
    ISO 19115 elements. 
	Note that any input which is not replaced by NCML values is left alone, but for elements which can occur multiple
	times no intelligent handling is applied (multiple pointOfContact organisationNames are all overwritten with the same 
    'institution' attribute, the first resourceConstraint useLimitation is set to 'terms_of_use' attribute etc.)

	The input document should also contain the NCML:

    Example input:
    <some_root_element>
		<gmd:MD_Metadata> ... all elements from schema ... </gmd:MD_Metadata>
		<nc:netcdf> ... the NCML from where values should be synchronized to the MD_Metadata element ... </nc:netcdf>
    </some_root_element>

    ISO 19110 Feature Catalog elements are not required to exist, this stylesheet creates or replaces it entirely.
	-->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="nc" select="//nc:netcdf"/>
    <xsl:template name="nc-global-attribute">
        <xsl:param name="attribute"/>
        <xsl:variable name="nc-attribute" select="$nc/nc:attribute[@name=$attribute and normalize-space(@value) != '']"/>
        <xsl:choose>
            <xsl:when test="$nc-attribute">
				<xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
					<xsl:value-of select="$nc-attribute/@value"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>    
    
    <!-- Templates to synchronize global NetCDF properties such as "title" which are required in the "NetCDF Climate and Forecast
         (CF) Metadata Conventions" to ISO fields.
    -->
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'title'"/>
        </xsl:call-template>
    </xsl:template>    
    <xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'source'"/>
        </xsl:call-template>
    </xsl:template>    
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'institution'"/>
        </xsl:call-template>
    </xsl:template>    
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'email'"/>
        </xsl:call-template>
    </xsl:template>   
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints[1]/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'terms_for_use'"/>
        </xsl:call-template>
    </xsl:template>  
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString">    
		<xsl:variable name="header"><xsl:text>NetCDF metadata global attributes:
</xsl:text></xsl:variable>
        <!-- Put some info from global attributes in the abstract -->
		<xsl:variable name="abstract">
			<xsl:value-of select="$header"/>
			<xsl:for-each select="$nc/nc:attribute[@name='references' and normalize-space(@value) != '']">references: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
			<xsl:for-each select="$nc/nc:attribute[@name='comment' and normalize-space(@value) != '']">comment: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
			<xsl:for-each select="$nc/nc:attribute[@name='version' and normalize-space(@value) != '']">version: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
			<xsl:for-each select="$nc/nc:attribute[@name='disclaimer' and normalize-space(@value) != '']">disclaimer: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
			<xsl:for-each select="$nc/nc:attribute[@name='Conventions' and normalize-space(@value) != '']">Conventions: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
			<xsl:for-each select="$nc/nc:attribute[@name='history' and normalize-space(@value) != '']">history: <xsl:value-of select="@value"/><xsl:text>
</xsl:text></xsl:for-each>
		</xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($abstract) &gt; string-length($header)">
				<xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
					<xsl:value-of select="$abstract"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>  		
    </xsl:template>          
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'geospatial_lat_min'"/>
        </xsl:call-template>
    </xsl:template> 
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'geospatial_lat_max'"/>
        </xsl:call-template>
    </xsl:template>  
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'geospatial_lon_min'"/>
        </xsl:call-template>
    </xsl:template> 
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'geospatial_lon_max'"/>
        </xsl:call-template>
    </xsl:template>   
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'time_coverage_start'"/>
        </xsl:call-template>
    </xsl:template> 
    <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
        <xsl:call-template name="nc-global-attribute">
            <xsl:with-param name="attribute" select="'time_coverage_end'"/>
        </xsl:call-template>
    </xsl:template>                             
    
    <!-- TODO: templates to set values from the "iso_dataset" variable from the ADAGUC standard at
         http://adaguc.knmi.nl/contents/documents/ADAGUC_Standard.html

		These templates should have a higher priority than the above templates.
    -->
    
    <!-- TODO: create Feature Catalog -->
</xsl:stylesheet>