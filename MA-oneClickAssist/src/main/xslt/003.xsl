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
	
	<xsl:template match="listitem">
		<xsl:variable name="cur" select="." />
		
		<xsl:choose>
			<xsl:when test="matches(Style, 'Heading[12]')">
				<xsl:variable name="sharpTerm" select="replace(*[matches(name(), 'Recommand2')]/text(), '^#', '')" />
				<xsl:variable name="cnt" select="count(tokenize($sharpTerm, '#'))" />
				
				<xsl:for-each select="1 to $cnt">
					<xsl:variable name="i" select="." />
					<xsl:for-each select="$cur">
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="matches(name(), 'Recommand2')">
										<xsl:copy>
											<xsl:apply-templates select="@*" />
											<xsl:value-of select="concat('#', tokenize($sharpTerm, '#')[$i])" />
										</xsl:copy>
									</xsl:when>
									
									<xsl:otherwise>
										<xsl:copy>
											<xsl:apply-templates select="@*, node()" />
										</xsl:copy>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:copy>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
