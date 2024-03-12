<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:x="adobe:ns:meta/"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    exclude-result-prefixes="xs idPkg x rdf dc ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:include href="branch/06_0-reference.xsl"/>
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$commonRef/version/@value = '6th'">
                <xsl:apply-templates select="." mode="V6" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="V5" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>