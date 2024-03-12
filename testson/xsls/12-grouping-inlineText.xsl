<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a h1 h2 h3 h4 h5 b i" />
    
    <xsl:key name="destinationKeys" match="a[@name]" use="@name" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" priority="10">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::b)">
                    <xsl:choose>
                        <xsl:when test="current-group()[1][name()='b']">
                            <b>
                                <xsl:apply-templates select="current-group()/node()" />
                            </b>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each-group select="$str0/node()" group-adjacent="boolean(self::i)">
                <xsl:choose>
                    <xsl:when test="current-group()[1][name()='i']">
                        <i>
                            <xsl:apply-templates select="current-group()/node()" />
                        </i>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()[not(ancestor::tr)]">
        <xsl:value-of select="replace(replace(., '&#xfeff;', ''), '\s+', '&#x20;')" />
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