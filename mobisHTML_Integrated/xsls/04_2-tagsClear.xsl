<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p Content ph"/>

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="docs">
        <body>
            <xsl:apply-templates  select="@*"/>
            <xsl:apply-templates />
        </body>
    </xsl:template>

    <xsl:template match="docs/HyperlinkURLDestination">
    </xsl:template>

    <xsl:template match="docs/Hyperlink">
    </xsl:template>

    <xsl:template match="doc">
        <chapter idml="{substring-before(@idml, '.idml')}">
            <xsl:apply-templates />
        </chapter>
    </xsl:template>

    <xsl:template match="Story">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="*[parent::*[@class='video_manual']]">
        <xsl:copy>
            <xsl:attribute name="videoGroup" select="'video_manual'" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[parent::Story]">
        <xsl:choose>
            <xsl:when test="self::p[img][count(node())=1]">
                <xsl:apply-templates select="node()" />
            </xsl:when>
            
            <xsl:when test="self::p[matches(@class, 'NoTOC2')]" />

            <xsl:when test="self::div[@class='video_manual']">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Cell/@Self">
    </xsl:template>

    <xsl:template match="ph">
        <xsl:choose>
            <xsl:when test=".='&#x20;'">
                <xsl:text>&#x20;</xsl:text>
            </xsl:when>
            
            <xsl:when test="matches(@class, '(^C_Button$|^C_URL$|^C_LtoR$|^C_MMI_LtoR$|^C_Superscript-R-TM$|^C_MMI_NoBold_LtoR$|^C_Below_Description_LtoR$|^C_Below_Heading_LtoR$|^C_Noline$)')">
                <span>
                    <!--<xsl:if test="root()/docs[matches(@data-language, 'Ara')]">
                        <xsl:attribute name="dir" select="'ltr'" />
                    </xsl:if>-->
                    <xsl:if test="matches($commonRef/ISOCode/@value, '(AR|IL|IW)')">
                        <xsl:attribute name="dir" select="'ltr'" />
                    </xsl:if>
                    
                    <xsl:apply-templates select="@*, node()" />
                </span>
            </xsl:when>

            <xsl:otherwise>
                <span>
                    <xsl:apply-templates select="@* | node()" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@class">
        <xsl:attribute name="class" select="if ( contains(., '%3a' ) ) then substring-after(., '%3a') else ." />
    </xsl:template>

    <xsl:template match="HyperlinkTextSource">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="img/@href">
        <!--<xsl:attribute name="src" select="concat('contents/images/', replace(replace(., '\.ai$', '.png'), '\.psd', '.png'))" />-->
        <xsl:attribute name="src" select="concat('contents/images/', replace(replace(replace(., '(^[ES]-gf_.*)(.ai$)', '$1.gif'), '\.ai$', '.png'), '\.psd', '.png'))" />
    </xsl:template>

    <xsl:template match="CrossReferenceSource[preceding-sibling::node()[1][name()='ph'][@class='C_CrossReference'][.='p.']]">
    </xsl:template>

</xsl:stylesheet>