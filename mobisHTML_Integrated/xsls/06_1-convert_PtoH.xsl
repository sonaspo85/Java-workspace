<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="matches(@idml, '(Basic|Systemoverview)')">
                <chapter>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:if test="position()=3">
                            <xsl:apply-templates select="ancestor::chapter/preceding-sibling::chapter[matches(@idml, 'Readmefirst')]/node()" />
                        </xsl:if>
                        <xsl:apply-templates select="." />
                    </xsl:for-each>
                </chapter>
            </xsl:when>
            
            <xsl:when test="matches(@idml, 'Readmefirst')" />
            
            <xsl:otherwise>
                <chapter>
                    <xsl:apply-templates select="@*, node()" />
                </chapter>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:include href="branch/06_1-reference.xsl"/>
    <xsl:template match="p[parent::chapter]">
        <xsl:choose>
            <xsl:when test="parent::chapter[matches(@idml, 'Readmefirst')]">
                <xsl:variable name="cur" select="." />
                
                <xsl:choose>
                    <xsl:when test="$commonRef/version/@value = '6th'">
                        <xsl:call-template name="Readme_chapterV6">
                            <xsl:with-param name="cur" select="$cur" />
                        </xsl:call-template>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:call-template name="Readme_chapterV5">
                            <xsl:with-param name="cur" select="$cur" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with(@class, 'Chapter')">
                        <h0>
                            <xsl:apply-templates select="@* | node()" />
                        </h0>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading1') or 
                                    ends-with(@class, 'H1')">
                        <xsl:choose>
                            <xsl:when test="parent::chapter[not(following-sibling::chapter)]
                                            /*[matches(@class, 'Heading1-Continue')]">
                                <p1 class="{@class}">
                                    <xsl:apply-templates select="@* | node()" />
                                </p1>
                            </xsl:when>
                            
                            <xsl:when test="parent::chapter[not(preceding-sibling::chapter)] and 
                                            matches(@class, 'Heading1-Continue')">
                                <p1 class="{@class}">
                                    <xsl:apply-templates select="@* | node()" />
                                </p1>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <h1 class="{@class}">
                                    <xsl:apply-templates select="@id | node()" />
                                </h1>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading2')">
                        <h2 class="{@class}">
                            <xsl:apply-templates select="@* except @id" />
                            <xsl:apply-templates select="@id | node()" />
                        </h2>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading3')">
                        <h3 class="{@class}">
                            <xsl:apply-templates select="@id | node()" />
                        </h3>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading4')">
                        <h4 class="{@class}">
                            <xsl:apply-templates select="@id | node()" />
                        </h4>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>