<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY trade "™">]>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast saxon"
    version="2.0">

    <xsl:character-map name="a"> 
        <xsl:output-character character='"' string="&amp;quot;"/>
        <xsl:output-character character="'" string="&amp;apos;"/>
        <xsl:output-character character="™" string="&amp;trade;"/>
    </xsl:character-map>

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p" />

    <xsl:variable name="topics" select="/body//topic" />
    <xsl:variable name="sourcePath" select="body/@sourcePath" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="file" select="concat($sourcePath, '/output/search/jsons/search.js')" />
        <xsl:result-document href="{$file}">
            <xsl:text>var search=[</xsl:text>

            <xsl:for-each select="$topics">
                <xsl:variable name="chapter">
                    <xsl:value-of select="ancestor::chapter/topic[1]/*[1]" />
                </xsl:variable>
                <xsl:variable name="chapter_id">
                    <xsl:value-of select="count(ancestor::chapter/preceding-sibling::chapter)" />
                </xsl:variable>
                <xsl:variable name="body">
                    <xsl:apply-templates select="* except (*[1], topic)" mode="body" />
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="@filename">
                        <xsl:variable name="fid" select="*[1]/@id" />
                        <xsl:variable name="filename" select="@filename" />
                        <xsl:variable name="toc_id" select="concat($filename, '_', $fid, '.html')" />
                        <xsl:variable name="title" select="*[1]" />
                        <xsl:text disable-output-escaping='yes'>&#xA;{"toc_id": "</xsl:text><xsl:value-of select="$toc_id"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "chapter": "</xsl:text><xsl:value-of select="$chapter"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "chapter_id": "</xsl:text><xsl:value-of select="$chapter_id"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "title": "</xsl:text><xsl:value-of select="$title" /><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "body": "</xsl:text>
                        <xsl:value-of select="normalize-space(replace($body, '&#xA0;', ' '))" />
                        <xsl:text disable-output-escaping='yes'>"}</xsl:text>
                        <xsl:if test="position()!=last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="fid" select="ancestor::topic[@filename][1]/*[1]/@id" />
                        <xsl:variable name="filename" select="ancestor::topic[@filename][1]/@filename" />
                        <xsl:variable name="toc_id" select="concat($filename, '_', $fid, '.html', '#', *[1]/@id)" />
                        <xsl:variable name="title" select="ancestor::topic[@filename][1]/*[1]" />
                        <xsl:variable name="title2" select="*[1]" />
                        <xsl:text disable-output-escaping='yes'>&#xA;{"toc_id": "</xsl:text><xsl:value-of select="$toc_id"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "chapter": "</xsl:text><xsl:value-of select="$chapter"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "chapter_id": "</xsl:text><xsl:value-of select="$chapter_id"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "title": "</xsl:text><xsl:value-of select="$title" /><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text><xsl:value-of select="$title2"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                        <xsl:text disable-output-escaping='yes'> "body": "</xsl:text>
                        <xsl:value-of select="normalize-space(replace($body, '&#xA0;', ' '))" />
                        <xsl:text disable-output-escaping='yes'>"}</xsl:text>
                        <xsl:if test="position()!=last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="li | p | td | br | *[starts-with(name(), 'h')]" mode="body">
        <xsl:apply-templates mode="body" />
        <xsl:text>&#x20;</xsl:text>
    </xsl:template>

    <xsl:template match="b" mode="body">
        <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>