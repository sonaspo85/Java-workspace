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
    
    <xsl:variable name="region" select="root/@region" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <root>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:variable name="specFBandNode">
                    <xsl:choose>
                        <xsl:when test="$lang = 'Ukr'">
                            <xsl:copy-of select="$specXML/bandmode_ukr" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="$specXML/bandmode" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="bandMode">
                    <xsl:for-each select="$specFBandNode/*">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:element name="{'bandmode'}">
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="spec">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    
                                    <xsl:choose>
                                        <xsl:when test="$Product = 'Watch' and 
                                                        matches(@bandandmode, 'wirelesscharging')">
                                            <xsl:attribute name="supportstatus" select="'Y'" />
                                            <xsl:apply-templates select="node()" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="node()" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:copy>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="getSupportY">
                    <xsl:for-each select="$bandMode/*/spec[@supportstatus='Y']">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:copy>
                            <xsl:attribute name="supportstatus" select="@supportstatus" />
                            
                            <xsl:choose>
                                <xsl:when test="matches(@bandandmode, '^lte')">
                                    <xsl:choose>
                                        <xsl:when test="preceding-sibling::*[matches(@bandandmode, '^lte')]">
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:attribute name="bandandmode" select="'lte'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="matches(@division, '^5G$')">
                                    <xsl:choose>
                                        <xsl:when test="preceding-sibling::*[matches(@division, '^5G$')]">
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:attribute name="bandandmode" select="'5g'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:attribute name="bandandmode" select="@bandandmode" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="idmlLists">
                    <doc>
                        <xsl:attribute name="lang" select="$lang" />
                        <xsl:for-each select="*">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="langBandItem" select="$langXML/bandmode/items[@lang = $lang]/item" />
                <xsl:variable name="lOutput" select="$langXML/bandmode/items[@lang = $lang]/item[@id='bandandmode']" />
                
                <xsl:variable name="getRusBandTable0">
                    <xsl:for-each select="$idmlLists/doc[@lang = $lang]/descendant::*">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:if test="$cur[text() = $lOutput] and
                                      ancestor::tr[1][count(preceding-sibling::tr) + 1 = 1]">
                            <xsl:variable name="bandTable" select="ancestor::Table[1]/tr" />
                            
                            <xsl:copy-of select="$bandTable" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="rus5gcheck">
                    <xsl:choose>
                        <xsl:when test="matches($lang, 'Rus')">
                            <xsl:choose>
                                <xsl:when test="$getRusBandTable0/*">
                                    <xsl:for-each select="$getRusBandTable0/tr[position() &gt; 1]/td[1]//text()">
                                        <xsl:variable name="cur" select="." />

                                        <xsl:if test="$cur = '5G'">
                                            <xsl:value-of select="'True'" />
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:value-of select="'False'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="getRusBandTable1">
                    <xsl:for-each select="$getRusBandTable0/*[position() &gt; 1]">
                        <xsl:variable name="cur" select="." />
                        
                        <tr>
                            <xsl:for-each select="td">
                                <xsl:variable name="name" select="@Name" />
                                
                                <xsl:choose>
                                    <xsl:when test="$lang = 'Rus'">
                                        <xsl:if test="current()[not(matches(@Name, '^0'))]">
                                            <p>
                                                <xsl:attribute name="name" select="$name" />
                                                <xsl:for-each select="current()[not(matches(@Name, '^0'))]/*">
                                                    <xsl:apply-templates select="node()" />
                                                </xsl:for-each>
                                            </p>
                                        </xsl:if>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <p>
                                            <xsl:attribute name="name" select="$name" />
                                            <xsl:for-each select="*">
                                                <xsl:apply-templates select="node()" />
                                                
                                                <xsl:choose>
                                                    <xsl:when test="position() != last() and 
                                                                    not(matches(., '\s+$'))">
                                                        <xsl:value-of select="' '" />
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="''" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="getRusBandTable2">
                    <xsl:for-each select="$getRusBandTable1/tr/*">
                        <xsl:variable name="cur" select="replace(., '(\s)?(\*)', '')" />
                        <xsl:variable name="name" select="@name" />
                        <xsl:variable name="rowNum" select="number(tokenize($name, ':')[1])" />
                        
                        <xsl:variable name="rowNum1">
                            <xsl:choose>
                                <xsl:when test="$lang = 'Rus'">
                                    <xsl:value-of select="1" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="0" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="$rowNum = $rowNum1">
                                <xsl:variable name="engLangVal">
                                    <xsl:choose>
                                        <xsl:when test="matches($cur, '(LTE|FR1)')">
                                            <xsl:value-of select="$cur" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($cur, '\d{3}[.,]\d{2}\skHz(.+)\d{3}\skHz')">
                                            <!--<xsl:value-of select="replace($cur, '\s110[.,]01\skHz(.+)148\skHz', '')" />-->
                                            <xsl:value-of select="$cur" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($cur, '(WCDMA Band VIII|WCDMA Band I)')">
                                            <xsl:value-of select="$cur" />
                                        </xsl:when>

                                        <!-- <xsl:when test="matches($cur, '(Uniquement dans)')">
                                            <xsl:value-of select="$cur" />
                                        </xsl:when> -->

                                        <xsl:otherwise>
                                            <xsl:for-each select="$langBandItem">
                                                <xsl:variable name="langItemVal" select="." />
                                                <xsl:variable name="langEngItem" select="$langXML/bandmode/items[@lang = 'Eng']/item[@id=$langItemVal/@id]" />

                                                <!-- <xsl:if test="$langItemVal = $cur">
                                                    <xsl:choose>
                                                        <xsl:when test="$langItemVal/@id = '5g'">
                                                            <xsl:value-of select="upper-case($langItemVal/@id)" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$langEngItem" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if> -->

                                                <xsl:choose>
                                                    <xsl:when test="$langItemVal = $cur">
                                                        <xsl:choose>
                                                            <xsl:when test="$langItemVal/@id = '5g'">
                                                                <xsl:value-of select="upper-case($langItemVal/@id)" />
                                                            </xsl:when>
                                                            
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$langEngItem" />
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>

                                                    <!-- <xsl:otherwise>
                                                        <xsl:value-of select="$langItemVal" />
                                                        <xsl:text> / </xsl:text>
                                                        <xsl:value-of select="$cur" />
                                                    </xsl:otherwise> -->
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                
                                <xsl:variable name="specID">
                                    <xsl:choose>
                                        <xsl:when test="matches($cur, 'LTE')">
                                            <xsl:value-of select="'lte'" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($cur, '\d{3}[.,]\d{2}\skHz(.+)\d{3}\skHz')">
                                            <xsl:value-of select="'wirelesscharging'" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($cur, 'FR1')">
                                            <xsl:value-of select="'5g'" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:for-each select="$langBandItem">
                                                <xsl:variable name="langItemVal" select="." />
                                                
                                                <xsl:if test="$langItemVal = $cur">
                                                    <xsl:choose>
                                                        <xsl:when test="$langItemVal = 'WCDMA Band VIII' or 
                                                                        $langItemVal = 'WCDMA Band I'">
                                                            <xsl:value-of select="$langItemVal/@id" />
                                                        </xsl:when>
                                                        
                                                        <xsl:when test="$langItemVal/@id = '5g'">
                                                            <xsl:value-of select="$langItemVal/@id" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$langItemVal/@id" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:variable name="idmlNumQty">
                                    <xsl:choose>
                                        <xsl:when test="matches($cur, 'LTE')">
                                            <xsl:variable name="token" select="tokenize(replace($cur, 'LTE\s?', ''), '/')" />
                                            <xsl:variable name="flwDecimalVal" select="following-sibling::*[1]" />
                                            
                                            <xsl:for-each select="$token">
                                                <xsl:value-of select="concat('lte_', ., ':', $flwDecimalVal)" />
                                                
                                                <xsl:choose>
                                                    <xsl:when test="position() != last()">
                                                        <xsl:value-of select="','" />
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="''" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($cur, 'FR1')">
                                            <xsl:variable name="token" select="tokenize(replace($cur, ' \(FR1\)', ''), '/')" />
                                            <xsl:variable name="flwDecimalVal" select="following-sibling::*[1]" />
                                            
                                            <xsl:for-each select="$token">
                                                <xsl:value-of select="concat(., ':', $flwDecimalVal)" />
                                                
                                                <xsl:choose>
                                                    <xsl:when test="position() != last()">
                                                        <xsl:value-of select="','" />
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="''" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="following-sibling::*[1]" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:variable name="supportstatus">
                                    <xsl:choose>
                                        <xsl:when test="$getSupportY/*[@bandandmode = $specID]">
                                            <xsl:value-of select="$getSupportY/*[@bandandmode = $specID]/@supportstatus" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="'N'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                
                                <item>
                                    <xsl:apply-templates select="@* except @name" />
                                    <xsl:attribute name="engLangVal" select="$engLangVal" />
                                    <xsl:attribute name="specid" select="$specID" />
                                    <xsl:attribute name="idmlnumqty" select="$idmlNumQty" />
                                    <xsl:attribute name="supportstatus" select="$supportstatus" />
                                    
                                    <xsl:apply-templates select="node()" />
                                </item>
                            </xsl:when>
                            
                            <!--<xsl:otherwise>
                                 </xsl:otherwise>-->
                         </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '9' else '10'" />
                    <xsl:attribute name="fileName" select="'bandmode'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:if test="matches($lang, 'Rus')">
                        <xsl:attribute name="rus5gcheck" select="$rus5gcheck" />
                    </xsl:if>
                    
                    <xsl:if test="(matches($region, '^(EUA-EUH|EUB|EUC|EUE|EU-alone)$')) or 
                                  ($region = 'MEA' and $lang = 'Tur') or 
                                  ($region = 'TURKEY' and $lang = 'Tur') or
                                  (matches($region, '(CIS|UKRAINE_ONLY|Ukr)') and matches($lang, '(Ukr|Rus)'))">
                        <!--EUC향 Rum어 인경우 CIS 향으로 인식하여 bandmode 검증되지 않도록 하기-->
                        <xsl:if test="not(matches($region, '^(EUC)$') and 
                                      matches($lang, 'Rum'))">
                            <xsl:if test="$getRusBandTable0/node()">
                                <xsl:copy-of select="$getRusBandTable2/*" />
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:copy>
            </xsl:for-each>
            
            <specXML>
                <xsl:copy-of select="$specXML/*[matches(local-name(), '^bandmode')]" />
            </specXML>
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
