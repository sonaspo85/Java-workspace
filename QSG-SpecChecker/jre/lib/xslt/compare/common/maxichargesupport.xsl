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
    <xsl:variable name="chargingtype" select="$specXML/chargingtype/@type" />
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="#current" />
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
                        <xsl:for-each select="$cur/descendant::p[matches(@class, '(Description|UnorderList)')]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="langchargingnode">
                    <xsl:choose>
                        <xsl:when test="$chargingtype = 'Y'">
                            <xsl:copy-of select="$langXML/chargingsupport/items[@lang = $lang]/item[@id = 'maximumchargingsupport(y)']" />
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:copy-of select="$langXML/chargingsupport/items[@lang = $lang]/item[@id = 'maximumchargingsupport(n)']" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:if test="$langchargingnode/item/text() and 
                              matches($region, '(EUB|EUC|EUE)') and 
                              matches($Product, '^(Mobile phone|Tablet|Buds)$') and 
                              not(matches($region, 'EUC') and matches($lang, '(Ukr|Rum)'))">
                    <xsl:variable name="langchargingnode2">
                        <xsl:for-each select="$langchargingnode/*">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:choose>
                                        <xsl:when test="self::*">
                                            <xsl:apply-templates />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace(., '(\{\d+\}\s?)', '(\\d+)([,.]\\d)? ')" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:for-each>
                    </xsl:variable>

                    <xsl:variable name="idmlValue">
                        <xsl:for-each select="$idmlLists/doc/*/text()">
                            <xsl:variable name="oriCur" select="." />
                            <xsl:variable name="cur" select="replace(., '(\d+)([,.]\d)?', '(\\d+)([,.]\\d)?')" />
                            
                            <xsl:analyze-string select="$cur" regex="{$langchargingnode2}" flags="q">
                                <xsl:matching-substring>
                                    <idmlValue>
                                        <xsl:variable name="decimalunit" select="replace($oriCur, '(.*?)(\d+)([,.]\d)?(.*?)(\d+)([,.]\d)?(.*)', '$2$3-$5$6')" />
                                        <!-- <xsl:attribute name="numUnit" select="replace($oriCur, '(.*?)(\d+)([,.]\d)?(.*?)(\d+)([,.]\d)?(.*)', '$2$3-$5$6')" /> -->
                                        <xsl:attribute name="numUnit" select="replace($decimalunit, ',', '.')" />
                                        
                                        <xsl:value-of select="." />
                                    </idmlValue>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:for-each>
                    </xsl:variable>

                    <xsl:variable name="cell5">
                        <xsl:choose>
                            <xsl:when test="$idmlValue/idmlValue/node()">
                                <xsl:for-each select="$idmlValue/idmlValue">
                                    <xsl:variable name="numunit" select="@numUnit" />
                                    
                                    <xsl:variable name="langpcUnit">
                                        <xsl:for-each select="$langchargingnode2/item">
                                            <xsl:variable name="value" select="@value" />

                                            <xsl:value-of select="$value" />
                                        </xsl:for-each>
                                    </xsl:variable>

                                    <xsl:choose>
                                        <xsl:when test="$numunit = $langpcUnit">
                                            <xsl:variable name="numunit" select="@numUnit" />
                                            
                                            <xsl:variable name="splitTxt">
                                                <xsl:for-each select="$numunit">
                                                    <xsl:choose>
                                                        <xsl:when test="matches(., '-')">
                                                            <xsl:for-each select="tokenize(., '-')">
                                                                <div class="{position()-1}">
                                                                    <xsl:value-of select="."/>
                                                                </div>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <div class="0">
                                                                <xsl:value-of select="."/>
                                                            </div>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:variable>

                                            <xsl:variable name="setDecimalPos">
                                                <xsl:analyze-string select="text()" regex="(.*)(\(\\d\+\)\(\[,.\]\\d\)\?)(.*?)(\(\\d\+\)\(\[,.\]\\d\)\?)(.*)">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="regex-group(1)" />
                                                        <xsl:value-of select="'{0}'" />
                                                        <xsl:value-of select="regex-group(3)" />
                                                        <xsl:value-of select="'{1}'" />
                                                        <xsl:value-of select="regex-group(5)" />
                                                    </xsl:matching-substring>

                                                    <xsl:non-matching-substring>
                                                        <!-- <xsl:value-of select="." /> -->
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:variable>

                                            <xsl:for-each select="$setDecimalPos/text()">
                                                <xsl:choose>
                                                    <xsl:when test="self::text()">
                                                        <xsl:apply-templates select="." mode="insertUnit">
                                                            <xsl:with-param name="splitTxt" select="$splitTxt" />
                                                        </xsl:apply-templates>
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="." />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'Not Found'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Not Found'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="cell6">
                        <xsl:for-each select="$langchargingnode/*">
                            <xsl:variable name="getAttr" select="replace(@value, ',', '.')" />
                            
                            <xsl:variable name="splitTxt">
                                <xsl:for-each select="$getAttr">
                                    <xsl:choose>
                                        <xsl:when test="matches(., '-')">
                                            <xsl:for-each select="tokenize(., '-')">
                                                <div class="{position()-1}">
                                                    <xsl:value-of select="."/>
                                                </div>
                                            </xsl:for-each>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <div class="0">
                                                <xsl:value-of select="."/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="self::text()">
                                        <xsl:apply-templates select="." mode="insertUnit">
                                            <xsl:with-param name="splitTxt" select="$splitTxt" />
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>

                    <xsl:variable name="cell7">
                        <xsl:choose>
                            <xsl:when test="$idmlValue/idmlValue/node()">
                                <xsl:for-each select="$idmlValue/idmlValue">
                                    <xsl:variable name="numunit" select="@numUnit" />
                                    
                                    <xsl:variable name="langpcUnit">
                                        <xsl:for-each select="$langchargingnode2/item">
                                            <xsl:variable name="value" select="replace(@value, ',', '.')" />

                                            <xsl:value-of select="$value" />
                                        </xsl:for-each>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="$numunit = $langpcUnit">
                                            <xsl:value-of select="'Success'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'Fail'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Fail'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="cell3" select="'고속 충전 지원 사양'" />

                    <xsl:copy>
                        <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '21' else '21'" />
                        <xsl:attribute name="fileName" select="'maxichargesupport'" />
                        <xsl:apply-templates select="@*" />
                        
                        <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />

                        <!-- <bbb>
                            <xsl:copy-of select="$idmlValue" />
                        </bbb> -->
                        <!-- <aaa>
                            <xsl:copy-of select="$langchargingnode2" />
                        </aaa>
                        <ccc>
                            <xsl:copy-of select="$cell5" />
                        </ccc>

                        <ddd>
                            <xsl:copy-of select="$cell6" />
                        </ddd> -->
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template match="text()" mode="insertUnit" priority="5">
        <xsl:param name="splitTxt" />
        
        <xsl:analyze-string select="." regex="(\{{0\}})">
            <xsl:matching-substring>
                <xsl:value-of select="$splitTxt/div[@class = '0']" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(\{{1\}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="$splitTxt/div[@class = '1']" />                        
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:value-of select="." />
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
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
