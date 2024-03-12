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
    
    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="score" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="div[@value]" mode="score">
        <xsl:variable name="value" select="@value" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:if test="@value = $scoredb/descendant::item/@class">
                <xsl:attribute name="score" select="$scoredb/descendant::item[@class = $value]/@score" />
            </xsl:if>
            
            <xsl:apply-templates select="node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="grouped[parent::grouped/parent::satisfyexcelDB]">
        <xsl:variable name="sum" select="sum(child::div/@score)" />
        <xsl:variable name="cnt" select="count(child::div)" />
        <xsl:variable name="avg" select="$sum div $cnt" />
        
        <xsl:copy>
            <xsl:attribute name="sum" select="$sum" />
            <xsl:attribute name="avg" select="$avg" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
    
    <xsl:function name="ast:Last">
        <xsl:param name="str" />
        <xsl:param name="char" />
        
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>
