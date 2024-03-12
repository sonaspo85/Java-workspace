<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs son xsi functx"
    version="3.0">
	
    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />
    <xsl:import href="../00-commonVar.xsl" />
	
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
	    
	    <xsl:variable name="vModelName" select="$specXML/model/@name" />
	    
		<root>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="doc">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="lang" select="@lang" />
				
			    <xsl:variable name="cell3" select="'모델명 사양'" />
			    <xsl:variable name="cell4" select="$vModelName" />
			    <xsl:variable name="cell5" select="$coverModelName" />
			    
			    <xsl:variable name="cell7">
			        <xsl:choose>
			            <xsl:when test="$vModelName = $coverModelName">
			                <xsl:value-of select="'Success'" />
			            </xsl:when>
			            <xsl:otherwise>
			                <xsl:value-of select="'Fail'" />
			            </xsl:otherwise>
			        </xsl:choose>
			    </xsl:variable>
				
				<xsl:copy>
					<xsl:attribute name="pos" select="2" />
					<xsl:attribute name="fileName" select="'model-name'" />
					<xsl:apply-templates select="@*" />
					
				    <div desc="{$cell3}" specXML="{$cell4}" indesignData="{$cell5}" langXML="" compare="{$cell7}" />
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