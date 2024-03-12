<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
        <xsl:output-character character="&apos;" string="&amp;apos;" />
    </xsl:character-map>

    <xsl:key name="target" match="*[@id]" use="@id" />

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:variable name="data-language" select="/topic/@data-language" />
    <xsl:variable name="lgns" select="substring-after(/topic/@data-language, '_')" />
    <xsl:variable name="fullLanguage" select="substring-before($lgns, '(')" />
    <xsl:variable name="codesFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'codes.xml'))/codes/langs" />
    
    <xsl:variable name="lang_iso">
        <xsl:for-each select="$codesFile/*">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="lang">
                <xsl:value-of select="substring-before($lang_iso/*[@Fullname = $fullLanguage]/@ISO, '-')" />
            </xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name() = 'h1' or name() = 'h2']">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::br">
                    </xsl:when>
                    
                    <xsl:when test="self::text()[not(preceding-sibling::node())]">
                        <xsl:value-of select="replace(., '^\s+', '')" />
                    </xsl:when>
                    
                    <xsl:when test="self::text()[not(following-sibling::node())]">
                        <xsl:value-of select="replace(., '\s+$', '')" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
        
        <xsl:if test="@video-after">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-after" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ul | ol">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:choose>
            <xsl:when test="matches($data-language, 'kia_Korean\(internal\)') and 
                            not(contains(@class, 'note')) and 
                            @video-after">
                <xsl:variable name="curr" select="." />
                <xsl:variable name="video_after" select="@video-after" />
                <xsl:variable name="video_size" select="@video-size" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::node())">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                    <video data-import="{$video_after}">
                                        <xsl:if test="$curr/@*[matches(name(), 'video-size')]">
                                            <xsl:attribute name="video-size" select="$video_size" />
                                        </xsl:if>
                                    </video>
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                <xsl:if test="@video-after">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-after" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="not(node()) and (@video-before or @video-after)">
                <xsl:call-template name="video-tem">
                    <xsl:with-param name="filename" select="@*[matches(name(), '(video-before|video-after)')]" />
                    <xsl:with-param name="size" select="@video-size" />
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:if test="@video-before">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-before" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
                
                <xsl:copy>
                    <xsl:apply-templates select="@* except @video-before, video-after" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
                
                <xsl:if test="@video-after">
                    <xsl:call-template name="video-tem">
                        <xsl:with-param name="filename" select="@video-after" />
                        <xsl:with-param name="size" select="@video-size" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img">
        <xsl:if test="@video-before">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-before" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
        
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
        
        <xsl:if test="@video-after">
            <xsl:call-template name="video-tem">
                <xsl:with-param name="filename" select="@video-after" />
                <xsl:with-param name="size" select="@video-size" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="video-tem">
        <xsl:param name="filename" />
        <xsl:param name="size" />
        
        <xsl:element name="video">
            <xsl:attribute name="data-import" select="$filename" />
            <xsl:if test="$size">
                <xsl:attribute name="video-size" select="$size" />
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@video-after | @video-before | @video-size" />

    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="@class='heading1' and count(*) = 1 and h1">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:if test="following-sibling::*[1][name()='div'][@class='heading2']">
                        <xsl:apply-templates select="following-sibling::*[1][name()='div'][@class='heading2']/node()" />
                    </xsl:if>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="@class='heading2' and 
                            preceding-sibling::*[1][name()='div'][@class='heading1'][count(*) = 1][h1]">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:variable name="id" select="substring-after(@href, '#')" />
        <xsl:variable name="ohref" select="substring-after(@ohref, '#')" />
        <xsl:variable name="cur" select="." />
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:choose>
                        <xsl:when test="key('target', $id)[name()='h0']">
                            <xsl:attribute name="href">
                                <xsl:value-of select="if ( count(key('target', $id)/following-sibling::topic[1][@file]/div) &gt; 1 ) 
                                                      then replace(key('target', $id)/following-sibling::topic[1][@file]/@file, '^(.+)_.+(\.html)$', '$1$2')
                                                      else key('target', $id)/following-sibling::topic[1][@file]/@file" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:when test="key('target', $id)[matches(name(), 'h(1|2)')]">
                            <xsl:variable name="str" select="if (count(key('target', $id)[matches(name(), 'h(1|2)')]) &gt; 1) then 
                                                             key('target', $id)[matches(name(), 'h(1|2)')][@oid=$ohref] else 
                                                             key('target', $id)[matches(name(), 'h(1|2)')]" />
                            <xsl:variable name="str1">
                                <xsl:for-each select="$str">
                                    <xsl:choose>
                                        <xsl:when test="self::h1[.=$cur]">
                                            <xsl:variable name="Next_h1idDelte">
                                                <xsl:variable name="lastID" select="tokenize(replace($str/ancestor::topic[@file]/@file, '.html', ''), '_')[last()]" />
                                                <xsl:value-of select="if ($lastID = $id) then $str/ancestor::topic[@file]/@file else concat($str/ancestor::topic[@file]/@file, '#', $id)"/>
                                            </xsl:variable>
                                            
                                            <xsl:value-of select="$Next_h1idDelte" />
                                        </xsl:when>
                                        <xsl:when test="self::h2[.=$cur]">
                                            <xsl:choose>
                                                <xsl:when test="matches(@class, 'heading2-continue')">
                                                    <xsl:variable name="firstH2ID" select="parent::*/h2[1]/@id" />
                                                    <xsl:value-of select="concat(ancestor::topic[@file]/@file, '#', $firstH2ID, '#', $id)" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat(ancestor::topic[@file]/@file, '#', $id)" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>

                            <xsl:attribute name="href">
                                <xsl:value-of select="$str1" />
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="key('target', $id)[matches(name(), 'h3')]/ancestor::div">
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat(key('target', $id)/ancestor::topic[@file]/@file, '#', key('target', $id)/preceding-sibling::h2[1]/@id, '#', $id)" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:when test="key('target', $id)[matches(name(), 'h4')]/ancestor::div">
                            <xsl:variable name="preceding-h3" select="key('target', $id)/preceding-sibling::h3[1]/@id" />
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat(key('target', $id)/ancestor::topic[@file]/@file, '#', key('target', $id)/preceding-sibling::h2[1]/@id, '#', $preceding-h3,'#', $id)" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:apply-templates select="@href" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="@href" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()[parent::*[matches(@class, 'heading')]]">
        <xsl:analyze-string select="." regex="®">
            <xsl:matching-substring>
                <sup class="c_superscript-r-tm">
                    <xsl:value-of select="." />
                </sup>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="span[matches(@class, 'c_crossreference-symbol')]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:choose>
                <xsl:when test="$Sangyong = 1">
                    <img src="images/B-crossreference_symbol.png" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
</xsl:stylesheet>
