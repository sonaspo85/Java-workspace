<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast ">



	<xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
	<xsl:strip-space elements="*" />

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@* | node()" mode="abc">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="abc"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<root>
			<xsl:attribute name="sourcePath">
				<xsl:value-of select="root/@sourcePath"/>
			</xsl:attribute>
			<html>
				<head>
					<title>User Manual</title>
					<xsl:apply-templates select="root/html[1]/head/*[3]" />
				</head>
				<body>
				<xsl:for-each select="root/html/body">
					<MadCap:section>
						<xsl:apply-templates select="node()" mode="abc" />
					</MadCap:section>
	            </xsl:for-each>
				</body>
			</html>
		</root>
    </xsl:template>

	<xsl:template match="*[matches(@class, '(.+)&#x20;KeepWithNext')]" mode="abc">
		<xsl:copy>
			<xsl:attribute name="class" select="substring-before(@class, ' ')" />
			<xsl:apply-templates select="@* except @class" />
			<xsl:apply-templates select="node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
	
	<xsl:function name="ast:normalized">
		<xsl:param name="value"/>
		<xsl:value-of select="replace(replace(replace(normalize-space(replace($value, '\+', '_plus')), '[!@#$%&amp;();:.,’?]+', ''), '[ &#xA0;]', '_'), '/', '_')"/>
	</xsl:function>
	
</xsl:stylesheet>
