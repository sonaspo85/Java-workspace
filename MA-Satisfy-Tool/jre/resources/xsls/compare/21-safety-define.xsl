<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="scoredb" select="root/scoreDB" />
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="item[ancestor::safety]">
        <xsl:variable name="filename" select="parent::*/@filename" />
        <xsl:variable name="result" select="parent::*/@result" />
        <xsl:variable name="score" select="parent::*/@score" />
        <xsl:variable name="ranking" select="parent::*/@ranking" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="filename" select="$filename" />
            <xsl:attribute name="result" select="$result" />
            <xsl:attribute name="score" select="$score" />
            <xsl:attribute name="ranking" select="$ranking" />
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="grouped[@filename][ancestor::safety]">
        <xsl:apply-templates />
    </xsl:template>
    
    
</xsl:stylesheet>