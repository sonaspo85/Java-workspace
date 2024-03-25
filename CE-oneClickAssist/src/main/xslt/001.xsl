<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
    <xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" include-content-type="no"/>
	<xsl:preserve-space elements="*"/>
	
	<xsl:param name="srcPath" />
	<xsl:variable name="srcPath11" select="concat('file:////', replace(replace($srcPath, ' ', '%20'), '^(file:/?)(.*)', '$2'))" />
	<xsl:variable name="srcDir" select="collection(concat(replace($srcPath11, '\\', '/'), '/?select=*.html;'))" />
	<xsl:variable name="QRcodes" select="document(concat(replace($srcPath11, '\\', '/'), '/temp/QRcodes.xml'))/root" />
	
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:for-each select="$srcDir/*">
			<xsl:variable name="fileName" select="ast:getLast(base-uri(.), '/')" />
			<xsl:result-document href="{$fileName}">
				<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="img">
		<xsl:variable name="src" select="tokenize(@src, '/')[last()]" />
		
		<xsl:variable name="item0">
			<xsl:for-each select="$QRcodes/listitem[IMG-FileName[matches(., $src)]]">
				<xsl:sequence select="." />
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$QRcodes/listitem[IMG-FileName[matches(., $src)]] and 
							not(parent::a)">
				<a>
					<xsl:attribute name="href" select="replace(normalize-space($QRcodes/listitem[IMG-FileName[matches(., $src)]]/URL-Path), '\s+', '')" />
					<xsl:copy>
						<xsl:apply-templates select="@*, node()" />
					</xsl:copy>
				</a>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="script">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:function name="ast:getLast">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="tokenize($str, $char)[last()]" />
	</xsl:function>
	
	<xsl:function name="ast:getPath">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
	</xsl:function>
	
</xsl:stylesheet>
