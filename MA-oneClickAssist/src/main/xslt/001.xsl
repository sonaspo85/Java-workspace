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
	<xsl:preserve-space elements="String file_name Style"/>
	

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()"  />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="root">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each-group select="*" group-starting-with="listitem[Style[matches(., 'Heading1')]]">
				<xsl:choose>
					<xsl:when test="current-group()[1][Style[matches(., 'Heading1')]]">
						<div class="h1Group">
							<xsl:apply-templates select="current-group()" />
						</div>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="Depth|no|chapter|applink|topic">
		
	</xsl:template>
	
	<xsl:template match="icon">
		<xsl:variable name="inSertExt">
			<xsl:choose>
				<xsl:when test="matches(., '(.*)(\.png$)')">
					<xsl:value-of select="." />
				</xsl:when>
				
				<xsl:when test="not(node())">
					<xsl:value-of select="." />
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="concat(., '.png')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:value-of select="$inSertExt" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
