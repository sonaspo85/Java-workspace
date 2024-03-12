<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
				xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                version="2.0"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg table ditaarch">

	<xsl:template match="*[contains(@class,' topic/table ')]" name="topic.table">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
		<table>
			<xsl:apply-templates select="." mode="table:common"/>
			<xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
		</table>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
	</xsl:template>


	<xsl:template match="*[contains(@class, ' topic/colspec ')]">
		<xsl:param name="totalwidth" as="xs:double"/>

		<xsl:variable name="cols" select="parent::tgroup/@cols" as="xs:string?"/>
		<xsl:variable name="colname" select="@colname" as="xs:string?"/>
		<col>
			<xsl:attribute name="class" select="concat('c', $cols, '-', $colname)"/>
		</col>
	</xsl:template>


</xsl:stylesheet>
