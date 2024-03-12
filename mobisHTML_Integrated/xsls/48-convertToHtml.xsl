<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">
    
    <xsl:import href="branch/46-reference.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />


    <xsl:key name="htmls" match="topic[@file]" use="@file"/>

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:apply-templates select="current()//topic[@file]"/>
    </xsl:template>

    <xsl:template match="topic">
        <xsl:variable name="filename" select="@file"/>
        <xsl:variable name="filename1" select="concat('../', 'output/', @file)"/>
        <xsl:variable name="cur" select="." />
        
        <xsl:result-document href="{$filename1}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{/topic/@data-language}">
                <xsl:attribute name="dir" select="if ($RTLlgs) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="/topic/@lang" />
                
                <xsl:call-template name="bodyHeader" />
                
                <body>
                    <xsl:call-template name="bodyTop">
                        <xsl:with-param name="cur" select="$cur" />
                    </xsl:call-template>
                    
                    <div id="wrapper">
                        <xsl:apply-templates select="@data-prev, @data-next" />
                        <div id="root">
                            <xsl:for-each select="div">
                                <xsl:apply-templates select="." />
                            </xsl:for-each>
                        </div>
                    </div>
                    
                    <xsl:if test="$commonRef/version/@value = '6th'">
                        <xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
                    </xsl:if>
                    <xsl:copy-of select="$body-footer" />
                    
                    <xsl:if test="$commonRef/version/@value = '6th'">
                        <xsl:copy-of select="$allContents" />
                    </xsl:if>
                    
                    <script type="text/javascript" src="js/video-play.js">&#xFEFF;</script>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="bodyHeader">
        <xsl:variable name="faviTitle">
            <xsl:call-template name="faviContents">
                <xsl:with-param name="cur" select="." />
            </xsl:call-template>
        </xsl:variable>
        
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta property="og:title">
                <xsl:attribute name="content" select="$faviTitle" />
            </meta>
            <meta property="og:image" content="images/M-hyundai_symbol.png"/>
            <meta property="twitter:title">
                <xsl:attribute name="content" select="$faviTitle" />
            </meta>
             
            <xsl:choose>
                <xsl:when test="$commonRef/version/@value = '6th'">
                    <link rel="apple-touch-icon" href="{concat('images/', $commonRef/company/@value, '_favicon_80.png')}" />
                    <link rel="apple-touch-icon-precomposed" href="{concat('images/', $commonRef/company/@value, '_favicon_80.png')}" />
                    <link rel="icon" href="{concat('images/', $commonRef/company/@value, '_favicon_16.png')}" type="image/x-icon" />
                    <link rel="shortcut icon" href="{concat('images/', $commonRef/company/@value, '_favicon_80.png')}" />
                </xsl:when>
                
                <xsl:otherwise>
                    <meta property="og:image" content="{concat('images/', $metaImage)}"/>
                    <meta name="twitter:image" content="{concat('images/', $metaImage)}"/>
                </xsl:otherwise>
            </xsl:choose>

            <meta property="og:description" content="{$uiTxtLang/title}"/>
            <meta name="twitter:card" content="summary"/>
            <meta name="twitter:description" content="{$uiTxtLang/title}"/>
            <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
            <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi"/>
            
            <xsl:choose>
                <xsl:when test="$commonRef/version/@value = '6th'">
                    <link rel="stylesheet" href="./styles/fonts/hy/stylesheet.css" />
                </xsl:when>
                
                <xsl:otherwise>
                    <link rel="stylesheet" href="{if (starts-with(/topic/@data-language, 'hyun')) then 
                        './styles/fonts/hy/stylesheet.css' else 
                        './styles/fonts/cube_R/stylesheet.css'}" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$body-header/self::div[matches(@class, 'contents')]/*" />
            
            <xsl:text disable-output-escaping='yes'>&lt;script async src="https://www.googletagmanager.com/gtag/js?id=</xsl:text>
            <xsl:value-of select="$URLformsAnalCode" />
            <xsl:text disable-output-escaping='yes'>"></xsl:text>
            <xsl:text disable-output-escaping='yes'>&lt;/script></xsl:text>
            <script>
                <xsl:text>window.dataLayer = window.dataLayer || [];</xsl:text>
                <xsl:text>function gtag() {dataLayer.push(arguments);}</xsl:text>
                <xsl:text>gtag('js', new Date());</xsl:text>
                <xsl:text>gtag('config', '</xsl:text>
                <xsl:value-of select="$URLformsAnalCode" />
                <xsl:text>');</xsl:text>
            </script>
        </head>
    </xsl:template>
    
    <xsl:template name="bodyTop">
        <xsl:param name="cur" />
        <div class="headerWrap">
            <div id="top">
                <div class="top_wrap">
                    <a class="logo" href="#">&#xFEFF;</a>
                    <div class="head_tit">&#xFEFF;</div>
                    
                    <xsl:choose>
                        <xsl:when test="$commonRef/version/@value = '6th'">
                            <xsl:for-each select="$searchBox/*">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:for-each select="node()">
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                        
                                        <button type="button" class="sch_Btn">
                                            <span>Search</span>
                                        </button>
                                    </xsl:for-each>
                                </xsl:copy>
                            </xsl:for-each>
                            
                            <div id="fontControll">&#xFEFF;</div>
                            <xsl:copy-of select="$allContents" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <div id="toolbar">&#xFEFF;</div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
            
            <div id="scroll_nav">
                <xsl:if test="$commonRef/version/@value = '6th'">
                    <div class="sNav_div">&#xFEFF;</div>
                </xsl:if>
                
                <div id="scrollmask">
                    <div class="scrollmaskWrap">
                        <div id="home_area">
                            <a class="home2" href="javascript:history.back(-1);">&#xFEFF;</a>
                        </div>
                        <span id="chapter">
                            <xsl:value-of select="ancestor::topic[@idml]/topic/h0/node()[not(self::*[matches(@class, 'c_below_chapter')])]"/>
                            <xsl:if test="ancestor::topic[@idml]/topic/h0/@caption">
                                <span class="caption">
                                    <xsl:value-of select="ancestor::topic[@idml]/topic/h0/@caption"/>
                                </span>
                            </xsl:if>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <xsl:if test="$commonRef/version/@value = '6th'">
            <div class="navWrap">
                <div class="all_contentsNav">&#xFEFF;</div>
            </div>
        </xsl:if>
        
        <xsl:if test="$commonRef/version/@value = '6th'">
            <xsl:text disable-output-escaping="yes">&lt;div class=&quot;contentsWrap&quot;></xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>