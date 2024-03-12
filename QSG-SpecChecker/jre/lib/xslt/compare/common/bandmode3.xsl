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
                
                <xsl:variable name="turwifi5" select="$langXML/turwifi5/items[@lang = $lang]/item" />
                
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
                
                <xsl:variable name="getTurSpec">
                    <xsl:if test="$lang = 'Tur' and 
                                  not(matches($Product, '(Buds|Hearable)'))">
                        <xsl:if test="$langBandItem[matches(@id, 'wifi5')]">
                            
                            <xsl:variable name="idmlValue">
                                <xsl:for-each select="$idmlLists/doc//*">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:if test="matches($cur, $turwifi5)">
                                        <xsl:variable name="before" select="substring-before($cur, $turwifi5)" />
                                        <xsl:variable name="after" select="substring-after($cur, $turwifi5)" />
                                        
                                        <!--<xsl:value-of select="normalize-space(substring-before(substring-after($cur, $before), $after))" />-->
                                        <xsl:value-of select="$turwifi5" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="idmlFlwQty">
                                <xsl:choose>
                                    <xsl:when test="string-length($idmlValue) = 0 or 
                                                    $idmlValue = ''">
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$idmlValue" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="bool">
                                <xsl:choose>
                                    <xsl:when test="string-length($idmlValue) = 0 or 
                                                    $idmlValue = ''">
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Success'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <div engLangVal="Tur 국가규제 WLAN 설명 사양" specXML="" idmlFlwQty="{$idmlFlwQty}" langXML="{$turwifi5}" compare="{$bool}" langSpecID="turwifi5" />
                        </xsl:if>
                    </xsl:if>
                </xsl:variable>
                
                <xsl:if test="not(matches($Product, 'Fit')) and 
                              (($lang = 'Tur') or
                              ($region = 'MEA' and $lang = 'Tur') or 
                              ($region = 'TURKEY' and $lang = 'Tur'))">
                    <xsl:copy>
                        <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '9' else '10'" />
                        <xsl:attribute name="fileName" select="'tur-wlan'" />
                        <xsl:apply-templates select="@*" />
                        
                        <xsl:copy-of select="$getTurSpec/*" />
                    </xsl:copy>
                </xsl:if>
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
