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
    
    <xsl:template match="ul">
        <xsl:choose>
            <xsl:when test="matches(@class, '^Step-UL1_2$')">
                <xsl:choose>
                    <xsl:when test="p[matches(@class, 'Step-Description_2')][not(following-sibling::*)]">
                        <xsl:variable name="flw" select="p[matches(@class, 'Step-Description_2')][not(following-sibling::*)]" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        <xsl:copy-of select="$flw" />
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
    
    <xsl:template match="p">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="matches(@class, 'Step-Description_2') and 
                            not(following-sibling::*) and 
                            parent::*[matches(@class, '^Step-UL1_2$')]" />
                
            <xsl:when test="contains(@class, 'Color') and 
                            following-sibling::*[1][not(matches(@class, '(Color|OL|-Note$|Warning$|Caution$)'))]">
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        
                        <xsl:if test="position()=last()">
                            <xsl:call-template name="nesting">
                                <xsl:with-param name="cur" select="$cur/following-sibling::*[1]" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="nesting">
        <xsl:param name="cur" />
        
        <xsl:for-each select="$cur">
            <xsl:if test="name()!='topic' and 
                          not(matches(@class, '(Color|OL|-Note$)')) and 
                          following-sibling::*">
                <xsl:sequence select="." />
                
                <xsl:if test="following-sibling::*[1][not(contains(@class, '(Color|OL|-Note$|Warning$|Caution$)'))]">
                    <xsl:call-template name="nesting">
                        <xsl:with-param name="cur" select="following-sibling::*[1]" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[name()!='topic'][not(matches(@class,'(Color|OL|-Note$)'))]
                          [preceding-sibling::*[1][contains(@class, 'Color')]]
                          [following-sibling::*[1][not(matches(@class, '(Color|OL|-Note$|Warning$|Caution$)'))]]">
    </xsl:template>
    
</xsl:stylesheet>