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
            <xsl:for-each-group select="*" group-starting-with="*[matches(@class,'^OL.+White$')]">
                <xsl:choose>
                    <xsl:when test="current-group()[1][not(matches(@class,'^OL.+White$'))]">
                        <xsl:apply-templates select="current-group()" />
                    </xsl:when>
                    
                    <xsl:when test="position() != last()">
                        <xsl:call-template name="not_last_group">
                            <xsl:with-param name="group" select="current-group()"/>
                        </xsl:call-template>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:call-template name="last_group">
                            <xsl:with-param name="group" select="current-group()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="not_last_group">
        <xsl:param name="group" />
        
        <xsl:for-each select="$group">
            <xsl:if test="position() = 1">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:for-each select="$group[position() &gt; 1]">
                        <xsl:if test="not(self::p[@class='Description-Symbol'])">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="last_group">
        <xsl:param name="group" />
        
        <xsl:for-each select="$group">
            <xsl:if test="position() = 1">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:for-each select="$group[position() &gt; 1][not(matches(@class,'^Description\-Symbol$'))]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
                <xsl:apply-templates select="$group[position() &gt; 1][matches(@class,'^Description\-Symbol$')]"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>