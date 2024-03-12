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
        <xsl:variable name="zipName" select="@folderName" />
        <xsl:variable name="region" select="@region" />
        <xsl:variable name="vModelName" select="$specXML/model/@name" />
        
        <root>
            <xsl:apply-templates select="@*" />

            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:variable name="modLists">
                    <doc>
                        <xsl:attribute name="lang" select="$lang" />
                        <xsl:for-each select="descendant::p[@class='ModelName-Cover-ID']">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="cell5">
                    <xsl:choose>
                        <xsl:when test="count($modLists/doc/*) = 0">
                            <xsl:value-of select="'Not Found'" />
                        </xsl:when>
                        
                        <xsl:when test="matches($modLists/doc/*, $vModelName)">
                            <xsl:value-of select="$modLists/doc/*[matches(., $vModelName)]" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Not Found'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="cell7">
                    <xsl:choose>
                        <xsl:when test="string-length($cell5) = 0 or 
                                        $cell5 = 'Not Found'">
                            <xsl:value-of select="'Fail'" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Success'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="cell3" select="'Ind 보증서 모델 사양'" />
                <xsl:variable name="cell4" select="$vModelName" />
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="16" />
                    <xsl:attribute name="fileName" select="'modelname-coverid'" />
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:if test="$region = 'SEA' and 
                                  $lang = 'Ind'">
                        <!--SEA, Ind 국가등록번호 사양, 보증서 모델 사양 확인-->
                        
                        <xsl:choose>
                            <xsl:when test="$cell7 = 'Success'">
                                <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
                                
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
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
