<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

	<xsl:attribute-set name="odd__header">
		<xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="color">cmyk(0%,0%,0%,70%)</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="start-indent">16mm</xsl:attribute>
		<xsl:attribute name="end-indent">0pt</xsl:attribute>
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
			<xsl:value-of select="'14pt'" />
		</xsl:attribute>
		<xsl:attribute name="color">cmyk(0%,0%,0%,70%)</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__header" use-attribute-sets="odd__header">
		<xsl:attribute name="space-before">6.6mm</xsl:attribute>
    </xsl:attribute-set>


	<xsl:attribute-set name="__body__odd__footer" use-attribute-sets="odd__footer">
		<xsl:attribute name="padding-bottom">
			<xsl:value-of select="'0.2mm'" />
		</xsl:attribute>
		<!-- <xsl:attribute name="format">
			<xsl:choose>
				<xsl:when test="$writing-mode = 'lr'">
					<xsl:value-of select="'i'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'١'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> -->
    </xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__header__heading">
		<xsl:attribute name="font-family">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('HeaderHeading', ' FontFamily')" />
			</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-size"><xsl:value-of select="$default-font-size" /></xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="__body__odd__footer__pagenum" use-attribute-sets="pagenum">
		<xsl:attribute name="font-family">
			<xsl:call-template name="getVariable">
			    <xsl:with-param name="id" select="concat('FooterPageNum', ' FontFamily')" />
			</xsl:call-template>
		</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>