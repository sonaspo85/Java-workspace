<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    exclude-result-prefixes="xs son xsi functx"
    version="2.0">
    
    <xsl:import href="../00-commonVar.xsl" />
    
    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />
    <xsl:param name="srcDirs" />
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
    <xsl:strip-space elements="*" />
    
    <xsl:variable name="Product" select="$specXML/product/@type" />
    <xsl:variable name="region" select="root/@region" />
    
    <xsl:variable name="srcDirs01" select="replace(replace(replace($srcDirs, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="concat('file:////', $srcDirs01)"  />
    
    <xsl:variable name="filePath">
        <xsl:choose>
            <xsl:when test="matches($Product, '^(Mobile phone|Tablet)$')">
                <xsl:value-of select="'/temp/compare/09-bandmode3.xml'" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="'/temp/compare/10-bandmode3.xml'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="srcDirs03" select="iri-to-uri(concat($srcDirs02, $filePath))"  />
    <xsl:variable name="directory" select="document($srcDirs03)" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
            
            <xsl:copy-of select="$directory/root/doc" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>
    
    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>
