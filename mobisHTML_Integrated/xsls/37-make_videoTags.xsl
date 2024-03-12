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
    
    <xsl:template match="*[name() = 'h1' or name() = 'h2']">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::br" />
                    
                    <xsl:when test="self::text()[not(preceding-sibling::node())]">
                        <xsl:value-of select="replace(., '^\s+', '')" />
                    </xsl:when>
                    
                    <xsl:when test="self::text()[not(following-sibling::node())]">
                        <xsl:value-of select="replace(., '\s+$', '')" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
        
        <xsl:if test="@video-after">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-after" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ul | ol">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:choose>
            <xsl:when test="matches($commonRef/dataLanguage/@value, 'kia_Korean\(internal\)') and 
                            not(contains(@class, 'note')) and 
                            @video-after">
                <xsl:variable name="curr" select="." />
                <xsl:variable name="video_after" select="@video-after" />
                <xsl:variable name="video_size" select="@video-size" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::node())">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                    <video data-import="{$video_after}">
                                        <xsl:if test="$curr/@*[matches(name(), 'video-size')]">
                                            <xsl:attribute name="video-size" select="$video_size" />
                                        </xsl:if>
                                    </video>
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="@video-after">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-after" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="not(node()) and (@video-before or @video-after)">
                <xsl:call-template name="video-tem">
                    <xsl:with-param name="filename" select="@*[matches(name(), '(video-before|video-after)')]" />
                    <xsl:with-param name="size" select="@video-size" />
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:if test="@video-before">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-before" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
                
                <xsl:copy>
                    <xsl:apply-templates select="@* except @video-before, video-after" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
                
                <xsl:if test="@video-after">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-after" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
        
        <xsl:if test="@video-after">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-after" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="video-tem">
        <xsl:param name="filename" />
        <xsl:param name="size" />
        
        <xsl:element name="video">
            <xsl:attribute name="data-import" select="$filename" />
            
            <xsl:if test="$size">
                <xsl:attribute name="video-size" select="$size" />
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@video-after | @video-before | @video-size" />

    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="@class='heading1' and 
                            count(*) = 1 and h1">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    
                    <xsl:if test="following-sibling::*[1][name()='div'][@class='heading2']">
                        <xsl:apply-templates select="following-sibling::*[1][name()='div'][@class='heading2']/node()" />
                    </xsl:if>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="@class='heading2' and 
                            preceding-sibling::*[1][name()='div'][@class='heading1'][count(*) = 1][h1]" />
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()[parent::*[matches(@class, 'heading')]]">
        <xsl:analyze-string select="." regex="®">
            <xsl:matching-substring>
                <sup class="c_superscript-r-tm">
                    <xsl:value-of select="." />
                </sup>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>
