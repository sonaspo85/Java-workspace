<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
        <xsl:output-character character="&apos;" string="&amp;apos;" />
    </xsl:character-map>

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="divs" select="/topic//div[matches(@class, 'swipe_inner_wrap')]/div[matches(@class, 'heading1')]" />


    <xsl:template match="/">
        <xsl:variable name="SearchFile" select="'../output/search/jsons/search_db.js'" />

        <xsl:result-document href="{$SearchFile}">
            <xsl:text>var search=[</xsl:text>
            
            <xsl:for-each select="$divs">
                <xsl:variable name="cur" select="." />
                
                <xsl:call-template name="recall" />
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="recall">
        <xsl:variable name="idmlTopic" select="ancestor::topic[@idml][last()]" />
        <xsl:variable name="fileTopic" select="ancestor::topic[@file][1]/@file" />
        
        <xsl:variable name="chapter">
            <xsl:value-of select="$idmlTopic/topic[1]/h0" />
        </xsl:variable>
        
        <xsl:variable name="chapterPos">
            <xsl:value-of select="count($idmlTopic/preceding-sibling::topic) + 1" />
        </xsl:variable>
        
        <xsl:variable name="body">
            <xsl:apply-templates select="* except (*[starts-with(name(),'h')][1], topic)" mode="body" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="*[1][name()='h1']">
                <xsl:variable name="title" select="replace(replace(*[1][name()='h1'], '&#xa;', ''),'^\s+', '')" />
                
                <xsl:text disable-output-escaping='yes'>&#xA;{"toc_id": "</xsl:text>
                <xsl:value-of select="$fileTopic"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "chapter": "</xsl:text>
                <xsl:value-of select="$chapter"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "chapter_i": "</xsl:text>
                <xsl:value-of select="$chapterPos"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "title": "</xsl:text>
                <xsl:value-of select="$title" />
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "body": "</xsl:text>
                <xsl:value-of select="normalize-space(replace($body, '&#xA0;', ' '))" />
                
                <xsl:choose>
                    <xsl:when test="position()=last()">
                        <xsl:text disable-output-escaping='yes'>"}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping='yes'>"},</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="*[1][name()='h2']">
                <xsl:variable name="hash" select="*[1][name()='h2']/@id" />
                
                <xsl:variable name="title" select="replace(replace(ancestor::topic[@file]
                                                                    //div[matches(@class, 'swipe_inner_wrap')][1]
                                                                    /div[*[1][name()='h1']]/h1, '&#xa;', ''),'^\s+', '')" />
                
                <xsl:variable name="title2" select="replace(replace(*[1][name()='h2'], '&#xa;', ''),'^\s+', '')" />
                
                <xsl:text disable-output-escaping='yes'>&#xA;{"toc_id": "</xsl:text>
                <xsl:value-of select="concat($fileTopic, '#', $hash)"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "chapter": "</xsl:text>
                <xsl:value-of select="$chapter"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "chapter_i": "</xsl:text>
                <xsl:value-of select="$chapterPos"/>
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "title": "</xsl:text>
                <xsl:value-of select="$title" />
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text>
                <xsl:value-of select="$title2" />
                <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                
                <xsl:text disable-output-escaping='yes'> "body": "</xsl:text>
                <xsl:value-of select="normalize-space(replace($body, '&#xA0;', ' '))" />
                
                <xsl:choose>
                    <xsl:when test="position()=last()">
                        <xsl:text disable-output-escaping='yes'>"}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping='yes'>"},</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul | ol | li | p | td | br | *[starts-with(name(), 'h')]" mode="body">
        <xsl:text>&#x20;</xsl:text>
        <xsl:apply-templates mode="body" />
        <xsl:text>&#x20;</xsl:text>
    </xsl:template>

    <xsl:template match="span | b | i" mode="body">
        <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>
