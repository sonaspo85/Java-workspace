<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    exclude-result-prefixes="xs ast son"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="data-language" select="/topic/@data-language" />
    <xsl:variable name="company" select="substring-before(/topic/@data-language, '_')" />
    
    <xsl:variable name="lgns" select="substring-after(/topic/@data-language, '_')" />
    <xsl:variable name="langISO" select="/topic/@lang" />
    <xsl:variable name="region" select="concat('(', substring-after(/topic/@data-language, '('))" />
    <xsl:variable name="root" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'URL_form.xml'))" />
    <xsl:variable name="URLforms" select="$root/root/URLform[starts-with(Project, $company)][ends-with(Language, $region)]" />
    <xsl:variable name="company1" select="son:count($data-language, '_')" />
    <xsl:variable name="region1" select="$URLforms[contains(Language, $company1)]" />
    <xsl:variable name="ch-images" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ch-images.xml'))" />
    <xsl:variable name="URLforms1" select="$root/root/URLform[starts-with(Project, $company)][contains(Language, $lgns)]/URL" />
    <xsl:variable name="URLforms_error" select="$root/root/URLform[starts-with(Project, $company)][contains(Language, $lgns)]" />
    <!--<xsl:variable name="UI_textDATA" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))" />-->
    
    <xsl:variable name="UI_lgns" select="$UI_textDATA/root/listitem[language[.=$lgns]]" />
    <xsl:variable name="localizationFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'index_localization.xml'))/root" />
    
    <xsl:variable name="URLformsCompany" select="$root/root/URLform[starts-with(Project, $company)]" />
    <xsl:variable name="URLformsLang" select="$URLformsCompany[Language[.=$lgns]]" />
    <xsl:variable name="URLformsAnalCode" select="$URLformsLang/analCode" />
    
    <xsl:variable name="error_select">
        <xsl:value-of select="'error.html'" />
    </xsl:variable>

    <xsl:variable name="error" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', $error_select))" />
    
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
    
    <xsl:template match="a[@class='howto_btn']/@href" mode="abc">
        <xsl:attribute name="href">
            <xsl:choose>
                <xsl:when test="$URLforms and 
                    $URLforms_error">
                    <xsl:value-of select="$URLforms_error/Error_URL" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="'otherwise'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="/topic">
        <xsl:result-document href="{concat('../', 'output/', $error_select)}">
            <xsl:for-each select="$error/node()">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
                
                <xsl:for-each select="$error/node()">
                    <html data-language="{$data-language}">
                        <xsl:apply-templates select="@*, node()" mode="abc"/>
                    </html>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>

        <xsl:variable name="IndexFile" select="'../output/index.html'" />
        <xsl:result-document href="{$IndexFile}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{@data-language}">
                <xsl:attribute name="dir" select="if (matches($data-language, '(Ara|Far|Urdu)')) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="$langISO" />
                
                <head>
                    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                    <meta name="viewport"
                        content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                    <meta name="apple-mobile-web-app-capable" content="yes" />
                    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                    <meta property="og:title" content="{$UI_lgns/html_title}" />
                    <meta property="og:image" content="{concat('images/', $com)}" />
                    <meta property="og:description" content="{$UI_lgns/title}" />
                    <meta name="twitter:card" content="summary" />
                    <meta name="twitter:title" content="{$UI_lgns/html_title}" />
                    <meta name="twitter:image" content="{concat('images/', $com)}" />
                    <meta name="twitter:description" content="{$UI_lgns/title}" />

                    <link rel="stylesheet" href="{if (starts-with(/topic/@data-language, 'hyun')) then 
                                                  './styles/fonts/hy/stylesheet.css' else 
                                                  './styles/fonts/cube_R/stylesheet.css'}" />

                    <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700" rel="stylesheet" />
                    <link rel="stylesheet" href="./styles/fonts/HyundaiSansTextKRRegular/stylesheet.css" />
                    
                    <xsl:copy-of select="$contentHeadFile/root/div[matches(@type, $Sangyong)]/head/*" />
                    <link type="text/css" rel="stylesheet" href="styles/index_style.css" />
                    
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

                <body id="main">
                    <div id="value" style="display:none">0</div>
                    <div id="value2" style="display:none">0</div>
                    <div id="value_c" style="display:none">0</div>
                    <div id="value_drag_position" style="display:none">0</div>
                    <header>
                        <div class="header_wrap">
                            <a class="logo" href="#">﻿&#xFEFF;</a>
                            <div class="language_area">
                                <div class="language_btn">
                                    <button type="button">&#xFEFF;</button>
                                    <div class="language_list">
                                        <ul>
                                            <xsl:variable name="langExport">
                                                <xsl:for-each select="$region1">
                                                    <li onclick="{concat('location.href=', '''', URL/text(), ''';')}">
                                                        <xsl:value-of select="if (count(tokenize(Language, '_')) = 2) 
                                                                              then substring-before(tokenize(Language, '_')[2], '(') 
                                                                              else substring-before(Language, '(')" />
                                                    </li>
                                                </xsl:for-each>
                                            </xsl:variable>
                                            
                                            <xsl:for-each select="$langExport/*">
                                                <xsl:variable name="cur" select="." />
                                                
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*" />
                                                    <xsl:choose>
                                                        <xsl:when test="self::*[.= $localizationFile/language/@lang]">
                                                            <xsl:value-of select="$localizationFile/language[@lang=$cur]/@localization" />
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:apply-templates select="node()" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:copy>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </div>
                                <a class="btn_nav" href="#">﻿&#xFEFF;</a>
                            </div>
                        </div>
                    </header>

                    <div class="wrap">
                        <section>
                            <div class="con_wrap">
                                <div class="cover">
                                    <div class="cover_img">
                                        <img class="main_img" src="images/highlights-pc.png" alt="" />
                                        <xsl:element name="div">
                                            <xsl:attribute name="class" select="'model'" />
                                            <xsl:if test="$region = '(IND)'">
                                                <xsl:variable name="Apos">
                                                    <xsl:text disable-output-escaping="no">'</xsl:text>
                                                </xsl:variable>
                                                <xsl:attribute name="style" select="concat('font-family: ', $Apos, 'HyundaiSans Text KR', $Apos, ';')" />
                                            </xsl:if>﻿&#xFEFF;</xsl:element>
                                    </div>
                                    <div class="cover_list_wrap">
                                        <ul class="cover_list">
                                            <!-- 10인치 내수 국문일 경우에만 -->
                                            <xsl:if test="matches($region, '\(internal') and
                                                          matches($lgns, 'Korean') and 
                                                          not(matches($UI_textDATA/root/@fileName, '8in')) and 
                                                          not(matches($UI_textDATA/root/@fileName, 'CV'))">
                                                <li>
                                                    <xsl:attribute name="id" select="replace('quickguide', '.html', '')" />
                                                    <a href="#" onclick="{concat('mainHover', '(', '''', 'quickguide001.html', '''', ')')}">
                                                        <img src="images/E-chcover_quickguide.png" class="cover_list_img" />
                                                        
                                                        <span class="chapter_text2">
                                                            <xsl:value-of select="'퀵 가이드'"/>
                                                        </span>
                                                    </a>
                                                </li>
                                            </xsl:if>
                                            
                                            <xsl:for-each select="topic[@idml]">
                                                <xsl:variable name="idx" select="tokenize(@idml, '_')[1]" />
                                                <xsl:variable name="s-flag" select="tokenize(lower-case(@idml), '_')[last()]" />
                                                <xsl:variable name="src">
                                                    <xsl:choose>
                                                        <xsl:when test="count($ch-images/images/image[@idx=$idx]) &gt; 1">
                                                            <xsl:for-each select="$ch-images/images/image[@idx=$idx]">
                                                                <xsl:variable name="t-flag" select="tokenize(replace(lower-case(@src), '.png', ''), '_')[last()]"/>
                                                                <xsl:choose>
                                                                    <xsl:when test="$s-flag = $t-flag">
                                                                        <xsl:value-of select="@src"/>
                                                                    </xsl:when>
                                                                </xsl:choose>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$ch-images/images/image[@idx=$idx]/@src"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                

                                                <xsl:variable name="chap-start-html">
                                                    <xsl:choose>
                                                        <xsl:when test="descendant::*[matches(@class, '\-sublink')]">
                                                            <xsl:choose>
                                                                <xsl:when test="matches(@idml, '_Features_')">
                                                                    <xsl:value-of select="topic[1]/topic[1]/@file" />
                                                                </xsl:when>
                                                                
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="concat(@idml, '.html')" />
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:when>

                                                        <xsl:when test="matches(@idml, 'Content')">
                                                            <xsl:value-of select="topic[1]/topic[1]/@file" />
                                                        </xsl:when>
                                                        
                                                        <xsl:when test="count(topic[1]/topic) &gt; 1">
                                                            <xsl:value-of select="concat(@idml, '.html')" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="topic[1]/topic[1]/@file" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                
                                                <li>
                                                    <xsl:attribute name="id" select="replace($chap-start-html, '.html', '')" />
                                                    <a href="#" onclick="{concat('mainHover', '(', '''',$chap-start-html, '''', ')')}">
                                                        <img src="{$src}" class="cover_list_img" />
                                                        
                                                        <span class="chapter_text2">
                                                            <xsl:value-of select="topic[1]/h0"/>
                                                        </span>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                    <div class="cover_list_wrap caution_txt">&#xFEFF;</div>
                                </div>
                            </div>
                        </section>
                    </div>

                    <footer>
                        <div class="footer_wrap">
                            <div class="footer_img">&#xFEFF;</div>
                            <p><span class="line1">&#xFEFF;</span>
                               <xsl:text>&#x20;</xsl:text>
                               <span class="line2">&#xFEFF;</span>
                            </p>
                        </div>
                    </footer>
                    <div id="top_kind_toc">
                        <div class="toc_close">&#xFEFF;</div>
                        <div class="toc_search">&#xFEFF;</div>
                    </div>
                    <div id="view_toc">
                        <div id="view_container">&#xFEFF;</div>
                    </div>
                    <div id="gototop">
                        <img src="images/go_to_top.png" />
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="son:count">
        <xsl:param name="str"/>
        <xsl:param name="char"/>

        <xsl:variable name="to" select="tokenize($str, $char)" />
        <xsl:choose>
            <xsl:when test="count($to) = 3">
                <xsl:value-of select="$to[2]" />
            </xsl:when>
            <xsl:when test="count($to) = 2">
                <xsl:value-of select="substring-after($to[2], '(')" />
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>