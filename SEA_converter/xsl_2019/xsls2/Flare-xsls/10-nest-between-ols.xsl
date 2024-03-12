<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ol[following-sibling::*[1][name()='div'][not(matches(@class, 'KeepTogether'))] and following-sibling::*[2][name()='ol'][@start &gt; 1]] | ol[following-sibling::*[1][name()='ul'][li[@class='Step-1']]]">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="li">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                    <xsl:if test="not(following-sibling::li)">
                        <xsl:copy-of select="if ( $current/following-sibling::*[1][name()='ol'] ) then '' else $current/following-sibling::*[1]" />
                    </xsl:if>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[following-sibling::*[1][name()='ol'][@start &gt; 1]]">
    </xsl:template>
    
    <xsl:template match="*[name()!='ol'][@class!='KeepTogether'][preceding-sibling::*[1][name()='ol']][following-sibling::*[1][name()='ol'][@start &gt; 1]]">
    </xsl:template>

    <xsl:template match="ul[following-sibling::*[1][name()='ol'][@start &gt; 1]] | ul[li[@class='Step-1']]">
    </xsl:template>

</xsl:stylesheet>