<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:suitesol="http://suite-sol.com/namespaces/mapcounts"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    exclude-result-prefixes="xsl opentopic-func xs axf suitesol"
    version="2.0">

    <xsl:template match="comment() | processing-instruction() | text()">
        <xsl:choose>
            <xsl:when test="self::text() and contains(., '~~')">
                <xsl:analyze-string select="." regex="(\s*)(~~)(\s*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)" />
                        <fo:inline font-family="SamsungOneKorean 400" font-stretch="120%" baseline-shift="0pt" line-height-shift-adjustment="disregard-shifts">
                            <xsl:value-of select="replace(regex-group(2), '~~', '&#x2192;')" />
                        </fo:inline>
                        <xsl:value-of select="regex-group(3)" />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="replace(., '[&#x20;&#x0A;]+&#x09;+', '')"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>

            <xsl:when test="self::processing-instruction('cmt')">
            </xsl:when>

            <!-- <xsl:when test="self::processing-instruction('cmt')">
                <xsl:variable name="contents" select="replace(replace(substring-after(., 'contents='), '&amp;quot;', '&quot;'), '&#x9;', '')"/>
                <fo:float float="right">
                    <fo:block margin-left="-8mm">
                        <xsl:attribute name="axf:annotation-type" select="'Text'" />
                        <xsl:attribute name="axf:annotation-color" select="'orange'" />
                        <xsl:attribute name="axf:annotation-author" select="@author" />
                        <xsl:attribute name="axf:annotation-contents">
                            <xsl:value-of select="$contents" />
                        </xsl:attribute>
                    </fo:block>
                </fo:float>
            </xsl:when> -->
            <xsl:otherwise>
                  <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>