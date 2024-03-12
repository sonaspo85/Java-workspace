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
    
    <!--<xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="avg" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>-->
    
    <xsl:template match="grouped[child::div[@value]]">
        <xsl:variable name="pos" select="count(preceding-sibling::grouped)" />
        <grouped>
            <xsl:attribute name="id" select="$pos" />
            <xsl:for-each select="child::div">
                <xsl:if test="not(preceding-sibling::div)">
                    <item>
                        <xsl:attribute name="id" select="$pos" />
                        <xsl:apply-templates select="@*, node()" />
                    </item>
                </xsl:if>
            </xsl:for-each>
        </grouped>
    </xsl:template>
    
    <xsl:template match="satisfyexcelDB">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="grouped">
                <xsl:sort select="number(@avg)" order="descending" />
                
                <satisfy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="class" select="'만족도'" />
                    <xsl:attribute name="filename" select="@class" />
                    <xsl:attribute name="id" select="'tv6'" />
                    
                    
                    <items>
                        <xsl:apply-templates select="node()" />
                    </items>
                </satisfy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="scoreDB">
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
