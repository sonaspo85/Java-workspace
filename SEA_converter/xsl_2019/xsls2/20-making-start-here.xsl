<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="html" indent="no" encoding="UTF-8" include-content-type="no" />
    <xsl:strip-space elements="*" />
    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="model-name" select="/body/@model-name" />
    <xsl:variable name="main-image" select="replace(replace(lower-case(replace(normalize-space(replace($model-name, '[!@#$%&amp;();:.,’?]', '')), '[&#x20;&#xA0;]', '_')), '_\|_', '_'), '\+', 'plus')" />
    <xsl:variable name="sourcePath" select="body/@sourcePath" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:variable name="file" select="concat($sourcePath, '/output/', 'start_here.html')" />
        <xsl:result-document href="{$file}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <html data-language="{$data-language}">
                <xsl:text>&#xA;&#x9;</xsl:text>
                <head>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <title><xsl:value-of select="$model-name" /></title>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon" href="common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon-precomposed" href="common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="icon" href="common/images/favicon.ico" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="shortcut icon" href="common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="stylesheet" type="text/css" href="common/css/working.css"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/jquery.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/hammer.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/common.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="common/js/message.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping='yes'>&lt;script&gt;(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create','UA-50979023-4','auto');ga('send','pageview');&lt;/script&gt;</xsl:text>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                </head>
                <xsl:text>&#xA;&#x9;</xsl:text>
                <body>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <div class="main-wrap">
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div class="right-wrap">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div class="search">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <div id="search_area">
                                    <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                    <input type="text" id="id_main_search" value="" placeholder="Enter search keyword" onKeyDown="fncSearchKeyDown(event.keyCode, this.value);" />
                                    <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                    <img id="id_search_button" src="common/images/search_icon.png" onclick="doSearch();" />
                                    <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                </div>
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div id="share_area">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <div class="addthis_inline_share_toolbox toolbox_toggle">&#xFEFF;</div>
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <div class="img_share"><img src="common/images/btn_share.svg"/>&#xFEFF;</div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </div>                            
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <span class="main_image">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <img class="deviceImage" src="{concat('images/', $main-image, '.png')}" width="136" height="200" />
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </span>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div class="main_title">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <img class="logoImage" src="{concat('images/logo_', $main-image, '.png')}" />
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div class="left-wrap">
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                        <ul class="main-nav">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <li><a href="start_here.html" class="s_button">
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <img src="common/images/toc1_00.svg" />
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <span class="chapter_text2">Welcome</span></a>
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            </li>
                            <xsl:for-each select="chapter[position() &gt; 1]">
                                <xsl:variable name="chaptername" select="topic[1]/*[1]" />
                                <xsl:variable name="filename" select="lower-case(topic[1]/@filename)" />
                                <xsl:variable name="fid" select="topic[1]/*[1]/@id" />
                                <xsl:variable name="file" select="concat($filename, '_', $fid, '.html')" />
                                <xsl:variable name="chnum" select="format-number(position(),'00')" />
                                <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                <li><a href="{$file}" class="s_button">
                                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                        <img src="{concat('common/images/toc1_', $chnum, '.svg')}" />
                                        <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                        <span class="chapter_text2"><xsl:value-of select="$chaptername" /></span>
                                    </a>
                                    <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                                </li>
                            </xsl:for-each>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                        </ul>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </div>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                    <xsl:variable name="data-next" select="concat(chapter[2]/topic[1]/@filename, '_', chapter[2]/topic[1]/*[starts-with(name(), 'h')]/@id)" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript">
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">$(document).ready(function() {var isMobile = window.matchMedia("only screen and (max-width: 760px)");if (isMobile.matches) {</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var element = $('.main-wrap');</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var mc = new Hammer(element[0]);</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">var swipe = new Hammer.Swipe();</xsl:text>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping="yes">mc.on('swipeleft', function() {$(location).attr('href','</xsl:text>
                    <xsl:value-of select='$data-next' />
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
    
</xsl:stylesheet>
