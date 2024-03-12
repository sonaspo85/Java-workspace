<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="title li p" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic">
        <topic>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-adjacent="starts-with(@class, 'UL1-Caution-Warning')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ul>
                            <xsl:apply-templates select="current-group()/@class"/>
                            <xsl:apply-templates select="current-group()/node()"/>
                        </ul>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </topic>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>