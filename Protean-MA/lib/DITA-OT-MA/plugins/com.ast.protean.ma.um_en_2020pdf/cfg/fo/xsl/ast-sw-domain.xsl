<?xml version='1.0'?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:template match="*[contains(@class,' sw-d/cmdname ')]">
		<xsl:apply-templates select="." mode="inlineTextOptionalKeyref">
			<xsl:with-param name="copyAttributes" as="element()">
				<wrapper xsl:use-attribute-sets="cmdname" />
			</xsl:with-param>
		</xsl:apply-templates> 
	</xsl:template>

</xsl:stylesheet>