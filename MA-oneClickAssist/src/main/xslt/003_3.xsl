<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
	<xsl:strip-space elements="*"/>

	<xsl:param name="tempPath" />
	
	<xsl:variable name="tempPath1" select="concat('file:////', replace(replace($tempPath, ' ', '%20'), '^(file:/?)(.*)', '$2'))" />
	<xsl:variable name="tagsValF" select="document(concat(replace($tempPath1, '\\', '/'), '/tagsValue.xml'))/root" />
	<xsl:variable name="tagsValFName" select="$tagsValF/@fileName" />
	<xsl:variable name="excelLang" select="replace(substring-after($tagsValFName, '-'), '.xlsx', '')" />
	
	<xsl:variable name="getTermVal">
		<xsl:for-each select="$tagsValF/listitem/*">
			<xsl:variable name="cur" select="." />
			<xsl:variable name="langName" select="name($cur)" />
			
			<xsl:if test="$excelLang = $langName">
				<xsl:copy>
					<xsl:attribute name="engVal" select="parent::*/TERM/text()" />
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()"  />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="root">
		<tags>
			<xsl:apply-templates select="node()"  />
		</tags>
	</xsl:template>
	
	<xsl:template match="div[matches(@class, 'h1Group')]">
		<xsl:variable name="sharpVal" select="listitem[1]/*[matches(name(), 'Recommand2')]" />
		
		<xsl:variable name="str0">
			<xsl:choose>
				<xsl:when test="$getTermVal/*/@engVal = substring-after($sharpVal, '#')">
					<xsl:value-of select="concat('#', $getTermVal/*[@engVal[. = substring-after($sharpVal, '#')]])" />
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="$sharpVal" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<tag>
			<xsl:attribute name="value" select="$str0" />
			<xsl:attribute name="value2" select="$str0" />
			
			<xsl:for-each select="listitem">
				<xsl:variable name="style" select="Style" />
				<xsl:variable name="hName">
					<xsl:variable name="num" select="replace($style, '(Heading)(\d)(.*)?', '$2')" />
					<xsl:value-of select="concat('h', $num)" />
				</xsl:variable>
				
				<xsl:variable name="link" select="replace(file_name, '\s+', '-')" />
				<xsl:variable name="icon" select="icon" />
				
				<xsl:element name="{$hName}">
					<xsl:attribute name="link" select="$link" />
					
					<xsl:if test="matches($style, 'Heading1') and 
								  $icon">
						<xsl:attribute name="icon" select="$icon" />
					</xsl:if>
					
					<xsl:value-of select="normalize-space(String/text())" />
				</xsl:element>
			</xsl:for-each>
		</tag>
	</xsl:template>
	
	<!--<xsl:template match="*[matches(name(), 'Recommand2')]">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>-->
	
</xsl:stylesheet>