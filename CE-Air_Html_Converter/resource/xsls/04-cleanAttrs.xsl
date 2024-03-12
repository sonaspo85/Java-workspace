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
            <xsl:apply-templates select="@*, node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="characterstylerange">
        <xsl:choose>
            <xsl:when test="not(node())" />
            
            <xsl:when test="matches(@class, 'no character style')">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:when test="matches(@class, 'note')">
                <xsl:element name="span">
                    <xsl:apply-templates select="@*, node()" />
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="count(node()) = 1 and 
                            child::image">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:apply-templates select="@*, node()" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="cell">
        <xsl:copy>
            <xsl:apply-templates select="@* except (@appliedcellstyle, @rowspan, @columnspan)" />
            
            <xsl:if test="@appliedcellstyle">
                <xsl:variable name="vals" select="replace(@appliedcellstyle, '\$id/\[none\]', '')" />
                
                <xsl:choose>
                    <xsl:when test="matches(@appliedcellstyle, '^\$id/\[none\]$')">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:attribute name="cellstyle" select="$vals" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            
            <xsl:if test="@rowspan">
                <xsl:attribute name="row" select="@rowspan" />
            </xsl:if>
            
            <xsl:if test="@columnspan">
                <xsl:attribute name="column" select="@columnspan" />
            </xsl:if>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    
    
</xsl:stylesheet>
