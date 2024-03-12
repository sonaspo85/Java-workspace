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
                
                <xsl:if test="matches($Product, '^(Mobile phone|Tablet)$') and 
                              not(matches($region, '(EUB|EUC|EUE|MEA)') and matches($lang, '(Ita|Tur)'))">
                    <xsl:variable name="producttype" select="lower-case(replace($Product, '\s+', ''))" />
                    <xsl:variable name="langsafetyinfo" select="$langXML/safetyinfo/items[@lang = $lang]/item[@id = $producttype]" />

                    <xsl:if test="$langsafetyinfo/text()">
                        <xsl:variable name="idmlValue">
                            <xsl:for-each select="$idmlLists/doc/*/text()">
                                <xsl:variable name="cur" select="." />
                                <!-- You can access more safety information by opening -->
                                
                                <xsl:if test="matches($cur, $langsafetyinfo)">
                                    <idmlValue>
                                        <xsl:value-of select="$langsafetyinfo" />
                                    </idmlValue>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="cell5">
                            <xsl:choose>
                                <xsl:when test="$idmlValue/idmlValue/node() and 
                                                string-length($idmlValue/idmlValue/text()) &gt; 0">
                                    <xsl:value-of select="$idmlValue" />
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:value-of select="'Not Found'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="cell6">
                            <xsl:value-of select="$langsafetyinfo" />
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
                        
                        <xsl:variable name="cell3" select="'Safety info'" />
                        
                        <xsl:copy>
                            <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '22' else '22'" />
                            <xsl:attribute name="fileName" select="'safetyinfo'" />
                            <xsl:apply-templates select="@*" />
                            
                            <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                            
                            <!-- <vvv>
                                <xsl:copy-of select="$langUsbCable2" />
                            </vvv> -->
                        </xsl:copy>
                    </xsl:if>
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
