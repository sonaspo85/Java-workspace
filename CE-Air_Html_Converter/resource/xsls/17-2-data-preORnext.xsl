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

    <xsl:key name="htmls" match="*[@file]" use="@file" />
        
    <xsl:variable name="filenames" as="xs:string*">
        <xsl:for-each select="root()/root/section[@file]/@file">
            <xsl:sequence select="."  />
        </xsl:for-each>
    </xsl:variable>
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[@file]" priority="5">
        <xsl:variable name="getPreFileVal">
            <xsl:call-template name="setPreFileVal">
                <xsl:with-param name="cur" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="getNextFileVal">
            <xsl:call-template name="setNextFileVal">
                <xsl:with-param name="cur" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:copy>
            <xsl:if test="$getPreFileVal">
                <xsl:attribute name="data-prev" select="$getPreFileVal" />
            </xsl:if>

            <xsl:attribute name="data-id" select="@file" />

            <xsl:if test="$getNextFileVal != '#'">
                <xsl:attribute name="data-next" select="$getNextFileVal" />
            </xsl:if>
            
            <xsl:apply-templates select="@* except @file" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template name="setNextFileVal">
        <xsl:param name="cur" />

        <xsl:variable name="filename" select="@file" />
        <xsl:variable name="next" select="key('htmls', $filenames[index-of($filenames, $filename) + 1])" />
        <xsl:variable name="nextFname" select="$next/@file" />

        <xsl:variable name="finalnextval">
            <xsl:choose>
                <xsl:when test="not(following-sibling::section) and 
                                not($nextFname)">
                    <xsl:value-of select="'#'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="$nextFname" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$finalnextval" />
    </xsl:template>

    <xsl:template name="setPreFileVal">
        <xsl:param name="cur" />

        <xsl:variable name="filename" select="@file" />
        <xsl:variable name="pre" select="key('htmls', $filenames[index-of($filenames, $filename) - 1])" />
        <xsl:variable name="preFname" select="$pre/@file" />

        <xsl:variable name="finalpreval">
            <xsl:choose>
                <xsl:when test="(index-of($filenames, $filename) - 1) = 0">
                    <xsl:value-of select="'start_here.html'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="$preFname" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$finalpreval" />
    </xsl:template>

</xsl:stylesheet>
