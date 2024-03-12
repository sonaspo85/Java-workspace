<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">


    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />

    <xsl:key name="topics" match="topic" use="@id" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="a">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:choose>
                        <xsl:when test="key('topics', substring-after(@href, '#'))/@scid">
                            <xsl:variable name="topic" select="key('topics', substring-after(@href, '#'))" />
                            
                            <xsl:choose>
                                <xsl:when test="count(tokenize($topic/@scid, ' ')) &gt; 1">
                                    <xsl:variable name="prefix" select="substring-before($topic/ancestor::topic[@scid][1]/@scid, '_')" />
                                    <xsl:attribute name="href" select="concat('#', tokenize($topic/@scid, ' ')[starts-with(., $prefix)][1])" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:attribute name="href" select="concat('#', key('topics', substring-after(@href, '#'))/@scid)" />
                                    <xsl:attribute name="ohref" select="@href" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="@href" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="@href" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[parent::topic]">
        <xsl:variable name="depth" select="count(ancestor::*)" />

        <xsl:copy>
            <xsl:choose>
                <xsl:when test="name()='topic' and @scid">
                    <xsl:choose>
                        <xsl:when test="count(tokenize(@scid, ' ')) &gt; 1">
                            <xsl:variable name="prefix" select="substring-before(ancestor::topic[@scid][1]/@scid, '_')" />
                            <xsl:attribute name="id" select="tokenize(@scid, ' ')[starts-with(., $prefix)][1]" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:attribute name="id" select="@scid" />
                            <xsl:attribute name="oid" select="@id" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:apply-templates select="@* except @id" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="@*" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>