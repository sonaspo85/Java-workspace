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
    
    <xsl:template match="*[ancestor::satisfyexcelDB][parent::listitem]" priority="5">
        <xsl:variable name="tagName" select="." />
        
        <xsl:variable name="ch_tagName">
            <xsl:choose>
                <xsl:when test="local-name($tagName) = '항목'">
                    <xsl:value-of select="'type'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '전혀_그렇지_않다'">
                    <xsl:value-of select="'verybad'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '그렇지_않다'">
                    <xsl:value-of select="'bad'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '보통이다'">
                    <xsl:value-of select="'normal'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '그렇다'">
                    <xsl:value-of select="'good'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '매우_그렇다'">
                    <xsl:value-of select="'great'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="local-name($tagName)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="div">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="value" select="$ch_tagName" />
            <xsl:apply-templates select="node()" />
        </xsl:element>
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
