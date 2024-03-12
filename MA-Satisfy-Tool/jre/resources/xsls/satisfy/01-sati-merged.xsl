<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="excelDirs" />
    <xsl:param name="scoreF" />

    <xsl:variable name="tempDir01" select="replace(replace(replace(replace($excelDirs, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="directory01" select="collection(iri-to-uri(concat('file:////', $tempDir01, '/?select=', '*.xml;recurse=no')))" />
	
    <xsl:variable name="excelDirs02" select="replace(replace(replace(replace($scoreF, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="directory02" select="document(iri-to-uri($excelDirs02))" />
    
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="/">
        <root>
            <satisfyexcelDB>
                <xsl:for-each select="$directory01/root">
                    <xsl:sort select="@filename" />
                    <xsl:variable name="filename" select="ast:getPath(replace(@filename, '.xlsx', ''), '_')" />
    
                    <div>
                        <xsl:apply-templates select="@*" />
                        <xsl:attribute name="filename" select="$filename" />
                        
                        <xsl:apply-templates select="node()" />
                    </div>
                </xsl:for-each>
            </satisfyexcelDB>
            
            <scoreDB>
                <xsl:copy-of select="$directory02/root/*" />
            </scoreDB>
        </root>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="@*[matches(local-name(), 't\dcell1')] = ''">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="time" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')" />
                
                <xsl:variable name="num">
                    <xsl:number level="any" from="root" />
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:if test="not(ancestor::*[matches(name(), '(satisfy|safety)')])">
                        <xsl:attribute name="uniqueKey" select="concat(generate-id(), $time, $num)" />
                    </xsl:if>
                    
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="items">
        <xsl:choose>
            <xsl:when test="ancestor::satisfy">
                <xsl:variable name="time" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')" />
                
                <xsl:variable name="num">
                    <xsl:number level="any" from="root" />
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:attribute name="uniqueKey" select="concat(generate-id(), $time, $num)" />
                    
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:choose>
            <xsl:when test="ancestor::safety">
                <xsl:variable name="time" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')" />
                
                <xsl:variable name="num">
                    <xsl:number level="any" from="root" />
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:attribute name="uniqueKey" select="concat(generate-id(), $time, $num)" />
                    
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
    
    <xsl:function name="ast:Last">
        <xsl:param name="str" />
        <xsl:param name="char" />
        
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>