<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:attribute-set name="base-font">
		<xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
		<xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
		<xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
		<xsl:attribute name="font-stretch">92.5%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.title">
    <xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
		<xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
		<xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
		<xsl:attribute name="writing-mode" select="$writing-mode"/>
    <xsl:attribute name="axf:word-break">keep-all</xsl:attribute>
    <xsl:attribute name="axf:word-wrap">normal</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="__force__page__count">
        <xsl:attribute name="force-page-count">
            <xsl:choose>
                <xsl:when test="/*[contains(@class, ' bookmap/bookmap ')]">
                    <xsl:value-of select="'even'"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'auto'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.cover" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.frontmatter">
    <xsl:attribute name="format">
      <xsl:choose>
        <xsl:when test="$writing-mode = 'lr'">
          <xsl:value-of select="'i'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'١'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!-- <xsl:attribute name="font-family">Arial</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.notice" use-attribute-sets="__force__page__count page-sequence.frontmatter">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.backmatter.notice" use-attribute-sets="__force__page__count">
    <xsl:attribute name="format">1</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.preface" use-attribute-sets="__force__page__count page-sequence.frontmatter">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.toc" use-attribute-sets="__force__page__count page-sequence.frontmatter">
    <xsl:attribute name="initial-page-number">2</xsl:attribute>
    <xsl:attribute name="format">
      <xsl:choose>
        <xsl:when test="$writing-mode = 'lr'">
          <xsl:value-of select="'1'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'١'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!-- <xsl:attribute name="font-family">Arial</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.lot" use-attribute-sets="page-sequence.toc">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.lof" use-attribute-sets="page-sequence.toc">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.body" use-attribute-sets="__force__page__count">
    <xsl:attribute name="format">
      <xsl:choose>
        <xsl:when test="$writing-mode = 'lr'">
          <xsl:value-of select="'1'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'١'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!-- <xsl:attribute name="font-family">Arial</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.part" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.appendix" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.glossary" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.index" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>


	<xsl:attribute-set name="common.block">
		<xsl:attribute name="space-before">0mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
