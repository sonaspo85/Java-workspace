<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="no" />
    
    <xsl:variable name="outputPath" select="root/body/@outputPath" />
    <xsl:variable name="outFolderName" select="root/@outFolderName" />
    <xsl:variable name="sourceName0" select="replace(root/@sourcename, '\\', '/')" />
    <xsl:variable name="sourceName" select="replace(ast:last($sourceName0, '/'), '.htm', '')"/>

    <xsl:variable name="lang" select="root/body/@lang" />
    <xsl:variable name="langCode" select="document(concat(ast:getPath(base-uri(.), '/'), '/codes.xml'))/codes/option" />
    <xsl:variable name="langVal" select="$langCode[$lang=@lang]/@lang" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body" priority="10">
        <xsl:variable name="curBody" select="." />
        <xsl:variable name="filename" select="concat('file:////', $outputPath, '/', $outFolderName, '/', $langVal, '/js/', 'search_db.js')"/>
        
        <xsl:result-document href="{$filename}">
            <xsl:text>var search=[</xsl:text>
            <xsl:for-each select="//*[@filename][not(matches(@filename, 'CoverInfo'))]">
                <xsl:variable name="toc_id" select="@filename" />
                <xsl:variable name="chapter_i" select="count(ancestor-or-self::chapter/preceding-sibling::chapter) + 1" />
                <xsl:variable name="chapter" select="ancestor-or-self::chapter/@browerTitle" />
                <xsl:variable name="title" select="ancestor-or-self::*[*[1][matches(name(), 'h2')]][1]/*[1][matches(name(), 'h2')] | 
                                                   ancestor-or-self::*[*[1][matches(name(), 'h1')]][1]/*[1][matches(@class, 'heading2_midtitle')]" />

                <xsl:variable name="title2" select="*[1][matches(name(), 'h3')]" />
                <xsl:variable name="body">
                    <xsl:apply-templates select="* except (*[starts-with(name(),'h')][1], topic)" mode="body" />
                </xsl:variable>
                <xsl:variable name="bodyReplace">
                    <xsl:value-of select="replace(replace(replace(
                                          $body, '&#xA0;', ' '),
                                          '\\', '\\\\'),
                                          '&quot;', '\\x22')"/>
                </xsl:variable>
                    <xsl:text disable-output-escaping='yes'>&#xA;{&#xA;"toc_id": "</xsl:text>
                    <xsl:value-of select="$toc_id"/>
                    <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                    <xsl:text disable-output-escaping='yes'> "chapter_i": "</xsl:text>
                    <xsl:value-of select="$chapter_i"/>
                    <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                    <xsl:text disable-output-escaping='yes'> "chapter": "</xsl:text>
                    <xsl:value-of select="$chapter"/>
                    <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                    <xsl:text disable-output-escaping='yes'> "title": "</xsl:text>
                    <xsl:value-of select="$title" />
                    <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                    <xsl:text disable-output-escaping='yes'> "title2": "</xsl:text>
                    <xsl:value-of select="$title2" />
                    <xsl:text disable-output-escaping='yes'>",&#xA;</xsl:text>
                    <xsl:text disable-output-escaping='yes'> "body": "</xsl:text>
                <xsl:value-of select="normalize-space($bodyReplace)"  />

                    <xsl:choose>
                        <xsl:when test="position()=last()">
                            <xsl:text disable-output-escaping='yes'>"&#xA;}</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text disable-output-escaping='yes'>"&#xA;},</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
            </xsl:for-each>
            <xsl:text>&#xA;]</xsl:text>
        </xsl:result-document>
        
        <xsl:result-document href="{concat('file:////', $outputPath, '/', $outFolderName, '/', $langVal, '/images/', 'dummy.xml')}">
            <dummy/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="ul | ol | li | p | td | br | *[starts-with(name(), 'h')]" mode="body">
        <xsl:text>&#x20;</xsl:text>
        <xsl:apply-templates mode="body" />
        <xsl:text>&#x20;</xsl:text>
    </xsl:template>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>