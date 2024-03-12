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

    <xsl:template match="listitem">
        <xsl:for-each select="child::div">
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="value" select="@value" />
            
            <xsl:choose>
                <xsl:when test="not(node())" />
                    
                <xsl:when test="matches($value, 'type') and 
                                not(matches(., '기타 건의 사항'))">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        
                        <xsl:if test="following-sibling::div/text()">
                            <xsl:attribute name="value" select="following-sibling::div[text()]/@value" />
                        </xsl:if>
                        
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
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
