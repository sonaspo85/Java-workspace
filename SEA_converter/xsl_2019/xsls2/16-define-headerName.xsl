<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p td" />

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <chapter>
            <xsl:for-each-group select="*" group-starting-with="h1">
                <xsl:apply-templates select="current-group()" mode="demote"/>
            </xsl:for-each-group>
        </chapter>
    </xsl:template>

    <xsl:template match="*[starts-with(name(), 'h')]" mode="demote">
        <xsl:choose>
            <xsl:when test="name()='h1'">
                <h2>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </h2>
            </xsl:when>
            <xsl:when test="name()='h2'">
                <h3>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </h3>
            </xsl:when>
            <xsl:when test="name()='h3'">
                <h4>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </h4>
            </xsl:when>
            <xsl:when test="name()='h4'">
                <h5>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </h5>
            </xsl:when>
            <xsl:when test="name()='h5'">
                <h6>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </h6>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* except @id" />
                    <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h3[not(preceding-sibling::h2)]">
        <h2>
            <xsl:apply-templates select="@* except @id" />
            <xsl:attribute name="id" select="if (@id) then @id else generate-id()" />
            <xsl:apply-templates select="node()" />
        </h2>
    </xsl:template>

</xsl:stylesheet>