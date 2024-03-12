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

        <root>
            <xsl:apply-templates select="@*" />

            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />
                <!--<xsl:variable name="vModelName" select="$specXML/model/@name" />-->
                
                <xsl:variable name="vRegNum" select="$specXML/registration/spec/@value" />
                
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

                <xsl:variable name="idmlValue0">
                    <xsl:variable name="sameCnt" select="count($idmlLists/doc/*[matches(., $vRegNum)])" />
                    
                    <xsl:variable name="var0">
                        <xsl:for-each select="$idmlLists/doc/*">
                            <xsl:variable name="cur" select="." />
                            <xsl:variable name="before" select="replace(replace(substring-before($cur, $vRegNum), '\(', '\\('), '\)', '\\)')" />
                            <xsl:variable name="after" select="replace(replace(substring-after($cur, $vRegNum), '\(', '\\('), '\)', '\\)')" />
                            
                            <!--<xsl:if test="matches($cur, $vRegNum) and 
                                          string-length($before) &gt; 0 and 
                                          string-length($after) &gt; 0">
                                <a>
                                    <xsl:analyze-string select="$cur" regex="({$before})(.*)({$after})">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(2)"/>
                                        </xsl:matching-substring>
                                        
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="'bbb '" />
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </a>
                            </xsl:if>-->
                            
                            <xsl:if test="matches($cur, $vRegNum)">
                                <a>
                                    <xsl:value-of select="$vRegNum" />
                                </a>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    
                    <bool>
                        <xsl:choose>
                            <xsl:when test="count($var0/a) != count(distinct-values($var0/a))">
                                <xsl:choose>
                                    <xsl:when test="count(distinct-values($var0/a)) = 1 and 
                                                    $var0/a[1] = $vRegNum">
                                        <xsl:value-of select="'Success'" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="'Fail'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:when test="count($var0/a) = count(distinct-values($var0/a))">
                                <xsl:choose>
                                    <xsl:when test="$var0/a = $vRegNum">
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
                    </bool>
                    
                    <idmlValue>
                        <xsl:choose>
                            <xsl:when test="$var0/a">
                                <xsl:for-each select="$var0/a">
                                    <xsl:value-of select="." />
                                    
                                    <xsl:choose>
                                        <xsl:when test="position() != last()">
                                            <xsl:value-of select="' / '" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="''" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Not Found'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </idmlValue>
                </xsl:variable>
                
                <xsl:variable name="bool" select="$idmlValue0/bool" />
                <xsl:variable name="idmlValue" select="$idmlValue0/idmlValue" />
                
                <xsl:variable name="cell4">
                    <xsl:choose>
                        <xsl:when test="string-length($vRegNum) = 0">
                            <xsl:value-of select="'Empty'" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="$vRegNum" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                 
                <xsl:variable name="cell3" select="'Ind 국가 등록 번호'" />
                <xsl:variable name="cell5" select="$idmlValue" />
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="15" />
                    <xsl:attribute name="fileName" select="'registration'" />
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:if test="$region = 'SEA' and 
                                  $lang = 'Ind'">
                        <!--SEA, Ind 국가등록번호 사양, 보증서 모델 사양 확인-->
                        <xsl:choose>
                            <xsl:when test="$bool = 'Success'">
                                <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$bool}" />
                                
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$bool}" />
                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
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
