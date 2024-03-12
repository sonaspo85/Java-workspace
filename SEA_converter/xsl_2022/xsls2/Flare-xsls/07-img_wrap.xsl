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

    <xsl:template match="img[matches(@class, 'LearnMore')]">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
            <xsl:for-each select="following-sibling::node()">
                <xsl:choose>
                    <xsl:when test="self::div[@class = 'LearnMore']">
                        <xsl:apply-templates select="node()" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[preceding-sibling::img[matches(@class, 'LearnMore')]]">
    </xsl:template>

</xsl:stylesheet>