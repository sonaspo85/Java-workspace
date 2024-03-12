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
        <xsl:variable name="coverModelName" select="@coverModelName" />
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
                    <xsl:attribute name="pos" select="7" />
                    <xsl:attribute name="fileName" select="'distance'" />
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
                        
                        <!-- AST 는 주석 처리, 타사는 Tur 주석 해제 -->
                        <xsl:when test="$lang = 'Tur'">
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--validation에서 SAR 사양 확인-->
                            <xsl:variable name="sarLists" select="$specXML/sars/spec[@division = 'Common']" />
                            
                            <xsl:for-each select="$sarLists">
                                <xsl:variable name="curSpec" select="." />
                                <xsl:variable name="vItem0" select="@item" />
                                
                                <xsl:variable name="vItem">
                                    <xsl:choose>
                                        <xsl:when test="matches($Product, '(Watch|Fit)')">
                                            <xsl:choose>
                                                <xsl:when test="$vItem0 = 'headsar'">
                                                    <xsl:value-of select="'frontoffacesar'" />
                                                </xsl:when>
                                                
                                                <xsl:when test="$vItem0 = 'body-wornsar'">
                                                    <xsl:value-of select="'limbsar'" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$vItem0" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="$vItem0" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                
                                <xsl:choose>
                                    <xsl:when test="$vItem != 'distance'">
                                        <xsl:call-template name="notDistance">
                                            <xsl:with-param name="curSpec" select="." />
                                            <xsl:with-param name="vItem" select="$vItem" />
                                            <xsl:with-param name="idmlLists" select="$idmlLists" />
                                            <xsl:with-param name="lang" select="$lang" />
                                        </xsl:call-template>
                                    </xsl:when>

                                    <xsl:when test="$vItem = 'distance'">
                                        <xsl:call-template name="existDistance">
                                            <xsl:with-param name="curSpec" select="." />
                                            <xsl:with-param name="vItem" select="$vItem" />
                                            <xsl:with-param name="idmlLists" select="$idmlLists" />
                                            <xsl:with-param name="lang" select="$lang" />
                                        </xsl:call-template>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template name="notDistance">
        <xsl:param name="curSpec" />
        <xsl:param name="vItem" />
        <xsl:param name="idmlLists" />
        <xsl:param name="lang" />
        
        <xsl:variable name="specEngValue" select="$langXML/sars/items[@lang = 'Eng']/item[@id = $vItem]" />
        <xsl:variable name="specLang" select="$langXML/sars/items[@lang = $lang]/item[@id = $vItem]" />
        <xsl:variable name="specValue" select="$curSpec/@value" />
        
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
                            <xsl:value-of select="''" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="cell4">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?W/kg', '')) = 0">
                    <xsl:value-of select="'Not Support'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$specValue" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="cell5">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?W/kg', '')) = 0">
                    <xsl:value-of select="'Not Support'" />
                </xsl:when>
                
                <xsl:when test="string-length($idmlValue) = 0 or 
                                not($idmlValue)">
                    <xsl:value-of select="'Not Found'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$idmlValue" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="cell7">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?W/kg', '')) = 0">
                    <xsl:value-of select="'Pass'" />
                </xsl:when>
                
                <xsl:when test="string-length($idmlValue) = 0 or 
                                not($idmlValue)">
                    <xsl:value-of select="'Fail'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:variable name="oVal" select="number(replace(replace($specValue, '(\s)?W/kg', ''), ',', '.'))" />
                    <xsl:variable name="sVal" select="number(replace(replace($idmlValue, '(\s)?W/kg', ''), ',', '.'))" />
                    
                    <xsl:call-template name="returnCompareNumbers">
                        <xsl:with-param name="oVal" select="$oVal" />
                        <xsl:with-param name="sVal" select="$sVal" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="cell3" select="$specEngValue" />
        
        <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
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

    <xsl:template name="existDistance">
        <xsl:param name="curSpec" />
        <xsl:param name="vItem" />
        <xsl:param name="idmlLists" />
        <xsl:param name="lang" />
        
        <xsl:variable name="diSpec">
            <xsl:choose>
                <xsl:when test="matches($Product, '(Watch|Hearable|Fit)')">
                    <xsl:value-of select="'w-distance'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="'distance'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="cell3" select="'이격 거리 사양'" />
        <xsl:variable name="specEngValue" select="$langXML/*[local-name()=$diSpec]/items[@lang = 'Eng']/item[@id = $vItem]" />
        
        <xsl:variable name="specLang0" select="$langXML/*[local-name()=$diSpec]/items[@lang = $lang]/item[@id = $vItem]" />
        <xsl:variable name="specValue" select="$curSpec/@value" />
        
        <xsl:variable name="specLang">
            <xsl:choose>
                <xsl:when test="matches($Product, '(Watch|Fit)') and 
                                ($specValue = '1.0 cm' or $specValue = '1.0cm')">
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
        
        <xsl:variable name="cell4">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                $specLang = '' or 
                                string-length($specLang) = 0">
                    <xsl:value-of select="'Not Support'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$specValue" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="specValueDimens" select="replace($specValue, ' mm', '')" />
        <xsl:variable name="findText" select="replace($specLang, '(\d)([.,])(\d)', concat('$1$2', $specValueDimens))" />
        
        <xsl:variable name="idmlValue0">
            <xsl:for-each select="$idmlLists/doc/*">
                <xsl:variable name="cur" select="." />
                
                <xsl:if test="matches($cur, $findText)">
                    <xsl:variable name="before" select="substring-before($cur, $findText)" />
                    <xsl:variable name="after" select="substring-after($cur, $findText)" />
                    
                    <xsl:value-of select="normalize-space(substring-before(substring-after($cur, $before), $after))" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="cell5">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                $specLang = '' or 
                                string-length($specLang) = 0">
                    <xsl:value-of select="''" />
                </xsl:when>
                
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
                                $specLang = '' or 
                                string-length($specLang) = 0">
                    <xsl:value-of select="''" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$specLang" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="cell7">
            <xsl:choose>
                <xsl:when test="number(replace($specValue, '(\s)?mm', '')) = 0 or 
                                $specLang = 'N/A' or 
                                string-length($specLang) = 0">
                    <xsl:value-of select="'Pass'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$cell5 != 'Not Found' and 
                                        string-length($cell5) &gt; 0">
                            <xsl:variable name="oVal" select="$findText" />
                            <xsl:variable name="sVal" select="$cell5" />
                            
                            <xsl:choose>
                                <xsl:when test="matches($sVal, $oVal)">
                                    <xsl:value-of select="'Success'" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="'Fail'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Fail'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
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
