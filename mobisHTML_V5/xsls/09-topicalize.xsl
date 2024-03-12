<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <topic>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </topic>
    </xsl:template>

    <xsl:template match="chapter">
        <topic>
            <xsl:apply-templates select="@*, node()" />
        </topic>
    </xsl:template>

    <xsl:template match="section">
        <xsl:choose>
            <xsl:when test="parent::chapter[matches(@idml, 'Troubleshooting')]">
                <xsl:sequence select="ast:group(*, 1)" />
            </xsl:when>
            
            <xsl:otherwise>
                <topic>
                    <xsl:attribute name="id" select="if (@id) then @id else concat('d', generate-id())" />
                    <title class="{@class}">
                        <xsl:if test="@caption">
                            <xsl:attribute name="caption">
                                <xsl:value-of select="@caption"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@title" />
                    </title>
                    <xsl:sequence select="ast:group(*, 1)" />
                </topic>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="h1 | h2 | h3 | h4">
        <title class="{@class}">
            <xsl:if test="@video-before">
                <xsl:attribute name="video-before" select="@video-before" />
            </xsl:if>
            <xsl:if test="@video-after">
                <xsl:attribute name="video-after" select="@video-after" />
            </xsl:if>
            <xsl:apply-templates select="@* | node()" />
        </title>
    </xsl:template>

    <xsl:template match="p[contains(@class,'UL')]">
        <xsl:variable name="flw_ul4" select="following-sibling::*[1][matches(@class, '^UL4$')]/node()" />

        <xsl:choose>
            <xsl:when test="matches(@class,'^UL4$') and 
                            preceding-sibling::node()[1][contains(@class,'UL')]">
            </xsl:when>
            
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="parent::*[not(matches(@class, '^UL2$'))]">
                                <xsl:apply-templates select="." />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                    <xsl:if test="$flw_ul4 and 
                                                  position()=last()">
                                        <ul class="UL4">
                                            <xsl:copy-of select="$flw_ul4" />
                                        </ul>
                                    </xsl:if>
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul[contains(@class,'UL')]">
        <ul>
            <xsl:apply-templates select="@*, node()" />
        </ul>
    </xsl:template>

    <xsl:template match="li[parent::*[matches(@class,'^(Step-UL1_1|Step-UL1_2|UL1_1|UL1_1_BlankNone|UL1_2|UL1_3|UL1-Caution-Warning|UL1-Safety)$')]]">
        <xsl:copy>
            <span class="bullet">
                <xsl:text>•&#160;&#160;</xsl:text>
            </span>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="ast:group" as="element()*">
        <xsl:param name="elements" as="element()*" />
        <xsl:param name="level" as="xs:integer" />
        
        <xsl:for-each-group select="$elements" group-starting-with="*[local-name() eq concat('h', $level)]">
            <xsl:choose>
                <xsl:when test="$level &gt; 4">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                
                <xsl:when test="self::*[local-name() eq concat('h', $level)]">
                    <topic>
                        <xsl:attribute name="id" select="if (@id) then @id else concat('d', generate-id())" />
                        <xsl:apply-templates select="current-group()[1]" />
                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </topic>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:function>

</xsl:stylesheet>