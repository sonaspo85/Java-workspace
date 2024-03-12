<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	version="2.0">

	<xsl:attribute-set name="ast-toc-body.first">
		<xsl:attribute name="margin-top">
			<xsl:value-of select="$page-body-margin-top" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<xsl:value-of select="'25mm'" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />
		</xsl:attribute>
		<xsl:attribute name="column-count">2</xsl:attribute>
		<xsl:attribute name="column-gap">10mm</xsl:attribute>
		<!-- <xsl:attribute name="background-color">green</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="ast-toc-body.odd">
		<xsl:attribute name="margin-top">
			<!-- <xsl:value-of select="$page-body-margin-top" /> -->
			<xsl:value-of select="'25mm'" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<xsl:value-of select="'25mm'" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />
		</xsl:attribute>
		<xsl:attribute name="column-count">2</xsl:attribute>
		<xsl:attribute name="column-gap">10mm</xsl:attribute>
		<!-- <xsl:attribute name="background-color">green</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="ast-toc-body.even">
		<xsl:attribute name="margin-top">
			<!-- <xsl:value-of select="$page-body-margin-top" /> -->
			<xsl:value-of select="'25mm'" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<xsl:value-of select="'25mm'" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />

		</xsl:attribute>
		<xsl:attribute name="column-count">2</xsl:attribute>
		<xsl:attribute name="column-gap">10mm</xsl:attribute>
		<!-- <xsl:attribute name="background-color">green</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="region-body.first">
		<!-- <xsl:attribute name="background-color">green</xsl:attribute> -->
		<xsl:attribute name="margin-top">
			<xsl:value-of select="$page-body-margin-top" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<xsl:value-of select="$page-body-margin-bottom" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />
		</xsl:attribute>
		<xsl:attribute name="column-count">3</xsl:attribute>
		<xsl:attribute name="column-gap">8mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="region-body.odd">
		<!-- <xsl:attribute name="background-color">green</xsl:attribute>  -->
		<xsl:attribute name="margin-top">
			<xsl:value-of select="$page-body-margin-top" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			
			<xsl:value-of select="$page-body-margin-bottom" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />
		</xsl:attribute>
		<xsl:attribute name="column-count">3</xsl:attribute>
		<xsl:attribute name="column-gap">8mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="region-body.even">
		<xsl:attribute name="margin-top">
			<xsl:value-of select="$page-body-margin-top" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<!-- <xsl:value-of select="'14mm'" /> -->
			<xsl:value-of select="$page-body-margin-bottom" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margin-outside" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margin-inside" />
		</xsl:attribute>
		<xsl:attribute name="column-count">3</xsl:attribute>
		<xsl:attribute name="column-gap">8mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="region-body__frontmatter.odd" use-attribute-sets="region-body.odd">
		<xsl:attribute name="margin-top">
			<xsl:value-of select="'-5.5mm'" />
		</xsl:attribute>
		<xsl:attribute name="margin-bottom">
			<xsl:value-of select="$page-margins-cover" />
		</xsl:attribute>
		<xsl:attribute name="background-image">url(Customization/OpenTopic/common/artwork/E-cover.png)</xsl:attribute>
		<xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
		<xsl:attribute name="background-position">0px 0px</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
			<xsl:value-of select="$page-margins-cover" />
		</xsl:attribute>
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
			<xsl:value-of select="$page-margins-cover" />
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="region-before">
		<xsl:attribute name="extent">
			<xsl:value-of select="$page-margin-top" />
		</xsl:attribute>
		<xsl:attribute name="display-align">before</xsl:attribute>
		<xsl:attribute name="background-color">yellow</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="region-after">
		<xsl:attribute name="extent">
			<!-- <xsl:value-of select="$page-margin-bottom" /> -->
			<xsl:value-of select="'5mm'" />
		</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="background-color">yellow</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>
