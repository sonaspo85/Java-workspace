<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-starting-with="h1">
                <xsl:variable name="pos" select="if (preceding-sibling::img[matches(@src, 'logo\.png')]) then 1 else 0"/>
                <xsl:if test="position() &gt; 1">
                    <chapter>
                        <xsl:if test="position() = 2">
                            <xsl:attribute name="TOC_chapter" select="'TOC_chapter'" />
                        </xsl:if>
                        <xsl:apply-templates select="current-group()" />
                    </chapter>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="table[descendant-or-self::h3]">
        <xsl:apply-templates select="descendant-or-self::h3" />
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[matches(@class, 'note|caution|warning|tip')]">
        <table class="note">
            <col/>
            <col/>
            <tbody>
                <tr>
                    <td><img src="{concat('images/', @class, '.png')}" /></td>
                    <td><xsl:apply-templates /></td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="a">
        <xsl:copy>
            <xsl:attribute name="id" select="substring-after(@href, '#')" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '[&#xa0;]+', ' ')" />
    </xsl:template>

</xsl:stylesheet>