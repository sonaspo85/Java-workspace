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
            <xsl:apply-templates select="@* | node()" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="." />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="topic[@filename][not(*[matches(@class, 'minitoc')])]">
        <xsl:variable name="file" select="concat($sourcePath, '/output/', @filename, '_', *[1]/@id, '.html')" />
        <xsl:variable name="title" select="concat(*[1], ' - ', $model-name)" />

        <xsl:result-document href="{$file}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <html data-language="{$data-language}">
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
                <body>
                    <header>
                        <div w3-include-html="header.html">&#xFEFF;</div>
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
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>