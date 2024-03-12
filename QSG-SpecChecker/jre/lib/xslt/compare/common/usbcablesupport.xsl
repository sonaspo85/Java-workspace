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
    <!-- <xsl:variable name="usbpoweradapter" select="$specXML/packages/spec[@item = 'usbpoweradapter']/@supportstatus" /> -->
    <xsl:variable name="usbcable" select="$specXML/packages/spec[@item = 'usbcable']/@supportstatus" />
    
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
                
                <xsl:if test="$usbcable = 'Y'">
                    <xsl:variable name="idmlLists">
                        <doc>
                            <xsl:attribute name="lang" select="$lang" />
                            <xsl:for-each select="$cur/descendant::p[matches(@class, '(Description|UnorderList)')]">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:for-each>
                        </doc>
                    </xsl:variable>
                    
                    <xsl:variable name="langUsbCable" select="$langXML/chargingsupport/items[@lang = $lang]/item[@id = 'usbcablesupport']" />
                    
                    <xsl:if test="$langUsbCable/text() and 
                                  matches($Product, '^(Mobile phone|Tablet)$')">
                        <xsl:variable name="langUsbCable2">
                            <xsl:choose>
                                <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                                    <xsl:for-each select="$langUsbCable">
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*" />
                                            
                                            <xsl:for-each select="node()">
                                                <xsl:choose>
                                                    <xsl:when test="self::*">
                                                        <xsl:apply-templates />
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="replace(., '(\{\d+\}([&#x200E;])?\s?)', '(\\d+)([,.]\\d)?([&#x200E;])? ')" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:copy>
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="langunit">
                            <xsl:copy-of select="$langXML/unit/items[@lang = $lang]/item[matches(@class, '^12')]/text()" />
                        </xsl:variable>
                        
                        <xsl:variable name="idmlValue">
                            <xsl:for-each select="$idmlLists/doc/*/text()">
                                <xsl:variable name="oriCur" select="." />
                                <xsl:variable name="strjoin" select="concat('(\d+)([,.]\d)?([&#x200E;])?\s?', $langunit)" />
                                <xsl:variable name="cur" select="replace(., $strjoin, concat('(\\d+)([,.]\\d)?([&#x200E;])? ', $langunit))" />
                                <!--If LTE/5G Power Class 2 is supported, max output power is (\d+) dBm.-->
                                
                                <xsl:analyze-string select="$cur" regex="{$langUsbCable2}" flags="q">
                                    <xsl:matching-substring>
                                        <idmlValue>
                                            <xsl:attribute name="numUnit" select="replace($oriCur, concat('(.*?)', '(\d+)([,.]\d)?', '([&#x200E;])?', '(\s?)', $langunit, '(.*)?'), '$2$3')" />
                                            <xsl:value-of select="." />
                                        </idmlValue>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>

                                <!-- <xsl:copy-of select="$cur" /> -->
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="cell5">
                            <xsl:choose>
                                <xsl:when test="$idmlValue/idmlValue/node()">
                                    <xsl:for-each select="$idmlValue/idmlValue">
                                        <xsl:variable name="numunit" select="replace(@numUnit, '\.', ',')" />
                                        
                                        <xsl:variable name="langpcUnit">
                                            <xsl:for-each select="$langUsbCable2/item">
                                                <xsl:variable name="value" select="@value" />
                                                
                                                <div decimal="{replace($value, '\.', ',')}" />
                                            </xsl:for-each>
                                        </xsl:variable>
                                        
                                        <xsl:choose>
                                            <xsl:when test="$numunit = $langpcUnit/div/@decimal">
                                                <xsl:variable name="numunit" select="@numUnit" />
                                                <xsl:value-of select="replace(., '\(\\d\+\)\(\[,.\]\\d\)\?\(\[&#x200E;\]\)\?', $numunit)" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="'Not Found'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:value-of select="'Not Found'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="cell6">
                            <xsl:for-each select="$langUsbCable">
                                <xsl:variable name="getAttr" select="@value" />
                                
                                <xsl:variable name="langpcUnit">
                                    <xsl:for-each select="$langUsbCable2/item">
                                        <xsl:variable name="value" select="@value" />
                                        
                                        <div decimal="{replace($value, '\.', ',')}" />
                                    </xsl:for-each>
                                </xsl:variable>
                                
                                <xsl:for-each select="node()">
                                    <xsl:choose>
                                        <xsl:when test="self::text()">
                                            <xsl:apply-templates select="." mode="insertUnit">
                                                <xsl:with-param name="langpcunit" select="$langpcUnit" />
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                            </xsl:copy>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="cell7">
                            <xsl:choose>
                                <xsl:when test="$idmlValue/idmlValue/node()">
                                    <xsl:for-each select="$idmlValue/idmlValue">
                                        <xsl:variable name="numunit" select="replace(@numUnit, '\.', ',')" />
                                        
                                        <xsl:variable name="langpcUnit">
                                            <xsl:for-each select="$langUsbCable2/item">
                                                <xsl:variable name="value" select="@value" />
                                                
                                                <div decimal="{replace($value, '\.', ',')}" />
                                            </xsl:for-each>
                                        </xsl:variable>
                                        
                                        <xsl:choose>
                                            <xsl:when test="$numunit = $langpcUnit/div/@decimal">
                                                <xsl:value-of select="'Success'" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="'Fail'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="'Fail'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="cell3" select="'USB 케이블 충전 지원 사양'" />
                        
                        <xsl:copy>
                            <xsl:attribute name="pos" select="if (matches($Product, '^(Mobile phone|Tablet)$')) then '18' else '18'" />
                            <xsl:attribute name="fileName" select="'usbcablesupport'" />
                            <xsl:apply-templates select="@*" />
                            
                            <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" /> 

                            <!-- <aaa>
                                <xsl:copy-of select="$langUsbCable2" />
                            </aaa>
                            <bbb>
                                <xsl:copy-of select="$idmlValue" />
                            </bbb> -->
                        </xsl:copy>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template match="text()" mode="insertUnit" priority="5">
        <xsl:param name="langpcunit" />
        
        <xsl:analyze-string select="." regex="(\{{0\}})">
            <xsl:matching-substring>
                <xsl:value-of select="$langpcunit/div/@decimal" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
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
