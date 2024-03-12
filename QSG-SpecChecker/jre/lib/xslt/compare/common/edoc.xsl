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

    <xsl:template match="root">
        <xsl:variable name="region" select="@region" />

        <root>
            <xsl:apply-templates select="@*" />

            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />

                <xsl:variable name="idmlLists">
                    <doc>
                        <xsl:attribute name="lang" select="$lang" />
                        <xsl:for-each select="descendant::p">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="cell3" select="'eDoc 사양'" />
                <xsl:variable name="leDoc" select="$langXML/eDoc/items[@lang = $lang]/item[@id='edoc']" />
                
                <xsl:if test="$leDoc/text()">
                    <xsl:variable name="cell6" select="$leDoc/text()" />
                    
                    <!--<xsl:variable name="cell5">
                            <xsl:choose>
                                <xsl:when test="$idmlLists/doc/* = $leDoc">
                                    <xsl:value-of select="'True'" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="'Not Found'" />
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>-->
                    
                    <xsl:variable name="cell5">
                        <xsl:choose>
                            <xsl:when test="$idmlLists/doc/*[matches(., $leDoc)]">
                                <xsl:value-of select="'True'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Not Found'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="cell7">
                        <xsl:choose>
                            <xsl:when test="$cell5 = 'True'">
                                <xsl:value-of select="'Success'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Fail'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:copy>
                        <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '11' else '13'" />
                        <xsl:attribute name="fileName" select="'edoc'" />
                        <xsl:apply-templates select="@*" />
                        
                        <xsl:choose>
                            <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                <xsl:if test="matches($region, '^(EUA-EUH|EUB|EUC|EUE|EU-alone)$') or
                                              (matches($region, '(CIS|Ukr)') and matches($lang, '^(Rum|Ukr)$'))">
                                    <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                </xsl:if>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:if test="matches($region, '^(EUA-EUH|EUB|EUC|EUE|EU-alone)$') or
                                              (matches($region, '(CIS|UKRAINE_ONLY)') and matches($lang, '^(Rum|Ukr|Kaz)$'))">
                                    <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>
        </root>
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
