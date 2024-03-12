<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:attribute-set name="__frontmatter__logo__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<!-- <xsl:attribute name="background-color">purple</xsl:attribute> -->
		<xsl:attribute name="width">29%</xsl:attribute>
		<xsl:attribute name="left">4mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__Material__container">
		<xsl:attribute name="line-height">2.5mm</xsl:attribute>
		<xsl:attribute name="font-size">6.5pt</xsl:attribute>
	</xsl:attribute-set>
	


	<xsl:attribute-set name="__frontmatter__title__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">89.7mm</xsl:when>
				<xsl:otherwise>80mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<!-- <xsl:attribute name="left">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">13.13mm</xsl:when>
				<xsl:otherwise>15.6mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="width">210mm</xsl:attribute>
		<xsl:attribute name="height">80.19mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="__frontmatter__textbox__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">206mm</xsl:when>
				<xsl:otherwise>207mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="left">50mm</xsl:attribute>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">120mm</xsl:when>
				<xsl:otherwise>110mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="__frontmatter__modelname__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">252mm</xsl:attribute>
		<xsl:attribute name="left">12mm</xsl:attribute>
		<!-- <xsl:attribute name="width">110mm</xsl:attribute> -->
		<xsl:attribute name="width">180mm</xsl:attribute>
		<xsl:attribute name="color">#BBB7BB</xsl:attribute>
		<xsl:attribute name="height">19mm</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>

		<!-- <xsl:attribute name="top">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">206mm</xsl:when>
				<xsl:otherwise>252mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->
		<!-- <xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">120mm</xsl:when>
				<xsl:otherwise>110mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->
	</xsl:attribute-set>


	<xsl:attribute-set name="__frontmatter__url__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">280.7mm</xsl:attribute>
		<!-- <xsl:attribute name="left">18.05mm</xsl:attribute> -->
		<xsl:attribute name="left">12mm</xsl:attribute>
		<xsl:attribute name="width">180mm</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__url__block">
		<xsl:attribute name="color">#000</xsl:attribute>
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="font-stretch">95%</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
		<xsl:attribute name="letter-spacing">-0.18pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__logo__block">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__title__block">
		<!-- <xsl:attribute name="font-family">SamsungOne 400</xsl:attribute> -->
		<xsl:attribute name="font-family">
			<xsl:value-of select="$base-font-family" />
		</xsl:attribute>
		<!-- <xsl:attribute name="font-family">
			<xsl:choose>
				<xsl:when test="substring-after($locale, '_') = 'KR'">SamsungOneKorean 400</xsl:when>
				<xsl:when test="substring-before($locale, '_') = 'ar'">SamsungOneArabic 400</xsl:when>
				<xsl:when test="substring-before($locale, '_') = 'fa'">SamsungOneArabic 400</xsl:when>
				<xsl:when test="substring-before($locale, '_') = 'he'">SamsungOneHebrew 400</xsl:when>
				<xsl:when test="substring-before($locale, '_') = 'th'">Tahoma</xsl:when>
				<xsl:when test="substring-before($locale, '_') = 'my'">Zawgyi-One</xsl:when>
				<xsl:when test="substring-after($locale, '_') = 'TW'">SamsungSVDMedium_T_CN</xsl:when>
				<xsl:when test="substring-after($locale, '_') = 'HK'">SamsungSVDMedium_T_CN</xsl:when>
				<xsl:when test="substring-after($locale, '_') = 'CN'">SamsungSVDMedium_S_CN</xsl:when>
				<xsl:otherwise>SamsungOne 400</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->
		<xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="matches(substring-after($locale, '-'), 'KR')">
					<xsl:value-of select="'55pt'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'55pt'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="axf:kerning-mode">pair</xsl:attribute>
		<xsl:attribute name="font-stretch">100%</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">#FFFFFF</xsl:attribute>
		<xsl:attribute name="line-height">100%</xsl:attribute>
		<xsl:attribute name="height">110%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__blankline__leader">
		<xsl:attribute name="leader-pattern">rule</xsl:attribute>
		<xsl:attribute name="rule-thickness">1pt</xsl:attribute>
		<xsl:attribute name="leader-length">27mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__model__block" use-attribute-sets="__frontmatter__font__size">
		<xsl:attribute name="space-before">
			<xsl:value-of select="'2mm'" />
        </xsl:attribute>

		<xsl:attribute name="color">cmyk(0%,0%,0%,70%)</xsl:attribute>
		<xsl:attribute name="font-size">13.5pt</xsl:attribute>
		<xsl:attribute name="line-height">7mm</xsl:attribute>
		<xsl:attribute name="font-family">HelveticaNeue-Roman</xsl:attribute>
		<xsl:attribute name="padding-top">-2mm</xsl:attribute>
		<xsl:attribute name="font-weight">lighter</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__font__size">
		<xsl:attribute name="font-size">
			<xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:value-of select="'12.5pt'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="'14pt'" />
                </xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__blankline__block" >
		<xsl:attribute name="color">#000</xsl:attribute>
		<!-- <xsl:attribute name="font-size">14pt</xsl:attribute> -->
		<xsl:attribute name="font-size">
			<xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:value-of select="'11.5pt'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="'14pt'" />
                </xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="font-stretch">95%</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
		<xsl:attribute name="letter-spacing">-0.15pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__blankline__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">280.7mm</xsl:attribute>
		<xsl:attribute name="left">12mm</xsl:attribute>
		<xsl:attribute name="width">180mm</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__external__link__block">
		<xsl:attribute name="padding-before">14.4pt</xsl:attribute>
		<xsl:attribute name="padding-after">14.4pt</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>