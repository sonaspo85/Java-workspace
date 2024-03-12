<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p" />
    
    
    <xsl:template name="Readme_chapterV5">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="starts-with(@class, 'Chapter')">
                <h1>
                    <xsl:attribute name="class" select="'Heading1'" />
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h1>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading1') or 
                            ends-with(@class, 'H1')">
                <h2 class="Heading2">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h2>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading2')">
                <h3 class="Heading3">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h3>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading3')">
                <h4 class="Heading4">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h4>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading4')">
                <h5 class="Heading5">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h5>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template name="Readme_chapterV6">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="starts-with(@class, 'Chapter')" />
            
            <xsl:when test="matches(@class, 'Description-Continue-H1')">
                <h2 class="Heading2-Continue">
                    <xsl:apply-templates select="@* except @class" />
                        <xsl:apply-templates select="node()" />
                </h2>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading1') or 
                            ends-with(@class, 'H1')">
                <h1 class="Heading1">
                    <xsl:apply-templates select="@* except @class" />
                    <span class="StyleH1">
                        <xsl:apply-templates select="node()" />
                    </span>
                </h1>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading2')">
                <h2 class="Heading2">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h2>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading3')">
                <h3 class="Heading3">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h3>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading4')">
                <h4 class="Heading4">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h4>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
    <xsl:template name="Readme_chapterV6">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="starts-with(@class, 'Chapter')">
                <h1>
                    <xsl:attribute name="class" select="'Heading1'" />
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h1>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Description-Continue-H1') or 
                ends-with(@class, 'H1') or 
                contains(@class, 'Heading1')">
                <h2 class="Heading2-Continue">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h2>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading2')">
                <h3 class="Heading3">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h3>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading3')">
                <h4 class="Heading4">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h4>
            </xsl:when>
            
            <xsl:when test="contains(@class, 'Heading4')">
                <h5 class="Heading5">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </h5>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>