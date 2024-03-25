<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="html" indent="no" encoding="UTF-8" include-content-type="no" />
    <xsl:strip-space elements="*" />
    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="code" select="/body/@code" />
    <xsl:variable name="sourcePath" select="body/@sourcePath" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:variable name="file" select="concat($sourcePath, '/output/search/', 'search.html')" />

        <xsl:result-document href="{$file}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <html data-language="{$data-language}">
                <xsl:text>&#xA;&#x9;</xsl:text>
                <head>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <title>Search</title>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon" href="../common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="apple-touch-icon-precomposed" href="../common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="icon" href="../common/images/favicon.ico" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link rel="shortcut icon" href="../common/images/favicon.png" />
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <link id="searchStyle" type="text/css" rel="stylesheet" href="../common/css/search_style.css"/>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="jsons/search.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="../common/js/jquery.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="../common/js/message.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="../common/js/common.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="../common/js/alertbox.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <script type="text/javascript" src="../common/js/search.js"></script>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <xsl:text disable-output-escaping='yes'>&lt;script&gt;(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create','UA-50979023-4','auto');ga('send','pageview');&lt;/script&gt;</xsl:text>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                </head>
                <xsl:text>&#xA;&#x9;</xsl:text>
                <body>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <div id="search_wrap">
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div id="search_close">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <a href="javascript:history.back(-1);"><span>home</span></a>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div id="recent_area" class="hidden">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <h3 id="keyword_text">&#x20;</h3>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <ul id="recent_keywords"></ul>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div id="id_searchwrap">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <input type="text" id="id_search" onKeyDown="fncSearchKeyDown(event.keyCode, this.value);" value="" placeholder="" />
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <img src="../common/images/del_search.png" class="del_search" />
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <img src="../common/images/main_search.png" id="id_search_button" />
                        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </div>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <div class="search_wrap">
                        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        <div class="search-result-wrap">
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div class="cate_wrap2" id="cate_wrap2">&#xFEFF;</div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div id="id_results">&#xFEFF;</div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;&#x9;</xsl:text>
                            <div id="id_results2">&#xFEFF;</div>
                            <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
                        </div>
                        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    </div>
                    <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                    <div class="cover">&#xFEFF;</div>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                </body>
                <xsl:text>&#xA;</xsl:text>
            </html>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
