<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="xs">


    <xsl:include href="ast-font-attr.xsl" />

	<xsl:variable name="pi.code">
        <xsl:for-each select="root()/dita/node()[self::processing-instruction('ast')]">
            <xsl:element name="{substring-before(., '=')}">
                <xsl:value-of select="substring-after(., '=')" />
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:key name="jobFile" match="file" use="@uri" />
    <xsl:variable name="OSname" select="$pi.code/*[name()='template']" />


	<!-- Maximum level allowed in the TOC -->
	<xsl:param name="tocMaximumLevel" select="4"/>
	<xsl:param name="antArgsGenerateTaskLabels" select="yes"/>
	<xsl:variable name="locale" select="/dita/@xml:lang"/>

	<xsl:variable name="page-width">210mm</xsl:variable>
	<xsl:variable name="page-height">297mm</xsl:variable>
	<xsl:variable name="page-margins">16mm</xsl:variable>

	<xsl:variable name="page-margins-cover">0mm</xsl:variable>
	<xsl:variable name="page-margin-inside" select="'16mm'"/>
	<xsl:variable name="page-margin-outside" select="'16mm'"/>
	<xsl:variable name="page-margin-top">10mm</xsl:variable>
	<xsl:variable name="page-margin-bottom">10mm</xsl:variable>
	<xsl:variable name="side-col-width">0mm</xsl:variable>

	<xsl:variable name="page-body-margin-top">25mm</xsl:variable>
	<!-- <xsl:variable name="page-body-margin-bottom">14mm</xsl:variable> -->
	<xsl:variable name="page-body-margin-bottom">10mm</xsl:variable>

	
	<xsl:variable name="default-font-size">
		<xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="concat('Default', ' Size')" />
        </xsl:call-template>
	</xsl:variable>

	<xsl:variable name="default-line-height">
		<xsl:call-template name="getVariable">
	        <xsl:with-param name="id" select="concat('Default', ' Common',  ' LineHeight')" />
	    </xsl:call-template>
	</xsl:variable>

	<xsl:variable name="default-font-stretch">
		<xsl:call-template name="getVariable">
		  	<xsl:with-param name="id" select="concat('Default', ' Common',  ' FontStretch')" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="default-letter-spacing">
		<xsl:call-template name="getVariable">
		  	<xsl:with-param name="id" select="concat('Default', ' Common',  ' LetterSpacing')" />
		</xsl:call-template>
	</xsl:variable>


	<xsl:variable name="base-font-family">
		<xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="concat('Default', ' Common', ' FontFamily')" />
        </xsl:call-template>
	</xsl:variable>

	<xsl:variable name="generate-front-cover" select="true()"/>
	<xsl:variable name="generate-back-cover" select="true()"/>
	<xsl:variable name="generate-toc" select="true()"/>
	<xsl:variable name="mirror-page-margins" select="true()"/>
</xsl:stylesheet>
