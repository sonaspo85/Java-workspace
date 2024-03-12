<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

	<xsl:attribute-set name="xref" use-attribute-sets="common.link">
        <xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="wrap-option">
            <xsl:choose>
                <xsl:when test="@scope = 'external'">
                    <xsl:value-of select="'no-wrap'" />
                </xsl:when>

                <xsl:otherwise>wrap</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
