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
                <xsl:variable name="vModelName" select="$specXML/model/@name" />
                

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

                <xsl:variable name="grtLang0" select="$langXML/turgaranty/items/item" />
                
                <xsl:variable name="grtLang">
                    <xsl:choose>
                        <xsl:when test="$Product = 'Hearable'">
                            <xsl:value-of select="replace($grtLang0, '5', '3')" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="$grtLang0" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="idmlValue">
                    <xsl:choose>
                        <xsl:when test="$idmlLists/doc/* = $grtLang">
                            <xsl:value-of select="$idmlLists/doc/*[. = $grtLang]" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Not Found'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="bool">
                    <xsl:choose>
                        <xsl:when test="$idmlValue != 'Not Found'">
                            <xsl:value-of select="'Success'" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Fail'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="cell3" select="'Tur 제품 수명 및 보증 사양'" />
                <xsl:variable name="cell5" select="$idmlValue" />
                <xsl:variable name="cell6" select="$grtLang" />
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="14" />
                    <xsl:attribute name="fileName" select="'turgaranty'" />
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:if test="$region = 'MEA' and 
                                          $lang = 'Tur'">
                                <!--Tur Product Spec 사양
                                    temp.xml 파일을 만들어 텍스트 데이터에서 table 값을 가져온다. band 사양 로직과 비슷하지만
                                    한 언어만 해당하는 사양이기에 하드 코딩으로 진행한 부분이 있음-->
                                <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$bool}" />
                            </xsl:if>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:if test="($region = 'MEA' and $lang = 'Tur') or 
                                           $lang = 'Tur'">
                                <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$bool}" />
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
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
