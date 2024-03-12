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
                        <xsl:for-each select="$cur/descendant::p[matches(@class, '(Description)')]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="langPObox">
                    <xsl:variable name="id">
                        <xsl:choose>
                            <xsl:when test="matches($region, '(SEA|AFRICA|MEA|TURKEY|VIETNAM)')">
                                <xsl:value-of select="'poaddress'" />
                            </xsl:when>
                            
                            <xsl:when test="matches($region, '(EUB|EUE|EUC)')">
                                <xsl:value-of select="'poaddress-uk'" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:for-each select="$langXML/pobox/items[@lang = $lang]/item[@id = $id]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="self::br">
                                        <xsl:value-of select="'&#x482;'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:if test="$langPObox/item/text()">
                    <xsl:variable name="idmlValue">
                        <xsl:for-each select="$idmlLists/doc/*/text()">
                            <xsl:variable name="cur" select="." />
                            
                            <xsl:if test="matches($langPObox/*/text(), $cur, 'q')">
                                <xsl:variable name="cur2">
                                    <xsl:if test="matches($region, '(EUB|EUE|EUC)')">
                                        <xsl:value-of select="parent::*/preceding-sibling::*[1]/text()" />
                                        <xsl:value-of select="'҂'" />
                                    </xsl:if>

                                    <xsl:value-of select="$cur" />
                                </xsl:variable>
                                    
                                <xsl:if test="matches($cur2, $langPObox/*/text())">
                                    <idmlValue>
                                        <xsl:value-of select="$cur2" />
                                    </idmlValue>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    
                    <xsl:variable name="cell5">
                        <xsl:choose>
                            <xsl:when test="$idmlValue/idmlValue/text() != '' and 
                                            string-length($idmlValue/idmlValue/text()) &gt; 1">
                                <xsl:value-of select="$idmlValue/idmlValue" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Not Found'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="cell6">
                        <xsl:value-of select="$langPObox" />
                    </xsl:variable>
                    
                    <xsl:variable name="cell7">
                        <xsl:choose>
                            <xsl:when test="$cell5 != 'Not Found'">
                                <xsl:value-of select="'Success'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Fail'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="cell3">
                        <xsl:choose>
                            <xsl:when test="matches($region, '(SEA|AFRICA|MEA|TURKEY|VIETNAM)')">
                                <xsl:value-of select="'PO Box 주소'" />
                            </xsl:when>
                            
                            <xsl:when test="matches($region, '(EUB|EUE|EUC)')">
                                <xsl:value-of select="'PO Box + 영국 주소'" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '20' else '20'" />
                    
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:if test="(matches($region, '(SEA|AFRICA|MEA|TURKEY|VIETNAM)') and 
                                           matches($lang, '(Eng|Tur)'))">
                                <xsl:copy>
                                    <xsl:attribute name="pos" select="$pos" />
                                    <xsl:attribute name="fileName" select="'pobox'" />
                                    <xsl:apply-templates select="@*" />
                                    
                                    <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                </xsl:copy>
                            </xsl:if>
                        </xsl:when>
                    
                        <xsl:when test="matches($Product, '^(Watch|Buds|Fit)$')">
                            <xsl:choose>
                                <xsl:when test="(matches($region, '(SEA|AFRICA|MEA|TURKEY|VIETNAM)') and 
                                                matches($lang, '(Eng|Tur)')) or 
                                                (matches($region, '(EUB|EUE|EUC)'))">
                                    <xsl:copy>
                                        <xsl:attribute name="pos" select="$pos" />
                                        <xsl:attribute name="fileName" select="'pobox'" />
                                        <xsl:apply-templates select="@*" />
                                        
                                        <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                    </xsl:copy>
                                </xsl:when>

                                <!-- <xsl:when test="matches($region, '(EUB|EUE|EUC)')">
                                    <xsl:copy>
                                        <xsl:attribute name="pos" select="$pos" />
                                        <xsl:attribute name="fileName" select="'pobox'" />
                                        <xsl:apply-templates select="@*" />
                                        
                                        <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                    </xsl:copy>
                                </xsl:when> -->
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
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
