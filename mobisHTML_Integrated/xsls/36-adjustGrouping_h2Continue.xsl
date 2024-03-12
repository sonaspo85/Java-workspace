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

    
    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="abc" /> 
        </xsl:variable>
        
        <xsl:apply-templates select="$str0/*" />
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topic[@file]" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:choose>
                <xsl:when test="not(matches(@idml, '(\d+_Video|\d+_Content)', 'i'))">
                    <xsl:variable name="var01">
                        <xsl:for-each-group select="*" group-adjacent="boolean(self::div[*[1][matches(@class, 'heading2-continue')]])">
                            <xsl:choose>
                                <xsl:when test="current-grouping-key()">
                                    <div class="h2ContinueGrouping">
                                        <xsl:apply-templates select="current-group()/node()" mode="abc" />
                                    </div>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" mode="abc" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:variable>
                    
                    <xsl:for-each select="$var01/*">
                        <xsl:choose>
                            <xsl:when test="following-sibling::node()[1][matches(@class, 'h2ContinueGrouping')]">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" mode="abc" />
                                    <xsl:copy-of select="following-sibling::*[1][matches(@class, 'h2ContinueGrouping')]/node()" />
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:when test="self::*[matches(@class, 'h2ContinueGrouping')]" />
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" mode="abc" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" mode="abc" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>