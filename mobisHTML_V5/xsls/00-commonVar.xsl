<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:x="adobe:ns:meta/"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
    exclude-result-prefixes="xs idPkg x rdf dc ast"
    version="2.0">

    <xsl:variable name="UI_textDATA" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))" />
    <xsl:variable name="searchHeadFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'search-head.xml'))" />
    <xsl:variable name="contentHeadFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'content-head.xml'))" />
    <xsl:variable name="Sangyong">
        <xsl:choose>
            <xsl:when test="matches($UI_textDATA/root/@fileName, '_CV_')">
                <xsl:value-of select="'1'" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="'0'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    
    
    <!--<xsl:template name="fontInsert">
        <xsl:param name="pos" />
        <xsl:param name="Sangyong" />
        
        <xsl:choose>
            <xsl:when test="$Sangyong = 1">
                <xsl:choose>
                    <xsl:when test="$pos = 1">
                        <link rel="stylesheet" href="./styles/fonts/HyundaiSans/stylesheet.css"/>
                    </xsl:when>
                    
                    <xsl:when test="$pos = 2" />
                    <xsl:when test="$pos = 3" />
                    <xsl:when test="$pos = 4" />
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$Sangyong = 0">
                <xsl:choose>
                    <xsl:when test="$pos = 1" />
                    
                    <xsl:when test="$pos = 2">
                        <link rel="stylesheet" href="./styles/fonts/notoSansAr/stylesheet.css"/>
                    </xsl:when>
                    
                    <xsl:when test="$pos = 3">
                        <link rel="stylesheet" href="./styles/fonts/notoSansInd/stylesheet.css"/>
                    </xsl:when>
                    
                    <xsl:when test="$pos = 4">
                        <link rel="stylesheet" href="./styles/fonts/genesis/stylesheet.css" />
                        <link rel="stylesheet" href="./styles/fonts/NotoSansCJKjp/stylesheet.css" />
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    
</xsl:stylesheet>