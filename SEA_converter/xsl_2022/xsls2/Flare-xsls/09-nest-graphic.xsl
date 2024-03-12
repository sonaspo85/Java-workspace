<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ol[following-sibling::*[1][name()='p'][@class='Graphic']]">
        <xsl:variable name="current" select="." />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="li">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                    <xsl:if test="not(following-sibling::li)">
                        <xsl:copy-of select="$current/following-sibling::*[1][name()='p'][@class='Graphic']/img" />
                    </xsl:if>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[@class='Graphic'][preceding-sibling::*[1][name()='ol']]">
    </xsl:template>

</xsl:stylesheet>