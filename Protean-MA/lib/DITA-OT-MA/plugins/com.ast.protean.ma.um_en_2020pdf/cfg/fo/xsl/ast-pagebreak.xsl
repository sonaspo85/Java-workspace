<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

	<xsl:template match="processing-instruction('pagebreak')" priority="300">
	</xsl:template>

	<xsl:template match="processing-instruction('linebreak')" priority="300">
		<xsl:value-of select="'&#x2028;'"/>
	</xsl:template>

	<xsl:template match="processing-instruction('ACE')" priority="300">
		<fo:inline axf:indent-here="0pt"/>
	</xsl:template>

</xsl:stylesheet>
