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

    <xsl:template match="*[matches(@class, '^Step-UL1_2$')]">
        <xsl:choose>
            <xsl:when test="*[matches(@class, 'Step-Description_2')][not(following-sibling::*)]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                <xsl:copy-of select="*[not(following-sibling::*)][matches(@class, 'Step-Description_2')]" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[matches(@class, 'Step-Description_2')][not(following-sibling::*)][parent::*[matches(@class, '^Step-UL1_2$')]]">
    </xsl:template>
    
    <xsl:template match="*[parent::topic][name()!='topic'][contains(@class, 'Color')][following-sibling::*[1][not(contains(@class, 'Color'))]]">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="position()=last()">
                    <xsl:call-template name="nesting">
                        <xsl:with-param name="current" select="$current/following-sibling::*[1]" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="nesting">
        <xsl:param name="current" />
        
        <xsl:choose>
            <xsl:when test="not(contains($current/@class, 'Color')) and following-sibling::*">
                <xsl:sequence select="$current" />
                <xsl:if test="$current/following-sibling::*[1][not(contains(@class, 'Color'))]">
                    <xsl:call-template name="nesting">
                        <xsl:with-param name="current" select="$current/following-sibling::*[1]" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[parent::topic][name()!='topic'][not(contains(@class,'Color'))][preceding-sibling::*[contains(@class, 'Color')]][following-sibling::*[contains(@class, 'Color')]]">
    </xsl:template>

</xsl:stylesheet>