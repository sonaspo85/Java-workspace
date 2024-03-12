<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:functs="http://www.functs.com"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:functx="http://www.functx.com"
	exclude-result-prefixes="xs functs fn">

	<xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="yes" />
	<xsl:param name="targetPath" />
	
	<xsl:variable name="target" select="replace(replace($targetPath, '\\', '/'), ' ', '%20')"/>

	<xsl:variable name="dummyPath" select="collection(concat('file:////', $target, '/?select=index.html;recurse=yes'))"/>
	<xsl:variable name="infoPath" select="collection(concat('file:////', $target, '/?select=Info.html;recurse=yes'))"/>
	
	<xsl:variable name="eachPath">
		<xsl:for-each select="$dummyPath">
			<xsl:variable name="uriExtract" select="resolve-uri('js/search_db.js', concat(string-join(tokenize(document-uri(/), '/')[position() ne last()], '/'), '/'))"/>
			<path src="{$uriExtract}" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="eachInfoPath">
		<xsl:for-each select="$dummyPath">
			<xsl:variable name="uriExtract" select="resolve-uri('Info.html', concat(string-join(tokenize(document-uri(/), '/')[position() ne last()], '/'), '/'))"/>
			<path src="{$uriExtract}" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="infoTitle">
		<xsl:for-each select="$eachInfoPath/path/@src">
			<xsl:variable name="cur" select="."/>
			<xsl:variable name="fullPath" select="replace(string-join(tokenize($cur, '/')[position() ne last()], '/'), ' ', '%20')" />
			<xsl:variable name="splitPath">
				<xsl:variable name="eachPath" select="resolve-uri($fullPath)"/>
				
				<xsl:value-of select="replace(replace($eachPath, $target, ''), '/$', '')"/>
			</xsl:variable>
			
			<xsl:for-each select="unparsed-text($cur, 'utf-8')">
				<xsl:analyze-string select="." regex="(&quot;title&quot;&gt;)(.*?)(&lt;)">
					<xsl:matching-substring>
						<xsl:element name="title">
							<xsl:attribute name="class" select="$splitPath" />
							<xsl:value-of select="regex-group(2)"/>
						</xsl:element>
					</xsl:matching-substring>
					<!-- <xsl:non-matching-substring>
						<xsl:analyze-string select="." regex="(&quot;manual&quot;&gt;)(.*?)(&lt;)">
							<xsl:matching-substring>
								<xsl:element name="manual">
									<xsl:attribute name="class" select="$splitPath" />
									<xsl:value-of select="regex-group(2)"/>
								</xsl:element>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</xsl:non-matching-substring> -->
				</xsl:analyze-string>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	
	
	<xsl:param name="text-encoding" as="xs:string" select="'utf-8'"/>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
    	</xsl:copy>
    </xsl:template>
	
	<xsl:template match="@* | node()" mode="abc">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="abc" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:text>var search=[</xsl:text>
		<xsl:for-each select="$eachPath/path/@src">
			<xsl:variable name="cur" select="."/>
			<xsl:variable name="fullPath" select="string-join(tokenize($cur, '/')[position() ne last()], '/')" />
			<xsl:variable name="splitPath">
				<xsl:variable name="eachPath" select="resolve-uri('.', $fullPath)"/>
				
				<xsl:value-of select="replace(replace($eachPath, $target, ''), '/$', '')"/>
			</xsl:variable>
			
			<xsl:variable name="title" select="$infoTitle/title[@class=$splitPath]"/>
			<xsl:variable name="manual" select="$infoTitle/manual[@class=$splitPath]"/>
			<xsl:variable name="path" select="$infoTitle/title[@class=$splitPath]/@class" />
			
			<xsl:if test="unparsed-text-available($cur)">
				<xsl:for-each select="unparsed-text($cur, 'utf-8')">
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>{</xsl:text>
					<xsl:text>&#xa;</xsl:text>
					
					<xsl:text>&quot;title&quot;:</xsl:text>
					<xsl:value-of select="concat('&quot;', $title, '&quot;')" />
					<xsl:text>,&#xa;</xsl:text>
					
					<xsl:text>&quot;path&quot;:</xsl:text>
					<xsl:value-of select="concat('&quot;', replace($path, 'file:/', ''), '&quot;')" />
					<xsl:text>,&#xa;</xsl:text>
					<xsl:text>&quot;content&quot;: [</xsl:text>
					
					<xsl:call-template name="reaplceText">
						<xsl:with-param name="cur" select="." />
					</xsl:call-template>
					<xsl:text>]</xsl:text>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="position() != last()">
						<xsl:value-of select="'},'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'}'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	</xsl:template>
	
	<xsl:template name="reaplceText">
		<xsl:param name="cur" />
		
		<xsl:analyze-string select="." regex="(var search=\&#x5B;)">
			<xsl:matching-substring>
			</xsl:matching-substring>
			
			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="(\n\])">
					<xsl:matching-substring>
					</xsl:matching-substring>
					
					<xsl:non-matching-substring>
						<xsl:value-of select="." disable-output-escaping="yes"/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	

	<xsl:function name="functs:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>

	<xsl:function name="functs:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
</xsl:stylesheet>