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
        <xsl:variable name="coverModelName" select="@coverModelName" />
        <xsl:variable name="zipName" select="@folderName" />
        <xsl:variable name="region" select="@region" />
        
        <xsl:variable name="Product" select="$specXML/product/@type" />
        
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
                    <xsl:attribute name="fileName" select="'face-of-sar'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="$region = 'EUB' and
                                        $lang = 'Fre(EU)' and 
                                        matches($Product, '(Watch|Fit)')">
                            <xsl:variable name="vItem0" select="$specXML/sars/spec[@item='frontoffacesar']" />
                            
                            <xsl:variable name="vItem">
                                <xsl:choose>
                                    <xsl:when test="not($vItem0)">
                                        <xsl:choose>
                                            <xsl:when test="$specXML/sars/spec[@division = $lang][@item = 'headsar']">
                                                <xsl:copy-of select="$specXML/sars/spec[@division = $lang][@item = 'headsar']" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:copy-of select="$specXML/sars/spec[@division = 'Common'][@item = 'headsar']" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy-of select="$vItem0" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="specLang" select="$langXML/sars/items[@lang=$lang]/item[@id='frontoffacesar']" />
                            <xsl:variable name="specUnit" select="$specLang/@unit" />
                            <xsl:variable name="specValue" select="$vItem/*/@value" />
                            
                            <xsl:variable name="cell3" select="$specLang" />
                            
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
                            
                            <xsl:variable name="idmlValue">
                                <xsl:for-each select="$idmlLists/doc/*">
                                    <xsl:variable name="cur" select="." />

                                    <xsl:if test="$cur = $specLang">
                                        <xsl:variable name="flwDecimalUnit" select="following-sibling::*[1]" />
                                        <xsl:value-of select="$flwDecimalUnit" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="cell5">
                                <xsl:choose>
                                    <xsl:when test="not($idmlValue) or 
                                                    string-length($idmlValue) = 0">
                                        <xsl:value-of select="'Not Found'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$idmlValue" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="cell7">
                                <xsl:choose>
                                    <xsl:when test="$cell5 != 'Not Found' and 
                                                    string-length($cell5) &gt; 0">
                                        <xsl:variable name="oVal" select="number(replace(replace($specValue, '(\s)?W/kg', ''), ',', '.'))" />
                                        <xsl:variable name="sVal" select="number(replace(normalize-space(replace($cell5, $specUnit, '')), ',', '.'))" />
                                        
                                        <xsl:call-template name="returnCompareNumbers">
                                            <xsl:with-param name="oVal" select="$oVal" />
                                            <xsl:with-param name="sVal" select="$sVal" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    
                                    <xsl:when test="number(replace($specValue, '(\s)?W/kg', '')) = 0">
                                        <xsl:value-of select="'Pass'" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$cell5 = 'Not Found'">
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                                
                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
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
