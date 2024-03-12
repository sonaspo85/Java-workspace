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
    <xsl:preserve-space elements="title p li" />
    
    <xsl:template match="@class" priority="5">
        <xsl:attribute name="class" select="lower-case(.)" />
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="img/@class">
        <xsl:attribute name="class" select="replace(., '\s+magnifier(_8inch)?', '')" />
    </xsl:template>
    
    <xsl:template match="span">
        <xsl:choose>
            <xsl:when test="matches(@class, 'C_URL')">
                <span class="C_URL">
                    <xsl:apply-templates select="@* | node()" />
                </span>
            </xsl:when>
            
            <xsl:when test="self::*[matches(@class, 'C_LtoR')] and 
                            following-sibling::node()[1][name()='span'][not(matches(@class, '(C_NoBreak|C_MMI|C_Symbol|C_Button|C_Important|C_Buttonbracket|C_CrossReference)'))]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                <xsl:text>&#x20;</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="@class='Caution'">
                <div class="line_mit">
                    <img src="contents\images\M-caution.png" class="caution icon" />
                    <xsl:copy> 
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </div>
            </xsl:when>
            
            <xsl:when test="@class='Warning'">
                <div class="line_mit">
                    <img src="contents\images\M-warning.png" class="warning icon" />
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::node()) and 
                                            matches(@class, 'magnifier')" />
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
                
                <xsl:if test="node()[position() = last()][matches(@class, 'magnifier')]">
                    <xsl:copy-of select="node()[last()][matches(@class, 'magnifier')]" />
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>