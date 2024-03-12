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

    <!-- <xsl:variable name="navF" select="document(concat($tempDir, '/19-create-body-header.xml'))/root" /> -->
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="root">
        <xsl:variable name="isocode" select="@isocode" />

        <xsl:for-each select="section">
            <xsl:variable name="cur" select="." />
            <!-- <xsl:variable name="filename" select="concat('file:////', $srcDir, '/output/', $isocode, '/', @data-id)" /> -->
            <xsl:variable name="filename">
                <xsl:choose>
                    <xsl:when test="number($langmapCnt) &gt; 1">
                        <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', upper-case(concat($type, '_', $isocode)), '/', @data-id)" />
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', @data-id)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
                <html>
                    <xsl:attribute name="data-key" select="'cont-page'" />
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

                    <xsl:copy-of select="$body-header/root/div[matches(@class, 'body')]/*" />

                    <body>
                        <div id="wrapper">
                            <xsl:copy-of select="$navF/header" />

                            <main id="main">
                                <xsl:apply-templates select="@*" />

                                <section class="chapter">
                                    <xsl:apply-templates select="$cur/node()" />
                                </section>
                            </main>

                            <xsl:copy-of select="$body-footer/root/*" />
                        </div>

                        <script src="./js/common.js">&#xFEFF;</script>
                        <script src="./js/contents.js">&#xFEFF;</script>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- <xsl:variable name="aaa1">
            <xsl:for-each select="$docinfo/root">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:variable> -->

        <dummy />
    </xsl:template>


</xsl:stylesheet>
