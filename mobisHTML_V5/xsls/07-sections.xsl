<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <chapter>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-starting-with="h0">
                <section title="{current-group()[1]}">
                    <xsl:if test="@id">
                        <xsl:attribute name="id" select="current-group()[1]/@id" />
                    </xsl:if>
                    <xsl:if test="@class">
                        <xsl:attribute name="class" select="current-group()[1]/@class" />
                    </xsl:if>
                    <xsl:if test="@caption">
                        <xsl:attribute name="caption" select="current-group()[1]/@caption" />
                    </xsl:if>
                    <xsl:apply-templates select="current-group()[position() &gt; 1]"/>
                </section>
            </xsl:for-each-group>
        </chapter>
    </xsl:template>

    <xsl:template name="videotemp">
        <xsl:param name="current" />

        <xsl:copy>
            <xsl:choose>
                <xsl:when test="video-content[1][matches(@position, 'before')]">
                    <xsl:attribute name="video-before" select="video-content[1]/@data-import" />
                    
                    <xsl:apply-templates select="video-content/@*[not(matches(name(), '(position|data-import)'))]" />
                </xsl:when>

                <xsl:when test="video-content[1][matches(@position, 'after')]">
                    <xsl:attribute name="video-after" select="video-content[1]/@data-import" />
                    
                    <xsl:apply-templates select="video-content/@*[not(matches(name(), '(position|data-import)'))]" />
                </xsl:when>
            </xsl:choose>

            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()[not(self::video-content)]" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[not(matches(name(), 'chapter'))]">
        <xsl:choose>
            <xsl:when test="self::tr[td[1]/*[1][matches(@class, 'THead')]]">
                <xsl:copy>
                    <xsl:attribute name="class" select="td[1]/*[1][matches(@class, 'THead')]/@class" />
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="video-content">
                <xsl:variable name="cur" select="name()" />
             
                <xsl:choose>
                    <xsl:when test="count(video-content) = 1">
                        <xsl:call-template name="videotemp">
                            <xsl:with-param name="current" select="." />
                        </xsl:call-template>
                        
                    </xsl:when>
                    
                    <xsl:when test="count(video-content) &gt; 1">
                        <xsl:call-template name="videotemp">
                            <xsl:with-param name="current" select="." />
                        </xsl:call-template>
                        
                        <xsl:for-each select="video-content[position() &gt; 1]">
                            <xsl:element name="{$cur}">
                                <xsl:choose>
                                    <xsl:when test="matches(@position, 'before')">
                                        <xsl:attribute name="video-before" select="@data-import" />
                                        
                                        <xsl:apply-templates select="@*[not(matches(name(), '(position|data-import)'))]" />
                                    </xsl:when>
                                    
                                    <xsl:when test="matches(@position, 'after')">
                                        <xsl:attribute name="video-after" select="@data-import" />
                                        
                                        <xsl:apply-templates select="@*[not(matches(name(), '(position|data-import)'))]" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:when test="matches(name(), 'img') and 
                        following-sibling::*[1][name() = 'video-content']">
                        <xsl:variable name="flw_video" select="following-sibling::*[1]" />
                        
                        <xsl:copy>
                            <xsl:attribute name="video-after" select="$flw_video/@data-import" />
                            
                            <xsl:if test="$flw_video/@video-size">
                                <xsl:attribute name="video-size" select="$flw_video/@video-size" />
                            </xsl:if>
                            
                            <xsl:apply-templates select="@* | node()" />
                        </xsl:copy>
                    </xsl:when>
                    
                    <xsl:when test="self::video-content">
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="parent::chapter and matches(name(), 'img') and 
                            following-sibling::*[1][name() = 'video-content']">
            <xsl:variable name="flw_video" select="following-sibling::*[1]" />
            
            <xsl:copy>
                <xsl:attribute name="video-after" select="$flw_video/@data-import" />
                
                <xsl:if test="$flw_video/@video-size">
                    <xsl:attribute name="video-size" select="$flw_video/@video-size" />
                </xsl:if>
                
                <xsl:apply-templates select="@* | node()" />
            </xsl:copy>
            </xsl:when>
            
            <xsl:when test="self::video-content">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>