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
	
	<xsl:template match="tags">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="tag">
				<xsl:sort select="@value" order="ascending" />
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@value2">
	    <xsl:attribute name="value2" select="replace(replace(., '&amp;', '_'), ';', '_')" />
	</xsl:template>
    
	<xsl:template match="text()" priority="5">
		<xsl:analyze-string select="." regex="(&amp;amp;amp;)">
			<xsl:matching-substring>
				<xsl:value-of select="replace(., regex-group(1), '&amp;')" />
			</xsl:matching-substring>

			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="(.*)(&amp;apos;)(.*)">
					<xsl:matching-substring>
						<xsl:value-of select="replace(., regex-group(2), '''')" />
					</xsl:matching-substring>

					<xsl:non-matching-substring>
						<xsl:value-of select="." />
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>

</xsl:stylesheet>