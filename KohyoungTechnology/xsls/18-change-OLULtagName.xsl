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

    <xsl:template match="*[matches(name(), '(^OL|^UL)')]">
        <xsl:choose>
            <xsl:when test="matches(name(), '^UL')">
                <ul>
                    <xsl:attribute name="class" select="local-name()" />
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <li>
                            <xsl:apply-templates select="@class" />
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ol>
                    <xsl:attribute name="class" select="local-name()" />
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <li>
                            <xsl:apply-templates select="@class" />
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </li>
                    </xsl:for-each>
                </ol>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ListIndent">
        <xsl:variable name="name" select="*[1]/@class" />
        <xsl:variable name="name1" select="if (matches($name, '^UL')) then 'ul' else 'ol'" />

        <xsl:element name="{$name1}">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="class" select="local-name()" />
            <xsl:for-each select="node()">
                <li>
                    <xsl:apply-templates select="@class" />
                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </li>
            </xsl:for-each>
        </xsl:element>
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