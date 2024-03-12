<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                exclude-result-prefixes="xs opentopic-index opentopic opentopic-func ot-placeholder"
                version="2.0">


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
        <fo:static-content flow-name="first-toc-header">
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstHeader">
        <fo:static-content flow-name="first-body-header">
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocStaticContents">
        <xsl:call-template name="insertTocOddFooter"/>
        <xsl:call-template name="insertTocEvenFooter"/>
        <xsl:call-template name="insertTocFirstHeader"/>
        <xsl:call-template name="insertTocOddHeader"/>
        <xsl:call-template name="insertTocEvenHeader"/>
    </xsl:template>

    <xsl:template name="insertBodyOddHeader">
        <fo:static-content flow-name="odd-body-header">
			<!-- <fo:block-container width="12mm" absolute-position="absolute">
				<fo:block border-right="1pt solid #949293" padding-bottom="12mm">
				</fo:block>
			</fo:block-container>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block> -->
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <!-- <fo:block xsl:use-attribute-sets="__body__even__header">
                <fo:block-container width="12mm" absolute-position="absolute">
				<fo:block border-right="1pt solid #949293" padding-bottom="12mm">
				</fo:block>
			</fo:block-container>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
            </fo:block> -->
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastHeader">
        <!-- <xsl:choose>
            <xsl:when test="descendant-or-self::*[matches(@outputclass, 'Heading1\-H3')]">
            </xsl:when>
        
            <xsl:otherwise>
                <fo:static-content flow-name="last-body-header">
                    <fo:block xsl:use-attribute-sets="__body__even__header">
                        <fo:block-container width="12mm" absolute-position="absolute">
                        <fo:block border-right="1pt solid #949293" padding-bottom="12mm">
                        </fo:block>
                    </fo:block-container>
                    <fo:block xsl:use-attribute-sets="__body__odd__header">
                        <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                            <fo:retrieve-marker retrieve-class-name="current-header"/>
                        </fo:inline>
                    </fo:block>
                    </fo:block>
                </fo:static-content>
            </xsl:otherwise>
        </xsl:choose> -->

    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer" background-color="blue">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <!-- <fo:static-content flow-name="even-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content> -->
    </xsl:template>

    <xsl:template name="insertBodyFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <fo:block-container xsl:use-attribute-sets="__frontmatter__logo__container" border="1px solid purple">
                <fo:float float="left" >
                    <fo:block border="1px solid red" padding-top="-5.5mm">
                        <!-- <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
                            <xsl:value-of select="'5mm'" />
                        </xsl:attribute> -->
                        <fo:external-graphic border="1px solid green" content-width="40%"  scaling="uniform"  src="url(Customization/OpenTopic/common/artwork/M-samsung_logo.svg)" />
                    </fo:block>
                </fo:float>
                
                <fo:float float="right">
                    <fo:block border="1px solid red" padding-top="-9mm">
                        <fo:external-graphic content-width="50%"  scaling="uniform"  src="url({$pi.code/*[matches(name(), 'barcode')]})" />
                    </fo:block>
                </fo:float>

                <fo:float float="right">
                    <fo:block-container text-align="right" padding-top="-7mm" margin-right="0.5mm" border="1px solid blue">
                        <fo:block xsl:use-attribute-sets="__frontmatter__Material__container">
                            <xsl:value-of select="$pi.code/*[name()='printed']" />
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="__frontmatter__Material__container">
                            <xsl:value-of select="$pi.code/*[name()='ver']" />
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="__frontmatter__Material__container">
                            <xsl:for-each select="$pi.code/*[matches(name(), '(language|date)')]">
                                <xsl:value-of select="." />
                                <xsl:if test="position() != last()">
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </fo:block>
                    </fo:block-container>
                </fo:float>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastFooter">
        <fo:static-content flow-name="last-body-footer">
            <xsl:choose>
                <xsl:when test="descendant-or-self::*[matches(@outputclass, 'Heading1\-H3')]">
                    <fo:block xsl:use-attribute-sets="__body__odd__footer">
                    </fo:block>
                </xsl:when>
            
                <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="__body__odd__footer">
                        <fo:inline xsl:use-attribute-sets="__body__odd__footer__pagenum">
                            <fo:page-number/>
                        </fo:inline>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
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
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <fo:block-container width="12mm" absolute-position="absolute">
                <fo:block border-right="1pt solid #949293" padding-bottom="12mm">
                </fo:block>
            </fo:block-container>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header">
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <fo:block-container width="12mm" absolute-position="absolute">
                <fo:block border-right="1pt solid #949293" padding-bottom="12mm">
                </fo:block>
            </fo:block-container>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
            </fo:block>
            </fo:block>
        </fo:static-content>
    </xsl:template>

</xsl:stylesheet>