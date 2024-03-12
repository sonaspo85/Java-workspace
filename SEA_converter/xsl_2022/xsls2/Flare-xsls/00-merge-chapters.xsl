<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:son="http://www.astkorea.net/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="MadCap son xs">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />

    <xsl:param name="SourcePath" />
    
    <xsl:variable name="fullPath" as="xs:string" select="concat('file:////', replace(replace($SourcePath, '\\', '/'), ' ', '%20'))"/>
    <xsl:variable name="files" select="document($fullPath)" />
    <!--<xsl:variable name="files" select="collection(concat(son:getpath($fullPath, '/'), '?select=*.htm;recurse=yes'))" />-->
    <!--<xsl:variable name="files" select="concat('file:////', replace(replace($filename, '\\', '/'), ' ', '%20'))" />-->
    <!--<xsl:variable name="files" select="collection(concat(replace(son:getpath(base-uri(.), '/'), 'xsls2', 'Source-Flare'), '?select=*.htm;recurse=yes'))" />-->
    <xsl:variable name="filename" select="concat(son:getpath(base-uri(.), '/'), '/../temp', '/mergedXML.xml')" />
    

    <xsl:template match="* | @*">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:result-document href="{$filename}">
            <root sourcePath="{son:getpath($fullPath, '/')}">
                <xsl:for-each select="$files/node()">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </xsl:for-each>
            </root>
        </xsl:result-document>
        <dummy/>
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
