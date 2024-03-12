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
    
    <xsl:variable name="frequencyband" select="$specXML/frequencyband/@name" />
    <xsl:variable name="wlanregion" select="$specXML/wlanregion/@name" />
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <xsl:variable name="region" select="@region" />
        
        <root>
            <xsl:apply-templates select="@*" />
            
            <xsl:if test="matches($Product, '^(Mobile phone|Tablet)$') and 
                matches($frequencyband, '^(2\.4\+5GHz|2\.4\+5GHz\+6GHz)$')">
                <xsl:for-each select="doc">
                    <xsl:variable name="cur" select="." />
                    <xsl:variable name="lang" select="@lang" />
                    
                    <xsl:if test="not(matches($region, 'EUC') and matches($lang, '(Ukr|Rum)')) and 
                                  matches($region, '(EUB|EUE)') or 
                                  (matches($region, '(SEA|MEA|India|AFRICA)') and $lang = 'Eng') or 
                                  matches($lang, 'Tur')">
                        <xsl:variable name="idmlLists">
                            <doc>
                                <xsl:attribute name="lang" select="$lang" />
                                <xsl:for-each select="$cur/descendant::p[matches(@class, '(Description)')]">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*, node()" />
                                    </xsl:copy>
                                </xsl:for-each>
                            </doc>
                        </xsl:variable>
                        
                        <xsl:variable name="langwlan" select="$langXML/wlan/items[@lang = $lang]/item[@id = $wlanregion]" />
                        
                        <xsl:if test="$langwlan/text()">
                            <xsl:variable name="idmlValue">
                                <xsl:for-each select="$idmlLists/doc/*/text()">
                                    <xsl:variable name="cur" select="." />
                                    <!-- This restriction is applicable in -->
                                    
                                    <xsl:if test="$langwlan/text() and 
                                        matches($cur, $langwlan, 'q')">
                                        <idmlValue>
                                            <xsl:value-of select="$cur[matches(., $langwlan, 'q')]" />
                                        </idmlValue>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="cell5">
                                <xsl:choose>
                                    <xsl:when test="$idmlValue/idmlValue/node() and 
                                        string-length($idmlValue/idmlValue/text()) &gt; 0">
                                        <xsl:value-of select="$langwlan" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="cell6">
                                <xsl:choose>
                                    <xsl:when test="$langwlan/text()">
                                        <xsl:value-of select="$langwlan" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="cell7">
                                <xsl:choose>
                                    <xsl:when test="not(matches($cell5, 'Not Found'))">
                                        <xsl:value-of select="'Success'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="cell3" select="'Wi-Fi 주의 문구'" />
                            
                            <xsl:copy>
                                <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '23' else '23'" />
                                <xsl:attribute name="fileName" select="'wifi-frequency'" />
                                <xsl:apply-templates select="@*" />
                                
                                <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                
                                <!-- <aaa>
                                     <xsl:copy-of select="$idmlValue" />
                                     </aaa>
                                     
                                     <bbb>
                                     <xsl:copy-of select="$langwlan" />
                                     </bbb> -->
                             </xsl:copy>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
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
