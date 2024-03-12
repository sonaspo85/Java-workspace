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
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, '(SA|IR|IL|PK)')">
                                <xsl:value-of select="regex-group(1)" />

                                <fo:inline font-family="SamsungOne-400" font-size="14pt" font-stretch="107%">
                                    <xsl:attribute name="baseline-shift">
                                        <xsl:choose>
                                            <xsl:when test="matches($localeStrAfter, 'IL')">
                                                <xsl:value-of select="'-0.3mm'" />
                                            </xsl:when>

                                            <xsl:otherwise>0.3mm</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>

                                    <xsl:value-of select="replace(regex-group(2), '~~', '&#x2190;')" />
                                </fo:inline>

                                <xsl:value-of select="regex-group(3)" />
                            </xsl:when>

                            <xsl:when test="matches($localeStrAfter, '(TH)')">
                                <xsl:value-of select="regex-group(1)" />

                                <fo:inline font-family="SamsungOne-400" font-size="14pt" font-stretch="115%" baseline-shift="0.1mm">
                                    <xsl:value-of select="replace(regex-group(2), '~~', '&#x2192;')" />
                                </fo:inline>

                                <xsl:value-of select="regex-group(3)" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="regex-group(1)" />

                                <fo:inline font-size="14pt" font-stretch="107%">
                                    <xsl:attribute name="font-family">
                                        <xsl:choose>
                                            <xsl:when test="matches($locale, 'zh-CN')">
                                                <xsl:value-of select="'Arial'" />
                                            </xsl:when>

                                            <xsl:otherwise>
                                                <xsl:value-of select="'SamsungOne-400'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>

                                    <xsl:attribute name="baseline-shift">
                                        <xsl:choose>
                                            <xsl:when test="matches($localeStrAfter, 'IN')">
                                                <xsl:value-of select="'0.1mm'" />
                                            </xsl:when>

                                            <xsl:otherwise>-0.1mm</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="replace(regex-group(2), '~~', '&#x2192;')" />
                                </fo:inline>

                                <xsl:value-of select="regex-group(3)" />
                            </xsl:otherwise>
                        </xsl:choose>
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