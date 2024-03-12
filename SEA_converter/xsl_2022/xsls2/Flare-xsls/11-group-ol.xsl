<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body | div">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-adjacent="boolean(self::ol)">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ol>
                            <xsl:apply-templates select="current-group()/*"/>
                        </ol>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[@class='Graphic']">
        <img class="block" src="{img/@src}" />
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '\s+', '&#x20;')" />
    </xsl:template>

</xsl:stylesheet>
