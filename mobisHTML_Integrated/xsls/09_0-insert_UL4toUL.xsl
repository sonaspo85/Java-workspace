<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
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

</xsl:stylesheet>