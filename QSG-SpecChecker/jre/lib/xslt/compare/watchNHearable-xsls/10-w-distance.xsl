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

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="root">
        <xsl:variable name="coverModelName" select="@coverModelName" />
        <xsl:variable name="zipName" select="@folderName" />
        <xsl:variable name="region" select="@region" />
        
        <xsl:variable name="Product" select="$specXML/product/@type" />
        
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

                <!--이격거리사양-->
                <xsl:copy>
                    <xsl:attribute name="pos" select="9" />
                    <xsl:attribute name="fileName" select="'w-distance'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="$region = 'EUB' and
                                        $lang = 'Fre(EU)' and 
                                        $Product = 'Watch'">
                            <xsl:variable name="vItem" select="$specXML/sars/spec[@item='distance']" />
                            <xsl:variable name="cell3" select="'이격 거리 사양'" />
                            <xsl:variable name="specEngValue" select="$langXML/w-distance/items[@lang='Eng']/item[@id='distance']" />
                            <xsl:variable name="specLang0" select="$langXML/w-distance/items[@lang=$lang]/item[@id='distance']" />
                            <xsl:variable name="specValue" select="$vItem/@value" />
                            
                            <xsl:variable name="specLang">
                                <xsl:choose>
                                    <xsl:when test="$specValue = '1.0 cm' or 
                                                    $specValue = '1.0cm'">
                                        <xsl:variable name="var0" select="replace(replace($specLang0, '0([.,])5', '1$10'), '%', '')" />
                                        <xsl:variable name="strBody" select="$langXML/sars/items[@lang = $lang]/item[@id='body-wornsar']" />
                                        <xsl:variable name="strFof" select="$langXML/sars/items[@lang = $lang]/item[@id='frontoffacesar']" />
                                        
                                        <xsl:value-of select="replace($var0, $strBody, $strFof)" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$specLang0" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="specLangDecimal" select="replace($specLang, '(.*)?(\d+)([.,])(\d+)(.*)?', '$3')" />
                            
                            <xsl:variable name="cell4">
                                <xsl:choose>
                                    <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                                    $specLang = 'N/A'">
                                        <xsl:value-of select="'Not Support'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$specValue" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="findText">
                                <xsl:choose>
                                    <xsl:when test="matches($specValue, 'cm')">
                                        <xsl:value-of select="$specLang" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:variable name="insert" select="replace(format-number(xs:decimal(replace($specValue, ' mm', '')) * 0.1, '#.#'), '(\d+)([.,]+)(\d+)', concat('$1', $specLangDecimal, '$3'))" />
                                        <xsl:value-of select="replace($specLang, '(\d)([.,])(\d)', $insert)" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            
                            <xsl:variable name="idmlValue0">
                                <xsl:for-each select="$idmlLists/doc/*">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:if test="matches($cur, $findText)">
                                        <xsl:value-of select="$findText" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="cell5">
                                <xsl:choose>
                                    <xsl:when test="string-length($idmlValue0) &gt; 0">
                                        <xsl:value-of select="$idmlValue0" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="cell6">
                                <xsl:choose>
                                    <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                                    $specLang = 'N/A'">
                                        <xsl:value-of select="''" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$specLang" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:variable>
                            
                            <xsl:variable name="cell7">
                                <xsl:choose>
                                    <xsl:when test="$cell5 != 'Not Found' and 
                                                    string-length($cell5) &gt; 0">
                                        <xsl:choose>
                                            <xsl:when test="matches($cell5, $findText)">
                                                <xsl:value-of select="'Success'" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="'Fail'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                                    $specLang = 'N/A'">
                                        <xsl:value-of select="'Pass'" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$cell5 = 'Not Found'">
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                                
                            <xsl:choose>
                                <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                                $specLang = 'N/A'">
                                    <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:copy>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template name="returnCompareNumbers">
        <xsl:param name="oVal" />
        <xsl:param name="sVal" />

        <xsl:choose>
            <xsl:when test="$oVal = $sVal">
                <xsl:value-of select="'Success'" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="'Fail'" />
            </xsl:otherwise>
        </xsl:choose>
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
