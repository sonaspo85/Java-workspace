<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <!--<xsl:import href="00-commonVar.xsl"/>-->
    <xsl:import href="branch/46-reference.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a"  />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:variable name="cur" select="." />
        
        <!--<xsl:for-each select="topic[@idml][not(matches(@idml, '(Video|Systemoverview)', 'i'))]
                              [count(topic[1]/topic[@file]) &gt; 1]
                              [not(descendant::*[matches(@class, '-sublink')])]">-->
        <xsl:for-each select="(topic[@idml][not(matches(@idml, '(Content|Video|Systemoverview|Appendix)', 'i'))]
                              [count(topic[1]/topic[@file]) &gt; 1]
                              [not(descendant::*[matches(@class, '-sublink')])], 
                              topic[matches(@idml, '(Systemoverview|Appendix)', 'i')])">
            <xsl:variable name="getPreFileVal">
                <xsl:call-template name="setPreFileVal">
                    <xsl:with-param name="cur" select="." />
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="getNextFileVal">
                <xsl:call-template name="setNextFileVal">
                    <xsl:with-param name="cur" select="." />
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="idml">
                <xsl:choose>
                    <xsl:when test="$commonRef/version/@value = '6th'">
                        <xsl:value-of select="replace(@idml, '(0\d+_)(.*)', '$2')" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="@idml" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="TOCFile" select="concat('../output/', $idml, '.html')" />
            <xsl:result-document href="{$TOCFile}">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
                <html data-language="{$cur/@data-language}">
                    <xsl:attribute name="dir" select="if ($RTLlgs) then 'rtl' else 'ltr'" />
                    <xsl:attribute name="lang" select="$cur/@lang" />
                    <xsl:attribute name="page-type" select="'h1_assemble'" />
                    
                    <xsl:call-template name="bodyHeader" />

                    <body>
                        <div class="headerWrap">
                            <div id="top">
                                <div class="top_wrap">
                                    <a class="logo" href="#">&#xFEFF;﻿</a>
                                    <div class="head_tit">&#xFEFF;﻿</div>
                                    
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
                            
                            <div class="scroll_nav">
                                <xsl:if test="$commonRef/version/@value = '6th'">
                                    <div class="sNav_div">&#xFEFF;</div>
                                </xsl:if>
                                
                                <div class="chap">
                                    <div id="scrollmask" class="chap_wrap">
                                        <div class="scrollmaskWrap">
                                            <div id="home_area">
                                                <a class="home2" href="javascript:history.back(-1);">﻿&#xFEFF;﻿</a>
                                            </div>
                                            <h1 id="chapter">
                                                <xsl:value-of select="topic[1]/h0"/>
                                                
                                                <xsl:if test="topic[1]/h0/@caption">
                                                    <span class="caption">
                                                        <xsl:value-of select="topic/h0/@caption"/>
                                                    </span>
                                                </xsl:if>
                                            </h1>
                                        </div>
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

                        <div id="wrapper">
                            <xsl:if test="not(matches($getPreFileVal, '^#$'))">
                                <xsl:attribute name="data-prev">
                                    <xsl:value-of select="$getPreFileVal"/>
                                </xsl:attribute>
                            </xsl:if>
                            
                            <xsl:if test="not(matches($getNextFileVal, '^#$'))">
                                <xsl:attribute name="data-next">
                                    <xsl:value-of select="$getNextFileVal"/>
                                </xsl:attribute>
                            </xsl:if>

                            <div id="root" class="toc-bgcolor">
                                <div class="Heading2" id="room_no_h1_0">
                                    <div class="swipe_inner_wrap">
                                        <ul class="sect">
                                            <xsl:for-each select="topic[1]/topic[@file]">
                                                <xsl:variable name="cur" select="." />
                                                <xsl:variable name="h1Pos" select="count($cur/preceding::h1)" />
                                                
                                                <xsl:variable name="finalFileVal">
                                                    <xsl:variable name="fileLastID" select="tokenize(replace(@file, '.html', ''), '_')[last()]" />
                                                    <xsl:value-of select="if ($fileLastID = h1/@id) then 
                                                                          @file else 
                                                                          concat(@file, '#', h1/@id)"/>
                                                </xsl:variable>
                                                
                                                <xsl:variable name="str0">
                                                    <xsl:apply-templates select="*[1]" mode="removeInline" />
                                                </xsl:variable>
                                                
                                                <li>
                                                    <a>
                                                        <xsl:attribute name="href" select="$finalFileVal" />
                                                        
                                                        <xsl:choose>
                                                            <xsl:when test="ancestor::topic[@idml][last()]/preceding-sibling::topic and 
                                                                            ancestor::topic[@idml][last()]/following-sibling::topic and 
                                                                            *[1][@class!='heading1-notoc']">
                                                                <xsl:value-of select="normalize-space($str0)"/>
                                                            </xsl:when>
                                                            
                                                            <xsl:when test="ancestor::topic[@idml][last()]
                                                                            /not(following-sibling::topic)">
                                                                <xsl:value-of select="normalize-space($str0)"/>
                                                            </xsl:when>
                                                            
                                                            <xsl:when test="ancestor::topic[@idml][last()]
                                                                            /not(preceding-sibling::topic)">
                                                                <xsl:value-of select="normalize-space($str0)"/>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    
                        <xsl:if test="$commonRef/version/@value = '6th'">
                            <xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
                        </xsl:if>
                    </body>

                    <div id="nav">
                        <div class="btn_prev2">
                            <img src="images/swipe_left.png" />
                        </div>
                        <div class="btn_next2">
                            <img src="images/swipe_right.png" />
                        </div>
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
                    
                    <xsl:if test="$commonRef/version/@value = '6th'">
                        <xsl:copy-of select="$allContents" />
                    </xsl:if>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="span" mode="removeInline">
        <xsl:choose>
            <xsl:when test="matches(@class, 'c_below_heading')" />
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="setNextFileVal">
        <xsl:param name="cur" />
        
        <xsl:variable name="finalNextVal">
            <xsl:variable name="fileLastID" select="tokenize(replace(topic[1]/topic[1]/@file, '.html', ''), '_')[last()]" />
            <xsl:variable name="nexLastID" select="topic[1]/topic[1]/h1/@id" />
            
            <xsl:value-of select="if ($fileLastID = $nexLastID) then 
                                  topic[1]/topic[1]/@file else 
                                  concat(topic[1]/topic[1]/@file, '#', topic[1]/topic[1]/h1/@id)"/>
        </xsl:variable>
        
        <xsl:variable name="next" select="$finalNextVal" />
        <xsl:value-of select="$next" />
    </xsl:template>
    
    <xsl:template name="setPreFileVal">
        <xsl:param name="cur" />
        
        <xsl:variable name="preLastTopic" select="preceding-sibling::topic[@idml][1]/topic[1]/topic[last()]" />
        
        <xsl:variable name="finalPreVal">
            <xsl:variable name="fileLastID" select="tokenize(replace($preLastTopic/@file, '.html', ''), '_')[last()]" />
            <xsl:variable name="preLastID" select="$preLastTopic/descendant-or-self::*[matches(name(), 'h(1|2)')][last()]/@id" />
            
            <xsl:choose>
                <xsl:when test="$fileLastID = $preLastID">
                    <xsl:value-of select="$preLastTopic/@file"/>
                </xsl:when>
                
                <xsl:when test="$preLastTopic/descendant-or-self::*[matches(@class, '-continue')][last()]">
                    <xsl:value-of select="$preLastTopic/@file"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="concat($preLastTopic/@file, '#', $preLastTopic/descendant-or-self::*[matches(name(), 'h(1|2)')][last()]/@id)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="prev" select="if (not(preceding-sibling::topic[@idml][1])) 
                                          then '#' 
                                          else $finalPreVal" />
        
        <xsl:value-of select="$prev" />
    </xsl:template>

    <xsl:template name="bodyHeader">
        <xsl:variable name="faviTitle">
            <xsl:call-template name="faviminiToc">
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
            
            <meta property="og:description" content="{$uiTxtLang/title}" />
            <meta name="twitter:card" content="summary" />
            <meta name="twitter:description" content="{$uiTxtLang/title}" />
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
            <meta name="apple-mobile-web-app-capable" content="yes" />
            
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
            
            <xsl:copy-of select="$body-header/self::div[matches(@class, 'minitoc')]/*" />

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
