<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@class[parent::p][.='nested Description_1-Center']">
        <xsl:attribute name="class" select="replace(., 'nested ', '')" />
    </xsl:template>
    
    <xsl:template match="img/@class">
        <xsl:choose>
            <xsl:when test="matches(., 'unnest Empty_1') and 
                            ends-with(., 'Img-Top-Cell')">
                <xsl:attribute name="class">block Img-Top-Cell</xsl:attribute>
            </xsl:when>
            
            <xsl:when test="matches(., 'nested Empty_(|2|3)')">
                <xsl:choose>
                    <xsl:when test="ends-with(., 'magnifier')">
                        <xsl:attribute name="class">block magnifier</xsl:attribute>
                    </xsl:when>
                    
                    <xsl:when test="ends-with(., 'magnifier_8inch')">
                        <xsl:attribute name="class">block magnifier_8inch</xsl:attribute>
                    </xsl:when>
                    
                    <xsl:when test="ends-with(., 'Img-Center')">
                        <xsl:attribute name="class">block Img-Center</xsl:attribute>
                    </xsl:when>
                    
                    <xsl:when test="ends-with(., 'Img-Top-Cell')">
                        <xsl:attribute name="class">block Img-Top-Cell</xsl:attribute>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:attribute name="class">block</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="class" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="matches(@class, 'Table_Symbol-Indent')">
                <xsl:apply-templates  />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>