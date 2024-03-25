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
        
        <xsl:variable name="vModelName" select="$specXML/model/@name" />
        <xsl:variable name="Product" select="$specXML/product/@type" />
        
        <root>
            <xsl:apply-templates select="@*" />

            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:variable name="LsleafLists">
                    <doc>
                        <xsl:attribute name="lang" select="$lang" />
                        <xsl:for-each select="*[matches(name(),'(Table|table)')][descendant::p[@class='Looseleaf-Center']]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </doc>
                </xsl:variable>
                
                <xsl:variable name="LsleafLists02">
                    <xsl:choose>
                        <xsl:when test="not($LsleafLists/doc//*)">
                            <doc>
                                <xsl:attribute name="lang" select="$lang" />
                                <xsl:element name="Table">                                    
                                    <xsl:for-each select="descendant::p[@class='Looseleaf-Center']">
                                        <tr>
                                            <td>
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*, node()" />
                                                </xsl:copy>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </xsl:element>
                            </doc>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="$LsleafLists" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="rusLfHead">
                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <a>
                                <xsl:value-of select="'ИНФОРМАЦИЯ О СЕРТИФИКАЦИИ ПРОДУКЦИИ'" />
                            </a>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$lang = 'Rus'">
                                    <a>
                                        <xsl:value-of select="'ИНФОРМАЦИЯ О СЕРТИФИКАЦИИ ПРОДУКЦИИ'" />
                                    </a>
                                </xsl:when>
                                
                                <xsl:when test="$lang = 'Kaz'">
                                    <xsl:choose>
                                        <xsl:when test="matches($Product, '(Watch|Buds|Hearable)')">
                                            <a>
                                                <xsl:value-of select="'ӨНІМДІ СЕРТИФИКАТТАУ ТУРАЛЫ АҚПАРАТ'" />
                                            </a>
                                            <a>
                                                <xsl:value-of select="'ИНФОРМАЦИЯ О СЕРТИФИКАЦИИ ПРОДУКЦИИ'" />
                                            </a>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <a>
                                                <xsl:value-of select="'ӨНІМДІ СЕРТИФИКАТТАУ ТУРАЛЫ АҚПАРАТ'" />
                                            </a>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:copy>
                    <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '12' else '17'" />
                    <xsl:attribute name="fileName" select="'Looseleaf'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:choose>
                        <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                            <xsl:if test="$region = 'CIS' and 
                                          $lang = 'Rus'">
                                <xsl:choose>
                                    <!--CIS_TYPE_A의 경우 검증하지 않음-->
                                    <xsl:when test="matches($zipName, '(CIS_TYPE_A|HHP_KAZAKHSTAN_ONLY|CIS\(CAU\)_Rus)')">
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:call-template name="recall">
                                            <xsl:with-param name="rusLfHead" select="$rusLfHead"/>
                                            <xsl:with-param name="LsleafLists02" select="$LsleafLists02"/>
                                            <xsl:with-param name="vModelName" select="$vModelName"/>
                                            <xsl:with-param name="Product" select="$Product"/>
                                            <xsl:with-param name="coverModelName" select="$coverModelName"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:if test="matches($region, '(CIS|UKRAINE_ONLY)') and
                                          matches($lang, '(Rus|Kaz)')">
                                <xsl:choose>
                                    <!--HHP_KAZAKHSTAN_ONLY의 경우, CIS_TYPE_B - Rus 검증하지 않음-->
                                    <xsl:when test="matches($zipName, '(HHP_KAZAKHSTAN_ONLY|CIS_TYPE_B|UKRAINE_ONLY|CIS\(CAU\)_Rus)') and 
                                                    $lang = 'Rus'">
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:call-template name="recall">
                                            <xsl:with-param name="rusLfHead" select="$rusLfHead"/>
                                            <xsl:with-param name="LsleafLists02" select="$LsleafLists02"/>
                                            <xsl:with-param name="vModelName" select="$vModelName"/>
                                            <xsl:with-param name="Product" select="$Product"/>
                                            <xsl:with-param name="coverModelName" select="$coverModelName"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template name="recall">
        <xsl:param name="rusLfHead" />
        <xsl:param name="LsleafLists02" />
        <xsl:param name="vModelName" />
        <xsl:param name="Product" />
        <xsl:param name="coverModelName" />
        
        <xsl:variable name="cell3" select="'Looseleaf 사양'" />

        <xsl:for-each select="$rusLfHead/a">
            <xsl:variable name="cur" select="." />
            
            <xsl:choose>
                <xsl:when test="$LsleafLists02/doc/*[matches(name(), '(Table|table)')]//p = $cur">
                    <xsl:variable name="cell5" select="$LsleafLists02/doc//p[. = $cur]" />
                    <xsl:variable name="table" select="$LsleafLists02/doc//p[. = $cur]/ancestor::*[matches(name(), '(Table|table)')][1]" />
                    
                    <xsl:variable name="cell7">
                        <xsl:choose>
                            <xsl:when test="$cell5">
                                <xsl:value-of select="'Success'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Fail'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="rusLfModel">
                        <a>
                            <xsl:value-of select="concat('Үлгі:', ' ', $vModelName)" />
                        </a>
                        <a>
                            <xsl:value-of select="concat('Модель:', ' ', $vModelName)" />
                        </a>
                        <a>
                            <xsl:value-of select="concat($vModelName, ' ', 'модельдегі')" />
                        </a>
                        <a>
                            <xsl:value-of select="concat('модели', ' ', $vModelName)" />
                        </a>
                    </xsl:variable>
                    
                    <xsl:variable name="cell5_2">
                        <xsl:choose>
                            <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                <xsl:for-each select="$table//*[text()]">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:if test="matches($cur, $vModelName) and 
                                                  string-length($vModelName) &gt; 0">
                                        <xsl:value-of select="$cur[matches(., $vModelName)]" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:for-each select="$table//*[@class = 'Looseleaf-Center']">
                                    <xsl:variable name="cur" select="." />
                                    
                                    <xsl:for-each select="$rusLfModel/a">
                                        <xsl:variable name="cur2" select="." />
                                        
                                        <xsl:if test="matches($cur, $cur2)">
                                            <xsl:value-of select="$cur" />
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="cell5_2final">
                        <xsl:choose>
                            <xsl:when test="not($cell5_2)">
                                <xsl:value-of select="'Not Found'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="$cell5_2" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="cell7_2">
                        <xsl:choose>
                            <xsl:when test="$cell5_2 = 'Not Found'">
                                <xsl:value-of select="'Fail'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'Success'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="cell6" select="$cur" />
                    <xsl:variable name="cell6_2" select="$vModelName" />
                    
                    <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                    <div desc="" specXML="" indesignData="{$cell5_2final}" langXML="{$cell6_2}" compare="{$cell7_2}" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:variable name="cell6">
                        <xsl:choose>
                            <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                <xsl:value-of select="$vModelName" />
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:value-of select="$coverModelName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <div desc="{$cell3}" specXML="" indesignData="Not Found" langXML="{$cur}" compare="Fail" />
                    <div desc="" specXML="" indesignData="Not Found" langXML="{$cell6}" compare="Fail" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

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
