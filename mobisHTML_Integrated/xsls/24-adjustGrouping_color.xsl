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

    <xsl:template match="topic[p|ul]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each-group select="*" group-adjacent="ends-with(@class, 'Color')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <group class="color">
                            <xsl:if test="current-group()[position() = last()][@*[matches(name(), 'video')]]">
                                <xsl:variable name="lastNodeAttr" select="current-group()[last()]/@* except @class" />
                                
                                <xsl:apply-templates select="$lastNodeAttr" />
                            </xsl:if>
                            <xsl:apply-templates select="current-group()" mode="color"/>
                        </group>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[contains(@class,'Color')]" mode="color">
        <li>
            <xsl:apply-templates select="@* except @*[matches(name(), 'video')]" />
            <xsl:apply-templates select="node()" />
        </li>
    </xsl:template>

</xsl:stylesheet>