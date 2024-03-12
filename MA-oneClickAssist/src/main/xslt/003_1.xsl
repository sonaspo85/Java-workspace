<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()"  />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="div[matches(@class, 'h1Group')]">
		<xsl:for-each-group select="*" group-by="*[matches(name(), 'Recommand2')]/text()">
			<xsl:choose>
				<xsl:when test="current-grouping-key()">
					<div class="h1Group">
						<xsl:apply-templates select="current-group()" />
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="h1Group">
						<xsl:apply-templates select="current-group()" />
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:template>
	
</xsl:stylesheet>