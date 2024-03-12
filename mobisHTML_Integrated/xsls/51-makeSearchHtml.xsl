<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a"  />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:variable name="SearchHtml" select="concat('..', '/output/search/search.html')" />
        
        <xsl:result-document href="{$SearchHtml}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-key="search-page" data-language="{@data-language}">
                <xsl:attribute name="dir" select="if ($RTLlgs) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="@lang" />
                
                <xsl:call-template name="bodyHeader" />
                
                <body>
                    <xsl:for-each select="$search-top">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="abc" />
                        </xsl:copy>
                    </xsl:for-each>
                    <xsl:copy-of select="$search-footer" />
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="div[matches(@id, 'toolbar')]" mode="abc">
        <xsl:choose>
            <xsl:when test="$commonRef/version/@value != '6th'">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:value-of select="'&#xFEFF;'" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img[matches(@id, 'id_search_button')]" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@* except @src" />
            
            <xsl:choose>
                <xsl:when test="$commonRef/version/@value = '6th'">
                    <xsl:attribute name="src" select="'../images/search_gray_bt.png'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:attribute name="src" select="'../images/h_search_icon.png'" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
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
            
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=0" />
            
            <title>﻿&#xFEFF;</title>
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
            
            <xsl:copy-of select="$body-header/self::div[matches(@class, 'search')]/*" />
            
            
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