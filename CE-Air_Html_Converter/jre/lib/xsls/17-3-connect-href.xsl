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

    <xsl:key name="hyperlink" match="*[@id]" use="@id" />
        
    
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="a[@href]">
        <xsl:variable name="href" select="concat('#', @href)" />

        <xsl:copy>
            <xsl:apply-templates select="@*" />

            <xsl:if test="key('hyperlink', $href)">
                <xsl:variable name="destkey" select="key('hyperlink', $href)[1]/@ast-id" />
                <xsl:variable name="destfilename" select="key('hyperlink', $href)[1]/ancestor::section[@data-id][1]/@data-id" />

                <xsl:attribute name="href" select="concat($destfilename, '#', $destkey)" />
            </xsl:if>

            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@id][@ast-id]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="id" select="concat('#', @ast-id)" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
