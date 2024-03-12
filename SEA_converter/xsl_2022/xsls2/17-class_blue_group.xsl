<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p" />

    <xsl:key name="xrefs" match="h1 | h2 | h3 | h4 | h5 | h6 | p[matches(@class, 'heading3')]" use="@id" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[*[matches(@class, 'blue')]]">
        <xsl:copy>
            <xsl:attribute name="class" select="'xref'" />
            <xsl:apply-templates select="@* except @class" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-adjacent="boolean(self::a[@class='blue'])">
                <xsl:choose>
                    <xsl:when test="current-group()[1][@class='blue']">
                        <p class="xref">
                            <xsl:for-each select="current-group()">
                                <xsl:apply-templates select="." />
                                <xsl:if test="following-sibling::*[1][@class='blue']">
                                    <xsl:text> | </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </p>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="a">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="key('xrefs', @id)">
                    <xsl:attribute name="class" select="'xref'" />
                    <xsl:apply-templates select="node()" />
                </xsl:when>

                <xsl:when test="starts-with(@href, '#')">
                    <xsl:attribute name="class" select="'xref'" />
                    <xsl:apply-templates select="node()" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="h3[preceding-sibling::node()[1][matches(@class, '(links|snippet)')]]">
        <p class="heading3">
            <xsl:apply-templates select="@*, node()" />
        </p>
    </xsl:template>
    
</xsl:stylesheet>