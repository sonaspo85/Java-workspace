<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:suitesol="http://suite-sol.com/namespaces/mapcounts" exclude-result-prefixes="xsl opentopic-func xs" version="2.0">

	<xsl:template match="comment() | processing-instruction() | text()">
		<xsl:choose>
			<xsl:when test="self::text() and contains(., '~~')">
				<xsl:analyze-string select="." regex="\s*~~\s*">
					<xsl:matching-substring>
						<xsl:choose>
							<xsl:when test="matches(substring-before($locale, '_'), 'ar|he|fa')">&#x20;&#x2190;&#x20;</xsl:when>
							<xsl:otherwise>&#x20;&#x2192;&#x20;</xsl:otherwise>
						</xsl:choose>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:value-of select="replace(., '[&#x20;&#x0A;]+&#x09;+', '')"/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:when>
			<xsl:otherwise>
      			<xsl:copy-of select="."/>
   			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>