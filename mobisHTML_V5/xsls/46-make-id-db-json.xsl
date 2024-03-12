<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
    </xsl:character-map>

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="h12s" select="/topic//div/*[matches(name(), 'h(1|2)')]" />

    <xsl:template match="/">
        <xsl:variable name="id_dbFile" select="'../output/js/id_db.js'" />
        
        <xsl:result-document href="{$id_dbFile}">
            <xsl:text>var chapterId = [</xsl:text>
            <xsl:for-each select="$h12s">
                <xsl:variable name="url"><xsl:value-of select="ancestor::topic[@idml]/@file" /></xsl:variable>
                
                <xsl:variable name="chapter_id">
                    <xsl:variable name="fileLastID" select="tokenize(replace(ancestor::topic[@idml]/@file, '.html', ''), '_')[last()]" />
                    
                    <xsl:choose>
                        <xsl:when test="self::*[matches(name(), 'h1')]">
                            <xsl:value-of select="if ($fileLastID = @id) then '' else @id"/>
                        </xsl:when>
                        <xsl:when test="self::*[matches(name(), 'h2')]">
                            <!--<xsl:value-of select="generate-id(@id)"/>-->
                            <xsl:value-of select="@id" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="h2_no">
                    <xsl:choose>
                        <xsl:when test="name() = 'h1'">0</xsl:when>
                        <xsl:when test="name() = 'h2'">
                            <xsl:choose>
                                <xsl:when test="preceding-sibling::h1">0</xsl:when>
                                <xsl:when test="matches(@class, 'heading2-continue')">0</xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="count(parent::div/preceding-sibling::div)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="title"><xsl:value-of select="replace(replace(ancestor::topic[@idml]/parent::topic/h0, '&#xa;', ''),'^\s+', '')" /></xsl:variable>
                <xsl:variable name="title2"><xsl:value-of select="replace(replace(., '&#xa;', ''),'^\s+', '')" /></xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#xA;{"url": "</xsl:text><xsl:value-of select="$url"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                <xsl:text disable-output-escaping='yes'> "chapter_id": "</xsl:text><xsl:value-of select="$chapter_id"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                <xsl:text disable-output-escaping='yes'> "h2_no": "</xsl:text><xsl:value-of select="$h2_no"/><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                <xsl:text disable-output-escaping='yes'> "title": "</xsl:text><xsl:value-of select="$title" /><xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text><xsl:value-of select="$title2" /><xsl:text disable-output-escaping='yes'>"}</xsl:text>
                <xsl:if test="position()!=last()">
                    <xsl:text disable-output-escaping='yes'>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
