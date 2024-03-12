<?xml version="1.0"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:attribute-set name="cmdname">
		<!-- <xsl:attribute name="font-family">
			<xsl:value-of select="$base-font-family" />
		</xsl:attribute> -->

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

		<xsl:attribute name="color">inherit</xsl:attribute>

        <xsl:attribute name="keep-together.within-line">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, '^preserve$')">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'auto'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="axf:kerning-mode">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'pair'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="axf:punctuation-trim">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'adjacent'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:choose>
                        <xsl:when test="matches(parent::*/@outputclass, 'Heading1') and
                                        @outputclass = 'nobold'">
                            <xsl:value-of select="'800'" />
                        </xsl:when>

                        <xsl:when test="matches(parent::*/@outputclass, 'Chapter') and
                                        @outputclass = 'nobold'">
                            <xsl:value-of select="'inherit'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'800'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		 <xsl:attribute name="wrap-option">
			<xsl:choose>
				<xsl:when test="@outputclass = 'nowrap'">
					<xsl:value-of select="'no-wrap'" />
				</xsl:when>
				<xsl:otherwise>wrap</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>