<?xml version='1.0'?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:attribute-set name="odd__header">
		<xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="color">cmyk(0%,0%,0%,70%)</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="start-indent">16mm</xsl:attribute>
		<xsl:attribute name="end-indent">0pt</xsl:attribute>
		<xsl:attribute name="space-before">7mm</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="odd__footer">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="end-indent">0pt</xsl:attribute>
		<xsl:attribute name="space-after">10pt</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="even__footer">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="space-after">10pt</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="pagenum">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(SG|CN|HK|TW)')">13.5pt</xsl:when>
				<xsl:otherwise>14pt</xsl:otherwise><!--수정 -->
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="font-stretch">
			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(LA|IN)')">100%</xsl:when>
				<xsl:otherwise>95%</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="color">cmyk(0%,0%,0%,70%)</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__header" use-attribute-sets="odd__header">
		<xsl:attribute name="space-before">
			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(LA|IN)')">6.7mm</xsl:when>
				<xsl:when test="matches($localeStrAfter, 'MM')">6.0mm</xsl:when>
				<xsl:when test="matches($localeStrAfter, 'KH')">6.9mm</xsl:when>
				<xsl:when test="matches($localeStrAfter, '(SG|CN|HK|TW)')">7.1mm</xsl:when>
				<xsl:when test="matches($localeStrAfter, '(SA|IL|PK)')">7.2mm</xsl:when>
				<xsl:when test="matches($localeStrAfter, '(KZ|MN|MK|SK|TR|VN)')">7.95mm</xsl:when>
				<xsl:otherwise>7.6mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    </xsl:attribute-set>


	<xsl:attribute-set name="__body__odd__footer" use-attribute-sets="odd__footer">
		<xsl:attribute name="padding-bottom">
			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(SG|CN|HK|TW)')">0.7mm</xsl:when>
				<xsl:otherwise>0.4mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__header__heading">
		<xsl:attribute name="font-family">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('HeaderHeading', ' FontFamily')" />
			</xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-weight">normal</xsl:attribute>

		<!-- <xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(CN|HK|SG|TW|KZ|MN|TR|MK|SK|VN)')">13.5pt</xsl:when>
				<xsl:when test="matches($localeStrAfter, '(SA|IL|PK)')">12.5pt</xsl:when>
				<xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">11.5pt</xsl:when>
				<xsl:when test="matches($localeStrAfter, 'MM')">10pt</xsl:when>
				<xsl:when test="matches($localeStrAfter, 'TH')">16pt</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'14pt'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->

		<xsl:attribute name="font-size">
            <xsl:variable name="cur" select="'HeaderHeading'" />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>


        </xsl:attribute>

		<xsl:attribute name="line-height">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('HeaderHeading', ' LineHeight')" />
			</xsl:call-template>
		</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__footer__pagenum" use-attribute-sets="pagenum">
		<xsl:attribute name="font-family">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('FooterPageNum', ' FontFamily')" />
			</xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('FooterPageNum', ' LineHeight')" />
			</xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('FooterPageNum', ' Size')" />
			</xsl:call-template>
		</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>