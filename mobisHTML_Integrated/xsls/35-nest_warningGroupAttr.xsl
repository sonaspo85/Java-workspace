<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ul">
        <xsl:choose>
            <xsl:when test="matches(@class, '^ul1_1$') and 
                            following-sibling::node()[1][matches(@class, 'warning-group')]
                            /following-sibling::node()[1][matches(@class, '^ul1_1$')]">
                <xsl:variable name="flw" select="following-sibling::node()[1][matches(@class, 'warning-group')]" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                            
                            <xsl:if test="position()=last()">
                                <xsl:copy-of select="$flw" />
                            </xsl:if>
                        </xsl:copy>
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
    
    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="matches(@class, 'warning-group')">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::node()[1][matches(@class, 'ul1_1')][not(matches(@class, '-note$'))] and 
                                    following-sibling::node()[1][matches(@class, 'ul1_1')][not(matches(@class, '-note$'))]">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="*[@videoGroup]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[@videoGroup])">
                        <xsl:choose>
                            <xsl:when test="current-group()[1][@videoGroup]">
                                <div class="video_manual">
                                    <xsl:apply-templates select="current-group()" />
                                </div>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="td">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:choose>
                <xsl:when test="position() = 1 and 
                                @rowspan">
                    <xsl:variable name="cur" select="." />
                    
                    <xsl:choose>
                        <xsl:when test="not(node())">
                            <xsl:choose>
                                <xsl:when test="preceding::td[@rowspan][position() = 1][. = $cur]">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'nonetop'"/>
                                    </xsl:attribute>
                                    
                                    <xsl:value-of select="''"/>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:apply-templates select="node()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:when test="ancestor::table[matches(@class, 'table_text$')] and 
                                        preceding::td[@rowspan][position() = 1][. = $cur]">
                            <xsl:attribute name="class">
                                <xsl:value-of select="'nonetop'"/>
                            </xsl:attribute>
                            
                            <xsl:value-of select="''"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@videoGroup" />
    
</xsl:stylesheet>