<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
        		<fo:external-graphic src="url(Customization/OpenTopic/common/artwork/M-samsung_logo.ai)" />
                <!-- <fo:external-graphic src="url(C:/DITA-OT-Mobile/plugins/com.ast.protean.ma.um2020pdf/cfg/common/artwork/M-samsung_logo.ai)" /> -->
        	</fo:block>
	    </fo:block-container>
        
        <xsl:if test="$localeStrAfter = 'TR'">
            <fo:block-container xsl:use-attribute-sets="__frontmatter__petLogo__container">
                <fo:float float="left">
                    <fo:block>
                        <fo:external-graphic src="url(../../BASIC/images/E-petname.pdf)" />
                    </fo:block>
                </fo:float>
            </fo:block-container>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$localeStrAfter = 'TR'">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__title__container__TR" writing-mode="{$writing-mode}">
                    <fo:block fo:linefeed-treatment="preserve">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'frontmatter-title'" />
                        </xsl:call-template>
                    </fo:block>
                </fo:block-container>

                <fo:block-container xsl:use-attribute-sets="__frontmatter__petName__container" writing-mode="{$writing-mode}">
                    <fo:block>
                        <!-- <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'frontmatter-petName-table'" />
                        </xsl:call-template> -->
                        <!-- <xsl:choose>
                            <xsl:when test="$pi.code/*[matches(name(),'prodtype')] = 'tablet'">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'frontmatter-petName-table'" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'frontmatter-petName-phone'" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose> -->
                        <xsl:for-each select="tokenize($pi.code/*[name()='userManual_sub'], '\|')">
                            <xsl:value-of select="." />
                        </xsl:for-each>
                    </fo:block>
                </fo:block-container>
            </xsl:when>

            <xsl:otherwise>
                <fo:block-container xsl:use-attribute-sets="__frontmatter__title__container" writing-mode="{$writing-mode}">
                    <fo:block fo:linefeed-treatment="preserve">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'frontmatter-title'" />
                        </xsl:call-template>
                    </fo:block>
                </fo:block-container>
            </xsl:otherwise>
        </xsl:choose>

	    <!-- <fo:block-container writing-mode="{$writing-mode}"> -->
	    <fo:block-container writing-mode="lr">
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

            <xsl:if test="$localeStrAfter = 'KZ'">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__eac__container">
                    <fo:block>
                        <fo:external-graphic src="url(../../BASIC/images/M-eac.pdf)" />
                    </fo:block>
                </fo:block-container>
            </xsl:if>

            <!-- <fo:block-container writing-mode="{$writing-mode}" xsl:use-attribute-sets="__frontmatter__blankline__container"> -->
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
                                <xsl:text>. </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </fo:float>
            </fo:block-container>

            <!-- <fo:block-container writing-mode="{$writing-mode}" xsl:use-attribute-sets="__frontmatter__url__container"> -->
            <fo:block-container writing-mode="lr" xsl:use-attribute-sets="__frontmatter__url__container">
                <xsl:choose>
                    <xsl:when test="$writing-mode = 'rl'">
                        <xsl:attribute name="left">12mm</xsl:attribute>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:attribute name="right">12mm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:variable name="lang">
                    <xsl:choose>
                        <xsl:when test="exists(key('LDFname', $sourceLang, $langDateFile))">
                            <xsl:value-of select="key('LDFname', $sourceLang, $langDateFile)/@site" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'NONE'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <fo:float float="{if ($writing-mode = 'rl') then 'left' else 'right'}">
                    <fo:block>
                        <xsl:value-of select="$lang" />
                    </fo:block>
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
        <xsl:variable name="currentTopic" select="descendant-or-self::*[contains(@class, ' topic/topic ')][@otherprops = 'backcover'][preceding-sibling::*[not(matches(@otherprops, 'backcover'))]]
                                                  /preceding-sibling::*[1][contains(@class, ' topic/topic ')]" />
        <fo:block>
            <xsl:if test="$currentTopic">
                <xsl:variable name="backContentTopic" select="$currentTopic/following-sibling::*[contains(@class, ' topic/topic ')]" />

                <!-- <xsl:apply-templates select="$backContentTopic" /> -->

                <xsl:for-each-group select="$backContentTopic" group-starting-with="*[matches(@outputclass, 'pagebreak')]">
                    <xsl:choose>
                        <xsl:when test="current-group()[1][not(matches(@outputclass, 'pagebreak'))]">
                            <xsl:apply-templates select="current-group()" />
                        </xsl:when>

                        <xsl:otherwise>
                            <fo:float axf:float-reference="page" axf:float-x="inside" axf:float-y="bottom">
                                <xsl:apply-templates select="current-group()" />
                            </fo:float>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:if>
        </fo:block>

    </xsl:template>

</xsl:stylesheet>