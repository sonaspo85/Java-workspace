<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">


    <xsl:attribute-set name="__toc__header" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-weight">inherit</xsl:attribute>
        <xsl:attribute name="padding-top">1.3mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">15mm</xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="'TOC-header'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__header_container">
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="width">170mm</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="margin-bottom">16mm</xsl:attribute>
        <xsl:attribute name="span">all</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <xsl:attribute name="text-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">-10mm</xsl:when>
                <xsl:when test="$level = 2">0mm</xsl:when>
                <xsl:when test="$level = 3">0mm</xsl:when>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:choose>
                        <xsl:when test="ancestor-or-self::*[contains(@class, ' topic/topic ')][not(preceding-sibling::*[contains(@class, ' topic/topic ')])]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>13.2mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$level = 2">0.8mm</xsl:when>
                <xsl:when test="$level = 3">0.8mm</xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>



        <xsl:attribute name="padding-before">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>


            <xsl:choose>
                <xsl:when test="$level = 1 and not(preceding-sibling::*[contains(@class, 'topic/topic ')])">
                    <xsl:value-of select="'0.3mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="numberSet" select="if (count(ancestor-or-self::*[contains(@class, ' topic/topic ')][last()]
                                                    /following-sibling::*[contains(@class, ' topic/topic ')]) = 1) then
                                                    4 else
                                                    3" as="xs:integer" />

            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

                <xsl:choose>
                    <xsl:when test="$level = 1">2mm</xsl:when>
                    <xsl:when test="$numberSet = 4 and $level = 2 and
                                    descendant::*[contains(@class, ' topic/topic ')][not(*[matches(@outputclass, '^Heading[23]\-APPLINK(\s+)?(nonePV)?$')])]">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::*[contains(@class, ' topic/topic ')])">
                                <xsl:value-of select="'0mm'" />
                            </xsl:when>

                            <xsl:otherwise>-0.80mm</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:when test="$numberSet = 4 and $level = 3 and not(following-sibling::*[contains(@class, ' topic/topic ')])">
                        <xsl:value-of select="'0.8mm'" />
                    </xsl:when>

                    <xsl:otherwise>0mm</xsl:otherwise>
                </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">inherit</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">10mm</xsl:attribute>

        <xsl:attribute name="break-before">
            <xsl:variable name="ancesTopic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')]" />
            <xsl:choose>
                <xsl:when test="count($ancesTopic) = 1 and
                                matches(@outputclass, 'tocbreak')">
                    <xsl:value-of select="'column'" />
                </xsl:when>

                <xsl:when test="count($ancesTopic) = 1 and
                                matches(@outputclass, 'pagebreak')">
                    <xsl:value-of select="'page'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__page-number">
        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'10mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="'TOC-depth'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__leader">
        <xsl:attribute name="leader-pattern">space</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__link">
        <xsl:attribute name="line-height" select="'inherit'" />
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__title">
        <xsl:attribute name="wrap-option">
            <xsl:choose>
                <xsl:when test="descendant::*[matches(@outputclass, 'nobreak')]">
                    <xsl:value-of select="'no-wrap'" />
                </xsl:when>

                <xsl:otherwise>wrap</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__between__bullet">
        <xsl:attribute name="provisional-distance-between-starts">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'1mm'"/>
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'10mm'"/>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="provisional-label-separation">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'0.5mm'"/>
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'9.5mm'"/>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="break-before">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'columnbreak')">
                    <xsl:value-of select="'column'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'tocbreak')">
                    <xsl:value-of select="'column'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>