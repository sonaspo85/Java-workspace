<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:son="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap son">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />

    <xsl:variable name="filename" select="concat(son:getpath(base-uri(.), '/'), '/../temp', '/mergedXML.xml')" />
    <xsl:variable name="files" select="collection(concat(replace(son:getpath(base-uri(.), '/'), 'xsls2', 'Source-Flare'), '?select=*.htm;recurse=yes'))" />
    <xsl:variable name="chpaterOrder" select="collection(concat(replace(son:getpath(base-uri(.), '/'), 'xsls2', 'Source-Flare'), '?select=*.mcbook;recurse=yes'))" />
        

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="{$filename}">
            <root>
                <xsl:for-each select="$chpaterOrder/MadCapBook/Chapter">
                    <xsl:variable name="orderIdx" select="@Link"/>
                    
                    <xsl:for-each select="$files/node()">
                        <xsl:variable name="pathName" select="replace(son:last(base-uri(.), '/'), '%20', ' ')"/>
                        <xsl:choose>
                            <xsl:when test="$orderIdx = $pathName">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>
            </root>
        </xsl:result-document>
    </xsl:template>

    <xsl:function name="son:normalized">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(replace(replace(normalize-space(replace($value, '\+', '_plus')), '[!@#$%&amp;();:,’?]+', ''), '[ &#xA0;]', '_'), '/', '_')"/>
    </xsl:function>
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>
    
    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>
