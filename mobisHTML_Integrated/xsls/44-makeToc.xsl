<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:variable name="TocFile" select="'../output/toc1.html'" />

        <xsl:result-document href="{$TocFile}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{@data-language}">
                <xsl:attribute name="dir" select="if ($RTLlgs) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="@lang" />
                
                <xsl:call-template name="bodyHeader" />
                
                <body>
                    <div id="top">
                        <div id="header">
                            <a href="javascript:history.back(-1);">
                                <img src="images/home_icon2.png" alt="" class="home" />
                            </a>
                            <div><span id="userManual">&#x20;&#xFEFF;</span></div>
                        </div>
                    </div>
                    
                    <div id="container">
                        <div id="con_list">
                            <div id="id_toc1">
                                <xsl:for-each select="topic[@idml]">
                                    <h1 class="toc-chap" data-style="Chapter">
                                        <a href="#">
                                            <span class="chapter_text2">
                                                <xsl:value-of select="topic[1]/h0/text()"/>
                                            </span>
                                        </a>
                                    </h1>
                                    
                                    <ul class="toc-sect">
                                        <xsl:for-each select="topic[1]/topic[@file]">
                                            <xsl:variable name="cur" select="." />
                                            <xsl:variable name="h1id" select="h1[1]/@id" />
                                            <xsl:variable name="h1-idx" select="count($cur/preceding::h1)" />

                                            <xsl:variable name="getFileVal">
                                                <xsl:variable name="fileLastSCID" select="tokenize(replace(@file, '.html', ''), '_')[last()]" />
                                                <xsl:variable name="LastID" select="$h1id" />

                                                <xsl:value-of select="if ($fileLastSCID = $LastID) then @file 
                                                                      else concat(@file, '#', $h1id)"/>
                                            </xsl:variable>
                                            
                                            <li>
                                                <a>
                                                    <xsl:attribute name="href" select="if (not(preceding-sibling::topic) and 
                                                                                       ancestor::topic[@idml]/descendant::*[matches(@class, 'sublink')]) 
                                                                                       then @file 
                                                                                       else $getFileVal" />
                                                    
                                                    <xsl:apply-templates select="*[1]" mode="normalize"/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:for-each>
                            </div>
                        </div>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="normalize">
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:choose>
                        <xsl:when test="following-sibling::node()[matches(@class, 'c_below_heading')]">
                            <xsl:value-of select="normalize-space(.)" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="." />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="self::br" />
                
                <xsl:when test="self::*[matches(@class, 'styleh1')]">
                    <xsl:value-of select="descendant-or-self::text()" />
                </xsl:when>
                
                <xsl:when test="self::*[not(matches(@class, 'c_below_heading'))]">
                    <xsl:copy>
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="bodyHeader">
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta property="og:title" content="{$uiTxtLang/html_title}"/>
            <meta property="og:image" content="images/M-hyundai_symbol.png"/>
            <meta property="og:description" content="{$uiTxtLang/title}"/>
            <meta name="twitter:card" content="summary"/>
            <meta name="twitter:title" content="{$uiTxtLang/html_title}"/>
            <meta name="twitter:description" content="{$uiTxtLang/title}"/>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
            <meta name="apple-mobile-web-app-capable" content="yes" />
            
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
            <xsl:copy-of select="$body-header/self::div[matches(@class, 'index')]/*" />
            <!--<xsl:variable name="var0">
                <xsl:copy-of select="$body-header/self::div[matches(@class, 'index')]/*" />
            </xsl:variable>-->
            
            
            
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
    
</xsl:stylesheet>
