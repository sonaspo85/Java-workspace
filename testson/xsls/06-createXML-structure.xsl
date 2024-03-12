<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&quot;" />
        <xsl:output-character character="&apos;" string="&apos;" />
        
        <xsl:output-character character="&amp;" string="&amp;" />
        <xsl:output-character character="&lt;" string="&lt;" />
        <xsl:output-character character="&gt;" string="&gt;" />
    </xsl:character-map>
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" use-character-maps="a" />
    <xsl:key name="IDKeys" match="GroupID/*" use="@ASTID" />
   
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@ASTID]">
        <xsl:variable name="sourceID" select="@ASTID" />

        <xsl:choose>
            <xsl:when test="key('IDKeys', $sourceID)">
                <xsl:value-of select="key('IDKeys', $sourceID)" />
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="root/GroupID">
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