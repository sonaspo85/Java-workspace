<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="5">
        <xsl:value-of select="if ( not(following-sibling::node()) ) then 
                              replace(., '\s+$', ' ') else 
                              ." />
    </xsl:template>

    <xsl:template match="img[parent::chapter]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="br[parent::*[matches(@class, '(Chapter|Heading\d+|H1)')]]" />
    
    <xsl:template match="span[matches(@class, 'C_URL')][a[ends-with(., '.')]]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:if test="self::a[ends-with(., '.')]">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        <xsl:value-of select="replace(., '(.)$', '')" />
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
        <xsl:text>.</xsl:text>
    </xsl:template>

</xsl:stylesheet>