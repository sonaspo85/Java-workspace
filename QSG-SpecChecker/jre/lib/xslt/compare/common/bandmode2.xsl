<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs son xsi functx" version="2.0">

    <xsl:import href="../00-commonVar.xsl"/>

    <xsl:param name="specXMLF"/>
    <xsl:param name="langXMLF"/>

    <xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents"/>
    <xsl:strip-space elements="*"/>

    <xsl:variable name="Product" select="$specXML/product/@type"/>
    <xsl:variable name="region" select="root/@region"/>
    <xsl:variable name="specBandmode" select="root/specXML"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="root">
        <root>
            <xsl:apply-templates select="@*"/>

            <xsl:for-each select="doc">
                <xsl:variable name="curDoc" select="."/>
                <xsl:variable name="lang" select="@lang"/>

                <xsl:variable name="specFBandNode">
                    <xsl:choose>
                        <xsl:when test="$lang = 'Ukr'">
                            <xsl:copy-of select="$specBandmode/bandmode_ukr"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:copy-of select="$specBandmode/bandmode"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="bandMode">
                    <xsl:for-each select="$specFBandNode/*">
                        <xsl:variable name="cur" select="."/>

                        <xsl:element name="{'bandmode'}">
                            <xsl:apply-templates select="@*"/>

                            <xsl:for-each select="spec">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*"/>

                                    <xsl:choose>
                                        <xsl:when test="$Product = 'Watch' and
                                                        matches(@bandandmode, 'wirelesscharging')">
                                            <xsl:attribute name="supportstatus" select="'Y'"/>
                                            <xsl:apply-templates select="node()"/>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:apply-templates select="node()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:copy>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="vSupport" select="$bandMode/bandmode/spec[@supportstatus='Y']" />

                <xsl:copy>
                    <xsl:apply-templates select="@*"/>

                    <xsl:for-each select="item">
                        <xsl:variable name="curItem" select="replace(., '(\s)?(\*)', '')" />
                        
                        <xsl:variable name="specNumQty">
                            <xsl:variable name="specid" select="@specid"/>
                            <xsl:variable name="idmlnumqty" select="@idmlnumqty"/>
                            <xsl:variable name="supportstatus" select="@supportstatus"/>

                            <xsl:choose>
                                <xsl:when test="$specid = 'wcdma900/wcdma2100'">
                                    <xsl:variable name="specBand3G" select="$bandMode/bandmode/spec[@division = '3G']"/>

                                    <xsl:for-each select="$specBand3G">
                                        <xsl:if test="@supportstatus = 'Y'">
                                            <xsl:variable name="outputpower" select="@outputpower"/>

                                            <xsl:value-of select="$outputpower"/>

                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of select="','"/>
                                                </xsl:when>

                                                <xsl:otherwise>
                                                  <xsl:value-of select="''"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>

                                <xsl:when test="$specid = 'lte'">
                                    <xsl:variable name="specBand4G" select="$bandMode/bandmode/spec[@division = '4G']"/>

                                    <xsl:for-each select="$specBand4G">
                                        <xsl:variable name="curr" select="."/>

                                        <xsl:if test="@supportstatus = 'Y'">
                                            <xsl:variable name="token" select="tokenize(replace($curItem, 'LTE\s?', ''), '/')"/>

                                            <xsl:for-each select="$token">
                                                <xsl:variable name="curToken" select="."/>

                                                <xsl:if test="$curr/@bandandmode = concat('lte_', $curToken)">
                                                  <xsl:variable name="lteNDecimal" select="concat($curr/@bandandmode, ':', $curr/@outputpower)"/>

                                                  <xsl:value-of select="$lteNDecimal"/>

                                                  <xsl:choose>
                                                      <xsl:when test="position() != last()">
                                                          <xsl:value-of select="','"/>
                                                      </xsl:when>
                                                      
                                                      <xsl:otherwise>
                                                          <xsl:value-of select="''"/>
                                                      </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>

                                <xsl:when test="$specid = '5g'">
                                    <xsl:variable name="specBand5G" select="$bandMode/bandmode/spec[@division = '5G']"/>

                                    <xsl:for-each select="$specBand5G">
                                        <xsl:variable name="curr" select="."/>

                                        <xsl:if test="@supportstatus = 'Y'">
                                            <xsl:variable name="token" select="tokenize(replace($curItem, ' \(FR1\)', ''), '/')"/>

                                            <xsl:for-each select="$token">
                                                <xsl:variable name="curToken" select="."/>

                                                <xsl:if test="$curr/@bandandmode = concat($curToken, '_(FR1)')">
                                                    <xsl:variable name="g5NDecimal" select="concat(replace($curr/@bandandmode, '_\(FR1\)', ''), ':', $curr/@outputpower)"/>
  
                                                    <xsl:value-of select="$g5NDecimal"/>
  
                                                    <xsl:choose>
                                                        <xsl:when test="position() != last()">
                                                            <xsl:value-of select="','"/>
                                                        </xsl:when>
      
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="''"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>

                                <xsl:when test="not($bandMode/*/spec[@bandandmode = $specid])">
                                    <xsl:value-of select="'Not Found'"/>
                                </xsl:when>

                                <xsl:when test="$Product = 'Watch' and
                                                $bandMode/*/spec[@bandandmode = 'wirelesscharging']/@supportstatus = 'N'">
                                    <xsl:variable name="specOutpow" select="$bandMode/*/spec[@bandandmode = $specid]/@outputpower"/>
                                    <xsl:value-of select="$specOutpow"/>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:variable name="specOutpow" select="$bandMode/*/spec[@bandandmode = $specid]/@outputpower"/>
                                    <xsl:value-of select="$specOutpow"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <xsl:if test="(matches($region, '^(EUA-EUH|EUB|EUC|EUE|EU-alone)$') and $lang != '') or
                                    ($region = 'MEA' and $lang = 'Tur') or
                                    ($region = 'TURKEY' and $lang = 'Tur') or
                                    (matches($region, '(CIS|UKRAINE_ONLY|Ukr)') and matches($lang, '(Ukr|Rus)'))">

                            <div>
                                <!-- <xsl:attribute name="engLangVal" select="@engLangVal" /> -->
                                <xsl:attribute name="engLangVal" select="if (@engLangVal = '') then . else @engLangVal" />
                                <xsl:attribute name="langSpecID" select="@specid" />
                                <xsl:attribute name="idmlFlwQty" select="@idmlnumqty" />
                                <xsl:attribute name="specNumQty" select="$specNumQty"/>
                                <xsl:attribute name="supportstatus" select="@supportstatus" />
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                    
                    <!--개수 파악-->
                    <xsl:if test="(matches($region, '^(EUA-EUH|EUB|EUC|EUE|EU-alone)$')) or
                                  ($region = 'MEA' and $lang = 'Tur') or
                                  ($region = 'TURKEY' and $lang = 'Tur') or
                                  (matches($region, '(CIS|UKRAINE_ONLY|Ukr)') and matches($lang, '(Ukr|Rus)'))">
                        <xsl:if test="not(matches($region, '^(EUC)$') and matches($lang, '(Rum)'))">
                            <xsl:if test="(@rus5gcheck != 'False' or not(@rus5gcheck))">
                                <div engLangVal="Bandmode 사양 오류, Band 목록 개수 불일치" langSpecID="bandCount" validcnt="{count($vSupport)}"/>
                            </xsl:if>
                            
                        </xsl:if>
                    </xsl:if>
                    
                </xsl:copy>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:function name="son:getpath">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)"/>
    </xsl:function>

    <xsl:function name="son:last">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]"/>
    </xsl:function>

</xsl:stylesheet>
