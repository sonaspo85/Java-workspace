<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@class[parent::p/parent::section][.='Description_1-Center']">
        <xsl:attribute name="class" select="concat('nested ', .)" />
    </xsl:template>

    <xsl:template match="body">
        <topic>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </topic>
    </xsl:template>
    
    <xsl:template match="chapter">
        <topic>
            <xsl:apply-templates select="@*, node()" />
        </topic>
    </xsl:template>
    
    <xsl:template match="h0">
        <title>
            <xsl:apply-templates select="@*, node()" />
        </title>
    </xsl:template>
    
    <xsl:template match="section">
        <xsl:choose>
            <xsl:when test="parent::chapter[matches(@idml, 'Troubleshooting')]">
                <xsl:sequence select="ast:group(*, 1)" />
            </xsl:when>
            
            <xsl:otherwise>
                <topic>
                    <xsl:attribute name="id" select="if (@id) then 
                                                     @id else 
                                                     concat('d', generate-id())" />
                    <!--<title class="{@class}">
                        <xsl:value-of select="@title" />
                    </title>-->
                    
                    <xsl:sequence select="ast:group(*, 1)" />
                </topic>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="h1 | h2 | h3 | h4">
        <title class="{@class}">
            <xsl:apply-templates select="@* except @class" />
            <xsl:apply-templates select="node()" />
        </title>
    </xsl:template>

    <xsl:template match="li[parent::*[matches(@class,'^(Step-UL1_1|Step-UL1_2|UL1_1|UL1_1_BlankNone|UL1_2|UL1_3|UL1-Caution-Warning|UL1-Safety)$')]]">
        <xsl:copy>
            <span class="bullet">
                <xsl:text>•&#160;&#160;</xsl:text>
            </span>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>