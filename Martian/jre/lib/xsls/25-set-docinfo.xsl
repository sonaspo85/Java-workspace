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
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="root">
        <xsl:variable name="langmapCnt" select="count(tokenize(child::item[@id = 'langsMap']/@sequence, ','))" />
        <xsl:variable name="tempDir" select="child::item[@id ='tempDir']/@path"/>
        <xsl:variable name="srcDir" select="child::item[@id ='srcDir']/@path"/>
        <xsl:variable name="type" select="@type" />
        <xsl:variable name="modelcode" select="@modelNumber" />
        <xsl:variable name="eachsrcpath" select="collection(concat('file:////', $tempDir, '/eachSrc/', '?select=*.xml;recurse=yes'))"/>

        <xsl:variable name="workinglng">
            <xsl:for-each select="$eachsrcpath/root">
                <xsl:variable name="isocode" select="@isocode" />

                <item>
                    <xsl:attribute name="id" select="'workinglngs'" />
                    <xsl:apply-templates select="@*" />

                    <xsl:variable name="outputP">
                        <xsl:choose>
                            <xsl:when test="number($langmapCnt) &gt; 1">
                                <xsl:value-of select="concat($srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', upper-case(concat($type, '_', $isocode)))" />
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:value-of select="concat($srcDir, '/output/', upper-case(concat($type, '_', $modelcode)))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="srcimgP">
                        <xsl:value-of select="concat($srcDir, '/', $isocode, '/images')" />
                    </xsl:variable>

                    <xsl:attribute name="outputpath" select="$outputP" />
                    <xsl:attribute name="srcimgpath" select="$srcimgP" />
                </item>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:copy-of select="$workinglng" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
