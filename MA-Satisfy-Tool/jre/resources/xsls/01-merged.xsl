<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
	<xsl:param name="excelF" />
    <xsl:param name="scoreF" />

	<xsl:variable name="excelDirs01" select="replace(replace(replace(replace($excelF, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="directory01" select="document(iri-to-uri($excelDirs01))" />
	
    <xsl:variable name="excelDirs02" select="replace(replace(replace(replace($scoreF, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="directory02" select="document(iri-to-uri($excelDirs02))" />
    
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
	<xsl:template match="root">
        <xsl:copy>
			<xsl:apply-templates select="@*"/>
            <xsl:attribute name="filename" select="ast:last($excelDirs01, '/')" />
            
            <dbtempls>
                <xsl:apply-templates select="node()" />
            </dbtempls>

			<excelData>
				<xsl:copy-of select="$directory01/*[local-name()='root']/*" />
			</excelData>
            
            <scoreDB>
                <xsl:copy-of select="$directory02/*[local-name()='root']/*" />
            </scoreDB>
		</xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>