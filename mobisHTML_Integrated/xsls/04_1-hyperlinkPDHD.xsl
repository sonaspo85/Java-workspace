<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p Content ph"/>

    <xsl:key name="hyperlinks" match="Hyperlink" use="@Source" />
    <xsl:variable name="elms" select="//*[@hd or @pd]" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="CrossReferenceSource[string(.)]">
        <xsl:variable name="key" select="key('hyperlinks', @Self)/@DestinationUniqueKey" />
        <xsl:variable name="val" select="normalize-space(.)" />
        
        <xsl:variable name="id">
            <xsl:for-each select="$key">
                <xsl:variable name="cur" select="." />
                
                <xsl:for-each select="($elms[contains(@hd, $cur)], $elms[contains(@pd, $cur)])">
                    <xsl:if test="normalize-space(.)=$val">
                        <xsl:value-of select="@id"/>
                    </xsl:if>
                    <xsl:text>:</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        
        <a href="{concat('#', distinct-values(tokenize($id, ':')[.!=''])[1])}">
            <xsl:value-of select="." />
        </a>
    </xsl:template>

    <xsl:template match="@hd | @pd">
    </xsl:template>

</xsl:stylesheet>