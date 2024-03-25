<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY trade "™">]>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast saxon"
    version="2.0">

    <xsl:character-map name="a">
        <xsl:output-character character='"' string="&amp;quot;"/>
        <xsl:output-character character="'" string="&amp;apos;"/>
        <xsl:output-character character="™" string="&amp;trade;"/>
    </xsl:character-map>

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p td" />
    
    <xsl:variable name="sourcePath" select="body/@sourcePath" />
    <xsl:key name="htmls" match="topic[@filename]" use="@id" />

    <xsl:variable name="ids" as="xs:string*">
        <xsl:for-each select="/body//topic[@filename]/@id">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="model-name" select="/body/@model-name" />

    <xsl:key name="xrefs" match="h1 | h2 | h3 | h4 | h5 | h6 | p[matches(@class, 'heading3')]" use="@id" />

    
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="topic">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="file" select="concat($sourcePath, '/output/', 'header.html')" />
        <xsl:result-document method="xml" href="{$file}">
            <a href="start_here.html">
                <span>home</span>
            </a>
            <span class="side-open">﻿﻿&#xFEFF;</span>
            <span class="title" onclick="location.href='start_here.html'">
                <xsl:value-of select="$model-name" />
            </span>
            <a href="#" onclick="location.href='search/search.html'">
                <img src="./common/images/search-icon.png" alt="search"/>
            </a>
        </xsl:result-document>

        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="topic[@filename]">
        <xsl:if test="*[1][name()='h1']/following-sibling::*[1][contains(@class, 'minitoc')]">
            <xsl:variable name="file" select="concat($sourcePath, '/output/', @filename, '_', *[1]/@id, '.html')" />
            <xsl:variable name="title" select="concat(*[1], ' - ', $model-name)" />

            <xsl:result-document href="{$file}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
                <html data-language="{$data-language}">
                    <xsl:call-template name="pre_head">
                        <xsl:with-param name="cur" select="." />
                    </xsl:call-template>
                    
                    <body>
                        <header>
                            <div w3-include-html="header.html">&#xFEFF;</div>
                        </header>
                        <section>
                            <div w3-include-html="toc.html" class="nav-wrap">&#xFEFF;</div>
                            <div id="content" data-title="{*[1]/@id}">
                                <div id="guide_contents">
                                    <div class="breadcrumb">
                                        <xsl:value-of select="ancestor::chapter/topic/*[1][starts-with(name(), 'h')]" />
                                        <div id="share_area_sub">
                                            <div class="addthis_inline_share_toolbox toolbox_toggle">&#xFEFF;</div>
                                            <div class="img_share"><img src="common/images/btn_share.svg"/>&#xFEFF;
                                            </div>
                                        </div>
                                    </div>
                                    <xsl:apply-templates />
                                </div>
                            </div>
                        </section>
                        <xsl:variable name="id" select="@id" />
                        <xsl:variable name="prev" select="key('htmls', $ids[index-of($ids, $id) - 1])" />
                        <xsl:variable name="prev-filename" select="$prev/@filename"/>
                        <xsl:variable name="prev-fid" select="$prev/*[1]/@id" />
                        <xsl:variable name="data-prev" select="if ( $prev-filename ) 
                                                                then concat($prev-filename, '_', $prev-fid)
                                                                else 'start_here'" />
                        <xsl:variable name="next" select="key('htmls', $ids[index-of($ids, $id) + 1])" />
                        <xsl:variable name="next-filename" select="$next/@filename" />
                        <xsl:variable name="next-fid" select="$next/*[1]/@id" />
                        <xsl:variable name="data-next" select="if ( $next-filename ) 
                                                                then concat($next-filename, '_', $next-fid)
                                                                else '#'" />

                        <xsl:call-template name="back_script">
                            <xsl:with-param name="cur" select="." />
                            <xsl:with-param name="data-next" select="$data-next" />
                            <xsl:with-param name="data-prev" select="$data-prev" />
                        </xsl:call-template>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>

    <xsl:template match="chapter[1]">
        <xsl:variable name="filename" select="toc_link[1]/h1" />
        
            <xsl:result-document href="{concat($sourcePath, '/output/', lower-case($filename), '_', $filename/@id, '.html')}" method="xml">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
                <html data-language="{$data-language}">
                    <xsl:call-template name="pre_head">
                        <xsl:with-param name="cur" select="." />
                    </xsl:call-template>
                    
                    <body>
                        <header>
                            <div w3-include-html="header.html">&#xFEFF;</div>
                        </header>
                        <section>
                            <div w3-include-html="toc.html" class="nav-wrap">&#xFEFF;</div>
                            <div id="content" data-title="{$filename/@id}">
                                <div id="guide_contents">
                                    <div class="breadcrumb">
                                        <xsl:value-of select="$filename" />
                                        <div id="share_area_sub">
                                            <div class="addthis_inline_share_toolbox toolbox_toggle">&#xFEFF;</div>
                                            <div class="img_share"><img src="common/images/btn_share.svg"/>&#xFEFF;
                                            </div>
                                        </div>
                                    </div>
                                    <h1>
                                        <xsl:apply-templates select="$filename/@id" />
                                        <xsl:attribute name="class" select="'chapterTitle'" />
                                        <xsl:value-of select="$filename" />
                                    </h1>
                                    <xsl:for-each select="toc_link">
                                        <xsl:apply-templates />
                                    </xsl:for-each>
                                </div>
                            </div>
                        </section>
                        
                        <xsl:variable name="data-next" select="concat(following-sibling::chapter[1]/topic[1]/@filename, '_', following-sibling::chapter[1]/topic[1]/*[starts-with(name(), 'h')]/@id)" />
                        <xsl:variable name="data-prev" select="'start_here'" />
                        
                        <xsl:call-template name="back_script">
                            <xsl:with-param name="cur" select="." />
                            <xsl:with-param name="data-next" select="$data-next" />
                            <xsl:with-param name="data-prev" select="$data-prev" />
                        </xsl:call-template>
                    </body>
                </html>
            </xsl:result-document>
    </xsl:template>

    <xsl:template match="h1[ancestor::*[matches(@TOC_chapter, 'TOC_chapter')]]">
    </xsl:template>

    <xsl:template match="img">
        <xsl:copy>
            <xsl:attribute name="src">
                <xsl:value-of select="replace(@src, 'output/', '')" />
            </xsl:attribute>
        </xsl:copy>
        <xsl:if test="following-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template name="recall">
        <xsl:param name="cur" />

        <xsl:choose>
            <xsl:when test="$cur[1][not(matches(name(), 'h'))]">
                <xsl:copy-of select="$cur[1]" />

                <xsl:call-template name="recall">
                    <xsl:with-param name="cur" select="$cur[position() &gt; 1]" />
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="pre_head">
        <xsl:param name="cur" />

        <xsl:variable name="file" select="concat('output/', @filename, '_', *[1]/@id, '.html')" />
        <xsl:variable name="title" select="concat(*[1], ' - ', $model-name)" />
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
            <title>
                <xsl:value-of select="$title" />
            </title>
            <xsl:comment> S : Facebook Open Graph Meta Tag </xsl:comment>
            <meta property="og:url" content="" />
            <meta property="og:title" content="{$title}" />
            <meta property="og:description" content="{$title}" />
            <meta property="og:type" content="website" />
            <meta property="og:image" content="" />
            <meta property="og:site_name" content="{concat($model-name, ' User Manual')}" />

            <meta property="og:locale" content="{if ($data-language='English') then 'en_US' else 'es_MX'}" />
            <meta property="twitter:card" content="summary" />
            <link rel="apple-touch-icon" href="common/images/favicon.png"/>
            <link rel="apple-touch-icon-precomposed" href="common/images/favicon.png"/>
            <link rel="icon" href="common/images/favicon.ico"/>
            <link rel="shortcut icon" href="common/images/favicon.png"/>
            <link rel="stylesheet" type="text/css" href="common/css/working.css"/>
            <link rel="stylesheet" type="text/css" href="common/css/jquery.mobile-1.4.5.min.css"/>
            <script type="text/javascript" src="common/js/jquery.js">&#xFEFF;</script>
            <script type="text/javascript" src="common/js/message.js">&#xFEFF;</script>
            <script type="text/javascript" src="common/js/image.js">&#xFEFF;</script>
            <script type="text/javascript" src="common/js/common.js">&#xFEFF;</script>
            <script type="text/javascript" src="common/js/init.js">&#xFEFF;</script>
            <script type="text/javascript" src="common/js/hammer.js">&#xFEFF;</script>
            <xsl:text disable-output-escaping='yes'>&lt;script&gt;(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create','UA-50979023-4','auto');ga('send','pageview');&lt;/script&gt;</xsl:text>
        </head>
    </xsl:template>

    <xsl:template name="back_script">
        <xsl:param name="cur" />
        <xsl:param name="data-prev" />
        <xsl:param name="data-next" />
        
        <div w3-include-html="share.html">&#xFEFF;</div>
        <xsl:comment> toc include </xsl:comment>
        <script type="text/javascript">includeHTML();</script>
        <script type="text/javascript">
            <xsl:text disable-output-escaping="yes">$(document).ready(function() {var isMobile = window.matchMedia("only screen and (max-width: 760px)");if (isMobile.matches) {</xsl:text>
            <xsl:text disable-output-escaping="yes">var element = $('#content');</xsl:text>
            <xsl:text disable-output-escaping="yes">var mc = new Hammer(element[0]);</xsl:text>
            <xsl:text disable-output-escaping="yes">var swipe = new Hammer.Swipe();</xsl:text>
            <xsl:text disable-output-escaping="yes">mc.on('swipeleft', function() {$(location).attr('href','</xsl:text>
            <xsl:value-of select='$data-next' />
            <xsl:text disable-output-escaping="yes">.html');});</xsl:text>
            <xsl:text disable-output-escaping="yes">mc.on('swiperight', function() {$(location).attr('href','</xsl:text>
            <xsl:value-of select='$data-prev' />
            <xsl:text disable-output-escaping="yes">.html');});</xsl:text>
            <xsl:text disable-output-escaping="yes">}});</xsl:text>
        </script>
    </xsl:template>
    
</xsl:stylesheet>
