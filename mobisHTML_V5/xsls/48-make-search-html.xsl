<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />
    
    <xsl:variable name="data-language" select="/topic/@data-language" />
    <xsl:variable name="company" select="substring-before(/topic/@data-language, '_')" />
    <xsl:variable name="lgns" select="substring-after(/topic/@data-language, '_')" />
    <xsl:variable name="langISO" select="/topic/@lang" />
    <xsl:variable name="root" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'URL_form.xml'))" />
    <xsl:variable name="URLforms1" select="$root/root/URLform[starts-with(Project, $company)][contains(Language, $lgns)]/URL" />

    <!--<xsl:variable name="UI_textDATA" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))" />-->
    <xsl:variable name="UI_lgns" select="$UI_textDATA/root/listitem[language[.=$lgns]]" />
    
    <xsl:variable name="search-top" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'search-top.xml'))/root/*" />
    <xsl:variable name="search-footer" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'search-footer.xml'))/root/*" />
    
    <xsl:variable name="URLformsCompany" select="$root/root/URLform[starts-with(Project, $company)]" />
    <xsl:variable name="URLformsLang" select="$URLformsCompany[Language[.=$lgns]]" />
    <xsl:variable name="URLformsAnalCode" select="$URLformsLang/analCode" />
    
    <xsl:variable name="com">
        <xsl:choose>
            <xsl:when test="/topic[contains(@data-language, 'hyun')]">
                <xsl:value-of select="'M-hyundai_symbol.png'" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'M-kia_symbol.png'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/topic">
        <xsl:variable name="SearchHtml" select="concat('..', '/output/search/search.html')" />
        
        <xsl:result-document href="{$SearchHtml}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-key="search-page" data-language="{@data-language}">
                <xsl:attribute name="dir" select="if (matches($data-language, '(Ara|Far|Urdu)')) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="$langISO" />
                
                <head>
                    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                    <meta property="og:title" content="{$UI_lgns/html_title}"/>
                    <meta property="og:image" content="{concat('images/', $com)}"/>
                    <meta property="og:description" content="{$UI_lgns/title}"/>
                    <meta name="twitter:card" content="summary"/>
                    <meta name="twitter:title" content="{$UI_lgns/html_title}"/>
                    <meta name="twitter:image" content="{concat('images/', $com)}"/>
                    <meta name="twitter:description" content="{$UI_lgns/title}"/>
                    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=0" />
                    <title>﻿&#xFEFF;</title>
                    <!-- font import -->
                    <link rel="stylesheet" href="{if (starts-with(/topic/@data-language, 'hyun')) then 
                                                '../styles/fonts/hy/stylesheet.css' else 
                                                '../styles/fonts/cube_R/stylesheet.css'}" />
                    <link type="text/css" rel="stylesheet" href="contents/styles/contents_style.css"/>
                    <xsl:copy-of select="$searchHeadFile/root/div[matches(@type, $Sangyong)]/head/*" />
                    
                    <!-- Global site tag (gtag.js) - Google Analytics -->
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

                <body>
                    <xsl:copy-of select="$search-top" />
                    <xsl:copy-of select="$search-footer" />
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
    
</xsl:stylesheet>