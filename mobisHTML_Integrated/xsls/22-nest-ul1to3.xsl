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


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p[parent::topic]">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="contains(@class, 'OL') and 
                            following-sibling::*[1][matches(@class, '(Step-)?UL1_(2|3)(-Note)?')]">
                <xsl:variable name="flw" select="following-sibling::*[1][matches(@class, '(Step-)?UL1_(2|3)(-Note)?')]" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        
                        <xsl:if test="position()=last()">
                            <xsl:copy-of select="$flw" />
                            
                            <xsl:if test="$flw[@class!='UL1_3']/following-sibling::node()[1][matches(@class, '(Step-)?UL1_(2|3)(-Note)?')]">
                                <xsl:copy-of select="$flw[@class!='UL1_3']/following-sibling::node()[1]" />
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="preceding-sibling::*[1][matches(@class, 'UL1_1')] and 
                            matches(@class, '(Description_3_2|Description_3-BlankNone)')">
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:choose>
            <xsl:when test="matches(@class, '(Step-)?UL1_(2|3)(-Note)?')">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][@class!='UL1_3'][not(matches(@class,'Empty|Img|magnifier'))]
                                    /preceding-sibling::*[1][contains(@class, 'OL')]">
                        
                    </xsl:when>
                    
                    <xsl:when test="preceding-sibling::*[1][contains(@class, 'OL')]" />
                        
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="matches(@class, 'UL1_1$')">
                <xsl:choose>
                    <xsl:when test="following-sibling::*[1][matches(@class, '(Description_3_2|Description_3-BlankNone)')]">
                        <xsl:variable name="flw" select="following-sibling::*[1]" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="*">
                                <xsl:choose>
                                    <xsl:when test="position() = last()">
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />

                                            <xsl:copy-of select="$flw" />
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
    
</xsl:stylesheet>