<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>

    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="isocode" select="@isocode" />
        <!-- <xsl:variable name="filename" select="concat('file:////', $srcDir, '/output/', $isocode, '/search/search.html')" /> -->
        <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when test="number($langmapCnt) &gt; 1">
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', upper-case(concat($type, '_', $isocode)), '/', 'search/search.html')" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', 'search/search.html')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:result-document href="{$filename}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <html>
                <xsl:attribute name="data-key" select="'search-page'" />
                <xsl:attribute name="data-language" select="$isocode" />
                <xsl:attribute name="lang" select="$isocode" />

                <xsl:attribute name="dir">
                    <xsl:choose>
                        <xsl:when test="matches($isocode, '^(ar)$')">
                            <xsl:value-of select="'rtl'" />
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:value-of select="'ltr'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>

                <xsl:copy-of select="$body-header/root/div[matches(@class, 'search')]/*" />

                <body id="body">
                    <div id="wrap">
                        <xsl:for-each select="$navF/header">
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" mode="abc" />
                            </xsl:copy>
                        </xsl:for-each>

                        <main id="main">
                            <section class="cont">
                                <div id="id_results"> </div>
                                <div id="id_results2"> </div>
                            </section>
                        </main>

                        <xsl:copy-of select="$body-footer/root/*" />
                    </div>

                    <script src="../common/js/common.js">&#xFEFF;</script>
                    <script src="../common/js/contents.js">&#xFEFF;</script>
                </body>
            </html>
        </xsl:result-document>
        
        <dummy />
    </xsl:template>

    <xsl:template match="@*[ancestor::div[matches(@class, 'header_top')]]" mode="abc">
        <xsl:choose>
            <xsl:when test="matches(name(.), '(href|src)') and 
                            parent::*[matches(local-name(), '^(a|img)$')]">
                <xsl:attribute name="{name()}" select="concat('.', .)" />
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:attribute name="{name()}" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
