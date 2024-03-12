<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="excelData">
	    <xsl:variable name="tagName" select="." />
	    
	    <excelDB>
	        <xsl:for-each select="listitem">
	            <xsl:choose>
	                <xsl:when test="not(descendant::node()[self::text()])">
	                </xsl:when>
	                
	                <xsl:otherwise>
	                    <xsl:copy>
	                        <xsl:apply-templates select="@*, node()" />
	                    </xsl:copy>
	                </xsl:otherwise>
	            </xsl:choose>
	        </xsl:for-each>
	    </excelDB>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="listitem">
                <xsl:choose>
                    <xsl:when test="not(descendant::node()[self::text()])">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="scoreMethod">
    </xsl:template>
    
    <xsl:template match="text()" priority="5">
        <xsl:value-of select="replace(replace(., '\s+$', ''), '^\s+', '')" />
    </xsl:template>
    
</xsl:stylesheet>