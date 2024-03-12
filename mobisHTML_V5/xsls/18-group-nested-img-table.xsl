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

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic[parent::topic]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-adjacent="starts-with(@class, 'nested')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <group>
                            <xsl:apply-templates select="current-group()"/>
                        </group>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>