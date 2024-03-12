<?xml version='1.0'?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:attribute-set name="__frontmatter__logo__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">16.4mm</xsl:attribute>
		<xsl:attribute name="left">
			<xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(SA|IR|IL|PK)')">148mm</xsl:when>
				<xsl:otherwise>12mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="right">
			<xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(SA|IR|IL|PK)')">12mm</xsl:when>
				<xsl:otherwise>12mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__petLogo__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">20mm</xsl:attribute>
		<xsl:attribute name="bottom">228.7mm</xsl:attribute>
		<xsl:attribute name="right">
			<xsl:value-of select="'12mm'" />
		</xsl:attribute>
		<xsl:attribute name="display-align" select="'after'" />
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__eac__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">239.3mm</xsl:attribute>
		<xsl:attribute name="left">
			<xsl:value-of select="'73.45mm'" />
		</xsl:attribute>
		<xsl:attribute name="width" select="'30%'" />
		<xsl:attribute name="height" select="'30%'" />
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__info">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">252.2mm</xsl:attribute>
		<xsl:attribute name="width">165mm</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="left">12mm</xsl:attribute>
		<xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>

		<xsl:attribute name="color">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontColor">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-info'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-info'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-info'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-info'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common__related__font">
		<xsl:attribute name="color">
            <xsl:variable name="cur" select="'Frontmatter-title'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-title'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-title'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-title'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-title'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-title'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__title__container" use-attribute-sets="common__related__font">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<xsl:value-of select="'74.7mm'" />
		</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="width">
			<xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(CZ|IT)')">194mm</xsl:when>
				<xsl:otherwise>186mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="height">80.19mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="left">
			<xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(CZ|IT)')">8mm</xsl:when>
				<xsl:otherwise>12mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="right">
			<xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(CZ|IT)')">8mm</xsl:when>
				<xsl:otherwise>12mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__titleband__container__TR" use-attribute-sets="common__related__font">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<xsl:value-of select="'71.8mm'" />
		</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="width">210mm</xsl:attribute>
		<xsl:attribute name="height">80.19mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="left">0.7mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__title__container__TR" use-attribute-sets="common__related__font">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<!-- <xsl:value-of select="'25.2mm'" /> -->
			<xsl:value-of select="'22.1mm'" />
		</xsl:attribute>

		<xsl:attribute name="display-align">before</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__petName__container" use-attribute-sets="common__related__font">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<!-- <xsl:attribute name="top">
			<xsl:value-of select="'56.85mm'" />
		</xsl:attribute> -->
		<xsl:attribute name="bottom">
			<xsl:value-of select="'8mm'" />
		</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="width">210mm</xsl:attribute>
		<xsl:attribute name="height">80.19mm</xsl:attribute>
		<!-- <xsl:attribute name="display-align">before</xsl:attribute> -->
		<xsl:attribute name="display-align">after</xsl:attribute>

		<xsl:attribute name="color">
            <xsl:variable name="cur" select="'Frontmatter-petName'" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-petName'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-petName'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-petName'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-petName'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-petName'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="__frontmatter__textbox__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">
			<xsl:value-of select="'207mm'" />
		</xsl:attribute>
		<xsl:attribute name="left">50mm</xsl:attribute>
		<xsl:attribute name="width">
			<xsl:value-of select="'110mm'" />
		</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="__frontmatter__modelname__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<!-- <xsl:attribute name="top">217mm</xsl:attribute> -->
		<xsl:attribute name="top">
			<xsl:choose>
			    <xsl:when test="matches($localeStrAfter, 'CN')">
			        <xsl:value-of select="'218.2mm'" />
			    </xsl:when>

			    <xsl:otherwise>
			        <xsl:value-of select="'217mm'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="margin-top">0.2mm</xsl:attribute>
		<xsl:attribute name="width">50mm</xsl:attribute>
		<xsl:attribute name="height">48.5mm</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>

		<xsl:attribute name="font-weight">
			<xsl:choose>
			    <xsl:when test="matches($localeStrAfter, 'MM')">
					<xsl:value-of select="'normal'" />
			    </xsl:when>

			    <xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

	    <xsl:attribute name="color">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontColor">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-model'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__LangDateVer__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">275.6mm</xsl:attribute>
		<xsl:attribute name="width">80mm</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>

		<xsl:attribute name="color">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontColor">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-LangDateVer'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__url__container">
		<xsl:attribute name="position">absolute</xsl:attribute>
		<xsl:attribute name="top">267mm</xsl:attribute>
		<xsl:attribute name="width">80mm</xsl:attribute>
		<xsl:attribute name="height">15mm</xsl:attribute>
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="color">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontColor">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-size">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontSize">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-family">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontFamily">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="lineHeight">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="fontStretch">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="letter-spacing">
		    <xsl:variable name="cur" select="'Frontmatter-Url'" />
		    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

		    <xsl:call-template name="letterSpacing">
		        <xsl:with-param name="cur" select="$cur" />
		        <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
		    </xsl:call-template>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__logo__block">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__blankline__leader">
		<xsl:attribute name="leader-pattern">rule</xsl:attribute>
		<xsl:attribute name="rule-thickness">1pt</xsl:attribute>
		<xsl:attribute name="leader-length">27mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__frontmatter__external__link__block">
		<xsl:attribute name="padding-before">14.4pt</xsl:attribute>
		<xsl:attribute name="padding-after">14.4pt</xsl:attribute>
	</xsl:attribute-set>

	  <xsl:attribute-set name="back-cover">
	    <xsl:attribute name="force-page-count">no-force</xsl:attribute>
	  </xsl:attribute-set>

	  <xsl:attribute-set name="__back-cover">
	    <xsl:attribute name="break-before">page</xsl:attribute>
	  </xsl:attribute-set>

</xsl:stylesheet>