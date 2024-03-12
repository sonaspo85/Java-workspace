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
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="cur" select="topic/topic[@idml]" />
        
        <topic data-language="{/topic/@data-language}">
            <xsl:attribute name="lang">
                <xsl:if test="$commonRef/language/@value = $codesFile/code/@Fullname">
                    <xsl:value-of select="$codesFile/code[@Fullname = $commonRef/language/@value]/@twoLetter" />
                </xsl:if>
            </xsl:attribute>
            
            <xsl:for-each select="$indexSortTopic/topic">
                <xsl:variable name="idml" select="@idml" />
                <xsl:apply-templates select="$cur[@idml = $idml]" mode="abc" />
            </xsl:for-each>
        </topic>
    </xsl:template>
    
    <xsl:variable name="str01">
        <xsl:for-each select="//topic[matches(@idml, '^002_Features')]/topic/topic[@file]">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="topic[@file]" mode="abc">
        <xsl:variable name="curfile" select="@file" />
        <xsl:variable name="idmlName" select="@idml" />
        <xsl:variable name="fileName" select="replace(@file, $idmlName, '')" />
        
        <xsl:choose>
            <xsl:when test="ancestor::topic[matches(@idml, '002_Features_')]">
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="matches(@file, '_\d\.html$') and 
                                        $curfile = $str01/*/@file">
                            <xsl:variable name="idx" select="index-of($str01/*/@file, $curfile)"/>
                            
                            <xsl:apply-templates select="@* except @file" />
                            
                            <xsl:attribute name="idml">
                                <xsl:value-of select="concat('002_Features_', $idx)" />
                            </xsl:attribute>
                            
                            <xsl:attribute name="file">
                                <xsl:value-of select="concat('002_Features_', $idx, '.html')" />
                            </xsl:attribute>
                            
                            <xsl:apply-templates select="node()" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:variable name="lastid" select="ast:getNameLast(@file, '_')"/>
                            
                            <xsl:apply-templates select="@* except @file" />
                            
                            <xsl:attribute name="idml">
                                <xsl:value-of select="concat('002_Features', replace($fileName, '.html', ''))" />
                            </xsl:attribute>
                            
                            <xsl:attribute name="file">
                                <xsl:value-of select="concat('002_Features', $fileName)" />
                            </xsl:attribute>
                            
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>