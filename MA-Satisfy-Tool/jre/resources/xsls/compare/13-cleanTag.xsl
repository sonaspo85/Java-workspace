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
    
    <xsl:template match="sameGroup">
        <xsl:variable name="name" select="name(child::*[1])" />
        <xsl:variable name="cls" select="child::*[1]/@class" />
        <xsl:variable name="id" select="child::*[1]/@id" />
        
        <xsl:choose>
            <xsl:when test="not(ancestor::safety)">
                <xsl:element name="{$name}">
                    <xsl:attribute name="class" select="$cls" />
                    <xsl:attribute name="id" select="$id" />
                    
                    <xsl:apply-templates select="node()" />
                </xsl:element>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[parent::sameGroup]">
        <xsl:choose>
            <xsl:when test="child::*[1][name()='safety']">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
                <!--<xsl:copy>
                    <xsl:attribute name="aaa" select="''" />
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>-->
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="item[not(ancestor::scoreDB)]">
        <xsl:copy>
            <xsl:if test="not(matches(local-name(ancestor::*[parent::sameGroup]), 'satisfy'))">
                <xsl:attribute name="filename" select="ancestor::*[@filename]/@filename" />
            </xsl:if>
            
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="items">
        <xsl:choose>
            <xsl:when test="matches(local-name(parent::*), 'satisfy')">
                <xsl:copy>
                    <xsl:apply-templates select="parent::*/@* except (parent::*/@class, parent::*/@id)" />
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>