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
    
    <xsl:template match="*[matches(name(), '(automation|quality)')][child::item]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <!--<xsl:variable name="name" select="@*[matches(local-name(), 't\dcell1')]" />-->
            <xsl:for-each-group select="item" group-by="@*[matches(local-name(), 't\dcell1')]">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <grouped class="{@*[matches(local-name(), 't\dcell1')]}">
                            <xsl:for-each select="current-group()">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* except (@t2cell1, @t4cell1)" />
                                    <xsl:apply-templates select="node()" />
                                </xsl:copy>
                            </xsl:for-each>
                        </grouped>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="safety">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each-group select="grouped" group-by="@id">
                <grouped class="{current-group()[1]/*[1]/@*[matches(local-name(), 't\dcell1')]}">
                    <xsl:for-each select="current-group()">
                        <xsl:copy>
                            <xsl:attribute name="filename" select="*[1]/@filename" />
                            <xsl:apply-templates select="@*, node()" mode="safety" />
                        </xsl:copy>
                    </xsl:for-each>
                </grouped>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="item" mode="safety">
        <xsl:copy>
            <xsl:apply-templates select="@* except (@filename, @t3cell1)" />
            <xsl:apply-templates select="node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="items">
        <xsl:choose>
            <xsl:when test="parent::*[local-name()='satisfy']">
                <xsl:copy>
                    <xsl:attribute name="filename" select="child::item[1]/@filename" />
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="item">
                        <xsl:copy>
                            <xsl:apply-templates select="@* except @filename" />
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
</xsl:stylesheet>