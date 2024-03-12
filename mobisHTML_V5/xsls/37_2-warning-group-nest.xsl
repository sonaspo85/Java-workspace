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

    <xsl:variable name="data-language" select="/topic/@data-language" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ul[matches(@class, '^ul1_1$')]">
        <xsl:variable name="flw_node" select="following-sibling::node()[1][matches(@class, 'warning-group')][following-sibling::node()[1][matches(@class, '^ul1_1$')]]" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                
                    <xsl:if test="position()=last()">
                        <xsl:copy-of select="$flw_node" />
                    </xsl:if>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[matches(@class, 'warning-group')]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::node()[1][matches(@class, 'ul1_1')] and 
                            following-sibling::node()[1][matches(@class, 'ul1_1')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="div">
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
    </xsl:template>
    
    <xsl:template match="td">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="position() = 1 and 
                                @rowspan">
                    <xsl:variable name="cur" select="." />
                    
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
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topic[@file]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:choose>
                <xsl:when test="not(ancestor::topic[position() != last()][matches(@idml, '015_Content')])">
                    <xsl:variable name="var01">
                        <xsl:for-each-group select="*" group-adjacent="boolean(self::*[*[1][matches(@class, 'heading2-continue')]])">
                            <xsl:choose>
                                <xsl:when test="current-grouping-key()">
                                    <h2ContinueGrouping>
                                        <xsl:apply-templates select="current-group()/node()" />
                                    </h2ContinueGrouping>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:variable>
                    
                    <xsl:for-each select="$var01/*">
                        <xsl:choose>
                            <xsl:when test="following-sibling::node()[1][name()= 'h2ContinueGrouping']">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                    <xsl:copy-of select="following-sibling::*[1][name()= 'h2ContinueGrouping']/node()" />
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:when test="self::*[name()= 'h2ContinueGrouping']">
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="@videoGroup" />
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
</xsl:stylesheet>