<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />

    <xsl:variable name="docLang" select="root/body/@lang" />
    <xsl:variable name="langCode" select="document(concat(ast:getPath(base-uri(.), '/'), '/codes.xml'))/codes/option" />

    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="topic">
        <xsl:variable name="fileValues">
            <xsl:variable name="chapterIdx">
                <xsl:choose>
                    <xsl:when test="matches(@class, 'heading2_midtitle')">
                        <xsl:value-of select="'00'" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="tokenize(ancestor::chapter[1]/@filename, '_')[1]" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="*[1][name()='h2']">
                    <xsl:variable name="h2subIdx">
                        <xsl:value-of select="format-number(count(preceding-sibling::topic)+1, '00')" />
                    </xsl:variable>
                    <xsl:value-of select="concat($chapterIdx, '_', 'heading', $h2subIdx, '_', $docLang, '.html')" />
                </xsl:when>
                
                <xsl:when test="*[1][name()='h3']">
                    <xsl:variable name="h2subIdx">
                        <xsl:value-of select="format-number(count(parent::*/preceding-sibling::topic)+1, '00')" />
                    </xsl:variable>
                    
                    <xsl:variable name="h3subIdx">
                        <xsl:value-of select="format-number(count(preceding-sibling::topic)+1, '00')" />
                    </xsl:variable>
                    <xsl:value-of select="concat($chapterIdx, '_', 'heading', $h2subIdx, '_', 'sub', $h3subIdx, '_', $docLang, '.html')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:attribute name="filename" select="$fileValues" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@browerTitle, '^CoverInfo$')])">
                <xsl:choose>
                    <xsl:when test="current-group()[1][matches(@browerTitle, '^CoverInfo$')][not(preceding-sibling::chapter)]">
                        <chapter>
                            <xsl:apply-templates select="@* except @filename" />
                            <xsl:attribute name="filename" select="'Info.html'" />
                            <h1>
                                <xsl:value-of select="$langCode[@lang=$docLang]/@CoverTitle" />
                            </h1>
                            <xsl:copy-of select="preceding-sibling::node()[1][matches(@class, 'coverContent')]" />

                            <xsl:for-each select="current-group()">
                                <topic>
                                    <xsl:apply-templates select="@*, node()" />
                                </topic>
                            </xsl:for-each>
                        </chapter>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[matches(@class, 'coverContent')]">
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