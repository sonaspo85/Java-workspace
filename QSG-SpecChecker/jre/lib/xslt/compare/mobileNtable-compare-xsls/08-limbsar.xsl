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
        <xsl:variable name="zipName" select="@folderName" />
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

                <xsl:copy>
                    <xsl:attribute name="pos" select="8" />
                    <xsl:attribute name="fileName" select="'limbsar'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="matches($zipName, '3rd') and
                                        $lang = 'Fre(EU)'"> 
                        </xsl:when>                            
                        
                        <xsl:when test="$region = 'EUB' and
                                        $lang != 'Fre(EU)'"> 
                        </xsl:when>
                        
                        <xsl:when test="matches($region, 'EUC')"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'EUA-EUH' and
                                        $lang != 'Fre(EU)'"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'EUE' and
                                        $lang != 'Rum'">
                        </xsl:when>
                        
                        <xsl:when test="matches($region, '(CIS|Ukr)')">
                        </xsl:when>
                        
                        <xsl:when test="$region = 'MEA' and
                                        $lang != 'Tur'"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'AFRICA' and
                                        $lang != 'Eng'"> 
                        </xsl:when>
                        
                        
                        <xsl:when test="$region = 'LTN'"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'HongKong'"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'EU-alone' and
                                        not(matches($lang, '^(Fre\(EU\)|Rum)$'))"> 
                        </xsl:when>
                        
                        <xsl:when test="$region = 'SEA' and 
                                        $lang = 'Tha'">
                        </xsl:when>
                        
                        <xsl:when test="$region = 'Taiwan' and 
                                        $lang = 'Chi(Taiwan)'">
                        </xsl:when>
                        
                        <xsl:when test="$region = 'India' and 
                                        $lang = 'Eng(India)'">
                        </xsl:when>
                        
                        <xsl:when test="$region = 'Korea' and 
                                        $lang = 'Kor'">
                        </xsl:when>
                        
                        <xsl:when test="$region = 'China' and 
                                        $lang = 'Chi'">
                        </xsl:when>
                        
                        <xsl:when test="not(matches($zipName, '3rd')) and
                                        $lang = 'Fre(EU)'">
                            <xsl:variable name="vItem" select="$specXML/sars/spec[@division='Fre(EU)']" />
                            <xsl:variable name="specValue" select="$vItem/@value" />
                            
                            <xsl:variable name="specLang" select="$langXML/sars/items[@lang = $lang]/item[@id='limbsar1']" />
                            <xsl:variable name="specUnit" select="$specLang/@value" />
                            
                            <xsl:variable name="idmlValue">
                                <xsl:for-each select="$idmlLists/doc/*">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:if test="$cur = $specLang">
                                        <xsl:variable name="flwDecimalUnit" select="following-sibling::*[1]" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="matches($flwDecimalUnit, 'W/kg')">
                                                <xsl:value-of select="$flwDecimalUnit" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="'0'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="bool">
                                <xsl:variable name="oVal" select="number(replace(replace($specValue, '(\s)?W/kg', ''), ',', '.'))" />
                                <xsl:variable name="sVal" select="number(replace(replace($idmlValue, '(\s)?W/kg', ''), ',', '.'))" />
                                
                                <xsl:call-template name="returnCompareNumbers">
                                    <xsl:with-param name="oVal" select="$oVal" />
                                    <xsl:with-param name="sVal" select="$sVal" />
                                </xsl:call-template>
                            </xsl:variable>
                            
                            <xsl:variable name="cell3" select="$specLang" />
                            
                            <xsl:choose>
                                <xsl:when test="number(replace($specValue, '(\s)?W/kg', '')) = 0">
                                    <xsl:variable name="cell4" select="'Not Support'" />
                                    <xsl:variable name="cell7" select="'-'" />
                                    
                                    <div desc="{$cell3}" specXML="{$cell4}" indesignData="" langXML="''" compare="{$cell7}" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:variable name="cell4" select="$specValue" />
                                    <xsl:variable name="cell5" select="if (string-length($idmlValue) = 0) then 'Not Found' else $idmlValue" />
                                    <xsl:variable name="cell7" select="$bool" />
                                    
                                    <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
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
