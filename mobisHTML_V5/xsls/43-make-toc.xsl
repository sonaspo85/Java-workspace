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
        <xsl:variable name="TocFile" select="'../output/toc1.html'" />
        <xsl:result-document href="{$TocFile}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{/topic/@data-language}">
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
                    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                    <meta name="apple-mobile-web-app-capable" content="yes" />
                    <!-- font import -->
                    <link rel="stylesheet" href="{if (starts-with(/topic/@data-language, 'hyun')) then 
                                                  './styles/fonts/hy/stylesheet.css' else 
                                                  './styles/fonts/cube_R/stylesheet.css'}" />
                    <link type="text/css" rel="stylesheet" href="./styles/index_style.css" />
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
                        <div id="header">
                            <a href="javascript:history.back(-1);"><img src="images/home_icon2.png" alt="" class="home" /></a>
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
                                                <xsl:value-of select="topic[1]/h0"/>
                                                <xsl:if test="topic[1]/h0/@caption">
                                                    <span class="caption">
                                                        <xsl:value-of select="topic[1]/h0/@caption"/>
                                                    </span>
                                                </xsl:if>
                                            </span>
                                        </a>
                                    </h1>
                                    
                                    <ul class="toc-sect">
                                        <xsl:for-each select="topic[1]/topic[@file]">
                                            <xsl:variable name="h1id" select="h1[1]/@id" />
                                            <xsl:variable name="current" select="." />
                                            <xsl:variable name="h1-idx" select="count($current/preceding::h1)" />

                                            <xsl:variable name="tocidDelte">
                                                <xsl:variable name="fileLastID" select="tokenize(replace(@file, '.html', ''), '_')[last()]" />
                                                <xsl:variable name="LastID" select="$h1id" />

                                                <xsl:value-of select="if ($fileLastID = $LastID) then @file 
                                                                      else concat(@file, '#', $h1id)"/>
                                            </xsl:variable>
                                            
                                            <li>
                                                <a>
                                                    <xsl:attribute name="href" select="if (not(preceding-sibling::topic) and ancestor::topic[@idml]/descendant::*[matches(@class, 'sublink')]) 
                                                                                       then @file 
                                                                                       else $tocidDelte" />
                                                    <xsl:attribute name="class" select="concat('h1_', $h1-idx)" />
                                                    <xsl:apply-templates select="*[1]" mode="normalize"/>
                                                </a>
                                                <xsl:if test="current()//h2">
                                                    <ul class="toc-sect">
                                                        <xsl:for-each select="current()//h2">
                                                            <li>
                                                                <a>
                                                                    <xsl:attribute name="href" select="concat(ancestor::topic[@file]/@file, '#', position() - 1)" />
                                                                    <xsl:value-of select="." />
                                                                </a>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </xsl:if>
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

                <xsl:when test="self::br"></xsl:when>
                
                <xsl:when test="self::*[not(matches(@class, 'c_below_heading'))]">
                    <xsl:copy>
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="span">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
    
</xsl:stylesheet>
