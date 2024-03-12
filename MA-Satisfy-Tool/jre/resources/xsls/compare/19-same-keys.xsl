<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    
    <xsl:key name="tarItem" match="root/tarF//*[@uniqueKey]" use="@uniqueKey" />
    <xsl:variable name="totalNode" select="root/tarF/total" />
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="item[not(ancestor::tarF)]">
        <xsl:variable name="ukey" select="@uniqueKey" />
        
        <xsl:choose>
            <xsl:when test="key('tarItem', $ukey)">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="key('tarItem', $ukey)/@*" />

                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="ancestor::satisfy">
                            <xsl:attribute name="t6cell1" select="." />                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:variable name="ukey" select="@uniqueKey" />
        
        <xsl:choose>
            <xsl:when test="key('tarItem', $ukey)">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="key('tarItem', $ukey)/@*" />
                    <xsl:attribute name="percent" select="key('tarItem', $ukey)/item[1]/@percent" />
                    
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="items">
        <xsl:variable name="ukey" select="@uniqueKey" />
        
        <xsl:choose>
            <xsl:when test="key('tarItem', $ukey)">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="key('tarItem', $ukey)/@*" />
                    <xsl:attribute name="percentage" select="key('tarItem', $ukey)/item[1]/@percent" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tarF">
    </xsl:template>
    
    <xsl:template match="div[parent::root]">
        <xsl:variable name="filename" select="@filename" />
        
        <xsl:copy>
            <xsl:if test="$filename = $totalNode/div/@filename">
                <xsl:apply-templates select="$totalNode/div[@filename = $filename]/@*" />
            </xsl:if>
            
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>