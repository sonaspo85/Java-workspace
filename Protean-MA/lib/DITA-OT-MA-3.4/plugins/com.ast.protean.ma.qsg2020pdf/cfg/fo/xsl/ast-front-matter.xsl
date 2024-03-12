<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="2.0">

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

    <!-- <xsl:variable name="pi.code">
        <xsl:for-each select="root()/dita/node()[self::processing-instruction('ast')]">
            <xsl:element name="{substring-before(., '=')}">
                <xsl:value-of select="substring-after(., '=')" />
            </xsl:element>
        </xsl:for-each>
    </xsl:variable> -->


      <xsl:template name="createFrontCoverContents">
		<fo:block-container xsl:use-attribute-sets="__frontmatter__logo__container">
	    	<fo:block>
        		<fo:external-graphic src="url(Customization/OpenTopic/common/artwork/M-samsung_logo.ai)" />
        	</fo:block>
	    </fo:block-container>

	    <fo:block-container xsl:use-attribute-sets="__frontmatter__title__container">
            <fo:block xsl:use-attribute-sets="__frontmatter__title__block">
                <xsl:choose>
                    <xsl:when test="$locale = 'en-GB'">
                        <xsl:value-of select="$pi.code/*[name()='userManual']" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'frontmatter-title'" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
	    </fo:block-container>

	    <!-- <fo:block-container writing-mode="{$writing-mode}"> -->
	    <fo:block-container writing-mode="lr">
	        <fo:block-container xsl:use-attribute-sets="__frontmatter__modelname__container">
                <fo:float float="{if ($writing-mode = 'rl') then 'right' else 'left'}">
                    <xsl:for-each select="tokenize($pi.code/*[name()='prodname'], '\|')">
                        <fo:block  xsl:use-attribute-sets="__frontmatter__model__block" >
                            <xsl:value-of select="." />
                        </fo:block>
                    </xsl:for-each>
                </fo:float>
			</fo:block-container>

            <!-- <fo:block-container writing-mode="{$writing-mode}" xsl:use-attribute-sets="__frontmatter__blankline__container"> -->
            <fo:block-container writing-mode="lr" xsl:use-attribute-sets="__frontmatter__blankline__container">
                <xsl:variable name="lang">
                    <xsl:choose>
                        <xsl:when test="$locale = 'en-GB'">
                            <xsl:value-of select="$pi.code/*[name()='language']" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'frontmatter-language'" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <fo:float float="{if ($writing-mode = 'rl') then 'right' else 'left'}">
                    <fo:block xsl:use-attribute-sets="__frontmatter__blankline__block">
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
                <fo:float float="{if ($writing-mode = 'rl') then 'left' else 'right'}">
                    <fo:block xsl:use-attribute-sets="__frontmatter__url__block">
                        <xsl:for-each select="$pi.code/*[matches(name(),'site')]">
                            <xsl:value-of select="." />
                        </xsl:for-each>
                    </fo:block>
                </fo:float>
            </fo:block-container>
    	</fo:block-container>
      </xsl:template>

</xsl:stylesheet>