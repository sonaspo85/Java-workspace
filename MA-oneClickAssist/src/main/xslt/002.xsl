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
		<xsl:if test="listitem[1][*[matches(name(), 'Recommand2')][matches(., '^#(.*)')]]">
			<xsl:copy>
				<xsl:apply-templates select="@*, node()" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="listitem">
		<xsl:if test="*[matches(name(), 'Recommand2')][matches(., '^#(.*)')]">
			<xsl:copy>
				<xsl:apply-templates select="@*, node()" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>