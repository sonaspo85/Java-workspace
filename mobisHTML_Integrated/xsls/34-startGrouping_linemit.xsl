<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />


    <xsl:variable name="open">&lt;div class="warning-group"&gt;</xsl:variable>
    <xsl:variable name="close">&lt;/div&gt;</xsl:variable>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div[matches(@class, 'heading2')]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-starting-with="*[matches(@class, 'line_mit')]">
                <xsl:choose>
                    <xsl:when test="current-group()[matches(@class, 'line_mit')][1]">
                        <xsl:value-of select="$open" disable-output-escaping="yes" />
                        <xsl:apply-templates select="current-group()[1]" />

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
            <xsl:when
                test="$group[1][matches(@class, 'description-caution-warning')] or
                      $group[1][matches(@class, 'ul1_2-note')][preceding-sibling::node()[1][matches(@class, 'description-caution-warning')]]">
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