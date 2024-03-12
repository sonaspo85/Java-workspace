<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />


    <xsl:variable name="docLang" select="root/body/@lang" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:sequence select="ast:group(*, 1)" />
        </xsl:copy>
    </xsl:template>


    <xsl:function name="ast:group">
        <xsl:param name="elements" />
        <xsl:param name="level" />

        <xsl:for-each-group select="$elements" group-starting-with="*[local-name() eq concat('h', $level)]">
            <xsl:variable name="chapterIdx">
                <xsl:choose>
                    <xsl:when test="matches(@class, 'heading2_midtitle')">
                        <xsl:variable name="str0">
                            <xsl:value-of select="format-number(count(preceding-sibling::h1[matches(@class, 'heading2_midtitle')])+1, '00')" />
                        </xsl:variable>
                        <xsl:value-of select="concat('chapter00', '_', 'heading', $str0, '_', $docLang, '.html')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="str0">
                            <xsl:value-of select="format-number(count(preceding-sibling::h1[matches(@class, 'heading1')])+1, '00')" />
                        </xsl:variable>
                        
                        <xsl:value-of select="concat('chapter', $str0, '_', $docLang, '.html')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$level &gt; 3">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                
                <xsl:when test="self::*[local-name() eq 'h1']">
                    <chapter>
                        <xsl:attribute name="filename" select="$chapterIdx" />
                        <xsl:attribute name="browerTitle" select="if (matches(@class, 'heading2_midtitle')) then 'CoverInfo' else ." />
                        <xsl:apply-templates select="current-group()[1]" />
                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </chapter>
                </xsl:when>

                <xsl:when test="self::*[local-name() eq concat('h', $level)]">
                    <topic>
                        <xsl:attribute name="id" select="@id" />
                        <xsl:apply-templates select="current-group()[1]" />
                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </topic>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:function>

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