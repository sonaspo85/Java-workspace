<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

	<xsl:output method="xml" version="1.0" indent="no" omit-xml-declaration="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

	<xsl:template match="/topic">
		<html data-language="{@data-language}">
			<head>
			<meta http-equiv="content-type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
			<link type="text/css" rel="stylesheet" href="resource/review.css" />
			<script type="text/javascript" src="js/00_jquery-1.9.1.min.js">&#xFEFF;</script>
			<script type="text/javascript" src="js/01_jquery.event.drag-1.5.min.js">&#xFEFF;</script>
			<script type="text/javascript" src="js/02_ui_text.js">&#xFEFF;</script>
			<script type="text/javascript" src="js/04_contents.js">&#xFEFF;</script>
			<script type="text/javascript" src="js/00_start.js">&#xFEFF;</script>
			</head>
			<body>
				<xsl:apply-templates select="@*, node()" />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="topic">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="h0">
		<p class="chapter">
			<xsl:apply-templates select="@*, node()" />
		</p>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="h1">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>