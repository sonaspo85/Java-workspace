<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs son xsi functx"
    version="3.0">
	
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
		<root>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="doc">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:variable name="idmlLists">
				    <doc>
				       <xsl:attribute name="lang" select="$lang" />
				        <xsl:for-each select="$cur/descendant::p[matches(@class, '^(UnorderList|Description-Cell)')]">
       					<xsl:copy>
       						<xsl:apply-templates select="@*, node()" />
       					</xsl:copy>
       				</xsl:for-each>
				    </doc>
				</xsl:variable>

				<xsl:variable name="packageSpec">
					<xsl:for-each select="$specXML/packages/spec">
						<xsl:variable name="curSpec" select="." />
						<xsl:variable name="division" select="@division" />
						<xsl:variable name="packItem0" select="@item" />
					    
					    <xsl:variable name="packItem">
					       <xsl:choose>
					           <xsl:when test="matches($packItem0, 'usbpoweradapt[oe]r')">
					               <xsl:value-of select="'usbpoweradapter'" />
					           </xsl:when>
					           
					           <xsl:otherwise>
					               <xsl:value-of select="$packItem0" />
					           </xsl:otherwise>
					       </xsl:choose>
					    </xsl:variable>
					    
						<xsl:variable name="bool">
						    <xsl:value-of select="@supportstatus" />
						</xsl:variable>
						
						<xsl:variable name="LangItems" select="$langXML/packages/items[@lang=$lang]" />
                        
					    <xsl:variable name="cell3" select="'패키지 사양'" />
					    <xsl:variable name="cell4" select="$division" />
                        
                        <xsl:choose>
                            <xsl:when test="$bool = 'Y'">
                                <xsl:choose>
                                    <xsl:when test="$packItem = $LangItems/item/@id">
                                        <xsl:for-each select="$LangItems">
                                            <xsl:variable name="lLang" select="@lang" />
                                            
                                            <xsl:for-each select="item">
                                                <xsl:variable name="id" select="@id" />
                                                <xsl:variable name="curLangItem" select="." />
                                                
                                                <xsl:variable name="cell5">
                                                    <xsl:choose>
                                                        <xsl:when test="$curLangItem = $idmlLists/doc[@lang=$lLang]/*/text()">
                                                            <xsl:value-of select="$idmlLists/doc[@lang=$lLang]/*[. = $curLangItem]" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Not Found'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                
                                                <xsl:variable name="cell6">
                                                    <xsl:choose>
                                                        <xsl:when test="$curLangItem = 'N/A'">
                                                            <xsl:value-of select="'Not Support'" />
                                                        </xsl:when>
                                                        
                                                        <xsl:when test="$curLangItem = $idmlLists/doc[@lang=$lLang]/*/text()">
                                                            <xsl:value-of select="$curLangItem[. = $idmlLists/doc[@lang=$lLang]/*/text()]" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$curLangItem" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                
                                                <xsl:variable name="cell7">
                                                    <xsl:choose>
                                                        <xsl:when test="$curLangItem = $idmlLists/doc[@lang=$lLang]/*/text()">
                                                            <xsl:value-of select="'Success'" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Fail'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                
                                                <xsl:if test="$packItem = $id">
                                                    <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <div desc="{$cell3}" specXML="{$cell4}" indesignData="Not Found" langXML="" compare="Fail" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:copy>
				    <xsl:attribute name="pos" select="3" />
				    <xsl:attribute name="fileName" select="'packages-compare'" />
					<xsl:apply-templates select="@*" />
					
					<xsl:copy-of select="$packageSpec" />
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