<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
				xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                version="2.0"
                exclude-result-prefixes="xs dita-ot related-links dita2html ditamsg ditaarch">
    
	<xsl:template match="*[contains(@class, ' task/cmd ')]" name="topic.task.cmd">
		<xsl:choose>
			<xsl:when test="@href and @keyref">
				<xsl:apply-templates select="." mode="turning-to-link">
					<xsl:with-param name="keys" select="@keyref"/>
					<xsl:with-param name="type" select="'ph'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setidaname"/> 
					<xsl:apply-templates/>  
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="add-br-for-empty-cmd"/>
	</xsl:template>

	<xsl:template name="generateItemGroupTaskElement">
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
