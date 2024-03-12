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
                        <xsl:for-each select="*">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>

                <xsl:variable name="temperatureTxt" select="'Teknik Özellikler'" />
                
                <xsl:variable name="flwTable" select="$idmlLists//*[. = $temperatureTxt]/following-sibling::*[1][name()='Table']" />
                <xsl:variable name="vProdLists" select="$specXML/productSpec/spec" />
                
                <xsl:variable name="tableClear">
                    <xsl:for-each select="$vProdLists">
                        <xsl:variable name="vcur" select="." />
                        <xsl:variable name="vdivision" select="@division" />
                        <xsl:variable name="vitem" select="@item" />
                        
                        <xsl:variable name="tdValID">
                            <xsl:for-each select="$flwTable/tr/td">
                                <xsl:variable name="tdcur" select="." />
                                <xsl:variable name="name" select="@Name" />
                                <xsl:variable name="rowNum" select="number(tokenize($name, ':')[1])" />
                                
                                <xsl:if test="$rowNum = 0">
                                    <xsl:variable name="tdid">
                                        <xsl:call-template name="getAttr">
                                            <xsl:with-param name="cur" select="$tdcur" />
                                        </xsl:call-template>
                                    </xsl:variable>
                                    
                                    <tdID>
                                        <xsl:value-of select="$tdid" />
                                    </tdID>
                                    
                                    <flwNode>
                                        <xsl:for-each select="$tdcur[$tdid = $vcur/@item]/following-sibling::td[1]/*">
                                            <xsl:value-of select="." />
                                            
                                            <xsl:if test="following-sibling::*">
                                                <xsl:value-of select="' '" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </flwNode>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="cell3">
                            <xsl:choose>
                                <xsl:when test="$Product = 'Watch'">
                                    <xsl:choose>
                                        <xsl:when test="$vdivision = 'Camera'">
                                            <xsl:value-of select="''" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$vitem = $tdValID/tdID">
                                                    <xsl:value-of select="@division" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="''" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$vitem = $tdValID/tdID">
                                            <xsl:value-of select="@division" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="''" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="cell4">
                            <xsl:choose>
                                <xsl:when test="$Product = 'Watch'">
                                    <xsl:choose>
                                        <xsl:when test="$vdivision = 'Camera'">
                                            <xsl:value-of select="''" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$vcur[@item = $tdValID/tdID]">
                                                    <xsl:value-of select="$vcur[@item = $tdValID/tdID]/@value" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="''" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$vcur[@item = $tdValID/tdID]">
                                            <xsl:value-of select="$vcur[@item = $tdValID/tdID]/@value" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="''" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="cell5">
                            <xsl:choose>
                                <xsl:when test="$Product = 'Watch' and 
                                                $vdivision = 'Camera'">
                                    <xsl:value-of select="''" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:call-template name="getCell5">
                                        <xsl:with-param name="vcur" select="$vcur" />
                                        <xsl:with-param name="tdValID" select="$tdValID" />
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="vProdVal" select="replace($cell4, '[\s|/|,|”]', '')" />
                        <xsl:variable name="iProdVal" select="replace($cell5, '[\s|/|,|”]', '')" />
                        
                        <xsl:variable name="cell7">
                            <xsl:choose>
                                <xsl:when test="$vProdVal = $iProdVal">
                                    <xsl:value-of select="'Success'" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="'Fail'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:if test="string($cell3/text())">
                            <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '13' else '12'" />
                    <xsl:attribute name="fileName" select="'productspec'" />
                    <xsl:apply-templates select="@*" />
                    
                    
                    
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:if test="$region = 'MEA' and 
                                            $lang = 'Tur'">
                                            <!--Tur Product Spec 사양
                                                temp.xml 파일을 만들어 텍스트 데이터에서 table 값을 가져온다. band 사양 로직과 비슷하지만
                                                한 언어만 해당하는 사양이기에 하드 코딩으로 진행한 부분이 있음-->
                                <xsl:copy-of select="$tableClear" />
                            </xsl:if>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:if test="($region = 'MEA' and 
                                           $lang = 'Tur') or 
                                           $lang = 'Tur'">
                                <xsl:copy-of select="$tableClear" />
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template name="getCell5">
        <xsl:param name="vcur" />
        <xsl:param name="tdValID" />
        
        <xsl:choose>
            <xsl:when test="$vcur[@item = $tdValID/tdID]">
                <xsl:value-of select="normalize-space($tdValID[tdID = $vcur/@item]/flwNode/text())" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="''" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="getAttr">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="$cur = 'İşlemci'">
                <xsl:value-of select="'cpu'" />
            </xsl:when>
            
            <xsl:when test="matches($cur, '(SRam|Ram)')">
                <xsl:value-of select="'ram'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Hafıza'">
                <xsl:value-of select="'memory'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'İşletim Sistemi'">
                <xsl:value-of select="'ossystem'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Ekran Boyut'">
                <xsl:value-of select="'screensize'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Ön Kamera'">
                <xsl:value-of select="'frontcamera'" />
            </xsl:when>
            
            <xsl:when test="matches($cur, '(İç Kamera|Kapak Kamerası)')">
                <xsl:value-of select="'covercamera'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Ekran Altı Kamera'">
                <xsl:value-of select="'underdisplaycamera'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Kamera'">
                <xsl:value-of select="'camera'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'Radyo'">
                <xsl:value-of select="'radio'" />
            </xsl:when>
            
            <xsl:when test="$cur = 'MicroSD'">
                <xsl:value-of select="'microsd'" />
            </xsl:when>
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
