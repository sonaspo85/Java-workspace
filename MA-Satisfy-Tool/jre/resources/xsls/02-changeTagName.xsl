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

    <xsl:template match="*[ancestor::*[local-name() = 'excelData']]" priority="5">
	    <xsl:variable name="tagName" select="." />
	    
	    <xsl:variable name="ch_tagName">
            <xsl:choose>
                <xsl:when test="local-name($tagName) = '구분'">
                    <xsl:value-of select="'type'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '평가항목'">
                    <xsl:value-of select="'evaluateType'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '세부_내용'">
                    <xsl:value-of select="'detail'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '업체'">
                    <xsl:value-of select="'company'" />
                </xsl:when>
                
                <xsl:when test="local-name($tagName) = '점수_자동_배점_방식'">
                    <xsl:value-of select="'scoreMethod'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="local-name($tagName)" />
                </xsl:otherwise>
            </xsl:choose>
	    </xsl:variable>
	    
	    <xsl:element name="{$ch_tagName}">
	        <xsl:apply-templates select="@*, node()" />
	    </xsl:element>
	</xsl:template>
    
</xsl:stylesheet>