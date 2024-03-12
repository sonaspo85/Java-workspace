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

    <xsl:key name="destinationKeys" match="//*[@*[matches(name(), concat('DesKey', '\d+'))]]" use="@*[matches(name(), concat('DesKey', '\d+'))]" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="CreateAtrrkey">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="CreateAtrrkey" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates  mode="CreateAtrrkey"/>
        </xsl:variable>

        <xsl:apply-templates select="$str0/node()" />
    </xsl:template>


    <xsl:template match="*[a[@name]]" mode="CreateAtrrkey">
        <xsl:variable name="cntA">
            <xsl:for-each select="a[@name]">
                <xsl:element name="{concat('DesKey', position())}">
                    <xsl:value-of select="@name" />
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:for-each select="$cntA/*">
                <xsl:attribute name="{name()}" select="." />
            </xsl:for-each>
            <xsl:attribute name="id" select="generate-id()" />
            <xsl:apply-templates select="@*, node()" mode="CreateAtrrkey" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="a[@name]" mode="CreateAtrrkey">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@href">
        <xsl:choose>
            <xsl:when test="starts-with(., '#')">
                <xsl:variable name="href" select="substring-after(., '#')" />
                <xsl:attribute name="{local-name()}">
                    <xsl:choose>
                        <xsl:when test="key('destinationKeys', $href)">
                            <xsl:value-of select="concat('#', key('destinationKeys', $href)/@id)"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="." />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:when>

            <xsl:otherwise>
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[not(matches(name(), '(^td$|^img$)'))]" priority="10">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and img">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:when test="not(string(normalize-space(.))) and not(*)">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
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