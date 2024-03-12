<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="tarF" />
    
    <xsl:variable name="tarDir01" select="replace(replace(replace(replace($tarF, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="directory01" select="document(iri-to-uri(concat('file:////', $tarDir01)))" />
    
    <xsl:key name="tark" match="$directory01//*[@uniqueKey]" use="@uniqueKey" />
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
            
            <tarF>
                <xsl:copy-of select="$directory01/root/*" />
            </tarF>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="scoreDB">
    </xsl:template>
    
</xsl:stylesheet>