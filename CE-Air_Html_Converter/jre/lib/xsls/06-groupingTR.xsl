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
    

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:copy>
            <xsl:apply-templates select="@*" />

            <xsl:for-each-group select="cell" group-adjacent="tokenize(@name, ':')[last()]">
                <xsl:variable name="row" select="xs:integer(tokenize(@name, ':')[last()])" as="xs:integer"/>

                <tr>
                    <xsl:attribute name="rowNum" select="tokenize(@name, ':')[last()]" />
                    <xsl:apply-templates select="current-group()" />
                </tr>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="cell">
        <xsl:element name="td">
            <xsl:apply-templates select="@* except @align"/>
            <xsl:apply-templates select="node()" />
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
