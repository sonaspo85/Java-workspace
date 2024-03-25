<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs saxon ast"
    version="2.0">

	<xsl:character-map name="a">
		<xsl:output-character character='&lt;' string="&lt;"/>
		<xsl:output-character character='&gt;' string="&gt;"/>
		<xsl:output-character character='&amp;' string="&amp;"/>
	</xsl:character-map>

	<xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	<xsl:strip-space elements="*" />
	<xsl:variable name="apphtml" select="document(concat(ast:getName(base-uri(.), '/'), '/../xsls2/', 'app.html'))" />
	<xsl:variable name="data-language" select="/body/@data-language" />

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:apply-templates />
		<xsl:result-document href="dummy.xml">
			<dummy/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="name()='h2'">
				<h2>
					<xsl:value-of select="normalize-space(.)" />
				</h2>
			</xsl:when>
			<xsl:when test="name()='h3'">
				<h3>
					<xsl:value-of select="normalize-space(.)" />
				</h3>
			</xsl:when>
			<xsl:when test="name()='h4'">
				<h4>
					<xsl:value-of select="normalize-space(.)" />
				</h4>
			</xsl:when>
			<xsl:when test="name()='h5'">
				<h5>
					<xsl:value-of select="normalize-space(.)" />
				</h5>
			</xsl:when>
			<xsl:when test="name()='h6'">
				<h6>
					<xsl:value-of select="normalize-space(.)" />
				</h6>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="applink">
		<xsl:param name="heading"/>
		<xsl:param name="chapterName" />
	</xsl:template>

	<xsl:template match="body">
		<xsl:variable name="file1" select="'../output/data/cross.xml'" />
		<xsl:variable name="toc1">
			<toc1>
				<xsl:for-each select="chapter//h1[@class='section-heading']">
	    			<xsl:variable name="chapter" select="." />
					<xsl:variable name="cName" select="$chapter/text()" />
	    			<xsl:for-each select="parent::topic/parent::topic//*[@id][starts-with(name(), 'h')][name()!='h1']">
	    				<xsl:variable name="context" select="." />
						<xsl:variable name="id" select="@id" />
		    			<line>
		    				<chapter>
		    					<xsl:value-of select="$cName" />
		    				</chapter>
		    				<xsl:apply-templates select="." />
							<xsl:call-template name="applink">
	    						<xsl:with-param name="heading" select="lower-case(normalize-space(string(.)))" />
								<xsl:with-param name="chapterName" select="lower-case($cName)" />
							</xsl:call-template>
		    				<link>
		    					<xsl:variable name="title" select="ancestor::topic[*[@filename]][1]/*[@filename][1]" />
								<xsl:variable name="id" select="$title/@id" />
								<xsl:variable name="html" select="concat($title/@filename, '_', $id, '.html')" />
								<xsl:variable name="hash" select="if (not($context/@filename)) then concat('#', @id) else ''" />
								<xsl:value-of select="concat($html, $hash)" />
		    				</link>
		    			</line>
	    			</xsl:for-each>
	    		</xsl:for-each>
			</toc1>
		</xsl:variable>

		<xsl:result-document href="{$file1}">
			<toc1 data-language="{$data-language}">
				<xsl:for-each select="$toc1/toc1/line">
					<xsl:if test="app_link">
						<xsl:copy-of select="." />
					</xsl:if>
				</xsl:for-each>
			</toc1>
		</xsl:result-document>
	</xsl:template>

	<xsl:function name="ast:getName">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
	</xsl:function>

</xsl:stylesheet>
