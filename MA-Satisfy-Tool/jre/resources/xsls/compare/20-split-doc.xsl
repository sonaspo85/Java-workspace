<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>

    <xsl:param name="tempDir" />
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="root">
        <xsl:for-each select="div">
            <xsl:variable name="filename" select="@filename" />
            
            <xsl:variable name="fullpath" select="concat('file:////', $tempDir, '/db/', $filename)" />
            
            <xsl:result-document href="{$fullpath}">
                <root>
                    <xsl:apply-templates select="@*, node()" />
                </root>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="item | grouped | items">
        <xsl:copy>
            <xsl:apply-templates select="@* except @filename" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="satisfy">
        <xsl:copy>
            <xsl:attribute name="class" select="@class" />
            <xsl:attribute name="id" select="@id" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@uniqueKey">
    </xsl:template>
    
</xsl:stylesheet>