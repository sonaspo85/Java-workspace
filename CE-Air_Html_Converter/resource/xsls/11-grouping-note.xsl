<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="open">&lt;div class=&quot;notesection&quot;&gt;</xsl:variable>
    <xsl:variable name="close">&lt;/div&gt;</xsl:variable>

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:for-each-group select="*" group-starting-with="para[matches(@class, '(note_heading|warning_heading)')]">
                <xsl:choose>
                    <xsl:when test="current-group()[1][matches(@class, '(note_heading|warning_heading)')]">
                        <xsl:value-of select="$open" disable-output-escaping="yes" />
                        <xsl:apply-templates select="current-group()[1]"/>

                        <xsl:call-template name="grouping">
                            <xsl:with-param name="group" select="current-group()[position() &gt; 1]" />
                        </xsl:call-template>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="grouping">
        <xsl:param name="group" />

        <xsl:choose>
            <xsl:when test="$group[1][matches(@class, '(description|indentgroup|unorderlist_\d)')]">
                <xsl:apply-templates select="$group[1]" />
                
                <xsl:call-template name="grouping">
                    <xsl:with-param name="group" select="$group[position() &gt; 1]" />
                </xsl:call-template>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:value-of select="$close" disable-output-escaping="yes" />
                <xsl:apply-templates select="$group" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
