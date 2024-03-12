<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    exclude-result-prefixes="xs ast son"
    version="2.0">
    
    <!--<xsl:import href="00-commonVar.xsl"/>-->
    <xsl:import href="branch/46-reference.xsl"/>
    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a"  />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />


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
                <xsl:when test="$URLformsLang and 
                                $URLformsLang/Error_URL">
                    <xsl:value-of select="$URLformsLang/Error_URL" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="'otherwise'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="/topic">
        <xsl:variable name="errorFile" select="concat('../', 'output/', 'error.html')" />
        <xsl:variable name="IndexFile" select="'../output/index.html'" />
        
        <xsl:result-document href="{$errorFile}">
            <xsl:for-each select="$errorHTML/node()">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
                
                <html data-language="{$data-language}">
                    <xsl:apply-templates select="@*, node()" mode="abc"/>
                </html>
            </xsl:for-each>
        </xsl:result-document>

        <xsl:result-document href="{$IndexFile}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{@data-language}">
                <xsl:attribute name="dir" select="if ($RTLlgs) then 'rtl' else 'ltr'" />
                <xsl:attribute name="lang" select="@lang" />
                
                <xsl:call-template name="bodyHeader" />
                
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
                                    <xsl:call-template name="languageList" />
                                </div>
                                <a class="btn_nav" href="#">﻿&#xFEFF;</a>
                            </div>
                            
                            <xsl:if test="$commonRef/version/@value = '6th'">
                                <xsl:copy-of select="$allContents" />
                            </xsl:if>
                        </div>
                    </header>

                    <div class="wrap">
                        <section>
                            <div class="con_wrap">
                                <div class="cover">
                                    <div class="cover_img">
                                        <xsl:if test="$commonRef/version/@value != '6th' and 
                                                      not($RTLlgs)">
                                            <img class="main_img" src="images/highlights-pc.png" alt="" />
                                        </xsl:if>
                                        
                                        <div class="coverWrap">
                                            <xsl:if test="$commonRef/version/@value = '6th'">
                                                <img src="images/main_web_icon.png" class="title_img" />
                                            </xsl:if>
                                            <xsl:element name="div">
                                                <xsl:attribute name="class" select="'model'" />
                                                <xsl:if test="$commonRef/region/@value = '(IND)'">
                                                    <xsl:variable name="Apos">
                                                        <xsl:text disable-output-escaping="no">'</xsl:text>
                                                    </xsl:variable>
                                                    
                                                    <xsl:attribute name="style" select="concat('font-family: ', $Apos, 'HyundaiSans Text KR', $Apos, ';')" />
                                                </xsl:if>
                                                <xsl:text>﻿&#xFEFF;</xsl:text>
                                            </xsl:element>
                                        </div>
                                        
                                        <xsl:if test="$commonRef/version/@value != '6th' and 
                                                      $RTLlgs">
                                            <img class="main_img" src="images/highlights-pc.png" alt="" />
                                        </xsl:if>
                                    </div>
                                    
                                    <xsl:if test="$commonRef/version/@value = '6th'">
                                        <xsl:copy-of select="$searchBox" />
                                    </xsl:if>
                                    
                                    <div class="cover_list_wrap">
                                        <ul class="cover_list">
                                            <!-- 10인치 내수 국문일 경우에만 -->
                                            <xsl:if test="matches($commonRef/region/@value, '^internal') and
                                                          matches($commonRef/language/@value, 'Korean') and 
                                                          not(matches($commonRef/uiTxtFileName/@value, '8in')) and 
                                                          matches($commonRef/company/@value, '(hyun|kia)') and 
                                                          not(matches($commonRef/carName/@value, '^(GZ|EU)$')) and 
                                                          not(matches($commonRef/ccncVer/@value, 'ccncLite'))">
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
                                            
                                            <xsl:call-template name="bodyArea">
                                                <xsl:with-param name="cur" select="topic[@idml]" />
                                            </xsl:call-template>
                                        </ul>
                                    </div>
                                    <div class="cover_list_wrap caution_txt">&#xFEFF;</div>
                                </div>
                            </div>
                        </section>
                    </div>
                    
                    <xsl:call-template name="footer" />
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="bodyHeader">
        <head>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
            <meta name="apple-mobile-web-app-capable" content="yes" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta property="og:title" content="{$uiTxtLang/html_title}" />
            <meta property="og:image" content="images/M-hyundai_symbol.png"/>
            <meta property="og:description" content="{$uiTxtLang/title}" />
            <meta name="twitter:card" content="summary" />
            <meta name="twitter:title" content="{$uiTxtLang/html_title}" />
            <meta name="twitter:description" content="{$uiTxtLang/title}" />
            
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
    
    <xsl:template name="bodyArea">
        <xsl:param name="cur" />
        
        <xsl:for-each select="$cur">
            <!--<xsl:variable name="idx" select="tokenize(@idx, '_')[1]" />-->
            <xsl:variable name="idx">
                <xsl:choose>
                    <xsl:when test="matches(@idx, '(\d+\.\d)')">
                        <xsl:value-of select="replace(@idx, '(\d+)(\.)(\d)', '$1-$3')" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="@idx" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="cur2" select="." />
            
            <xsl:variable name="srcChapterName">
                <xsl:choose>
                    <xsl:when test="$commonRef/version/@value = '6th'">
                        <xsl:value-of select="tokenize(@idml, '_')[last()]" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="lower-case(tokenize(@idml, '_')[last()])" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="src">
                <xsl:choose>
                    <xsl:when test="count($ch-images/images/image[@idx=$idx]) &gt; 1">
                        <xsl:for-each select="$ch-images/images/image[@idx=$idx]">
                            <xsl:variable name="tarChapterName" select="tokenize(replace(lower-case(@src), '.png', ''), '_')[last()]"/>
                            
                            <xsl:if test="$srcChapterName = $tarChapterName">
                                <xsl:value-of select="@src"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="$ch-images/images/image[@idx=$idx]/@src"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="chap-start-html">
                <xsl:choose>
                    <xsl:when test="descendant::*[matches(@class, '-sublink')]">
                        <xsl:choose>
                            <xsl:when test="matches(@idml, '_features_', 'i')">
                                <xsl:value-of select="topic[1]/topic[1]/@file" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$commonRef/version/@value = '6th'">
                                        <xsl:value-of select="concat($srcChapterName, '.html')" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($cur2/@idml, '.html')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:when test="matches(@idml, '(Content|Video|Systemoverview)', 'i')">
                        <xsl:value-of select="topic[1]/topic[1]/@file" />
                    </xsl:when>
                    
                    <xsl:when test="count(topic[1]/topic) &gt; 1">
                        <xsl:choose>
                            <xsl:when test="$commonRef/version/@value = '6th'">
                                <xsl:value-of select="concat($srcChapterName, '.html')" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="concat($cur2/@idml, '.html')" />
                            </xsl:otherwise>
                        </xsl:choose>
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
                        <!-- <xsl:value-of select="topic[1]/h0/text()"/> -->
                        <xsl:for-each select="topic[1]/h0">
                            <xsl:choose>
                                <xsl:when test="self::*">
                                    <xsl:choose>
                                        <xsl:when test="self::br">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@* | node()"/>
                                            </xsl:copy>
                                        </xsl:when>
                                    
                                        <xsl:otherwise>
                                            <xsl:apply-templates />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:value-of select="." />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </span>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="footer">
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
        <div>
            <xsl:attribute name="id" select="if ($commonRef/version/@value = '6th') then 'gototop' else 'gototop'" />
            <img src="images/go_to_top.png" />
        </div>
    </xsl:template>
    
    <xsl:template name="languageList">
        <div class="language_list">
            <ul>
                <xsl:variable name="langExport">
                    <xsl:for-each select="$sameRegionURL">
                        <li onclick="{concat('location.href=', '''', URL/text(), ''';')}">
                            <xsl:value-of select="substring-before(Language, '(')" />
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
    </xsl:template>

</xsl:stylesheet>