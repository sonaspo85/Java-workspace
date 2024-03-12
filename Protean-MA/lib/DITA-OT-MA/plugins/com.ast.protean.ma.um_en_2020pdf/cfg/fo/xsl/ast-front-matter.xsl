<?xml version='1.0'?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    exclude-result-prefixes="opentopic axf"
    version="2.0">

    <xsl:variable name="langDateFile" select="document(resolve-uri('languages.xml', replace(concat('file:\', $languagesData), '\\', '/')))" as="document-node()?"/>

    <xsl:key name="LDFname" match="language" use="@name"/>
    <xsl:variable name="sourceLang" select="*[local-name()='dita']/@master-lang" />
    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
    
    <xsl:template name="createFrontMatter">
      <xsl:if test="$generate-front-cover">
        <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="page-sequence.cover">
            <xsl:call-template name="insertFrontMatterStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
              <fo:block-container xsl:use-attribute-sets="__frontmatter">
                <xsl:call-template name="createFrontCoverContents"/>
              </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
      </xsl:if>
    </xsl:template>

    <xsl:template name="createFrontCoverContents">
		<fo:block-container xsl:use-attribute-sets="__frontmatter__logo__container" writing-mode="{$writing-mode}">
	    	<fo:block>
                <xsl:variable name="str0">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('cover-', 'Logo-Path')" />
                    </xsl:call-template>
                </xsl:variable>

                <fo:external-graphic src="url('{concat($artworkPrefix, $str0)}')"/>
        	</fo:block>
	    </fo:block-container>

        <xsl:choose>
            <xsl:when test="$localeStrAfter = 'TR'">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__petLogo__container" writing-mode="{$writing-mode}">
                    <fo:block text-align="right" line-height="12pt" padding-bottom="0.8mm">
                        <!-- <fo:external-graphic src="url(../../BASIC/images/E-petname.ai)" width="100%" content-height="100%" content-width="scale-down-to-fit" scaling="uniform" position="absolute" top="0mm" right="12mm" /> -->
                        <xsl:for-each select="tokenize($pi.code/*[matches(name(),'petName')]/text(), '\|')">
                            <xsl:variable name="cur" select="." />
                            <xsl:variable name="petPath" select="concat('url(', concat('../../BASIC/images/', $cur, '.ai'), ')')" />
                            <fo:external-graphic src="{$petPath}" width="100%" content-height="100%" content-width="scale-down-to-fit" scaling="uniform" position="absolute" top="0mm" right="12mm" />
                        </xsl:for-each>
                    </fo:block>
                </fo:block-container>

                <fo:block-container xsl:use-attribute-sets="__frontmatter__titleband__container__TR" writing-mode="{$writing-mode}">
                    <fo:block-container xsl:use-attribute-sets="__frontmatter__title__container__TR">
                        <fo:block fo:linefeed-treatment="preserve">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'frontmatter-title'" />
                            </xsl:call-template>
                        </fo:block>
                    </fo:block-container>

                    <fo:block-container xsl:use-attribute-sets="__frontmatter__petName__container" writing-mode="{$writing-mode}">
                        <fo:block>
                        	<xsl:choose>
	                            <xsl:when test="$pi.code/*[matches(name(),'prodtype')] = 'tablet'">
	                                <xsl:call-template name="getVariable">
	                                    <xsl:with-param name="id" select="'frontmatter-petName-tablet'" />
	                                </xsl:call-template>
	                            </xsl:when>
	                            <xsl:otherwise>
	                                <xsl:call-template name="getVariable">
	                                    <xsl:with-param name="id" select="'frontmatter-petName-phone'" />
	                                </xsl:call-template>
	                            </xsl:otherwise>
                        	</xsl:choose>
                        </fo:block>
                    </fo:block-container>
                </fo:block-container>
            </xsl:when>

            <xsl:otherwise>
                <fo:block-container xsl:use-attribute-sets="__frontmatter__title__container" writing-mode="{$writing-mode}">
                    <fo:block fo:linefeed-treatment="preserve">
                        <!-- <xsl:choose>
                            <xsl:when test="$sourceLang = 'Bulgarian' and
                                            $locale = 'ru-RU'">
                                <xsl:value-of select="'РЪКОВОДСТВО НА ПОТРЕБИТЕЛЯ1111'" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'frontmatter-title'" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose> -->
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'frontmatter-title'" />
                        </xsl:call-template>
                    </fo:block>
                </fo:block-container>
            </xsl:otherwise>
        </xsl:choose>

	    <fo:block-container writing-mode="lr">
            <xsl:if test="not(matches($locale, '(en-CN|en-TW)'))">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__modelname__container">
                    <xsl:choose>
                        <xsl:when test="$writing-mode = 'rl'">
                            <xsl:attribute name="right">12mm</xsl:attribute>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:attribute name="left">12mm</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <fo:float float="{if ($writing-mode = 'rl') then 'right' else 'left'}">
                        <xsl:for-each select="tokenize($pi.code/*[name()='prodname'], '\|')">
                            <fo:block>
                                <xsl:value-of select="." />
                            </fo:block>
                        </xsl:for-each>
                    </fo:float>
                </fo:block-container>
            </xsl:if>

            <xsl:if test="matches($locale, '(en-CN|en-TW)')">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__info">
                    <fo:float float="left">
                        <!-- <xsl:attribute name="xml:lang" select="if ( matches($localeStrAfter, 'CN') ) then 'zh-CN' else 'zh-TW'" /> -->
                        <xsl:attribute name="xml:lang" select="'zh'" />
                        <fo:block>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'frontmatter-infomation'" />
                            </xsl:call-template>
                        </fo:block>
                    </fo:float>
                </fo:block-container>
            </xsl:if>

            <xsl:if test="$localeStrAfter = 'KZ'">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__eac__container">
                    <fo:block>
                        <fo:external-graphic src="url(../../BASIC/images/M-eac.ai)" />
                    </fo:block>
                </fo:block-container>
            </xsl:if>

            <fo:block-container writing-mode="lr" xsl:use-attribute-sets="__frontmatter__LangDateVer__container">
                <xsl:choose>
                    <xsl:when test="$writing-mode = 'rl'">
                        <xsl:attribute name="right">12mm</xsl:attribute>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:attribute name="left">12mm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:variable name="lang">
                    <xsl:choose>
                        <xsl:when test="exists(key('LDFname', $sourceLang, $langDateFile))">
                            <xsl:value-of select="key('LDFname', $sourceLang, $langDateFile)/@frontname" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'NONE'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <fo:float float="{if ($writing-mode = 'rl') then 'right' else 'left'}">
                    <fo:block>
                        <xsl:for-each select="$lang, $pi.code/*[matches(name(),'(date|ver)')]">
                            <xsl:value-of select="." />
                            <xsl:if test="position() != last()">
                                <xsl:choose>
                                    <xsl:when test="matches($locale, 'zh-CN')">
                                        <xsl:text> </xsl:text>
                                    </xsl:when>

                                    <xsl:otherwise>. </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </fo:float>
            </fo:block-container>

            <fo:block-container writing-mode="lr" xsl:use-attribute-sets="__frontmatter__url__container">
                <xsl:choose>
                    <xsl:when test="$writing-mode = 'rl'">
                        <xsl:attribute name="left">12mm</xsl:attribute>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:attribute name="right">12mm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:variable name="site">
                    <xsl:choose>
                        <xsl:when test="matches($locale, 'en-TW')">
                            <xsl:value-of select="$pi.code/*[name()='site']" />
                        </xsl:when>

                        <xsl:when test="exists(key('LDFname', $sourceLang, $langDateFile))">
                            <xsl:value-of select="key('LDFname', $sourceLang, $langDateFile)/@site" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'NONE'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <fo:float float="{if ($writing-mode = 'rl') then 'left' else 'right'}">
                    <xsl:choose>
                        <xsl:when test="matches($site, '\|')">
                            <xsl:for-each select="tokenize($site, '\|')">
                                <xsl:variable name="cur" select="." />

                                <fo:block>
                                    <xsl:if test="position() = last()">
                                        <xsl:attribute name="margin-top" select="'1.7mm'" />
                                    </xsl:if>

                                    <fo:basic-link wrap-option="no-wrap">
                                        <xsl:attribute name="external-destination">
                                            <xsl:text>url('</xsl:text>
                                            <xsl:value-of select="concat('http://', $cur)" />
                                            <xsl:text>')</xsl:text>
                                        </xsl:attribute>

                                        <xsl:value-of select="$cur" />
                                    </fo:basic-link>
                                </fo:block>
                            </xsl:for-each>
                        </xsl:when>

                        <xsl:otherwise>
                            <fo:block>
                                <fo:basic-link wrap-option="no-wrap">
                                    <xsl:attribute name="external-destination">
                                        <xsl:text>url('</xsl:text>
                                        <xsl:value-of select="concat('http://', $site)" />
                                        <xsl:text>')</xsl:text>
                                    </xsl:attribute>

                                    <xsl:value-of select="$site" />
                                </fo:basic-link>
                            </fo:block>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:float>
            </fo:block-container>
    	</fo:block-container>
    </xsl:template>

      <xsl:template name="createBackCover">
          <xsl:if test="$generate-back-cover">
            <fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="back-cover">
              <xsl:call-template name="insertBackCoverStaticContents"/>
              <fo:flow flow-name="xsl-region-body">
                <fo:block-container xsl:use-attribute-sets="__back-cover">
                  <xsl:call-template name="createBackCoverContents"/>
                </fo:block-container>
              </fo:flow>
            </fo:page-sequence>
          </xsl:if>
    </xsl:template>

    <xsl:template name="createBackCoverContents">
        <xsl:variable name="currentTopic" select="descendant-or-self::*[contains(@class, ' topic/topic ')][matches(@outputclass, 'backcover')][preceding-sibling::*[not(matches(@outputclass, 'backcover'))]]
                                                  /preceding-sibling::*[1][contains(@class, ' topic/topic ')]" />
        <fo:block>
            <xsl:if test="$currentTopic">
                <xsl:variable name="backContentTopic" select="$currentTopic/following-sibling::*[contains(@class, ' topic/topic ')]" />

                <xsl:choose>
                    <xsl:when test="matches($locale, '^en\-')">
                        <fo:float axf:float-reference="page" axf:float-x="left" axf:float-y="bottom">
                            <xsl:apply-templates select="$backContentTopic" />
                        </fo:float>
                    </xsl:when>

                    <xsl:when test="matches($localeStrAfter, '(DK|NL|FI|NO|PL|ES|SE|TR|TW|IT)')">
                        <xsl:for-each-group select="$backContentTopic" group-adjacent="position() = 1">
                            <xsl:choose>
                                <xsl:when test="current-grouping-key()">
                                    <xsl:apply-templates select="." />
                                </xsl:when>

                                <xsl:otherwise>
                                    <fo:float axf:float-reference="page" axf:float-x="left" axf:float-y="bottom" margin-bottom="1.2mm">
                                        <xsl:apply-templates select="current-group()" />
                                    </fo:float>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>

                    <xsl:otherwise>
                        <fo:float axf:float-reference="page" axf:float-x="left" axf:float-y="bottom" padding-bottom="1.2mm">
                            <xsl:apply-templates select="$backContentTopic" />
                        </fo:float>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>