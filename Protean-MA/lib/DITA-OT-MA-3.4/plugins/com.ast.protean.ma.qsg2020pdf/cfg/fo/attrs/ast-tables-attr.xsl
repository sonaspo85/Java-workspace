<?xml version="1.0"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	version="2.0">

	<xsl:attribute-set name="common.table.body.entry">
		<!-- <xsl:attribute name="space-before">5pt</xsl:attribute> -->
		<xsl:attribute name="space-before">0mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
		
		<xsl:attribute name="start-indent">
			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)">
					<xsl:value-of select="'0.5mm'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'2mm'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="end-indent">3pt</xsl:attribute>
		<xsl:attribute name="text-align">inherit</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tbody.row.entry__content" use-attribute-sets="common.table.body.entry">
		<xsl:attribute name="space-before">0mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
		
		<xsl:attribute name="start-indent">
			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)">
					<xsl:value-of select="'0.5mm'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'2mm'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="end-indent">3pt</xsl:attribute>
		<xsl:attribute name="text-align">inherit</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.table.head.entry">
		<xsl:attribute name="font-weight">600</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.table.cell">
		<!-- <xsl:attribute name="padding-before">0pt</xsl:attribute>
		<xsl:attribute name="padding-after">0pt</xsl:attribute>
		<xsl:attribute name="padding-start">0pt</xsl:attribute>
		<xsl:attribute name="padding-end">0pt</xsl:attribute> -->
	</xsl:attribute-set>


	<xsl:attribute-set name="tbody.row.entry">
		<xsl:attribute name="padding-before">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]">
					<xsl:value-of select="'1.2mm'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][not(*[contains(@class, ' topic/thead ')])]">
					<xsl:value-of select="'3.5mm'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		
		<xsl:attribute name="padding-after">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]">
					<xsl:choose>
						<xsl:when test="ancestor::*[contains(@class, ' topic/tbody ')] and 
                                        count(*) = 1 and 
                                        *[contains(@class, ' topic/p ')]/*[contains(@class, ' topic/image ')]">
                            <xsl:value-of select="'1.2mm'" />
                        </xsl:when>
						<xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>

				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][not(*[contains(@class, ' topic/thead ')])]">
					<xsl:value-of select="'0mm'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		
		<xsl:attribute name="padding-start">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]">
					<xsl:value-of select="'1.8mm'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][not(*[contains(@class, ' topic/thead ')])]">
					<xsl:value-of select="'2.2mm'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		
		<xsl:attribute name="padding-end">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]">
					<xsl:value-of select="'1.8mm'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][not(*[contains(@class, ' topic/thead ')])]">
					<xsl:value-of select="'2.2mm'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="display-align">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')]">
					<xsl:value-of select="'center'" />
	            </xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'before'" />
                </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="background-color">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')] and 
								not(preceding-sibling::*)">
					<xsl:value-of select="'cmyk(0%,0%,0%,10%)'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]//*[contains(@class, ' topic/entry ')]/@nameend">
					<xsl:variable name="test" select="number(replace(ancestor::*[contains(@class, ' topic/tgroup ')][1]//*[contains(@class, ' topic/entry ')]/@nameend, '(.+)(\d)', '$2')) + 1" />
					<xsl:choose>
						<xsl:when test="xs:integer(replace(@colname, '(.+)(\d)', '$2')) &lt; $test">
							<xsl:value-of select="'cmyk(0%,0%,0%,10%)'" />
                    	</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'transparent'" />
                        </xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>transparent</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.thead.row">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
		<!-- <xsl:attribute name="background-color">cmyk(0%,0%,0%,30%)</xsl:attribute> -->
		<!-- <xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border-width">1pt</xsl:attribute>
		<xsl:attribute name="border-color">cmyk(0%,0%,0%,20%)</xsl:attribute> -->

		<!-- <xsl:attribute name="display-align">left</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.thead.padding">
		<!-- <xsl:attribute name="padding-top">0pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">0pt</xsl:attribute> -->
		<xsl:attribute name="padding-left">5pt</xsl:attribute>
		<xsl:attribute name="padding-right">5pt</xsl:attribute>
		<xsl:attribute name="background-color">
			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)">
					<xsl:value-of select="'cmyk(0%,0%,0%,20%)'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.tbody.row">
		<!-- <xsl:attribute name="display-align">center</xsl:attribute> -->
		<!-- <xsl:attribute name="line-height">5.3mm</xsl:attribute> -->
		<xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.tgroup.thead">
		<xsl:attribute name="line-height">5.7mm</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="thead.row.entry__content" use-attribute-sets="common.table.body.entry common.table.head.entry">
		<xsl:attribute name="padding-before">1.75mm</xsl:attribute>
		<xsl:attribute name="padding-after">0.3mm</xsl:attribute>
		<xsl:attribute name="padding-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="padding-after.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

<!-- default talbe border start -->
	<xsl:attribute-set name="__tableframe__top" use-attribute-sets="table.rule__top">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="table.rule__bottom">
		<xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="common.border__bottom">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__left" use-attribute-sets="table.rule__left">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__right" use-attribute-sets="table.rule__right">
	</xsl:attribute-set>
<!-- default talbe border end -->


	<xsl:attribute-set name="common.border__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">1pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">1pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__right">
		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__left">
		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
	</xsl:attribute-set>

<!-- table rule -->
	<xsl:attribute-set name="table.rule__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">1pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">1pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__right">
		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__left">
		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.tgroup">
		<xsl:attribute name="space-before">
			<xsl:choose>
				<xsl:when test="not(*[contains(@class, 'topic/thead')])">
					<xsl:value-of select="'0mm'" />
				</xsl:when>

				<xsl:otherwise>3.5mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    	<xsl:attribute name="space-after">3.5mm</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table" use-attribute-sets="base-font">
		<xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="start-indent">0mm</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>