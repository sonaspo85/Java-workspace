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
        <xsl:variable name="countY" select="count(child::item[matches(lower-case(@t3cell4), '^o$')])" />
        
        <xsl:copy>
            <xsl:attribute name="cntY" select="if (number($countY) &gt; 0) then $countY else 0" />
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
                            <xsl:variable name="cell3" select="if ($cur/@t2cell3 != '') then number($cur/@t2cell3) else 0" />
                            <xsl:variable name="cell4" select="number($cur/@t2cell4)" />
                            
                            <xsl:for-each select="$scoreNode/item">
                                <xsl:variable name="itemCls" select="@class" />
                                <xsl:variable name="min" select="number(@min)" />
                                <xsl:variable name="max" select="number(@max)" />
                                <xsl:variable name="vals" select="@vals" />
                                <xsl:variable name="score" select="@score" />
                                
                                <xsl:choose>
                                    <xsl:when test="$id = 0">
                                        <xsl:choose>
                                            <xsl:when test="(not($max) and $max!=0) and 
                                                            $min &lt;= $cell4">
                                                <vals>
                                                    <xsl:value-of select="$vals" />
                                                </vals>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                            
                                            <xsl:when test="$min &lt;= $cell4 and 
                                                            $cell4 &lt; $max">
                                                <vals>
                                                    <xsl:value-of select="$vals" />
                                                </vals>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:when test="$id = 1">
                                        <xsl:variable name="minus" select="$cell4 - $cell3" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="(not($max) and $max!=0) and 
                                                            $min &lt;= $minus">
                                                <vals>
                                                    <xsl:value-of select="$vals" />
                                                </vals>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                            
                                            <xsl:when test="$minus &lt; 0 and 
                                                            $itemCls = 'verybad'">
                                                <vals>
                                                    <xsl:value-of select="$vals" />
                                                </vals>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                            
                                            <xsl:when test="$min &lt;= $minus and 
                                                            $minus &lt;= $max">
                                                <vals>
                                                    <xsl:value-of select="$vals" />
                                                </vals>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
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
                    <xsl:apply-templates select="@*" />
                    <xsl:if test="$ancesId = 'tv2'">
                        <xsl:attribute name="t2cell5" select="$calculate/vals" />
                        <xsl:attribute name="score" select="$calculate/score" />
                    </xsl:if>
                    
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
    
    <xsl:template match="grouped">
        <xsl:variable name="id" select="@id" />
        
        <xsl:choose>
            <xsl:when test="@cntY">
                <xsl:variable name="cnty" select="number(@cntY)" />
                <xsl:variable name="ancesId" select="ancestor::*[matches(@id, 'tv\d')]/@id" />
                <xsl:variable name="name" select="name(ancestor::*[matches(@id, $ancesId)])" />
                
                <xsl:variable name="scoreNode">
                    <xsl:for-each select="$scoredb/div[matches(@class, $name)]/div[@id = $id]/item">
                        <xsl:variable name="itemCls" select="@class" />
                        <xsl:variable name="min" select="number(@min)" />
                        <xsl:variable name="max" select="number(@max)" />
                        <xsl:variable name="vals" select="@vals" />
                        <xsl:variable name="score" select="@score" />
                        
                        <xsl:choose>
                            <xsl:when test="$min &lt;= $cnty and 
                                            $cnty &lt;= $max">
                                <vals>
                                    <xsl:value-of select="$vals" />
                                </vals>
                                <score>
                                    <xsl:value-of select="$score" />
                                </score>
                            </xsl:when>
                            
                            <xsl:when test="not($max) and 
                                            $min = $cnty">
                                <vals>
                                    <xsl:value-of select="$vals" />
                                </vals>
                                <score>
                                    <xsl:value-of select="$score" />
                                </score>
                            </xsl:when>

                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:apply-templates select="@* except @cntY" />
                    <xsl:attribute name="result" select="$scoreNode/vals" />
                    <xsl:attribute name="score" select="$scoreNode/score" />
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
    
    
</xsl:stylesheet>