<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:preserve-space elements="p Content"/>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::Story">
                <xsl:choose>
                    <xsl:when test="ends-with(@class, 'Chapter-Num')" />
                    
                    <xsl:when test="Table">
                        <xsl:apply-templates select="node()" />
                    </xsl:when>
                    
                    <xsl:when test="matches(@class, 'Chapter_Index_TOC') and 
                                    following-sibling::*[1][matches(@class, 'Chapter-SupportTxt')]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="caption">
                                <xsl:value-of select="following-sibling::*[1]" />
                            </xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:when>
                    
                    <xsl:when test="matches(@class, 'Chapter-SupportTxt')" />
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="ancestor::*[matches(@class, 'Table_Video')]">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template match="imgTxtGroup">
        <xsl:copy>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::node()[1][name() = 'imgTxtGroup']) and 
                                    not(following-sibling::node()[1][name() = 'imgTxtGroup'])">
                        <xsl:value-of select="'Img-Center'" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="@class" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:apply-templates select="@* except @class" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>-->
    
</xsl:stylesheet>