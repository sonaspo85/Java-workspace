<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs ast son functx"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ParagraphStyleRange">
        <xsl:variable name="pStyle" select="@pStyle"/>
        
        <xsl:choose>
            <xsl:when test="starts-with(@pStyle, 'Image')">
                <xsl:apply-templates select="node()" />
            </xsl:when>
            
            <xsl:when test="Br[preceding-sibling::*[1][name()='video-content']]">
                <!--When adding a video by inserting a memo function in idml-->
                <xsl:for-each-group select="node()" group-ending-with="Br[preceding-sibling::*[1][name()='video-content']]">
                    <p class="{$pStyle}">
                        <xsl:if test="descendant-or-self::HyperlinkTextDestination">
                            <xsl:attribute name="id" select="generate-id(.)" />
                            <xsl:attribute name="hd" select="concat('hd_', string-join(descendant-or-self::HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                        </xsl:if>
                        
                        <xsl:if test="descendant-or-self::ParagraphDestination">
                            <xsl:attribute name="id" select="generate-id(.)" />
                            <xsl:attribute name="pd" select="concat('pd_', string-join(descendant-or-self::ParagraphDestination/@DestinationUniqueKey, ':'))" />
                        </xsl:if>
                        
                        <xsl:for-each select="current-group()">
                            <xsl:variable name="cur" select="." />
                            
                            <xsl:call-template name="nodeClean">
                                <xsl:with-param name="cur" select="$cur" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </p>
                </xsl:for-each-group>
            </xsl:when>

            <!--<xsl:when test="Br[preceding-sibling::*[1][name()='Note']]">
                
                <xsl:for-each-group select="node()" group-ending-with="Br[preceding-sibling::*[1][name()='Note']]">
                    <p class="{$pStyle}">
                        <xsl:if test="descendant-or-self::HyperlinkTextDestination">
                            <xsl:attribute name="id" select="generate-id(.)" />
                            <xsl:attribute name="hd" select="concat('hd_', string-join(descendant-or-self::HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                        </xsl:if>
                        
                        <xsl:if test="descendant-or-self::ParagraphDestination">
                            <xsl:attribute name="id" select="generate-id(.)" />
                            <xsl:attribute name="pd" select="concat('pd_', string-join(descendant-or-self::ParagraphDestination/@DestinationUniqueKey, ':'))" />
                        </xsl:if>
                        
                        <xsl:for-each select="current-group()">
                            <xsl:variable name="cur" select="." />
                            
                            <xsl:call-template name="nodeClean">
                                <xsl:with-param name="cur" select="$cur" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </p>
                </xsl:for-each-group>
            </xsl:when>-->
            
            <xsl:otherwise>
                <p class="{@pStyle}">
                    <xsl:if test=".//HyperlinkTextDestination">
                        <xsl:attribute name="id" select="generate-id(.)" />
                        <xsl:attribute name="hd" select="concat('hd_', string-join(.//HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                    </xsl:if>
                    
                    <xsl:if test=".//ParagraphDestination">
                        <xsl:attribute name="id" select="generate-id(.)" />
                        <xsl:attribute name="pd" select="concat('pd_', string-join(.//ParagraphDestination/@DestinationUniqueKey, ':'))" />
                    </xsl:if>

                    <xsl:for-each select="node()">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:call-template name="nodeClean">
                            <xsl:with-param name="cur" select="$cur" />
                        </xsl:call-template>
                    </xsl:for-each>
                </p>
                
                <xsl:apply-templates select="Table except Table[.//Content[matches(., '^NOTICE OF USE$')]]" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="nodeClean">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="name()='Table'">
                <!--<xsl:if test=".//Content='NOTICE OF USE'">
                    <xsl:apply-templates select="Table" />
                </xsl:if>-->
                
                <xsl:choose>
                    <xsl:when test=".//Content='NOTICE OF USE'">
                        <xsl:apply-templates select="Table" />
                    </xsl:when>
                    
                    <xsl:when test="matches(@AppliedTableStyle, 'Table_Symbol-Indent')">
                        <xsl:apply-templates select="Table" />
                    </xsl:when>
                    
                    <!--<xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>-->
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="name()='Content'">
                <xsl:apply-templates select="node()" />
            </xsl:when>
            
            <xsl:when test="self::Br[preceding-sibling::*[1][name()='video-content']]" />
            
            <xsl:when test="name()='Br'">
                <br/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="CharacterStyleRange">
        <xsl:variable name="current" select="." />
        
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="name()='Content'">
                    <xsl:if test="string(.)">
                        <ph class="{parent::CharacterStyleRange/@cStyle}">
                            <xsl:if test="$current//HyperlinkTextDestination">
                                <xsl:attribute name="id" select="concat('id_', generate-id(.))" />
                                <xsl:attribute name="hd" select="concat('hd_', string-join($current//HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                            
                            <xsl:if test="$current//ParagraphDestination">
                                <xsl:attribute name="id" select="concat('id_', generate-id(.))" />
                                <xsl:attribute name="pd" select="concat('pd_', string-join($current//ParagraphDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                            
                            <xsl:apply-templates select="node()" />
                        </ph>
                    </xsl:if>
                </xsl:when>
                
                <xsl:when test="name()='Br'">
                    <br/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="HyperlinkTextDestination | ParagraphDestination" />
    
    <xsl:template match="HyperlinkTextDestination[parent::CharacterStyleRange]" />
    
    
    
    <xsl:template match="Br[parent::ParagraphStyleRange]" />

</xsl:stylesheet>
