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
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:variable name="total">
                <total>
                    <xsl:for-each-group select="descendant::*[@filename]" group-by="@filename">
                        <xsl:variable name="var0">
                            <div filename="{current-group()[1]/@filename}">
                                <xsl:for-each select="current-group()">
                                    <item>
                                        <xsl:choose>
                                            <xsl:when test="parent::competitive_price">
                                                <xsl:attribute name="value" select="@result" />
                                            </xsl:when>
                                            
                                            <xsl:when test="parent::satisfy">
                                                <xsl:attribute name="value" select="@score" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:attribute name="value" select="@score" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </item>
                                </xsl:for-each>
                            </div>
                        </xsl:variable>
                        
                        <xsl:for-each select="$var0/div">
                            <xsl:variable name="sum" select="sum(child::item/@value)" />
                            
                            <xsl:copy>
                                <xsl:attribute name="total" select="$sum" />
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </xsl:for-each-group>
                </total>
            </xsl:variable>
            
            <xsl:for-each select="$total/total">
                <total>
                    <xsl:for-each select="div">
                        <xsl:sort select="number(@total)" order="descending" />
                        
                        <xsl:copy>
                            <xsl:attribute name="ranking" select="position()" />
                            <xsl:attribute name="total" select="@total" />
                            <xsl:attribute name="filename" select="@filename" />
                        </xsl:copy>
                    </xsl:for-each>
                </total>
            </xsl:for-each>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>