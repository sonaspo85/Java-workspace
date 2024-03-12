<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    <xsl:strip-space elements="*"/>
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="no" />

    <!--<xsl:param name="midName" />
    <xsl:variable name="midName0" select="concat('file:////', replace($midName, '\\', '/'))"  />-->
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="doc[@lang]" group-by="@lang">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <doc lang="{current-group()[1]/@lang}">
                            <xsl:apply-templates select="current-group()/node()" />
                        </doc>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:variable name="lang" select="ancestor::doc/@lang"/>
        <xsl:choose>
            <xsl:when test="matches(name(), 'class')">
                <xsl:attribute name="{local-name()}">
                    <xsl:analyze-string select="." regex="(.*%3a)(.*)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:matching-substring>
                        
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:attribute>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>