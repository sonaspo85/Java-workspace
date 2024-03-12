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
    
    <xsl:template match="items[ancestor::dbtempls]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:variable name="var0">
                <xsl:for-each-group select="item" group-by="@*[matches(local-name(), 't\dcell1')]">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <grouped>
                                <xsl:apply-templates select="current-group()" />
                            </grouped>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <grouped>
                                <xsl:apply-templates select="current-group()" />
                            </grouped>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:for-each select="$var0/grouped">
                <xsl:copy>
                    <xsl:attribute name="id" select="count(preceding-sibling::grouped)" />
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>