<?xml version='1.0'?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

    <xsl:template match="*[contains(@class,' hi-d/b ')]">
        <fo:inline xsl:use-attribute-sets="b">
            <!-- <xsl:if test="matches($localeStrAfter, 'SA') and
                          not(matches(@outputclass, 'preserve'))">
                <xsl:attribute name="axf:number-transform" select="'SA'" />
            </xsl:if> -->

            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' hi-d/i ')]">
        <fo:inline xsl:use-attribute-sets="i">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

</xsl:stylesheet>