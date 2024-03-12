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
                
                <xsl:variable name="idmlItemCnt">
                    <xsl:for-each select="child::div/@engLangVal[not(matches(parent::*/@langSpecID, '(bandCount|turwifi5)'))][string-length(.) &gt; 0]">
                        <xsl:variable name="cur" select="replace(., '\(.*\)', '')" />
                        
                        <xsl:choose>
                            <xsl:when test="count(tokenize($cur, '/')) &gt; 1">
                                <xsl:for-each select="tokenize($cur, '/')">
                                    <xsl:variable name="token" select="." />
                                    <a>
                                        <xsl:value-of select="$token" />
                                    </a>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <a>
                                    <xsl:value-of select="$cur" />
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '10' else '11'" />
                    <xsl:attribute name="fileName" select="'bandmode'" />
                    
                    <xsl:for-each select="div">
                        <xsl:variable name="bool">
                            <xsl:choose>
                                <xsl:when test="@langSpecID = 'bandCount'">
                                    <xsl:choose>
                                        <!-- <xsl:when test="count(parent::*/div[@langSpecID = '']) &gt; 0">
                                            <xsl:value-of select="'Fail'" />
                                        </xsl:when> -->

                                        <xsl:when test="count($idmlItemCnt/*) = @validcnt">
                                            <xsl:value-of select="'Success'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'Fail'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="@langSpecID = 'turwifi5'">
                                    <xsl:value-of select="@compare" />
                                </xsl:when>
                                
                                <xsl:when test="@langSpecID = 'wcdma900/wcdma2100'">
                                    <xsl:variable name="uniqueVals">
                                        <xsl:for-each select="tokenize(@specNumQty, ',')">
                                            <xsl:variable name="cur" select="number(replace(., '([W/kg|dBm|mW]+)(\s+)?', ''))" />
                                            
                                            <a>
                                                <xsl:value-of select="$cur" />
                                            </a>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="count(distinct-values($uniqueVals/a)) = 1">
                                            <xsl:variable name="sVal" select="number(replace(@idmlFlwQty, '([W/kg|dBm|mW]+)(\s+)?', ''))" />
                                            
                                            <xsl:choose>
                                                <xsl:when test="distinct-values($uniqueVals/a) = $sVal">
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
                                </xsl:when>
                                
                                <xsl:when test="matches(@langSpecID, '(lte|5g)$')">
                                    <xsl:choose>
                                        <xsl:when test="@specNumQty = @idmlFlwQty">
                                            <xsl:value-of select="'Success'" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="'Fail'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="matches(@langSpecID, '(nfc1|wirelesscharging|mst3_6khz)')">
                                    <xsl:variable name="specNumQty1">
                                        <xsl:variable name="var0">
                                            
                                            <xsl:analyze-string select="@specNumQty" regex="((\d+)([.,])?(\d+)?)">
                                                <xsl:matching-substring>
                                                    <a>
                                                        <xsl:value-of select="number(replace(regex-group(1), ',', '.'))" />
                                                    </a>
                                                </xsl:matching-substring>
                                                
                                                <xsl:non-matching-substring>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:variable>
                                        
                                        <xsl:for-each select="$var0/node()">
                                            <xsl:sort />
                                            <xsl:value-of select="." />
                                        </xsl:for-each>
                                    </xsl:variable>
                                    
                                    <xsl:variable name="idmlFlwQty1">
                                        <xsl:variable name="var0">
                                            <xsl:analyze-string select="@idmlFlwQty" regex="((\d+)([.,])?(\d+)?)">
                                                <xsl:matching-substring>
                                                    <a>
                                                        <xsl:value-of select="number(replace(regex-group(1), ',', '.'))" />
                                                    </a>
                                                </xsl:matching-substring>
                                                
                                                <xsl:non-matching-substring>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:variable>
                                        
                                        <xsl:for-each select="$var0/node()">
                                            <xsl:sort />
                                            <xsl:value-of select="." />
                                        </xsl:for-each>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="not(@specNumQty) or 
                                                        string-length(@specNumQty) = 0">
                                            <xsl:value-of select="'Not Support'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="@supportstatus = 'Y'">
                                                    <xsl:choose>
                                                        <xsl:when test="$specNumQty1 = $idmlFlwQty1">
                                                            <xsl:value-of select="'Success'" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Fail'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'Not Support'" />
                                                    <!--<xsl:value-of select="'Fail'" />-->
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="@supportstatus = 'Y'">
                                    <xsl:choose>
                                        <xsl:when test="@langSpecID = 'wifi5_9_6_4ghz'">
                                            <xsl:variable name="specVal" select="replace(@specNumQty, '[\s|/]+', '')" />
                                            <xsl:variable name="wifi5964" select="replace(@idmlFlwQty, '[\s|/]+', '')" />
                                            
                                            <xsl:choose>
                                                <xsl:when test="$specVal = $wifi5964">
                                                    <xsl:value-of select="'Success'" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'Fail'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="@specNumQty = @idmlFlwQty">
                                                    <xsl:value-of select="'Success'" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'Fail'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                 
                                <xsl:when test="not(@specNumQty) or 
                                                string-length(@specNumQty) = 0">
                                    <xsl:value-of select="'Not Support'" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="'Not Support'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="@langSpecID = 'bandCount'">
                                <xsl:choose>
                                    <xsl:when test="matches($bool, '(Fail)')">
                                        <xsl:copy>
                                            <xsl:if test="@langSpecID = 'bandCount'">
                                                <xsl:attribute name="desc" select="@engLangVal" />
                                                <xsl:attribute name="specXML" select="@validcnt" />
                                                <xsl:attribute name="indesignData" select="count($idmlItemCnt/*)" />
                                                <xsl:attribute name="langXML" select="@langXML" />
                                            </xsl:if>
                                            <xsl:attribute name="compare" select="$bool" />
                                            <xsl:apply-templates select="node()" />
                                        </xsl:copy>

                                        <xsl:if test="count(parent::*/div[@langSpecID = '']) &gt; 0">
                                            <xsl:copy>
                                                <xsl:if test="@langSpecID = 'bandCount'">
                                                    <xsl:attribute name="desc" select="'Bandmode 사양 오류, Band 수치 불일치 개수'" />
                                                    <xsl:attribute name="langSpecID" select="@langSpecID" />
                                                    <xsl:attribute name="specXML" select="''" />
                                                    <xsl:attribute name="indesignData" select="count(parent::*/div[@langSpecID = ''])" />
                                                    <xsl:attribute name="langXML" select="''" />
                                                </xsl:if>
                                                <xsl:attribute name="compare" select="$bool" />
                                                <xsl:apply-templates select="node()" />
                                            </xsl:copy>
                                        </xsl:if>
                                    </xsl:when>

                                    <xsl:when test="matches($bool, '(Success)') and 
                                                    count(parent::*/div[@langSpecID = '']) &gt; 0">
                                        <xsl:copy>
                                            <xsl:if test="@langSpecID = 'bandCount'">
                                                <xsl:attribute name="desc" select="'Bandmode 사양 오류, Band 목록 개수 불일치'" />
                                                <xsl:attribute name="langSpecID" select="@langSpecID" />
                                                <xsl:attribute name="specXML" select="''" />
                                                <xsl:attribute name="indesignData" select="count(parent::*/div[@langSpecID = ''])" />
                                                <xsl:attribute name="langXML" select="''" />
                                            </xsl:if>
                                            <xsl:attribute name="compare" select="'Fail'" />
                                            <xsl:apply-templates select="node()" />
                                        </xsl:copy>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:if test="@langSpecID = 'bandCount'">
                                                <xsl:attribute name="desc" select="'Bandmode 사양 오류, Band 수치 불일치 개수'" />
                                                <xsl:attribute name="langSpecID" select="@langSpecID" />
                                                <xsl:attribute name="specXML" select="''" />
                                                <xsl:attribute name="indesignData" select="''" />
                                                <xsl:attribute name="langXML" select="''" />
                                            </xsl:if>
                                            <xsl:attribute name="compare" select="$bool" />
                                            <xsl:apply-templates select="node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>

                            <xsl:when test="@langSpecID != 'bandCount'">
                                <xsl:copy>
                                    <xsl:attribute name="desc" select="@engLangVal" />
                                    <xsl:attribute name="specXML" select="@specNumQty" />
                                    <xsl:attribute name="indesignData" select="@idmlFlwQty" />
                                    <xsl:attribute name="langXML" select="@langXML" />
                                    <xsl:attribute name="compare" select="$bool" />
                                    <xsl:apply-templates select="node()" />
                                </xsl:copy>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </root>
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
