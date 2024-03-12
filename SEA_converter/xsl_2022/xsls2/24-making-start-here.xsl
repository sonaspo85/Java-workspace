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
     
     <xsl:template match="/">
          <xsl:apply-templates />
          <xsl:result-document href="dummy.xml">
               <dummy/>
          </xsl:result-document>
     </xsl:template>
     
     <xsl:template match="body">
          <xsl:variable name="file" select="concat($sourcePath, '/output/', 'start_here.html')" />
          <xsl:result-document href="{$file}">
              <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
               <html data-language="{$data-language}">
                    <head>
                         <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                         <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                         <title><xsl:value-of select="$model-name" /></title>
                         <link rel="apple-touch-icon" href="common/images/favicon.png" />
                         <link rel="apple-touch-icon-precomposed" href="common/images/favicon.png" />
                         <link rel="icon" href="common/images/favicon.ico" />
                         <link rel="shortcut icon" href="common/images/favicon.png" />
                         <link rel="stylesheet" type="text/css" href="common/css/working.css"/>
                         <script type="text/javascript" src="common/js/jquery.js"></script>
                         <script type="text/javascript" src="common/js/hammer.js"></script>
                         <script type="text/javascript" src="common/js/common.js"></script>
                         <script type="text/javascript" src="common/js/message.js"></script>
                         <xsl:text disable-output-escaping='yes'>&lt;script&gt;(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create','UA-50979023-4','auto');ga('send','pageview');&lt;/script&gt;</xsl:text>
                    </head>
                    <body>
                         <div class="main-wrap">
                              <div class="right-wrap">
                                   <div class="search">
                                        <div id="search_area">
                                             <input type="text" id="id_main_search" value="" placeholder="Enter search keyword" onKeyDown="fncSearchKeyDown(event.keyCode, this.value);" />
                                             <img id="id_search_button" src="common/images/search_icon.png" onclick="doSearch();" />
                                        </div>
                                   </div>
                                   <div id="share_area">
                                    <div class="addthis_inline_share_toolbox toolbox_toggle">&#xFEFF;</div>
                                    <div class="img_share"><img src="common/images/btn_share.svg"/>&#xFEFF;</div>
                                </div>
                                   <span class="main_image">
                                        <img class="deviceImage" src="{concat('images/', $main-image, '.png')}" width="136" height="200" />
                                   </span>
                                   <div class="main_title">
                                        <img class="logoImage" src="{concat('images/logo_', $main-image, '.png')}" />
                                   </div>
                              </div>
                             <div class="left-wrap">
                                  <ul class="main-nav">
                                        <li><a href="start_here.html" class="s_button">
                                             <img src="common/images/toc1_00.svg" />
                                             <span class="chapter_text2">Welcome</span></a>
                                        </li>
                                        <li>
                                             <a class="s_button">
                                                  <xsl:attribute name="href" select="concat(lower-case(chapter[1]/toc_link[1]/h1), '_', chapter[1]/toc_link[1]/h1/@id, '.html')" />
                                                  <img src="common/images/toc1_01.svg" />
                                                  <span class="chapter_text2">
                                                       <xsl:value-of select="chapter[1]/toc_link[1]/h1" />
                                                  </span>
                                             </a>
                                        </li>
                                       <xsl:for-each select="chapter[position() &gt; 1]">
                                             <xsl:variable name="chaptername" select="topic[1]/*[1]" />
                                             <xsl:variable name="filename" select="lower-case(topic[1]/@filename)" />
                                             <xsl:variable name="fid" select="topic[1]/*[1]/@id" />
                                             <xsl:variable name="file" select="concat($filename, '_', $fid, '.html')" />
                                             <xsl:variable name="chnum" select="format-number(position()+1,'00')" />
                                             <li>
	                                             <a href="{$file}" class="s_button">
	                                                 <img src="{concat('common/images/toc1_', $chnum, '.svg')}" />
	                                                 <span class="chapter_text2"><xsl:value-of select="$chaptername" /></span>
	                                             </a>
                                             </li>
                                       </xsl:for-each>
                                  </ul>
                              </div>
                         </div>
                         <xsl:variable name="data-next" select="concat(chapter[2]/topic[1]/@filename, '_', chapter[2]/topic[1]/*[starts-with(name(), 'h')]/@id)" />
                         <script type="text/javascript">
                         <xsl:text disable-output-escaping="yes">$(document).ready(function() {var isMobile = window.matchMedia("only screen and (max-width: 760px)");if (isMobile.matches) {</xsl:text>
                         <xsl:text disable-output-escaping="yes">var element = $('.main-wrap');</xsl:text>
                         <xsl:text disable-output-escaping="yes">var mc = new Hammer(element[0]);</xsl:text>
                         <xsl:text disable-output-escaping="yes">var swipe = new Hammer.Swipe();</xsl:text>
                         <xsl:text disable-output-escaping="yes">mc.on('swipeleft', function() {$(location).attr('href','</xsl:text>
                         <xsl:value-of select='$data-next' />
                         <xsl:text disable-output-escaping="yes">.html');});</xsl:text>
                         <xsl:text disable-output-escaping="yes">}});</xsl:text>
                         </script>
                    </body>
               </html>
          </xsl:result-document>
     </xsl:template>
</xsl:stylesheet>
