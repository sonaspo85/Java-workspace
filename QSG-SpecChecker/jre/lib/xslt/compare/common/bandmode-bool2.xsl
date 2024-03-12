<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    exclude-result-prefixes="xs son xsi functx"
    version="2.0">

    <xsl:import href="../00-commonVar.xsl" />

    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />

    <xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
    <xsl:strip-space elements="*" />
    
    <xsl:variable name="Product" select="$specXML/product/@type" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="doc">
        
        <xsl:choose>
            <xsl:when test="child::div[@langSpecID]">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:choose>
                    <xsl:when test="child::div[@langSpecID='bandCount'][@compare='Success']">
                        <xsl:variable name="failcnt" select="count(child::div[@compare='Fail'])" />
                        <xsl:variable name="failcnt2" select="if ($failcnt) then $failcnt else 0" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="child::div">
                                <xsl:choose>
                                    <xsl:when test="@langSpecID='bandCount'and 
                                                    @compare='Success' and 
                                                    $failcnt2 &gt; 0">
                                        <xsl:copy>
                                            <xsl:apply-templates select="@* except @langSpecID" />
                                            <xsl:attribute name="indesignData" select="$failcnt2" />
                                            <xsl:attribute name="compare" select="'Fail'" />
                                            <xsl:apply-templates select="node()" />
                                        </xsl:copy>
                                    </xsl:when>
                                    
                                    <xsl:when test="@langSpecID='bandCount'and 
                                                    @compare='Success' and 
                                                    $failcnt2 = 0">
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@fileName">
        <xsl:attribute name="fileName" select="'bandmode-bool'" />
    </xsl:template>
    
    <xsl:template match="@specID | @oArray | @sArray | @supportstatus | @validcnt | @engLangVal | @langSpecID">
    </xsl:template>

    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>

    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>
