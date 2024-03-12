<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <topic data-language="{concat($commonRef/dataLanguage/@value, '(', $commonRef/region/@value, ')')}">
            <xsl:attribute name="inch" select="@inch" />
            <xsl:apply-templates />
        </topic>
    </xsl:template>
    
    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="matches(@class, 'magnifier')">
                <xsl:variable name="flw_inch" select="substring-after(@class, 'magnifier')" />
                
                <div class="{concat('magnifier', $flw_inch)}">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </div>
            </xsl:when>
            
            <xsl:when test="not(matches(@class, 'magnifier'))">
                <xsl:choose>
                    <xsl:when test="ancestor::td or 
                                    @class='C_Image' or 
                                    @class='C_Button'">
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
                        <xsl:variable name="inch" select="if (matches($commonRef/inch/@value, '8in')) then  
                                                          'magnifier_8inch radio_img' else  
                                                          'magnifier radio_img'" />
                        <div class="{$inch}">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </div>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:variable name="imgName" select="tokenize(@src, '/')[last()]" />
                        
                        <xsl:variable name="selectInch">
                            <xsl:choose>
                                <xsl:when test="matches($commonRef/inch/@value, '8in') and 
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
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img/@class">
        <xsl:choose>
            <xsl:when test="matches(parent::*/@src, '(M-hdrt_programinfo_black|M-hdrt_digitalsound_black|M-hdrt_digitalsound_black|M-hd2-hd3_black|M-traffic_black|M-hdradio)')">
                <xsl:attribute name="class" select="concat(., '&#x20;', 'img_medium')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="class" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>