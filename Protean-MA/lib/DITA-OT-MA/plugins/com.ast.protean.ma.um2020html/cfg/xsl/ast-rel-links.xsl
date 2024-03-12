<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    exclude-result-prefixes="xs related-links ditamsg dita-ot ditaarch">

  <xsl:template name="href">
  	<xsl:choose>
  		<xsl:when test="name() ='xref' and @format='html' and @scope = 'external'">
  			<xsl:value-of select="replace(@href, '^https?://', '')"/>
  		</xsl:when>
  		<xsl:otherwise>
    		<xsl:apply-templates select="." mode="determine-final-href"/>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>

</xsl:stylesheet>
