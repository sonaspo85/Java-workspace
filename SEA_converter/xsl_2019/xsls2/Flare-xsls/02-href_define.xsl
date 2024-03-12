<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast">

    <xsl:key name="targets" match="*[@id]" use="@id" />

    <xsl:output indent="no" method="xml" encoding="utf-8" omit-xml-declaration="yes"/>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@href">
        <xsl:choose>
            <xsl:when test="starts-with(., '#')">
                <xsl:variable name="old_id" select="substring-after(., '#')" />
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="concat('#', generate-id(key('targets', $old_id)))"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@id">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="generate-id(parent::*)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="li">
        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
        <li xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" mode="nor" />
        </li>
        <xsl:if test="not(following-sibling::li)">
            <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*" mode="nor">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text()" mode="nor">
        <xsl:choose>
            <xsl:when test="normalize-space(.)=''">
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace(replace(., '\son page&#xA0;\d+', ''), '\s+', '&#x20;')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@MadCap:*">
    </xsl:template>

    <xsl:template match="comment() | processing-instruction()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '\son page&#xA0;\d+', ''), '\s+', '&#x20;')" />
    </xsl:template>

</xsl:stylesheet>