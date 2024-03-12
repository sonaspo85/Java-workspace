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
                        <xsl:for-each select="descendant::p[@class='Description_UpSp1']">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>

                <xsl:variable name="langBis">
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:value-of select="$langXML/indiabis/items[@lang = $lang]/item" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Depending on the region or model, some devices are required to receive approval from the Bureau of Indian Standards (BIS).'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="idmlValue">
                    <xsl:variable name="var0">
                        <xsl:choose>
                            <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                <xsl:choose>
                                    <xsl:when test="$idmlLists/doc/*[. = $langBis]">
                                        <a>
                                            <xsl:value-of select="$idmlLists/doc/*[. = $langBis]" />
                                        </a>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <a>
                                            <xsl:value-of select="'Not Found'" />
                                        </a>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:for-each select="$idmlLists/doc/*">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:if test="contains(., $langBis)">
                                        <xsl:value-of select="$cur[contains(., $langBis)]" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <cell5>
                        <xsl:choose>
                            <xsl:when test="$var0 = 'Not Found' or 
                                            string-length($var0) = 0">
                                <xsl:value-of select="'Not Found'" />
                            </xsl:when>
                            
                            <xsl:when test="not($var0)">
                                <xsl:value-of select="'Not Found'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                        <xsl:value-of select="$var0/a" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'True'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </cell5>
                    
                    <bool>
                        <xsl:choose>
                            <xsl:when test="$var0 = 'Not Found' or 
                                            string-length($var0) = 0">
                                <xsl:value-of select="'Fail'" />
                            </xsl:when>
                            
                            <xsl:when test="not($var0)">
                                <xsl:value-of select="'Not Found'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Success'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </bool>
                </xsl:variable>
                
                <xsl:variable name="cell3" select="'India BIS 사양'" />
                <xsl:variable name="cell5" select="$idmlValue/cell5" />
                <xsl:variable name="cell6" select="$langBis" />
                <xsl:variable name="cell7" select="$idmlValue/bool" />
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '17' else '15'" />
                    <xsl:attribute name="fileName" select="'indiabis'" />
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:if test="$region = 'India' and 
                                  $lang = 'Eng(India)' and 
                                  matches($Product, '^(Mobile phone|Watch|Fit)$')">
                        <!--India Bis 문구 확인-->
                        
                        <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                    </xsl:if>
                </xsl:copy>
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
