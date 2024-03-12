<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="../00-commonVar.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p" />
    
    <!--<xsl:variable name="chapterImg" select="/body/chapter/node()[1][name()='img']" />
    <xsl:variable name="chapterImgFilePath" select="'../resource/ch-images.xml'" />-->

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    
    <xsl:template match="/" mode="V5">
        <xsl:text>&#xA;</xsl:text>
        <images>
            <xsl:for-each select="body/chapter/node()[1][name()='img']">
                <xsl:variable name="pos">
                    <xsl:value-of select="parent::chapter[@idml]/xs:integer(substring-before(@idml, '_')) - 3" />
                </xsl:variable>
                <xsl:text>&#xA;&#x9;</xsl:text>
                
                <image idx="{format-number($pos, '000')}" src="{replace(@src, 'contents/', '')}" />
            </xsl:for-each>
        </images>
    </xsl:template>
    
    <xsl:template match="/" mode="V6">
        <xsl:text>&#xA;</xsl:text>
        <images>
            <xsl:for-each select="body/chapter/node()[1][name()='img']">
                <xsl:variable name="chapterName" select="parent::chapter/tokenize(@idml, '_')[last()]" />
                
                <xsl:variable name="pos">
                    <xsl:value-of select="parent::chapter/tokenize(@idml, '_')[1]" />
                </xsl:variable>
                <xsl:text>&#xA;&#x9;</xsl:text>
                
                <image idx="{$pos}" src="{replace(@src, 'contents/', '')}" />
                <xsl:if test="position() = last()">
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </images>
    </xsl:template>
    
</xsl:stylesheet>