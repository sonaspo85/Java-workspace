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
    
    <xsl:variable name="URLformsCompany" select="$root/root/URLform[starts-with(Project, $company)]" />
    <xsl:variable name="URLformsLang" select="$URLformsCompany[Language[.=$lgns]]" />
    <xsl:variable name="URLformsAnalCode" select="$URLformsLang/analCode" />

    <xsl:template match="/topic">
        <xsl:for-each select="topic[@idml][not(matches(@idml, 'Content'))][count(topic[1]/topic[@file]) &gt; 1][not(descendant::*[matches(@class, '\-sublink')])]">
            <xsl:variable name="prev-last-topic" select="preceding-sibling::topic[@idml][1]/topic[1]/topic[last()]" />

            <xsl:variable name="previdDelte">
                <xsl:variable name="fileLastID" select="tokenize(replace($prev-last-topic/@file, '.html', ''), '_')[last()]" />
                <xsl:variable name="preLastID" select="$prev-last-topic/descendant-or-self::*[matches(name(), 'h(1|2)')][last()]/@id" />
                
                <xsl:choose>
                    <xsl:when test="$fileLastID = $preLastID">
                        <xsl:value-of select="$prev-last-topic/@file"/>
                    </xsl:when>
                    
                    <xsl:when test="$prev-last-topic/descendant-or-self::*[matches(@class, '\-continue')][last()]">
                        <xsl:value-of select="$prev-last-topic/@file"/>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="concat($prev-last-topic/@file, '#', $prev-last-topic/descendant-or-self::*[matches(name(), 'h(1|2)')][last()]/@id)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="prev" select="if (not(preceding-sibling::topic[@idml][1])) 
                                              then '#' 
                                              else $previdDelte" />

            <xsl:variable name="NextidDelte">
                <xsl:variable name="fileLastID" select="tokenize(replace(topic[1]/topic[1]/@file, '.html', ''), '_')[last()]" />
                <xsl:variable name="nexLastID" select="topic[1]/topic[1]/h1/@id" />

                <xsl:value-of select="if ($fileLastID = $nexLastID) then topic[1]/topic[1]/@file 
                                      else concat(topic[1]/topic[1]/@file, '#', topic[1]/topic[1]/h1/@id)"/>
            </xsl:variable>
            
            <xsl:variable name="next" select="$NextidDelte" />
            <xsl:variable name="TOCfile" select="concat('../output/', @idml, '.html')" />
            
            <xsl:result-document href="{$TOCfile}">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
                <html data-language="{/topic/@data-language}">
                    <xsl:attribute name="dir" select="if (matches($data-language, '(Ara|Far|Urdu)')) then 'rtl' else 'ltr'" />
                    <xsl:attribute name="lang" select="$langISO" />
                    
                    <head>
                        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                        <meta property="og:title" content="{$UI_lgns/html_title}" />
                        <meta property="og:image" content="{concat('images/', $com)}" />
                        <meta property="og:description" content="{$UI_lgns/title}" />
                        <meta name="twitter:card" content="summary" />
                        <meta name="twitter:title" content="{$UI_lgns/html_title}" />
                        <meta name="twitter:image" content="{concat('images/', $com)}" />
                        <meta name="twitter:description" content="{$UI_lgns/title}" />
                        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                        <meta name="viewport"
                            content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                        <meta name="apple-mobile-web-app-capable" content="yes" />
                        
                        <link rel="stylesheet" href="{if (starts-with(/topic/@data-language, 'hyun')) then 
                                                      './styles/fonts/hy/stylesheet.css' else 
                                                      './styles/fonts/cube_R/stylesheet.css'}" />
                        
                        <link type="text/css" rel="stylesheet" href="contents/styles/contents_style.css"/>
                        <xsl:copy-of select="$contentHeadFile/root/div[matches(@type, $Sangyong)]/head/*" />
                        
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
                        <div id="top">
                            <div class="top_wrap">
                                <a class="logo" href="#">&#xFEFF;﻿</a>
                                <div class="head_tit">&#xFEFF;﻿</div>
                                <div id="toolbar">&#xFEFF;﻿</div>
                            </div>
                        </div>
                        <div class="chap">
                            <div id="scrollmask" class="chap_wrap">
                                <div id="home_area">
                                    <a class="home2" href="javascript:history.back(-1);">﻿&#xFEFF;﻿</a>
                                </div>
                                <h1 id="chapter">
                                    <xsl:value-of select="topic[1]/h0"/>
                                    <xsl:if test="topic[1]/h0/@caption">
                                        <span class="caption">
                                            <xsl:value-of select="topic[1]/h0/@caption"/>
                                        </span>
                                    </xsl:if>
                                </h1>
                            </div>
                        </div>
                        <div id="wrapper">
                            <xsl:if test="not(matches($prev, '^#$'))">
                                <xsl:attribute name="data-prev">
                                    <xsl:value-of select="$prev"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(matches($next, '^#$'))">
                                <xsl:attribute name="data-next">
                                    <xsl:value-of select="$next"/>
                                </xsl:attribute>
                            </xsl:if>

                            <div id="root" class="toc-bgcolor">
                                <div class="Heading2" id="room_no_h1_0">
                                    <div class="swipe_inner_wrap">
                                        <ul class="sect">
                                            <xsl:for-each select="topic[1]/topic[@file]">
                                                <xsl:variable name="current" select="." />
                                                <xsl:variable name="h1-idx" select="count($current/preceding::h1)" />
                                                
                                                <xsl:variable name="h1idDelte">
                                                    <xsl:variable name="fileLastID" select="tokenize(replace(@file, '.html', ''), '_')[last()]" />
                                                    <xsl:value-of select="if ($fileLastID = h1/@id) then @file else concat(@file, '#', h1/@id)"/>
                                                </xsl:variable>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="parent::topic/parent::topic[@idml][preceding-sibling::topic and following-sibling::topic] and 
                                                                    *[1][@class!='heading1-notoc']">
                                                        <li>
                                                            <a>
                                                                <xsl:attribute name="href" select="$h1idDelte" />
                                                                <xsl:attribute name="class" select="concat('h1_', $h1-idx)" />
                                                                <xsl:apply-templates select="*[1]" />
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                    
                                                    <xsl:when test="parent::topic/parent::topic[@idml][not(following-sibling::topic)]">
                                                        <li>
                                                            <a>
                                                                <xsl:attribute name="href" select="$h1idDelte" />
                                                                <xsl:attribute name="class" select="concat('h1_', $h1-idx)" />
                                                                <xsl:apply-templates select="*[1]" />
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                    
                                                    <xsl:when test="parent::topic/parent::topic[@idml][not(preceding-sibling::topic)]">
                                                        <li>
                                                            <a>
                                                                <xsl:attribute name="href" select="$h1idDelte" />
                                                                <xsl:attribute name="class" select="concat('h1_', $h1-idx)" />
                                                                <xsl:apply-templates select="*[1]" />
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </body>

                    <div id="nav">
                        <div class="btn_prev2"><img src="images/swipe_left.png" /></div>
                        <div class="btn_next2"><img src="images/swipe_right.png" /></div>
                    </div>
                    <div class="btn_area">
                        <div id="count">&#xFEFF;</div>
                    </div>
                    <div id="top_kind_toc">
                        <div class="toc_close">﻿&#xFEFF;</div>
                        <div class="toc_search">﻿&#xFEFF;</div>
                    </div>
                    <div id="view_toc">
                        <div id="view_container">﻿&#xFEFF;</div>
                    </div>
                    <div id="gototop">
                        <img src="images/go_to_top.png" />
                    </div>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="span">
        <xsl:copy>
            <xsl:attribute name="class" select="@class" />
            <xsl:attribute name="dir" select="@dir" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
    
</xsl:stylesheet>
