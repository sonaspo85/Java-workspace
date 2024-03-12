<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/*[matches(name(), '(p|^h)')]" priority="10">
        <xsl:variable name="cur" select="name()" />

        <xsl:variable name="eleName">
            <xsl:choose>
                <xsl:when test="matches(@class, 'heading2_midtitle')">
                    <xsl:value-of select="'h1'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="name()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="classVal">
            <xsl:choose>
                <xsl:when test="matches($cur, '^h\d+')">
                    <xsl:value-of select="concat('heading', substring-after($cur, 'h'))" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'noclass'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$eleName}">
            <xsl:if test="not(@class)">
                <xsl:attribute name="class" select="$classVal" />
            </xsl:if>
            <xsl:if test="not(@id)">
                <xsl:attribute name="id" select="concat('d', generate-id())" />
            </xsl:if>
            <xsl:apply-templates select="@*, node()" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*[matches(name(), 'ast\d+\-')]">
        <xsl:variable name="str0" select="replace(name(), 'ast\d+\-', '')" />

        <xsl:attribute name="{$str0}" select="." />
    </xsl:template>

    <xsl:template match="img">
        <xsl:variable name="srcFilename" select="tokenize(@*[matches(name(), 'src')], '/')[last()]" />
        <xsl:copy>
            <xsl:apply-templates select="@* except @*[matches(name(), 'src')]" />
            
            <xsl:attribute name="src" select="concat('images/', $srcFilename)" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '\s+', '&#x20;')" />
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