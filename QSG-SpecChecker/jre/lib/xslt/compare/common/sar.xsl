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

                <xsl:variable name="specFBodyworn" select="$specXML/sars/spec[@division = 'Common'][@item = 'body-wornsar']/@value" />
                <xsl:variable name="specFBodywornTxt" select="number(replace($specFBodyworn, '(\s)?W/kg', ''))" />
                <!-- <xsl:variable name="specFHeadsar" select="$specXML/sars/spec[@division = $lang][@item = 'headsar']/@value" /> -->
                <xsl:variable name="specFHeadsar" select="$specXML/sars/spec[@division = 'Common'][@item = 'headsar']/@value" />
                <xsl:variable name="specFHeadsarTxt" select="number(replace($specFHeadsar, '(\s)?W/kg', ''))" />

                <xsl:variable name="specFSpecItem">
                    <xsl:choose>
                        <xsl:when test="$region = 'SEA' and
                                        $lang = 'Tha'">
                            <xsl:choose>
                                <xsl:when test="$specFBodywornTxt >= $specFHeadsarTxt">
                                    <xsl:copy-of select="$specXML/sars/spec[@division = 'Common'][@item = 'body-wornsar']" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:copy-of select="$specXML/sars/spec[@division = 'Common'][@item = 'headsar']" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$specXML/sars/spec[@division = $lang]">
                            <xsl:choose>
                                <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                    <xsl:copy-of select="$specXML/sars/spec[@division = $lang][@item = 'headsar']" />
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:copy-of select="$specXML/sars/spec[@division = 'Common'][@item = 'headsar']" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:copy-of select="$specXML/sars/spec[@division = 'Common'][@item = 'headsar']" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="langFSarItem">
                    <xsl:choose>
                        <xsl:when test="$lang = 'Tha'">
                            <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'body-wornsar']" />
                        </xsl:when>
                        
                        <xsl:when test="$lang = 'Chi(Taiwan)'">
                            <xsl:choose>
                                <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                    <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'headsar']" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'body-wornsar']" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:when test="$lang = 'Eng(India)'">
                            <xsl:choose>
                                <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                    <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'headsar']" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'body-wornsar']" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:when test="$lang = 'Kor'">
                            <xsl:variable name="specItem" select="$langXML/distance/items[@lang = $lang]/item[@id = 'distance']" />
                            <xsl:variable name="specItemTxt" select="replace($specItem, '몸통', '머리')" />
                            
                            <xsl:choose>
                                <xsl:when test="$Product = 'Watch'">
                                    <xsl:copy-of select="replace($specItemTxt, '1\.5', '1.0')" />
                                </xsl:when>
                                
                                <xsl:when test="$Product = 'Hearable'">
                                    <xsl:copy-of select="replace($specItemTxt, '1\.5', '0')" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:copy-of select="$langXML/distance/items[@lang = $lang]/item[@id = 'distance']" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="$langXML/sars/items[@lang = $lang]/item[@id = 'body-wornsar']" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="specFSpecVal" select="$specFSpecItem/spec/@value" />

                <xsl:variable name="cell3">
                    <xsl:choose>
                        <xsl:when test="$lang = 'Tha'">
                            <xsl:value-of select="'SAR 사양'" />
                        </xsl:when>

                        <xsl:when test="$lang = 'Chi(Taiwan)'">
                            <xsl:value-of select="'Head SAR'" />
                        </xsl:when>

                        <xsl:when test="$lang = 'Eng(India)'">
                            <xsl:value-of select="'Head SAR 사양'" />
                        </xsl:when>

                        <xsl:when test="$lang = 'Kor'">
                            <xsl:value-of select="'이격 거리 사양'" />
                        </xsl:when>

                        <xsl:when test="$lang = 'Chi'">
                            <xsl:value-of select="'Body-worn SAR'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'SAR 사양'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="findTxt1" select="concat($langFSarItem/*/text(), ' ', replace($specFSpecVal, ',', '.'))" />
                <xsl:variable name="chiSarVal" select="'2.0 W/kg'" />

                <xsl:variable name="idmlValue">
                    <xsl:for-each select="$idmlLists/doc/*">
                        <xsl:variable name="cur" select="." />

                        <xsl:choose>
                            <xsl:when test="$lang = 'Tha' or
                                            $lang = 'Chi(Taiwan)'">
                                <!-- <xsl:choose>
                                    <xsl:when test="matches($cur, $findTxt1)">
                                        <xsl:variable name="before" select="substring-before($cur, $findTxt1)" />
                                        <xsl:variable name="after" select="substring-after($cur, $findTxt1)" />
                                        
                                        <xsl:value-of select="normalize-space(substring-before(substring-after($cur, $before), $after))" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:otherwise>
                                </xsl:choose> -->
                                <xsl:if test="matches($cur, $findTxt1)">
                                    <xsl:variable name="before" select="substring-before($cur, $findTxt1)" />
                                    <xsl:variable name="after" select="substring-after($cur, $findTxt1)" />
                                        
                                    <xsl:value-of select="normalize-space(substring-before(substring-after($cur, $before), $after))" />
                                </xsl:if>
                            </xsl:when>

                            <xsl:when test="$lang = 'Eng(India)'">
                                <xsl:if test="$cur = $langFSarItem">
                                    <xsl:variable name="flwDecimalUnit" select="$cur/following-sibling::*[1]" />

                                    <xsl:choose>
                                        <xsl:when test="matches($flwDecimalUnit, 'W/kg')">
                                            <xsl:value-of select="$flwDecimalUnit" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'Not Found'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:when>

                            <xsl:when test="$lang = 'Kor'">
                                <xsl:if test="$cur = $langFSarItem">
                                    <xsl:value-of select="$langFSarItem" />
                                </xsl:if>
                            </xsl:when>

                            <xsl:when test="$lang = 'Chi'">
                                <xsl:if test="matches($cur, $langFSarItem)">
                                    <xsl:variable name="before" select="replace(replace(substring-before($cur, concat($langFSarItem, ' ', $chiSarVal)), '\(', '\\('), '\)', '\\)')" />
                                    <xsl:variable name="after" select="replace(replace(substring-after($cur, concat($langFSarItem, ' ', $chiSarVal)), '\(', '\\('), '\)', '\\)')" />

                                    <xsl:choose>
                                        <xsl:when test="string-length($before) &gt; 0 and 
                                                        string-length($after) &gt; 0">
                                            <xsl:analyze-string select="$cur" regex="({$before})(.*)({$after})">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="regex-group(2)"/>
                                                </xsl:matching-substring>
                                                
                                                <xsl:non-matching-substring>
                                                    <xsl:value-of select="''" />
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="'Not Found'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="'Not Found'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="cell4">
                    <xsl:choose>
                        <xsl:when test="not(matches($Product, '^(Mobile phone|Tablet)$'))">
                            <xsl:choose>
                                <xsl:when test="$lang = 'Tha' or 
                                                $lang = 'Chi(Taiwan)'">
                                    <xsl:choose>
                                        <xsl:when test="number(replace($specFSpecVal, '(\s)?W/kg', '')) = 0">
                                            <xsl:value-of select="'Not Support'" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="$specFSpecVal" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$lang = 'Kor'">
                                    <xsl:value-of select="''" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="$specFSpecVal" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="$specFSpecVal" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="cell5">
                    <xsl:choose>
                        <xsl:when test="string-length($idmlValue) &gt; 0 and 
                                        not(matches($idmlValue, 'Not Found'))">
                            <xsl:choose>
                                <xsl:when test="$langFSarItem/*/text()">
                                    <xsl:value-of select="normalize-space(replace($idmlValue, $langFSarItem/*/text(), ''))" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="$idmlValue" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'Not Found'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="bool">
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$') and 
                                        $region = 'China' and
                                        $lang = 'Chi'">
                            <xsl:call-template name="returnCompareNumbers">
                                <xsl:with-param name="oVal" select="$chiSarVal" />
                                <xsl:with-param name="sVal" select="$cell5" />
                            </xsl:call-template>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:variable name="oVal" select="number(replace(replace($specFSpecVal, '(\s)?W/kg', ''), ',', '.'))" />
                            <xsl:variable name="sVal" select="number(replace(replace($cell5, '(\s)?W/kg', ''), ',', '.'))" />
                            
                            <xsl:call-template name="returnCompareNumbers">
                                <xsl:with-param name="oVal" select="$oVal" />
                                <xsl:with-param name="sVal" select="$sVal" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                    
                <xsl:copy>
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '6' else '5'" />
                    <xsl:attribute name="fileName" select="'sar'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:choose>
                                <xsl:when test="$region = 'SEA' and
                                                $lang = 'Tha'">
                                    <!--Body-worn SAR 수치만 기재, 이격 거리 제외-->
                                    <xsl:choose>
                                        <xsl:when test="number(replace($specFSpecVal, '(\s)?W/kg', '')) = 0">
                                            <!--SAR 전용 사양 미지원-->
                                            <div desc="{$cell3}" specXML="Not Support" indesignData="" langXML="" compare="-" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$idmlValue}" compare="{$bool}" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$region = 'Taiwan' and 
                                                $lang = 'Chi(Taiwan)'">
                                    <!--전용 SAR 검증-->
                                    <xsl:choose>
                                        <xsl:when test="number(replace($specFSpecVal, '(\s)?W/kg', '')) = 0">
                                            <!--SAR 전용 사양 미지원-->
                                            <div desc="{$cell3}" specXML="Not Support" indesignData="" langXML="" compare="-" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$idmlValue}" compare="{$bool}" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$region = 'India' and
                                                $lang = 'Eng(India)'"> 
                                    <!--1g SAR, 이격거리 제외-->
                                    <xsl:choose>
                                        <xsl:when test="number(replace($specFSpecVal, '(\s)?W/kg', '')) = 0">
                                            <!--SAR 전용 사양 미지원-->
                                            <div desc="{$cell3}" specXML="Not Support" indesignData="" langXML="" compare="-" />
                                        </xsl:when>
                                        
                                        <xsl:when test="string-length($idmlValue) &gt; 0">
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$bool}" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="Fail" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$region = 'China' and
                                                $lang = 'Chi'"> 
                                    <!--중국향 Body Worm SAR 전용 사양 검증-->
                                    <xsl:choose>
                                        <xsl:when test="number($specFHeadsarTxt) = 0 and
                                                        number($specFBodywornTxt) = 0">
                                            <!--SAR 전용 사양 미지원-->
                                            <div desc="{$cell3}" specXML="Not Support" indesignData="" langXML="" compare="-" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$chiSarVal}" indesignData="{$cell5}" langXML="{$langFSarItem}" compare="{$bool}" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$region = 'Korea' and
                                                $lang = 'Kor'">
                                    <!--국판향 이격 거리 전용 사양-->
                                    <xsl:choose>
                                        <xsl:when test="string-length($idmlValue) &gt; 0">
                                            <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$langFSarItem/*/text()}" compare="Success" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$langFSarItem/*/text()}" compare="Fail" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$region = 'SEA' and
                                                $lang = 'Tha'">
                                    <xsl:choose>
                                        <xsl:when test="number(replace($specFSpecVal, '(\s)?W/kg', '')) = 0">
                                            <!--SAR 전용 사양 미지원-->
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="" langXML="" compare="'Pass'" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$idmlValue}" compare="{$bool}" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="$region = 'Korea' and
                                                $lang = 'Kor'">
                                    <xsl:choose>
                                        <xsl:when test="string-length($idmlValue) &gt; 0">
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$idmlValue}" compare="Success" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$idmlValue}" compare="Fail" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
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
