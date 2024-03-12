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
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="excelDB">
	    <xsl:copy>
	        <xsl:apply-templates select="@*" />
	        
	        <xsl:for-each-group select="listitem" group-adjacent="type">
	            <xsl:choose>
	                <xsl:when test="current-grouping-key()">
	                    <grouped class="{type/text()}">
	                        <xsl:apply-templates select="current-group()" mode="abc" />
	                    </grouped>
	                </xsl:when>
	                
	                <xsl:otherwise>
	                    <xsl:apply-templates select="current-group()" />
	                </xsl:otherwise>
	            </xsl:choose>
	        </xsl:for-each-group>
	    </xsl:copy>
    </xsl:template>
    
    <xsl:template match="listitem" mode="abc">
        <xsl:copy>
            <xsl:if test="child::*[local-name()='evaluateType']">
                <xsl:attribute name="evaluateType" select="*[local-name()='evaluateType']" />
            </xsl:if>
            
            <xsl:if test="child::*[local-name()='detail']">
                <xsl:attribute name="detail" select="*[local-name()='detail']" />
            </xsl:if>
            
            <xsl:if test="child::*[local-name()='company']">
                <xsl:attribute name="company" select="*[local-name()='company']" />
            </xsl:if>
            
            <xsl:apply-templates select="@*" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>