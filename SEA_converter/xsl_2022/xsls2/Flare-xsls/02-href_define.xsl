<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast">

    <xsl:key name="targets" match="*[@id]" use="@id" />
    <xsl:key name="a_targets" match="*[@aid]" use="@aid" />

    <xsl:output indent="no" method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*" />

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
                    <xsl:choose>
                        <xsl:when test="key('targets', $old_id)">
                            <xsl:value-of select="concat('#', generate-id(key('targets', $old_id)))"/>
                        </xsl:when>
                        
                        <xsl:when test="not(key('targets', $old_id)) and 
                                        key('a_targets', $old_id)">
                            <xsl:value-of select="concat('#', generate-id(key('a_targets', $old_id)))"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="concat('#', generate-id(key('targets', $old_id)))"/>
                        </xsl:otherwise>
                    </xsl:choose>
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
        <li xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" mode="nor" />
        </li>
    </xsl:template>
    
    <xsl:template match="*" mode="nor">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="@class = 'LearnMore' or 
                            @class = 'LearnMoreGraphic'">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table">
        <xsl:choose>
            <xsl:when test="parent::p[matches(@class, 'LearnMore')]">
                <div>
                    <xsl:attribute name="class" select="parent::*/@class" />
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:for-each select="descendant::td/node()">
                        <xsl:apply-templates select="." />
                    </xsl:for-each>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
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