<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="company" select="tokenize(/topic/@data-language, '_')[1]" />
    <xsl:variable name="type" select="substring-before(substring-after(/topic/@data-language, '('), ')')" />
    <xsl:variable name="chapter_sort" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'index_sort.xml'))/root" />
    
    <xsl:variable name="lgns" select="substring-after(/topic/@data-language, '_')" />
    <xsl:variable name="fullLanguage" select="substring-before($lgns, '(')" />
    <xsl:variable name="codesFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'codes.xml'))/codes/langs" />
    
    <xsl:variable name="lang_iso">
        <xsl:for-each select="$codesFile/*">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="chapter_idml">
        <xsl:for-each select="$chapter_sort/chapter[matches(@company, $company)]">
            <xsl:variable name="same" select="current()[@type = $type]" />

            <xsl:variable name="same_topic">
                <xsl:if test="$same">
                    <xsl:sequence select="$same/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="differ_topic">
                <xsl:if test="not(parent::*/chapter[@type = $type]) and current()[@type != $type]">
                    <xsl:sequence select="current()[@type = 'common']/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$same_topic/node()">
                    <xsl:copy-of select="$same_topic" />
                </xsl:when>

                <xsl:when test="not($same_topic/node()) and $differ_topic">
                    <xsl:copy-of select="$differ_topic" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="curr" select="topic/topic[@idml]" />
        <xsl:text>&#xA;</xsl:text>
        <topic data-language="{/topic/@data-language}">
            <xsl:attribute name="lang">
                <xsl:value-of select="substring-before($lang_iso/*[@Fullname = $fullLanguage]/@ISO, '-')" />
            </xsl:attribute>
            <xsl:for-each select="$chapter_idml/topic">
                <xsl:variable name="idml" select="@idml" />
                <xsl:apply-templates select="$curr[@idml = $idml]" mode="abc" />
            </xsl:for-each>
        </topic>
    </xsl:template>
    
    <xsl:variable name="str01">
        <xsl:for-each select="//topic[matches(@idml, '^002_Features')]/topic/topic[@file]">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="topic[@file]" mode="abc">
        <xsl:variable name="curfile" select="@file" />
        
        <xsl:choose>
            <xsl:when test="ancestor::topic[matches(@idml, '002_Features_')]">
                <xsl:copy>
                    
                    <xsl:choose>
                        <xsl:when test="matches(@file, '_\d\.html$') and 
                                        $curfile = $str01/*/@file">
                            <xsl:variable name="idx" select="index-of($str01/*/@file, $curfile)"/>
                            
                            <xsl:apply-templates select="@* except @file" />
                            <xsl:attribute name="file">
                                <xsl:value-of select="concat('002_Features_', $idx, '.html')" />
                            </xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="lastid" select="ast:last(@file, '_')"/>
                            
                            <xsl:apply-templates select="@* except @file" />
                            <xsl:attribute name="file">
                                <xsl:value-of select="concat('002_Features_', $lastid)" />
                            </xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:getLast">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="if (count(tokenize($str, $char)) = 2) then tokenize($str, $char)[position() eq last()] else string-join(tokenize($str, $char)[position() ne 1], $char)" />
    </xsl:function>
    
    <xsl:function name="ast:last">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>