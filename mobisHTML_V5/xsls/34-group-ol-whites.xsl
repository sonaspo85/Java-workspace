<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />

    <xsl:variable name="company" select="tokenize(/topic/@data-language, '_')[1]" />
    <xsl:variable name="lang" select="ast:getLast(/topic/@data-language, '_')" />
    <xsl:variable name="inch" select="/topic/@inch" />
    <xsl:variable name="data-language" select="concat($company, '_', $lang)" />
    <xsl:variable name="UI_textDATA" select="substring-after(document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))/root/listitem[1]/language, '(')" />

    <xsl:template match="/topic">
        <topic data-language="{concat($data-language, '(', $UI_textDATA)}">
            <xsl:attribute name="inch" select="@inch" />
            <xsl:apply-templates />
        </topic>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic[parent::topic]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-adjacent="matches(@class, '^OL.+White$')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ol class="white">
                            <xsl:apply-templates select="current-group()" mode="white"/>
                        </ol>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[matches(@class, '^OL.+White$')]" mode="white">
        <li>
            <xsl:apply-templates select="@*, node()" />
        </li>
    </xsl:template>

    <xsl:template match="img[matches(@class, 'magnifier')]" mode="white">
        <xsl:variable name="flw_inch" select="substring-after(@class, 'magnifier')" />
        <div class="{concat('magnifier', $flw_inch)}">
            <xsl:copy>
                <xsl:apply-templates select="@*, node()" />
            </xsl:copy>
        </div>
    </xsl:template>

    <xsl:template match="img[matches(@class, 'magnifier')]">
        <xsl:variable name="flw_inch" select="substring-after(@class, 'magnifier')" />
        <div class="{concat('magnifier', $flw_inch)}">
            <xsl:copy>
                <xsl:apply-templates select="@*, node()" />
            </xsl:copy>
        </div>
    </xsl:template>

    <xsl:template match="img[not(matches(@class, 'magnifier'))]" mode="#all">
        <xsl:choose>
            <xsl:when test="ancestor::td or @class='C_Image' or @class='C_Button'">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@src, '(M-here_color|M-navi_warning|M-video)')">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@src, 'M-hdrt_programinfo_black|M-hdrt_digitalsound_black|M-hd2-hd3_black|M-traffic_black|M-hdrt_digitalsound_black|M-hd2-hd3_black|M-traffic_black')">
                <xsl:variable name="inch" select="if (matches($inch, '8in')) 
                                                  then 'magnifier_8inch radio_img' 
                                                  else 'magnifier radio_img'" />
                <div class="{$inch}">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        <xsl:apply-templates select="node()" />
                    </xsl:copy>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <!--<div class="{if (root()/descendant-or-self::*[matches(@class, 'magnifier_8inch')]) 
                             then 'magnifier_8inch' 
                             else 'magnifier'}">-->
                <xsl:variable name="imgName" select="tokenize(@src, '/')[last()]" />
                <xsl:variable name="selectInch">
                    <xsl:choose>
                        <xsl:when test="matches($inch, '8in') and 
                                        matches($imgName, '^D\-')">
                            <xsl:value-of select="'magnifier_8inch'" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'magnifier'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <div class="{$selectInch}">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img/@class" priority="15">
        <xsl:choose>
            <xsl:when test="matches(parent::*/@src, '(M-hdrt_programinfo_black|M-hdrt_digitalsound_black|M-hdrt_digitalsound_black|M-hd2-hd3_black|M-traffic_black|M-hdradio)')">
                <xsl:attribute name="class" select="concat(., '&#x20;', 'img_medium')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="class" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:getLast">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="if (count(tokenize($str, $char)) = 2) then tokenize($str, $char)[position() eq last()] else string-join(tokenize($str, $char)[position() ne 1], $char)" />
    </xsl:function>

</xsl:stylesheet>