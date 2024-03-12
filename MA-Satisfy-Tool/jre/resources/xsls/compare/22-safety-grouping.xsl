<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="scoredb" select="root/scoreDB" />
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    
    
    <xsl:template match="grouped">
        <xsl:choose>
            <xsl:when test="parent::safety">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each-group select="item" group-by="@t3cell2">
                        <items>
                            <xsl:attribute name="class" select="current-group()[1]/@t3cell2" />
                            
                            <xsl:for-each select="current-group()">
                                <xsl:sort select="@ranking" order="ascending" />
                                
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:for-each>
                        </items>
                    </xsl:for-each-group>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="parent::*[matches(local-name(), '(automation|quality)')]">
                <items>
                    <xsl:apply-templates select="@*, node()" />
                </items>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>