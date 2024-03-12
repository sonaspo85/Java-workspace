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
	<xsl:strip-space elements="*"/>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
	
	<xsl:template match="root">
		<xsl:variable name="coverModelName" select="@coverModelName" />
		<xsl:variable name="region" select="@region" />
	    <xsl:variable name="usbpoadap" select="$specXML/packages/spec[matches(@item, 'usbpoweradapt[eo]r')]" />
	    
		<root>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="doc">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="lang" select="@lang" />
			    
			    <xsl:variable name="LangItems" select="$langXML/packages/items[@lang=$lang]/item[matches(@id, 'usbpoweradapt[oe]r')]" />
			    
			    <xsl:variable name="idmlLists">
			        <doc>
			            <xsl:attribute name="lang" select="$lang" />
			            <xsl:for-each select="$cur/descendant::p[matches(@class, '(UnorderList_1|Description-Cell)')]">
			                <xsl:copy>
			                    <xsl:apply-templates select="@*, node()" />
			                </xsl:copy>
			            </xsl:for-each>
			        </doc>
			    </xsl:variable>
			    
			    <xsl:variable name="greenissue" select="$langXML/greenissue/items[@lang=$lang]" />
			    <xsl:variable name="cell3" select="'Green issue'" />

			    <xsl:copy>
			    	<xsl:attribute name="pos" select="4" />
			    	<xsl:attribute name="fileName" select="'green-compare'" />
			        <xsl:apply-templates select="@*" />
                    
			        <xsl:if test="$region = 'SWA' and 
			            $lang = 'Ben'">
			            <xsl:choose>
			                <xsl:when test="$usbpoadap[@supportstatus = 'N']">
			                    <xsl:for-each select="$greenissue">
			                        <xsl:variable name="lLang" select="@lang" />
			                        
			                        <xsl:for-each select="item">
			                            <xsl:variable name="id" select="@id" />
			                            <xsl:variable name="curLangItem" select="." />
			                            
			                            <xsl:variable name="cell5">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="$idmlLists/doc/*[. = $curLangItem]" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="'Not Found'" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:variable name="cell6">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="$curLangItem[. = $idmlLists/doc/*/text()]" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="$curLangItem" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:variable name="cell7">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="'Success'" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="'Fail'" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:choose>
			                                <xsl:when test="$curLangItem[. = $idmlLists/doc/*/text()]">
			                                    <div desc="{$cell3}" specXML="" indesignData="" langXML="{$greenissue}" compare="Fail" />
			                                </xsl:when>
			                                
			                                <xsl:otherwise>
			                                </xsl:otherwise>
			                            </xsl:choose>
			                        </xsl:for-each>
			                    </xsl:for-each>
			                </xsl:when>
			                
			                <xsl:when test="$usbpoadap[@supportstatus = 'Y'] and 
			                                $LangItems = $idmlLists/doc/*/text()">
			                    <xsl:for-each select="$greenissue">
			                        <xsl:variable name="lLang" select="@lang" />
			                        
			                        <xsl:for-each select="item">
			                            <xsl:variable name="id" select="@id" />
			                            <xsl:variable name="curLangItem" select="." />
			                            
			                            <xsl:variable name="cell5">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="$idmlLists/doc/*[. = $curLangItem]" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="'Not Found'" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:variable name="cell6">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="$curLangItem[. = $idmlLists/doc/*/text()]" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="$curLangItem" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:variable name="cell7">
			                                <xsl:choose>
			                                    <xsl:when test="$curLangItem = $idmlLists/doc/*/text()">
			                                        <xsl:value-of select="'Success'" />
			                                    </xsl:when>
			                                    
			                                    <xsl:otherwise>
			                                        <xsl:value-of select="'Fail'" />
			                                    </xsl:otherwise>
			                                </xsl:choose>
			                            </xsl:variable>
			                            
			                            <xsl:choose>
			                                <xsl:when test="$curLangItem[. = $idmlLists/doc/*/text()]">
			                                    <div desc="{$cell3}" specXML="" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
			                                </xsl:when>
			                                
			                                <xsl:otherwise>
			                                    <div desc="{$cell3}" specXML="" indesignData="Not Found" langXML="{$greenissue}" compare="Fail" />
			                                </xsl:otherwise>
			                            </xsl:choose>
			                        </xsl:for-each>
			                    </xsl:for-each>
			                </xsl:when>
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