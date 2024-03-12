<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[parent::topic]">
        <xsl:variable name="level" select="count(ancestor::*)" />
        <xsl:variable name="depth" select="$level - 2" />
        <xsl:variable name="chapter" select="ancestor-or-self::topic[@idml]/@idml" />
    
        <xsl:copy>
            <xsl:apply-templates select="@* except @id" />
            <xsl:choose>
                <xsl:when test="name()='topic' and 
                                *[1][name()='title']">
                    <xsl:variable name="title">
                        <xsl:value-of select="*[1][name()='title']" />
                    </xsl:variable>
                    
                    <xsl:variable name="link" select="$linkedIdFile/listitem[fileName[.=$chapter]]
                                                                            [Depth[.=$depth]]
                                                                            [contents_string[normalize-space(.)=normalize-space($title)]]" />
                    
                    <xsl:if test="$link[shortcutID/node()]/shortcutID">
                        <xsl:variable name="scids">
                            <xsl:for-each select="$link">
                                <xsl:value-of select="replace(replace(replace(replace(replace(shortcutID, '\C', '_'), '[.:-]', '_'), '^_', ''), '_$', ''), '_+', '_')" />
                                <xsl:if test="position()!=last()">
                                    <xsl:text>&#x20;</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:attribute name="scid" select="$scids" />
                    </xsl:if>

                    <xsl:if test="@id">
                        <xsl:attribute name="id" select="@id" />
                    </xsl:if>
                    
                    <xsl:apply-templates select="node()" />
                </xsl:when>
                
                <xsl:when test="name()='title'">
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="self::*[not(contains(@class, 'C_MMI'))]">
                                <xsl:apply-templates select="." />
                            </xsl:when>

                            <xsl:when test="self::text()[not(following-sibling::node())]">
                                <xsl:value-of select="replace(., '\s+$', '')" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="string(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:if test="@id">
                        <xsl:attribute name="id" select="@id" />
                    </xsl:if>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>