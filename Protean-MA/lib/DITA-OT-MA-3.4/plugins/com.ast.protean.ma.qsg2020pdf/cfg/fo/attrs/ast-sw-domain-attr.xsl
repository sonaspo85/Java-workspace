<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

	<xsl:attribute-set name="cmdname">
		<xsl:attribute name="color">cmyk(0%,0%,0%,100%)</xsl:attribute>
		<xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
		<xsl:attribute name="color">inherit</xsl:attribute>
		 <xsl:attribute name="font-weight">600</xsl:attribute> 
	</xsl:attribute-set>

	<xsl:attribute-set name="cmdname.noweight" use-attribute-sets="cmdname">
		<xsl:attribute name="font-weight">400</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>