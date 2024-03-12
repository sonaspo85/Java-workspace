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
	    
	    <xsl:variable name="vOptical" select="$specXML/optical/@name" />
	    <xsl:variable name="Product" select="$specXML/product/@type" />
	    
		<root>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="doc">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="lang" select="@lang" />
			    
			    <xsl:variable name="idmlLists">
			        <doc>
			            <xsl:attribute name="lang" select="$lang" />
			            <xsl:for-each select="$cur/descendant::p">
			                <xsl:copy>
			                    <xsl:apply-templates select="@*, node()" />
			                </xsl:copy>
			            </xsl:for-each>
			        </doc>
			    </xsl:variable>
			    
			    <xsl:variable name="fingerprintEng" select="$langXML/fingerprint/items[@lang='Eng']" />
			    <xsl:variable name="fingerprintTar" select="$langXML/fingerprint/items[@lang=$lang]" />
                
                <!--지문인식 확인-->
                <xsl:copy>
                    <xsl:attribute name="pos" select="5" />
                    <xsl:attribute name="fileName" select="'fingerprint'" />
                    <xsl:apply-templates select="@*" />
                
     			    <xsl:choose>
                         <xsl:when test="$vOptical = '미지원'">
                         </xsl:when>
                         
                         <xsl:when test="$vOptical = '광학식'">
                             <xsl:call-template name="recall">
                                 <xsl:with-param name="type" select="'optical'" />
                                 <xsl:with-param name="desc" select="'지문인식 광학식'" />
                                 <xsl:with-param name="fingerprintEng" select="$fingerprintEng" />
                                 <xsl:with-param name="fingerprintTar" select="$fingerprintTar" />
                                 <xsl:with-param name="idmlLists" select="$idmlLists" />
                             </xsl:call-template>
                         </xsl:when>
                         
                         <xsl:when test="$vOptical = '초음파식'">
                             <xsl:call-template name="recall">
                                 <xsl:with-param name="type" select="'ultrawave'" />
                                 <xsl:with-param name="desc" select="'지문인식 초음파식'" />
                                 <xsl:with-param name="fingerprintEng" select="$fingerprintEng" />
                                 <xsl:with-param name="fingerprintTar" select="$fingerprintTar" />
                                 <xsl:with-param name="idmlLists" select="$idmlLists" />
                             </xsl:call-template>
                         </xsl:when>
                         
                         <xsl:when test="matches($vOptical, '^(초음파식-보호필름o|초음파식-보호필름x)$')">
                             <xsl:variable name="desc" select="$vOptical" />
                             
                             <div desc="{$desc}" specXML="" indesignData="Not Found" langXML="" compare="Fail" />
                         </xsl:when>
                     </xsl:choose>
                </xsl:copy>
			</xsl:for-each>
		</root>
	</xsl:template>
    
    <xsl:template name="recall">
        <xsl:param name="type" />
        <xsl:param name="desc" />
        <xsl:param name="fingerprintEng" />
        <xsl:param name="fingerprintTar" />
        <xsl:param name="idmlLists" />
        
        <xsl:variable name="cell4" select="$fingerprintEng/item[@id = $type]" />

        <xsl:if test="$fingerprintTar/item[@id = $type]">
            <xsl:for-each select="$fingerprintTar/item[@id = $type]">
                <xsl:variable name="LangFpOri" select="." />
                
                <xsl:variable name="cell5">
                    <xsl:choose>
                        <xsl:when test="string-length($LangFpOri) = 0">
                            <xsl:value-of select="''" />
                        </xsl:when>
                        
                        <xsl:when test="$LangFpOri = $idmlLists/doc/*/text()">
                            <xsl:value-of select="$idmlLists/doc/*[. = $LangFpOri]" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Not Found'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="cell6">
                    <xsl:value-of select="$LangFpOri" />
                </xsl:variable>
                
                <xsl:variable name="cell7">
                    <xsl:choose>
                        <xsl:when test="string-length($LangFpOri) = 0">
                            <xsl:value-of select="'Success'" />
                        </xsl:when>
                        
                        <xsl:when test="$LangFpOri = $idmlLists/doc/*/text()">
                            <xsl:value-of select="'Success'" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="'Fail'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test="$LangFpOri = $idmlLists/doc/*/text()">
                        <xsl:variable name="l" select="$idmlLists/doc/*[. = $LangFpOri]" />
                        
                        <div desc="{$desc}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <div desc="{$desc}" specXML="{$cell4}" indesignData="{$cell5}" langXML="{$cell6}" compare="{$cell7}" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
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