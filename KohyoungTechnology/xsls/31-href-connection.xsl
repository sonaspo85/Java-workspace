<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="no" />

    <xsl:key name="targetID" match="*[@id]" use="@id" />

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="normalize">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="normalize" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="normalize"/>
        </xsl:variable>

        <xsl:apply-templates select="$str0/*" />
    </xsl:template>

    <xsl:template match="a[@href]" >
        <xsl:variable name="Shref" select="substring-after(@href, '#')" />
        <xsl:variable name="targetFilename" select="key('targetID', $Shref)/ancestor-or-self::*[@filename][1]/@filename" />
        <xsl:variable name="atrrCreate">
            <xsl:choose>
                <xsl:when test="key('targetID', $Shref)">
                    <xsl:value-of select="concat($targetFilename, @href)" />
                </xsl:when>
                
                <xsl:when test="matches(@href, 'TextNodeCopy')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="href" select="$atrrCreate" />
            <xsl:attribute name="class" select="'cross'" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="normalize" priority="10">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::*">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="normalize" />
                        </xsl:copy>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::node()) and 
                                            not(preceding-sibling::node()) and 
                                            matches(., '(^\s+)(.*)(\s+$)')">
                                <xsl:value-of select="replace(., '(^\s+)(.*)(\s+$)', '$2')" />
                            </xsl:when>

                            <xsl:when test="not(preceding-sibling::node()) and 
                                            matches(., '^\s+')">
                                <xsl:value-of select="replace(., '^\s+', '')" />
                            </xsl:when>

                            <xsl:when test="not(following-sibling::node()) and 
                                                    matches(., '\s+$')">
                                <xsl:value-of select="replace(., '\s+$', '')" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="." />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
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