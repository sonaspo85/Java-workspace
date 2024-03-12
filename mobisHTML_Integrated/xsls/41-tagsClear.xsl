<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="table">
        <xsl:copy>
            <xsl:apply-templates select="@* except @tableSize" />
            
            <xsl:choose>
                <xsl:when test="@tableSize">
                    <xsl:attribute name="style">
                        <xsl:text>width:</xsl:text>
                        <xsl:value-of select="@tableSize" />
                    </xsl:attribute>
                    
                    <xsl:apply-templates select="node()" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="video">
        <xsl:variable name="cur" select="." />
        
        <xsl:variable name="numbers">
            <xsl:number from="topic[@file]" count="video" level="any" format="1" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="preceding-sibling::node()[1][name()='h2']">
                <xsl:variable name="preHeading2" select="preceding-sibling::node()[1]" />
                
                <div class="video_container">
                    <xsl:choose>
                        <xsl:when test="count($preHeading2/ancestor::topic[1]/div[@class='heading2']) &gt;= 2">
                            <xsl:for-each select="$preHeading2">
                                <xsl:element name="{local-name()}">
                                    <xsl:attribute name="class" select="concat(@class, ' ', 'Heading2-APPLINK')"/>
                                    <xsl:apply-templates select="@id"/>
                                    <xsl:apply-templates select="node()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="preceding-sibling::node()[1]" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:call-template name="videoContainer">
                        <xsl:with-param name="cur" select="$cur" />
                        <xsl:with-param name="numbers" select="$numbers" />
                    </xsl:call-template>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:call-template name="videoContainer">
                    <xsl:with-param name="cur" select="$cur" />
                    <xsl:with-param name="numbers" select="$numbers" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="videoContainer">
        <xsl:param name="cur" />
        <xsl:param name="numbers" />
        
        <xsl:variable name="videoLink" select="$cur/@data-import" />
        <xsl:variable name="size">
            <xsl:choose>
                <xsl:when test="@video-size">
                    <xsl:value-of select="concat('video_', @video-size)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('video_', '100')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$cur/@data-import[matches(., '(youtube|youtu\.be)')]">
                <xsl:text disable-output-escaping="yes">&lt;iframe width="100%" height="100%" </xsl:text>
                <xsl:text>src="</xsl:text>
                <xsl:value-of select="replace(replace($videoLink, 'https://', 'https://www.'), 'youtu\.be', 'youtube.com/embed')"/>
                <xsl:text disable-output-escaping="yes">" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" </xsl:text>
                <xsl:text>class="</xsl:text>
                <xsl:value-of select="$size" />
                <xsl:text disable-output-escaping="yes">" id="video</xsl:text>
                <xsl:value-of select="$numbers" />
                <xsl:text disable-output-escaping="yes">" preload="none" allowfullscreen="true" autocomplete="off"&gt;&#xFEFF;&lt;/iframe&gt;</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <div>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$size" />
                    </xsl:attribute>
                    
                    <video poster="{replace($videoLink, '.mp4', '.png')}" controlsList="nodownload" crossorigin="anonymous" preload="none" autocomplete="off">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('video', $numbers)" />
                        </xsl:attribute>
                        <source src="{$videoLink}" type="video/mp4" />
                    </video>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template match="li">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="child::img[@class = 'c_image-cell']">
                    <div class="c_img_Group">
                        <xsl:apply-templates select="node()" />
                    </div>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="not(node())" />
                
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="child::*[@class = 'c_text-cell']">
                            <xsl:apply-templates select="@* except @class" />
                            <xsl:attribute name="class" select="concat(@class, ' ', 't_indent')" />
                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="@*" />
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="h2[following-sibling::node()[1][name()='video']]" />
    <!--<xsl:template match="p[not(node())]" />-->
    
    <xsl:template match="@video-before | @video-after" />
    
    <xsl:template match="text()" priority="5">
        <xsl:choose>
            <xsl:when test="parent::*[matches(name(), '(h1|h2)')] and 
                            not(following-sibling::node())">
                <xsl:value-of select="replace(., '\s+$', '')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template match="@href">
        <xsl:attribute name="href" select="replace(., '^(0\d+_)(.*)', '$2')" />
    </xsl:template>-->

</xsl:stylesheet>