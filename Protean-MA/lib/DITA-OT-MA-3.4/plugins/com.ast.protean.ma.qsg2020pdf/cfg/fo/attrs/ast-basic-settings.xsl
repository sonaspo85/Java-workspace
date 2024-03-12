<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="xs">

	<!-- Maximum level allowed in the TOC -->
	<xsl:param name="tocMaximumLevel" select="4"/>
	<xsl:param name="antArgsGenerateTaskLabels" select="yes"/>
	<xsl:variable name="locale" select="/dita/@xml:lang"/>
	
	<!-- Change page size to A4 -->
	<xsl:variable name="page-width">198mm</xsl:variable>
	<xsl:variable name="page-height">138mm</xsl:variable>

	<!-- This is the default, but you can set the margins individually below. -->
	<xsl:variable name="page-margins">16mm</xsl:variable>
	<xsl:variable name="page-margins-cover">0mm</xsl:variable>

	<!-- Change these if your page has different margins on different sides. -->
	<xsl:variable name="page-margin-outside" select="'5mm'"/>
	<xsl:variable name="page-margin-inside" select="'5mm'"/>

	<!-- header margin -->
	<xsl:variable name="page-margin-top">5mm</xsl:variable>
	<xsl:variable name="page-margin-bottom">5mm</xsl:variable>
	<!-- The side column width is the amount the body text is indented relative to the margin. -->
	<xsl:variable name="side-col-width">0mm</xsl:variable>

	<!-- body page margin -->
	<xsl:variable name="page-body-margin-top">5mm</xsl:variable>
	<xsl:variable name="page-body-margin-bottom">5mm</xsl:variable>

	<!-- Set default font-size and line-height -->
	<!-- <xsl:variable name="default-font-size">14pt</xsl:variable> -->
	<xsl:variable name="default-font-size">
		<xsl:choose>
			<xsl:when test="matches(substring-after($locale, '-'), 'KR')">
				<xsl:value-of select="'6pt'" />
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="'7pt'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="default-line-height">6.3mm</xsl:variable>
	
	<xsl:variable name="base-font-family">
		<xsl:choose>
			<xsl:when test="matches(substring-after($locale, '-'), 'KR')">
				<xsl:value-of select="'삼성긴고딕OTF'" />
			</xsl:when>

			<!-- <xsl:when test="matches(substring-after($locale, '-'), 'GB')">
				<xsl:value-of select="'Myriad Pro'" />
			</xsl:when> -->

			<xsl:otherwise>
				<xsl:value-of select="'Myriad Pro'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="generate-front-cover" select="false()"/>
	<xsl:variable name="generate-toc" select="false()"/>
	<xsl:variable name="mirror-page-margins" select="true()"/>
</xsl:stylesheet>
