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
    
    <xsl:template match="satisfyexcelDB">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each-group select="div" group-by="@filename">
                <grouped class="{current-group()[1]/@filename}">
                    <xsl:attribute name="percentage" select="replace(current-group()[1]/@percentage, '(가중치\s?:\s?)(\d+)(%)', '$2')" />
                    
                    <xsl:for-each select="current-group()">
                        <xsl:copy>
                            <!--<xsl:apply-templates select="@* except @filename" />-->
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:for-each>
                </grouped>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="scoreDB">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="child::div[@class='satisfy']" />
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
