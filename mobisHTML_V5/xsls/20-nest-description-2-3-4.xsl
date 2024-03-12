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

    <xsl:template match="ul[following-sibling::*[1][name()='img'][starts-with(@class, 'nested')]]">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="position()=last()">
                    <xsl:copy-of select="$current/following-sibling::*[1][name()='img'][starts-with(@class, 'nested')]" />
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img[starts-with(@class, 'nested')][preceding-sibling::*[1][name()='ul']]">
    </xsl:template>

    <xsl:template match="*[parent::topic][not(matches(name(), '(topic|Heading)'))][following-sibling::*[1][matches(@class, '(Step\-)?(Cmd\-)?Description_(2|3|4)')]]">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="position()=last()">
                    <xsl:copy-of select="$current/following-sibling::node()[1][matches(@class, '(Step\-)?(Cmd\-)?Description_(2|3|4)')]" />
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[parent::topic][name()!='topic'][matches(@class, '(Step\-)?Description_(2|3|4)')]">
    </xsl:template>

    <xsl:template match="*[parent::topic][name()='group']">
        <xsl:apply-templates />
    </xsl:template>
    
</xsl:stylesheet>