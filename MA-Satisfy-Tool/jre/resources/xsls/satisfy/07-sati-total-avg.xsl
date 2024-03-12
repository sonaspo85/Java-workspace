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
            <xsl:apply-templates mode="avg" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="grouped[parent::satisfyexcelDB]" mode="avg">
        <xsl:variable name="sum" select="sum(child::grouped/@avg)" />
        <xsl:variable name="cnt" select="count(child::grouped)" />
        <xsl:variable name="avg" select="$sum div $cnt" />
        
        <xsl:variable name="calculate">
            <xsl:for-each select="$scoredb/descendant::item[@score]">
                <xsl:variable name="min" select="@min" />
                <xsl:variable name="max" select="@max" />
                <xsl:variable name="score" select="@result" />
                <xsl:variable name="vals" select="@vals" />
                
                <xsl:choose>
                    <!--<xsl:when test="$avg = 0">
                        <result>
                            <xsl:value-of select="$vals" />
                        </result>
                    </xsl:when>-->
                    
                    <xsl:when test="$min &lt;= $avg and 
                                    $avg &lt; $max">
                        <result>
                            <xsl:value-of select="$vals" />
                        </result>
                        
                        <score>
                            <xsl:value-of select="$score" />
                        </score>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
            
        <xsl:copy>
            <xsl:attribute name="sum" select="$sum" />
            <xsl:attribute name="avg" select="$avg" />
            <xsl:attribute name="result" select="$calculate/result" />
            <xsl:attribute name="score" select="$calculate/score" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="satisfyexcelDB">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="grouped">
                <xsl:sort select="number(@sum)" order="descending" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:for-each>
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
