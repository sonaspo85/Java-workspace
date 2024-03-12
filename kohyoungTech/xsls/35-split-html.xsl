<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    
    <xsl:variable name="outFolderName" select="root/@outFolderName" />
    <xsl:variable name="lang" select="root/body/@lang" />
    <xsl:variable name="langCode" select="document(concat(ast:getPath(base-uri(.), '/'), '/codes.xml'))/codes/option" />
    <xsl:variable name="langVal" select="$langCode[$lang=@lang]/@lang" />
    
    <xsl:variable name="selectedLang">
        <xsl:variable name="str0">
            <xsl:value-of select="$langCode/root()/codes/@TotalLang"/>
        </xsl:variable>
        <xsl:variable name="multiLang" select="if (matches($str0, ', ')) then tokenize($str0, ', ') else $str0"/>
        <xsl:for-each select="$multiLang">
            <lang>
                <xsl:value-of select="."/>
            </lang>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="outputPath" select="root/body/@outputPath" />
    <!--<xsl:variable name="sourceName0" select="replace(root/@sourcename, '\\', '/')" />
    <xsl:variable name="sourceName" select="replace(ast:last($sourceName0, '/'), '.htm', '')"/>-->
    
    <xsl:variable name="coverContent">
        <xsl:for-each select="//div[matches(@class, 'coverContent')]/*">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="body" priority="10">
        <xsl:variable name="curBody" select="." />
        <xsl:variable name="indexfile" select="concat('file:////', $outputPath, '/', $outFolderName, '/', $langVal, '/', 'index.html')"/>
        
        <xsl:for-each select="//*[@filename]">
            <xsl:variable name="curfile" select="if (not(matches(@filename, 'Info.html'))) then xs:integer(replace(tokenize(@filename, '_')[1], 'chapter', '')) else 00"/>
            <xsl:variable name="filename" select="concat('file:////', $outputPath, '/', $outFolderName, '/', $langVal, '/', @filename)"/>
            
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
                <html data-language="{$lang}">
                    <xsl:attribute name="lang" select="$langCode[$lang=@lang]/@abbr" />
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
                        <title>
                            <xsl:value-of select="concat($coverContent/*[matches(@class, 'coverTitle2')], ' - ', ancestor-or-self::chapter/@browerTitle)" />
                        </title>
                        <link type="text/css" rel="stylesheet" href="css/style.css"/>
                        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi" />
                        <meta name="apple-mobile-web-app-capable" content="yes" />
                        <script src="js\jquery-3.0.0.js" type="text/javascript">&#xfeff;</script>
                        <script src="js\toc.js">&#xfeff;</script>
                        <script src="js\ui_text.js">&#xfeff;</script>
                    </head>
                    <body>
                        <header>
                            <div class="container">
                                <div class="cover">
                                    <a href="index.html">
                                        <div class="logo">
                                            <xsl:copy-of select="$coverContent/*[1]/img[1]" />
                                        </div>
                                        <div class="main_title">
                                            <p class="manual">
                                                <xsl:value-of select="$coverContent/*[matches(@class, 'coverTitle1')]" />
                                            </p>

                                            <p class="title">
                                                <xsl:value-of select="$coverContent/*[matches(@class, 'coverTitle2')]" />
                                            </p>
                                            <p class="ver">
                                                <xsl:value-of select="$coverContent/*[matches(@class, 'coverVersion')]" />
                                            </p>
                                        </div>
                                    </a>
                                </div>
                                <div class="search">
                                    <div class="language">
                                        <label for="lang">
                                            <img src="css/img/Language.svg"/>
                                        </label>
                                        <select onChange="window.location.href=this.value">
                                            <xsl:for-each select="$langCode[@lang=$selectedLang/lang]">
                                                <xsl:text disable-output-escaping="yes">&lt;option value="../</xsl:text>
                                                <xsl:value-of select="@lang" />
                                                <xsl:text disable-output-escaping="yes">/index.html"</xsl:text>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="$lang=@lang">
                                                        <xsl:text disable-output-escaping="yes"> selected></xsl:text>
                                                        <xsl:value-of select="."/>
                                                        <xsl:text disable-output-escaping="yes">&lt;/option&gt;</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                                                        <xsl:value-of select="."/>
                                                        <xsl:text disable-output-escaping="yes">&lt;/option&gt;</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </select>
                                    </div>

                                    <div class="form">
                                        <label>
                                            <svg class="octicon octicon-search bg-gradient-light mr-2" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true" onclick="doSearch();">
                                                <path fill="grey" fill-rule="evenodd" d="M11.5 7a4.499 4.499 0 11-8.998 0A4.499 4.499 0 0111.5 7zm-.82 4.74a6 6 0 111.06-1.06l3.04 3.04a.75.75 0 11-1.06 1.06l-3.04-3.04z" />
                                            </svg>
                                            <xsl:text disable-output-escaping="yes">&lt;input type=&quot;text&quot; maxlength=&quot;255&quot; placeholder=&quot;Search the latest docs...&quot; autocomlete=&quot;off&quot; id=&quot;id_main_search&quot; onKeyDown=&quot;fncSearchKeyDown(event.keyCode, this.value);&quot;&gt;</xsl:text>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </header>
                        
                        <main>
                            <div id="btn_menu">
                                <button id="btn-toc" class="btn01">&#xfeff;</button>
                            </div>
                            <div class="row">
                                <div class="toc">
                                    <div id="toc">
                                        <ul>
                                            <xsl:for-each select="$curBody/chapter">
                                                <xsl:variable name="cnt" select="count(preceding-sibling::chapter) + 1" />
                                                <xsl:variable name="idCreate" select="concat('list-item-', $cnt)" />
                                                
                                                <xsl:variable name="chfile" select="if (not(matches(@filename, 'Info.html'))) then xs:integer(replace(tokenize(@filename, '_')[1], 'chapter', '')) else 00"/>
                                                
                                                <li class="heading1">
                                                    <xsl:text disable-output-escaping="yes">&lt;input type=&quot;checkbox&quot; id=&quot;</xsl:text>
                                                    <xsl:value-of select="$idCreate" />
                                                    
                                                    <xsl:choose>
                                                        <xsl:when test="$curfile = $chfile">
                                                            <xsl:text disable-output-escaping="yes">&quot; checked&gt;</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text disable-output-escaping="yes">&quot;&gt;</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>

                                                    <xsl:element name="label">
                                                        <xsl:attribute name="for" select="$idCreate" />
                                                        <xsl:if test="not(preceding-sibling::chapter)">
                                                            <xsl:attribute name="class" select="'first'" />
                                                        </xsl:if>
                                                        <xsl:if test="not(following-sibling::chapter)">
                                                            <xsl:attribute name="class" select="'last'" />
                                                        </xsl:if>
                                                        <a>
                                                            <xsl:choose>
                                                                <xsl:when test="matches(@filename, 'Info.html')">
                                                                    <xsl:attribute name="href" select="'Info.html'" />
                                                                    <xsl:attribute name="id" select="'docuinfo'" />
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:attribute name="href" select="@filename" />
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            <xsl:value-of select="@browerTitle" />
                                                        </a>
                                                    </xsl:element>

                                                    <xsl:if test="topic">
                                                        <xsl:call-template name="recall">
                                                            <xsl:with-param name="cur" select="topic" />
                                                        </xsl:call-template>
                                                    </xsl:if>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </div>

                                <div class="contents">
                                    <xsl:if test="self::topic[*[1][matches(name(), 'h2')]]">
                                        <xsl:copy-of select="ancestor-or-self::chapter/h1" />
                                    </xsl:if>
                                    <xsl:if test="self::topic[*[1][matches(name(), 'h3')]]">
                                        <xsl:copy-of select="ancestor-or-self::chapter/h1" />
                                        <xsl:copy-of select="parent::topic/h2" />
                                    </xsl:if>

                                    <xsl:choose>
                                        <xsl:when test="self::*[matches(@filename, 'Info')]">
                                            <h1 id="docuInfo">
                                                <xsl:value-of select="*[1][name()='h1']" />
                                            </h1>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:apply-templates select="node() except *[@filename]" />
                                        </xsl:otherwise>
                                    </xsl:choose>

                                    <xsl:if test="self::*[matches(name(), '(chapter|topic)')] and 
                                                  topic">
                                        <ul id="subheading" class="disc">
                                            <xsl:for-each select="topic">
                                                <xsl:variable name="link" select="@filename" />
                                                <xsl:variable name="linkContent">
                                                    <xsl:value-of select="*[1]" />
                                                </xsl:variable>
                                                <li>
                                                    <a href="{$link}">
                                                        <xsl:value-of select="$linkContent" />
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:if>
                                </div>
                            </div>
                            <div class="gotop">
                                <a href="#top">TOP</a>
                            </div>
                        </main>
                        <footer>
                            <div class="copyright">
                                <p>
                                    <xsl:value-of select="$coverContent/*[matches(@class, 'Copyright')]" />
                                </p>
                                <p>Homepage: <a href="https://www.kohyoung.com" target="_blank">www.kohyoung.com/</a>&#x20;&#x20;&#x20;&#x20;Helpdesk: <a href="https://help.kohyoung.com" target="_blank">help.kohyoung.com/</a></p>
                            </div>
                        </footer>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:result-document href="{$indexfile}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html>
                <head>
                    <meta charset="utf-8" />
                    <title>Untitled Document</title>
                    <meta http-equiv="refresh" content="{concat('0;url=chapter01_', $lang, '.html')}" />
                </head>
                <body> </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="recall">
        <xsl:param name="cur" />

        <ul>
            <xsl:for-each select="$cur">
                <xsl:variable name="link" select="@filename" />
                <xsl:variable name="Hnum" select="count(ancestor-or-self::*[@filename])" />
                <li class="{concat('heading', $Hnum)}">
                    <a href="{$link}">
                        <xsl:value-of select="*[matches(@class, concat('heading', $Hnum))]" />
                    </a>
                    <xsl:if test="topic">
                        <xsl:call-template name="recall">
                            <xsl:with-param name="cur" select="topic" />
                        </xsl:call-template>
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>