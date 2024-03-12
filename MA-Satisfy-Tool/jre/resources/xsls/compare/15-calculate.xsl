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
    
    <xsl:template match="competitive_price">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:variable name="var0">
                <xsl:for-each select="item">
                    <xsl:sort select="replace(@t1cell3, '(\d+)(.*)', '$1')" />

                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="default" select="$scoredb/div[matches(@class, 'competitive_price')]/item/@vals" />
            
            <xsl:for-each select="$var0/item">
                <xsl:variable name="pos" select="position()" />
                <xsl:variable name="subtract" select="($pos - 1) * 10" />
                <!--<xsl:variable name="cell3" select="normalize-space(replace(@t1cell3, '(\d+)(.*)', '$1'))" />-->
                
                <xsl:variable name="score">
                    <xsl:value-of select="$default - $subtract" />
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="result" select="$score" />
                    <xsl:attribute name="t1cell4" select="$pos" />
                    <xsl:attribute name="ranking" select="$pos" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:choose>
            <xsl:when test="parent::automation">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="item">
                        <xsl:sort select="number(@score)" order="descending" />
                        <xsl:variable name="pos" select="position()" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="ranking" select="$pos" />
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="parent::*[matches(local-name(), '(safety|quality)')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="*">
                        <xsl:sort select="number(@score)" order="descending" />
                        <xsl:variable name="pos" select="position()" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="ranking" select="$pos" />
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="delivery_compliance">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="item">
                <xsl:sort select="number(@t5cell4)" order="descending" />
                <xsl:variable name="pos" select="position()" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="ranking" select="$pos" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="satisfy">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="items">
                <xsl:sort select="number(@sum)" order="descending" />
                <xsl:variable name="pos" select="position()" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="ranking" select="$pos" />
                    
                    <xsl:for-each select="item">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="t6cell1" select="." />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>