<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs ast son functx"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>


    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Note">
        <xsl:if test="descendant::Content[1][matches(lower-case(.), '(before|after)')]">
            <xsl:element name="video-content">
                <xsl:for-each select="ParagraphStyleRange//Content">
                    <xsl:variable name="cur" select="."/>
                    
                    <xsl:choose>
                        <xsl:when test="matches(., 'before')">
                            <xsl:attribute name="position">
                                <xsl:value-of select="'before'"/>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'after')">
                            <xsl:attribute name="position">
                                <xsl:value-of select="'after'"/>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'filename')">
                            <xsl:attribute name="data-import">
                                <xsl:choose>
                                    <xsl:when test="tokenize(., ' ')[2]">
                                        <xsl:value-of select="tokenize(., ' ')[2]"/>
                                    </xsl:when>
                                    
                                    <xsl:when test="not(tokenize(., ' ')[2]) and 
                                                    following-sibling::*[1][not(matches(., '^@'))]">
                                        <xsl:value-of select="following-sibling::*[1]" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'size')">
                            <xsl:attribute name="video-size">
                                <xsl:value-of select="tokenize(., ' ')[2]"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
