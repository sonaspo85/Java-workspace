<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" 
    exclude-result-prefixes="xs idPkg ast dita-ot"
    version="3.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
	
    <xsl:param name="srcDirs" />
    
    <!--"C:/Users/SMC/Desktop/IMAGE/qsg/test/[SM-A546B]/temp" 와 같이 폴더 이름에 '[]' 기호가 있는 경우-->
    <xsl:variable name="srcDirs01" select="replace(replace(replace($srcDirs, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="iri-to-uri(concat('file:////', $srcDirs01, '/?select=', '*.xml;recurse=yes'))"  />
    <xsl:variable name="directory" select="collection($srcDirs02)" />
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="/">
        <root>
            <xsl:for-each select="$directory/root">
                <div>
                    <xsl:apply-templates select="@*, node()" />
                </div>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template match="*[parent::listitem]">
        <xsl:variable name="fileName" select="ancestor::root/@fileName" />
        
        <item>
            <!--<xsl:choose>
                <xsl:when test="$fileName = 'unit'">
                    <xsl:attribute name="lgn" select="name()" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:attribute name="lgn" select="replace(replace(name(), '_$', ')'), '(.*)_(.*)', '$1($2')" />
                </xsl:otherwise>
            </xsl:choose>-->
            <xsl:attribute name="lgn" select="replace(replace(name(), '_$', ')'), '(.*)_(.*)', '$1($2')" />
            <xsl:apply-templates select="@*, node()" />
        </item>
    </xsl:template>
    
    <xsl:template match="text()" priority="5">
        <xsl:value-of select="replace(replace(replace(replace(replace(., '&#xA0;', ' '),'&amp;lt;', '&lt;'),'&amp;gt;', '&gt;'), '&amp;quot;', '&quot;'), '”', '')" disable-output-escaping="yes" />
    </xsl:template>
    
</xsl:stylesheet>