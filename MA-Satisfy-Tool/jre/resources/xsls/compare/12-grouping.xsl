<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="root">
        <root>
            <xsl:for-each-group select="child::div/dbtempls/*" group-by="name()">
                <sameGroup>
                    <xsl:apply-templates select="current-group()" />
                </sameGroup>
            </xsl:for-each-group>
            
            <xsl:copy-of select="child::scoreDB" />
        </root>
    </xsl:template>
    
    <xsl:template match="*[parent::dbtempls]">
        <xsl:copy>
            <xsl:attribute name="filename" select="ancestor::div/@filename" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:choose>
            <xsl:when test="not(ancestor::safety)">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>