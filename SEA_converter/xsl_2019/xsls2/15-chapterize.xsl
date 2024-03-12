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
                <chapter>
                    <xsl:apply-templates select="current-group()" />
                </chapter>
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

</xsl:stylesheet>