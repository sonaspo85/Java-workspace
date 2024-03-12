<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="data-language" select="/topic/@data-language" />
    <xsl:variable name="company" select="tokenize(/topic/@data-language, '_')[1]" />
    <xsl:variable name="type" select="substring-before(substring-after(/topic/@data-language, '('), ')')" />
    <xsl:variable name="lgns" select="tokenize(/topic/@data-language, '_')[2]" />
    <xsl:variable name="langISO" select="/topic/@lang" />
    
    <xsl:variable name="root" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'URL_form.xml'))" />
    <xsl:variable name="URLforms1" select="$root/root/URLform[starts-with(Project, $company)][contains(Language, $lgns)]/URL" />

    <!--<xsl:variable name="UI_textDATA" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))" />-->
    <xsl:variable name="UI_lgns" select="$UI_textDATA/root/listitem[language[.=$lgns]]" />
    <!--<xsl:variable name="video-import" select="collection(concat(ast:getName(base-uri(.), '/'), '/../resource/template?select=*.html;recurse=yes'))" />-->
    <!-- <xsl:variable name="term_compare" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'defined_regex.xml'))" /> -->
    <xsl:variable name="chapter_sort" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'index_sort.xml'))/root" />
    <xsl:variable name="body-footer" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'body-footer.xml'))/root/*" />
    
    <xsl:variable name="URLformsCompany" select="$root/root/URLform[starts-with(Project, $company)]" />
    <xsl:variable name="URLformsLang" select="$URLformsCompany[Language[.=$lgns]]" />
    <xsl:variable name="URLformsAnalCode" select="$URLformsLang/analCode" />
    
    <xsl:key name="htmls" match="topic[@file]" use="@file"/>
    
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

    <xsl:variable name="chapter_idml">
        <xsl:for-each select="$chapter_sort/chapter[matches(@company, $company)]">
            <xsl:variable name="same" select="current()[@type = $type]" />

            <xsl:variable name="same_topic">
                <xsl:if test="$same">
                    <xsl:sequence select="$same/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="differ_topic">
                <xsl:if test="not(parent::*/chapter[@type = $type]) and current()[@type != $type]">
                    <xsl:sequence select="current()[@type = 'common']/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$same_topic/node()">
                    <xsl:copy-of select="$same_topic" />
                </xsl:when>

                <xsl:when test="not($same_topic/node()) and $differ_topic">
                    <xsl:copy-of select="$differ_topic" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="chapter_change">
        <xsl:variable name="curr" select="root()/topic/topic[@idml]" />

        <topic data-language="{$data-language}">
            <xsl:for-each select="$chapter_idml/topic">
                <xsl:variable name="idml" select="@idml" />
                
                <xsl:copy-of select="$curr[@idml = $idml]" />
            </xsl:for-each>
        </topic>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="$chapter_change" mode="resort"/>
    </xsl:template>

    <xsl:variable name="filenames" as="xs:string*">
        <xsl:for-each select="$chapter_change/topic//topic[@file]/@file">
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/topic" mode="resort">
        <xsl:apply-templates select="current()//topic[@file]"/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic">
        <xsl:variable name="filename" select="@file"/>
        <xsl:variable name="filename1" select="concat('../', 'output/', @file)"/>
        <!-- calculate prev -->
        <xsl:variable name="prev" select="key('htmls', $filenames[index-of($filenames, $filename) - 1])"/>
        <xsl:variable name="prev-filename" select="$prev/@file"/>
        <xsl:variable name="prev-div-hs" select="$prev/div[last()]/*[matches(name(), 'h(1|2)')]"/>
        <xsl:variable name="prev-div-id" select="if ( $prev/div[last()][h1][h2] ) then $prev-div-hs[1]/@id else $prev-div-hs[last()]/@id"/>
        

        <xsl:variable name="Pre_h1idDelte">
            <xsl:variable name="lastID" select="tokenize(replace($prev-filename, '.html', ''), '_')[last()]" />
            <xsl:value-of select="if ($lastID = $prev-div-id) then $prev-filename else concat($prev-filename, '#', $prev-div-id)"/>
        </xsl:variable>
        
        <xsl:variable name="prev-div">
            <xsl:choose>
                <xsl:when test="not($prev) and matches($filename, '_Content')">
                    <xsl:value-of select="'#'" />
                </xsl:when>
                
                <xsl:when test="not(preceding-sibling::topic) and 
                                following-sibling::topic/descendant::*[matches(@class, '\-sublink')]">
                    <xsl:value-of select="$Pre_h1idDelte" />
                </xsl:when>
                
                <xsl:when test="not(preceding-sibling::topic) and 
                                count(parent::*/topic) &gt; 1">
                    <xsl:value-of select="concat(ancestor::topic[@idml]/@idml, '.html')"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$Pre_h1idDelte" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<!--        <xsl:variable name="data-prev" select="if ($prev-filename!='') then $prev-div else '#'"/>-->
        <xsl:variable name="data-prev" select="$prev-div"/>

        <!-- calculate next -->
        <xsl:variable name="next" select="key('htmls', $filenames[index-of($filenames, $filename) + 1])"/>
        <xsl:variable name="next-filename" select="$next/@file"/>
        <xsl:variable name="next-div-hs" select="$next/div[1]/*[matches(name(), 'h(1|2)')]"/>
        <xsl:variable name="next-div-id" select="$next-div-hs[1]/@id"/>
        
        <xsl:variable name="Next_h1idDelte">
            <xsl:variable name="lastID" select="tokenize(replace($next-filename, '.html', ''), '_')[last()]" />
            <xsl:value-of select="if ($lastID = $next-div-id) then $next-filename else concat($next-filename, '#', $next-div-id)"/>
        </xsl:variable>
        
        <xsl:variable name="next-div">
            <xsl:choose>
                <xsl:when test="not(following-sibling::topic) and 
                                ancestor::topic[@idml]/following-sibling::topic[@idml][1]/descendant::*[matches(@class, '\-sublink')]">
                    <xsl:value-of select="concat(ancestor::topic[@idml]/following-sibling::topic[@idml][1]/topic[1]/topic[1]/@idml, '.html')"/>
                </xsl:when>

                <xsl:when test="not(following-sibling::topic) and count(ancestor::topic[@idml]/following-sibling::topic[@idml][1]/topic[1]/topic) &gt; 1">
                    <xsl:value-of select="concat(ancestor::topic[@idml]/following-sibling::topic[@idml][1]/@idml, '.html')"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$Next_h1idDelte" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="filename2" select="'E:\WORK\WORK\Mobis\Mobis_bat\Bat_task\ddd.xml'"/>
        
        <xsl:result-document href="{$filename1}">
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
                    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
                    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0, target-densitydpi=medium-dpi"/>
                    <!-- font import -->
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
                            <a class="logo" href="#">&#xFEFF;</a>
                            <div class="head_tit">&#xFEFF;</div>
                            <div id="toolbar">&#xFEFF;</div>
                        </div>
                    </div>
                    
                    <div id="scroll_nav">
                        <div id="scrollmask">
                            <div id="home_area">
                                <a class="home2" href="javascript:history.back(-1);">&#xFEFF;</a>
                            </div>
                            <span id="chapter">
                                <xsl:value-of select="ancestor::topic[@idml]/topic/h0"/>
                                <xsl:if test="ancestor::topic[@idml]/topic/h0/@caption">
                                    <span class="caption">
                                        <xsl:value-of select="ancestor::topic[@idml]/topic/h0/@caption"/>
                                    </span>
                                </xsl:if>
                            </span>
                        </div>
                    </div>
                    <!--<xsl:comment> wrapper division </xsl:comment>-->
                    <div id="wrapper">
                        <xsl:if test="$prev-div!='#'">
                            <xsl:attribute name="data-prev">
                                <xsl:value-of select="$prev-div"/>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:if test="$next-filename!=''">
                            <xsl:attribute name="data-next">
                                <xsl:value-of select="$next-div"/>
                            </xsl:attribute>
                        </xsl:if>
                        <div id="root">
                            <xsl:for-each select="div">
                                <div class="Heading2" id="{@id}">
                                    <div class="swipe_inner_wrap">
                                        <xsl:choose>
                                            <xsl:when test="count(parent::topic/div[@class='heading2']) = 1">
                                                <div class="heading1" id="{@id}">
                                                    <xsl:apply-templates/>
                                                </div>
                                            </xsl:when>

                                            <xsl:when test="h1[matches(@class, 'sublink')]">
                                                <div class="heading1" id="{@id}">
                                                    <xsl:apply-templates mode="applink"/>
                                                </div>
                                            </xsl:when>

                                            <xsl:when test="count(parent::topic/div[@class='heading2']) &gt;= 2">
                                                <div class="heading1" id="{@id}">
                                                    <xsl:apply-templates mode="applink"/>
                                                </div>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:apply-templates />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <xsl:if test="parent::topic/preceding-sibling::node()[1][name()='h0'][ancestor::topic[matches(@idml, '(_Settings$|_Features_)')]] and 
                                                      ancestor::topic[@idml][last()]//descendant::*[matches(@class, '\-sublink')]">
                                            <xsl:comment> h1_sublink </xsl:comment>
                                            <xsl:variable name="cur" select="." />
                                            <div class="h1_sublink">
                                                <ul class="h1_list">
                                                    <xsl:for-each select="ancestor::topic[@idml][last()]//descendant::*[matches(@class, '\-sublink')]/node()[not(matches(@class, 'c_below_heading'))]">
                                                        <xsl:variable name="root_filename" select="ancestor::topic[@file][1]/@file" />
                                                        <xsl:variable name="cur_id" select="parent::*/@id" />

                                                        <xsl:variable name="Subln_h1idDelte">
                                                            <xsl:variable name="lastID" select="tokenize(replace($root_filename, '.html', ''), '_')[last()]" />
                                                            <xsl:value-of select="if ($lastID = $cur_id) then $root_filename else concat($root_filename, '#', $cur_id)"/>
                                                        </xsl:variable>
                                                        
                                                        <li>
                                                            <a href="{$Subln_h1idDelte}">
                                                                <xsl:value-of select="." />
                                                            </a>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </div>
                                            <xsl:comment> //h1_sublink </xsl:comment>
                                        </xsl:if>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                    
                    <xsl:copy-of select="$body-footer" />
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- applink는 해당 Heading 밑에 하위 Heading을 가지고 있는 경우, 파란색 링크로 제공하기 위해 사용 함 -->
    <xsl:template match="*" mode="applink">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()" mode="applink"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p[not(node())]" mode="#all">
    </xsl:template>
    
    <xsl:template match="table" mode="#all">
        <xsl:choose>
            <xsl:when test="@tableSize">
                <xsl:copy>
                    <xsl:attribute name="style">
                        <xsl:text>width:</xsl:text>
                        <xsl:value-of select="@tableSize" />
                    </xsl:attribute>
                    <xsl:apply-templates select="@* except @tableSize" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="video" mode="#all" priority="5">
        <xsl:variable name="current" select="." />
        <xsl:variable name="curPos">
            <xsl:number from="topic[@file]" count="video" level="any" format="1" />
        </xsl:variable>
        <xsl:variable name="videoLink" select="@data-import" />
        <xsl:variable name="numbers">
            <xsl:number from="topic[@file]" count="video" level="any" format="1" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$current/preceding-sibling::node()[1][name()='h2']">
                <xsl:variable name="preHeading2" select="$current/preceding-sibling::node()[1]" />
                
                <div class="video_container">
                    <xsl:choose>
                        <xsl:when test="count($preHeading2//ancestor::topic[1]/div[@class='heading2']) &gt;= 2">
                            <xsl:for-each select="$preHeading2">
                                <xsl:element name="{local-name()}">
                                    <xsl:attribute name="class" select="concat(@class, ' ', 'Heading2-APPLINK')"/>
                                    <xsl:apply-templates select="@id"/>
                                    <xsl:apply-templates select="node()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="$current/preceding-sibling::node()[1]" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:call-template name="videoContainer">
                        <xsl:with-param name="cur" select="$current" />
                        <xsl:with-param name="numbers" select="$numbers" />
                    </xsl:call-template>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:call-template name="videoContainer">
                    <xsl:with-param name="cur" select="$current" />
                    <xsl:with-param name="numbers" select="$numbers" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="videoContainer">
        <xsl:param name="cur" />
        <xsl:param name="numbers" />
        
        <xsl:variable name="videoLink" select="$cur/@data-import" />
        <xsl:variable name="size">
            <xsl:choose>
                <xsl:when test="@video-size">
                    <xsl:value-of select="concat('video_', @video-size)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('video_', '100')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$cur/@data-import[matches(., '(youtube|youtu\.be)')]">
                <xsl:text disable-output-escaping="yes">&lt;iframe width="100%" height="100%"</xsl:text>
                <xsl:text>src="</xsl:text>
                <xsl:value-of select="replace(replace($videoLink, 'https://', 'https://www.'), 'youtu\.be', 'youtube.com/embed')"/>
                <xsl:text disable-output-escaping="yes">" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" </xsl:text>
                <xsl:text>class="</xsl:text>
                <xsl:value-of select="$size" />
                <xsl:text disable-output-escaping="yes">" id="video</xsl:text>
                <xsl:value-of select="$numbers" />
                <xsl:text disable-output-escaping="yes">" preload="none" allowfullscreen &gt;&lt;/iframe&gt;</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <div>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$size" />
                    </xsl:attribute>
                    
                    <video poster="{replace($videoLink, '.mp4', '.png')}" controlsList="nodownload" crossorigin="anonymous" preload="none">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('video', $numbers)" />
                        </xsl:attribute>
                        <source src="{$videoLink}" type="video/mp4" />
                    </video>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[matches(name(), 'h2')][following-sibling::node()[1][name()='video']]">
    </xsl:template>

    <xsl:template match="@video-before | @video-after">
    </xsl:template>
    
    <xsl:template match="h1 | p1" mode="applink">
        <xsl:element name="{if (local-name()='p1') then 'h1' else local-name()}">
            <xsl:variable name="class" select="if (matches(@class, '(\-sublink|-features)')) then replace(@class, '(\-sublink|-features)', '') 
                                else @class" />
            <xsl:attribute name="class" select="concat($class, ' ', 'Heading1-APPLINK')"/>
            <xsl:apply-templates select="@id"/>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::text()">
                        <xsl:value-of select="replace(., '&#xa;', '')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="h1 | p1">
        <xsl:element name="{if (local-name()='p1') then 'h1' else local-name()}">
            <xsl:variable name="class" select="if (matches(@class, '\-sublink')) then replace(@class, '\-sublink', '') else @class" />
            <xsl:attribute name="class" select="$class"/>
            <xsl:apply-templates select="@* except @class"/>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::text()">
                        <xsl:value-of select="replace(., '&#xa;', '')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="h2" mode="applink">
        <xsl:choose>
            <xsl:when test="matches(@class, 'heading2-none-view')">
                <xsl:element name="{local-name()}">
                    <xsl:attribute name="class" select="'heading2-none-view'"/>
                    <xsl:apply-templates select="@id"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="following-sibling::node()[1][name()='video']">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:element name="{local-name()}">
                    <xsl:attribute name="class" select="concat(@class, ' ', 'Heading2-APPLINK')"/>
                    <xsl:apply-templates select="@id"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()[parent::*[name()='h1' or name()='h2']][not(following-sibling::node())]" mode="#all">
        <xsl:value-of select="replace(., '\s+$', '')" />
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>