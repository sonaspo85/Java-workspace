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

    <xsl:key name="htmls" match="topic[@filename]" use="@id" />

    <xsl:variable name="ids" as="xs:string*">
        <xsl:for-each select="/body//topic[@filename]/@id">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="model-name" select="/body/@model-name" />
    <xsl:variable name="sourcePath" select="body/@sourcePath" />

    <xsl:key name="xrefs" match="h1 | h2 | h3 | h4 | h5 | h6 | p[matches(@class, 'heading3')]" use="@id" />

    <xsl:template match="/">
        <!-- <xsl:variable name="file" select="concat('../output/', 'header.html')" /> -->
        <xsl:variable name="file" select="concat($sourcePath, '/output/', 'header.html')" />
        <xsl:result-document method="xml" href="{$file}">
            <a href="start_here.html"><span>home</span></a>
            <xsl:text>&#xA;</xsl:text>
            <span class="side-open">﻿﻿&#xFEFF;</span>
            <xsl:text>&#xA;</xsl:text>
            <span class="title" onclick="location.href='start_here.html'">
                <xsl:value-of select="$model-name" />
            </span>
            <xsl:text>&#xA;</xsl:text>
            <a href="#" onclick="location.href='search/search.html'"><img src="./common/images/search-icon.png" alt="search"/></a>
        </xsl:result-document>
        <xsl:apply-templates />
    </xsl:template>

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

    <xsl:template match="li/text()[not(preceding-sibling::node())][matches(., '^\s+$')]">
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '[&#x9;&#xA;]', ''), '[&#x20;]+', '&#x20;')" />
    </xsl:template>

    <xsl:template match="img">
        <xsl:copy>
            <xsl:apply-templates select="@* except @src" />
            <xsl:attribute name="src">
                <xsl:value-of select="replace(@src, 'output/', '')" />
            </xsl:attribute>
        </xsl:copy>
        <xsl:if test="following-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="a">
        <xsl:if test="preceding-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
        <xsl:copy>
        <xsl:choose>
            <xsl:when test="matches(@href, '^#')">
                <xsl:variable name="target" select="key('xrefs', substring-after(@href, '#'))[1]" />
                <xsl:variable name="filename" select="$target/ancestor::topic[@filename][1]/@filename" />
                <xsl:variable name="fid" select="$target/ancestor::topic[@filename][1]/*[1]/@id" />
                <xsl:variable name="html" select="concat($filename, '_', $fid, '.html')" />
                
                <xsl:attribute name="href">
                    <xsl:value-of select="concat($html, @href)" />
                </xsl:attribute>
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="@* | node()" />
            </xsl:otherwise>
        </xsl:choose>
        </xsl:copy>
        <xsl:if test="following-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[starts-with(name(), 'h')][@id]">
        <xsl:choose>
            <xsl:when test="name()='h1'">
            </xsl:when>
            <xsl:when test="name()='h2'">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::*) and parent::topic/parent::chapter and 
                                      not(string(replace(replace(following-sibling::*[1], '^\s+$', ''), '&#xA0;', '')))">
                        <h1>
                            <xsl:apply-templates select="@* | node()" />
                        </h1>
                    </xsl:when>
                    <xsl:otherwise>
                        <h2>
                            <xsl:apply-templates select="@* | node()" />
                        </h2>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::topic/*[1][name()='h3']">
                <xsl:choose>
                    <xsl:when test="name()='h3'">
                        <h2>
                            <xsl:apply-templates select="@* | node()" />
                        </h2>
                    </xsl:when>
                    <xsl:when test="name()='h4'">
                        <h3>
                            <xsl:apply-templates select="@* | node()" />
                        </h3>
                    </xsl:when>
                    <xsl:when test="name()='h5'">
                        <h4>
                            <xsl:apply-templates select="@* | node()" />
                        </h4>
                    </xsl:when>
                    <xsl:when test="name()='h6'">
                        <h5>
                            <xsl:apply-templates select="@* | node()" />
                        </h5>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="matches(@class, 'heading3')">
                <h3>
                    <xsl:apply-templates select="@* | node()" />
                </h3>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="topic">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="topic[@filename]">
        <!-- <xsl:variable name="file" select="concat('../output/', @filename, '_', *[1]/@id, '.html')" /> -->
        <xsl:variable name="file" select="concat($sourcePath, '/output/', @filename, '_', *[1]/@id, '.html')" />
        <xsl:variable name="title" select="concat(*[1], ' - ', $model-name)" />

        <xsl:result-document href="{$file}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <html data-language="{$data-language}">
                <xsl:text>&#xA;&#x9;</xsl:text>
                <head>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta charset="UTF-8" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <title>
                        <xsl:value-of select="$title" />
                    </title>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:comment> S : Facebook Open Graph Meta Tag </xsl:comment>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:url" content="" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:title" content="{$title}" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:description" content="{$title}" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:type" content="website" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:image" content="" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:site_name" content="{concat($model-name, ' User Manual')}" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="og:locale" content="{if ($data-language='English') then 'en_US' else 'es_MX'}" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta property="twitter:card" content="summary" />
                    <xsl:text>&#xA;</xsl:text>

                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon" href="common/images/favicon.png"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon-precomposed" href="common/images/favicon.png"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="icon" href="common/images/favicon.ico"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="shortcut icon" href="common/images/favicon.png"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="stylesheet" type="text/css" href="common/css/working.css"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="stylesheet" type="text/css" href="common/css/jquery.mobile-1.4.5.min.css"/>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/jquery.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/message.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/image.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/common.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/init.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text><script type="text/javascript" src="common/js/hammer.js">&#xFEFF;</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping='yes'>&lt;script&gt;(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create','UA-50979023-4','auto');ga('send','pageview');&lt;/script&gt;</xsl:text>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                </head>
                <xsl:text>&#xA;&#x9;</xsl:text>
                <body>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <header>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div w3-include-html="header.html">&#xFEFF;</div>
                        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </header>

                    <!-- calculate prev -->
                    <xsl:variable name="id" select="@id" />
                    <xsl:variable name="prev" select="key('htmls', $ids[index-of($ids, $id) - 1])" />
                    <xsl:variable name="prev-filename" select="$prev/@filename"/>
                    <xsl:variable name="prev-fid" select="$prev/*[1]/@id" />
                    <xsl:variable name="data-prev" select="if ( $prev-filename )
                                                           then concat($prev-filename, '_', $prev-fid)
                                                           else 'start_here'" />

                    <!-- calculate next -->
                    <xsl:variable name="next" select="key('htmls', $ids[index-of($ids, $id) + 1])" />
                    <xsl:variable name="next-filename" select="$next/@filename" />
                    <xsl:variable name="next-fid" select="$next/*[1]/@id" />
                    <xsl:variable name="data-next" select="if ( $next-filename )
                                                           then concat($next-filename, '_', $next-fid)
                                                           else '#'" />

                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <section>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div w3-include-html="toc.html" class="nav-wrap">&#xFEFF;</div>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div id="content" data-title="{*[1]/@id}">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div id="guide_contents">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <h1 class="breadcrumb"><xsl:value-of select="ancestor::chapter/topic/*[1][starts-with(name(), 'h')]" />
                                    <div id="share_area_sub">
                                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                        <div class="addthis_inline_share_toolbox toolbox_toggle">&#xFEFF;</div>
                                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                        <div class="img_share"><img src="common/images/btn_share.svg"/>&#xFEFF;</div>
                                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                    </div>
                                </h1>
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <xsl:apply-templates />
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </div>
                        </div>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </section>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <div w3-include-html="share.html">&#xFEFF;</div>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:comment> toc include </xsl:comment>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript">includeHTML();</script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript">
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">$(document).ready(function() {var isMobile = window.matchMedia("only screen and (max-width: 760px)");if (isMobile.matches) {</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var element = $('#content');</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var mc = new Hammer(element[0]);</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var swipe = new Hammer.Swipe();</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">mc.on('swipeleft', function() {$(location).attr('href','</xsl:text>
                    <xsl:value-of select='$data-next' />
                    <xsl:text disable-output-escaping="yes">.html');});</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">mc.on('swiperight', function() {$(location).attr('href','</xsl:text>
                    <xsl:value-of select='$data-prev' />
                    <xsl:text disable-output-escaping="yes">.html');});</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">}});</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </script>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                </body>
                <xsl:text>&#xA;</xsl:text>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="table">
        <xsl:choose>
            <xsl:when test="@class = 'genminitoctable1'">
                <xsl:variable name="current" select="tr/td[2]" />
                <xsl:variable name="idref" select="substring-after(tr/td[2]/a/@href, '#')" />
                <xsl:variable name="target" select="key('xrefs', $idref)[1]" />
                <xsl:variable name="filename" select="$target/ancestor::topic[1]/@filename" />
                <xsl:variable name="fid" select="$target/ancestor::topic[1]/*[1]/@id" />
                <xsl:variable name="html" select="concat($filename, '_', $fid, '.html')" />

                <xsl:if test="not(preceding-sibling::table[@class='genminitoctable1'])">
                    <div class="started_background">&#xFEFF;</div>
                </xsl:if>
                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                <p class="subchapter_toc">
                    <a class="genminitoctext1" href="{concat($filename, '_', $fid, '.html', '#', $idref)}">
                        <xsl:value-of select="$current" />
                    </a>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="cellspacing">0</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>