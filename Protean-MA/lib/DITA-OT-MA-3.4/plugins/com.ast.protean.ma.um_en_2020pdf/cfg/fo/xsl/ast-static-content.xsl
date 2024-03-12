<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                exclude-result-prefixes="xs opentopic-index opentopic opentopic-func ot-placeholder"
                version="2.0">

    <!-- <xsl:variable name="OSname" select="$pi.code/*[name()='template']" /> -->

    <xsl:template name="insertBodyStaticContents">
        <xsl:call-template name="insertBodyFootnoteSeparator"/>
        <xsl:call-template name="insertBodyOddFooter"/>
        <xsl:if test="$mirror-page-margins">
          <xsl:call-template name="insertBodyEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertBodyOddHeader"/>
        <xsl:if test="$mirror-page-margins">
          <xsl:call-template name="insertBodyEvenHeader"/>
        </xsl:if>
        <xsl:call-template name="insertBodyFirstHeader"/>
        <xsl:call-template name="insertBodyFirstFooter"/>
        <xsl:call-template name="insertBodyLastHeader"/>
        <xsl:call-template name="insertBodyLastFooter"/>
    </xsl:template>

    <xsl:template name="insertTocFirstHeader">
    </xsl:template>

    <xsl:template name="insertBodyFirstHeader">
        <fo:static-content flow-name="first-body-header">
            <!-- <fo:block-container width="12mm" absolute-position="absolute">
                <fo:block border-right="0.5pt solid cmyk(0%,0%,0%,80%)" padding-bottom="12mm">
                </fo:block>
            </fo:block-container>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block> -->
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocStaticContents">
        <xsl:call-template name="insertTocOddFooter"/>
        <xsl:call-template name="insertTocEvenFooter"/>
        <xsl:call-template name="insertTocFirstHeader"/>
        <xsl:call-template name="insertTocOddHeader"/>
        <xsl:call-template name="insertTocEvenHeader"/>
    </xsl:template>

    <xsl:variable name="regionBefore.borderRight">
        <xsl:choose>
            <xsl:when test="$writing-mode = 'rl'">
                <fo:block-container>
                    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
                        <xsl:value-of select="'12mm'" />
                    </xsl:attribute>
                    <xsl:attribute name="absolute-position" select="'absolute'" />

                    <fo:block border-right="0.5pt solid cmyk(0%,0%,0%,100%)" padding-bottom="12mm" />
                </fo:block-container>
            </xsl:when>

            <xsl:otherwise>
                <fo:block-container>
                    <!-- <xsl:attribute name="margin-left" select="'12mm'" /> -->
                    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
                        <xsl:value-of select="'12mm'" />
                    </xsl:attribute>
                    <xsl:attribute name="absolute-position" select="'absolute'" />

                    <fo:block border-left="0.5pt solid cmyk(0%,0%,0%,100%)" padding-bottom="12mm" />
                </fo:block-container>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template name="insertBodyOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <xsl:copy-of select="$regionBefore.borderRight" />
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:copy-of select="$regionBefore.borderRight" />
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastHeader">
        <fo:static-content flow-name="last-body-header">
            <xsl:copy-of select="$regionBefore.borderRight" />
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <fo:static-content flow-name="even-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <xsl:if test="matches($OSname, '-OS_upgrade')">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="$writing-mode = 'rl'">
                            <xsl:attribute name="margin-bottom" select="'87.3mm'" />
                            <!-- <xsl:attribute name="margin-left" select="'33.5mm'" /> -->
                            <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
                                <xsl:value-of select="'33.5mm'" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:attribute name="margin-bottom" select="'87.5mm'" />
                            <!-- <xsl:attribute name="margin-left" select="'120mm'" /> -->
                            <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
                                <xsl:value-of select="'120mm'" />
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <fo:float>
                        <xsl:choose>
                            <xsl:when test="$writing-mode = 'rl'">
                                <xsl:attribute name="float" select="'left'" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:attribute name="float" select="'left'" />
                            </xsl:otherwise>
                        </xsl:choose>
                        <fo:block>
                            <xsl:variable name="currentTopic" select="descendant-or-self::*[contains(@class, ' topic/topic ')]/@oid[. = $totalTopic]" />

                            <xsl:variable name="noteImagePath">
                                <xsl:variable name="noteType" as="xs:string">
                                    <xsl:choose>
                                        <xsl:when test="matches($currentTopic, '^(basics|getting_started)$')">
                                            <xsl:value-of select="'basics Chapter'" />
                                        </xsl:when>

                                        <xsl:when test="matches($currentTopic, 'apps_and_features')">
                                            <xsl:value-of select="'apps_and_features Chapter'" />
                                        </xsl:when>

                                        <xsl:when test="matches($currentTopic, 'settings')">
                                            <xsl:value-of select="'settings Chapter'" />
                                        </xsl:when>

                                        <xsl:when test="matches($currentTopic, 'usage_notices')">
                                            <xsl:value-of select="'usage_notices Chapter'" />
                                        </xsl:when>

                                        <xsl:when test="matches($currentTopic, 'appendix')">
                                            <xsl:value-of select="'appendix Chapter'" />
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat($noteType, ' Image Path')" />
                                </xsl:call-template>
                            </xsl:variable>

                            <fo:external-graphic src="url('{concat($artworkPrefix, $noteImagePath)}')"/>
                        </fo:block>
                    </fo:float>
                </fo:block>
            </xsl:if>

            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastFooter">
        <fo:static-content flow-name="last-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddFooter">
        <fo:static-content flow-name="odd-toc-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenFooter">
        <fo:static-content flow-name="even-toc-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header">
            <xsl:copy-of select="$regionBefore.borderRight" />
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header">
            <xsl:copy-of select="$regionBefore.borderRight" />
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBackCoverOddHeader">
    </xsl:template> 

    <xsl:template name="insertBackCoverEvenHeader">
    </xsl:template>

    <xsl:template name="insertBackCoverOddFooter">
    </xsl:template>

    <xsl:template name="insertBackCoverEvenFooter">
    </xsl:template>


</xsl:stylesheet>