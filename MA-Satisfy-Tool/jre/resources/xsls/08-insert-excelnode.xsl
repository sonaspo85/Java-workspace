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
            <xsl:apply-templates  mode="abc"/>
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="grouped[ancestor::*[matches(@id, '(tv3)')]]" mode="abc">
        <xsl:variable name="countY" select="count(item[matches(@t3cell3, 'O')])" />
        
        <xsl:copy>
            <xsl:attribute name="cntY" select="$countY" />
            <xsl:apply-templates select="@*, node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="ancestor::*[matches(@id, 'tv\d')]">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="id" select="@id" />
                <xsl:variable name="ancesId" select="ancestor::*[matches(@id, 'tv\d')]/@id" />
                <xsl:variable name="name" select="name(ancestor::*[matches(@id, $ancesId)])" />
                <xsl:variable name="scoreNode" select="$scoredb/div[matches(@class, $name)]/div[@id = $id]" />
                
                <xsl:variable name="calculate">
                    <xsl:choose>
                        <xsl:when test="$ancesId = 'tv2'">
                            <xsl:variable name="cell2" select="number($cur/@t2cell2)" />
                            <xsl:variable name="cell3" select="number($cur/@t2cell3)" />
                            
                            <xsl:for-each select="$scoreNode/item">
                                <xsl:variable name="itemCls" select="@class" />
                                <xsl:variable name="min" select="number(@min)" />
                                <xsl:variable name="max" select="number(@max)" />
                                <xsl:variable name="vals" select="@vals" />
                                
                                <xsl:choose>
                                    <xsl:when test="$id = 0">
                                        <xsl:choose>
                                            <xsl:when test="(not($max) and $max!=0) and 
                                                            $min &lt;= $cell3">
                                                <xsl:value-of select="$vals" />
                                            </xsl:when>
                                            
                                            <xsl:when test="$min &lt;= $cell3 and 
                                                            $cell3 &lt;= $max">
                                                <xsl:value-of select="$vals" />
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:when test="$id = 1">
                                        <xsl:variable name="minus" select="$cell3 - $cell2" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="(not($max) and $max!=0) and 
                                                            $min &lt;= $minus">
                                                <xsl:value-of select="$vals" />
                                            </xsl:when>
                                            
                                            <xsl:when test="$minus &lt; 0 and 
                                                            $itemCls = 'verybad'">
                                                <xsl:value-of select="$vals" />
                                                
                                            </xsl:when>
                                            
                                            <xsl:when test="$min &lt;= $minus and 
                                                            $minus &lt;= $max">
                                                <xsl:value-of select="$vals" />
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--<xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>-->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:if test="$ancesId = 'tv2'">
                        <xsl:attribute name="score" select="$calculate" />
                    </xsl:if>
                    
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:variable name="id" select="@id" />
        
        <xsl:choose>
            <xsl:when test="@cntY">
                <xsl:variable name="cnty" select="@cntY" />
                <xsl:variable name="ancesId" select="ancestor::*[matches(@id, 'tv\d')]/@id" />
                <xsl:variable name="name" select="name(ancestor::*[matches(@id, $ancesId)])" />
                <xsl:variable name="scoreNode" select="$scoredb/div[matches(@class, $name)]/div[@id = $id]" />
                
                <xsl:copy>
                    <xsl:attribute name="score" select="$scoreNode/item[@score = $cnty]/@vals" />
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>