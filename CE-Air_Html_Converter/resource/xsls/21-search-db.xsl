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
    
    <xsl:variable name="divs" select="descendant::div[matches(@class, '^Heading[12]')]" />

    <xsl:template match="root">
        <xsl:variable name="isocode" select="@isocode" />
        <!-- <xsl:variable name="filename" select="concat('file:////', $srcDir, '/output/', $isocode, '/search/jsons/search_db.js')" /> -->
        <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when test="number($langmapCnt) &gt; 1">
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/',  upper-case(concat($type, '_', $modelcode)), '/', upper-case(concat($type, '_', $isocode)), '/', 'search/jsons/search_db.js')" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', 'search/jsons/search_db.js')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:result-document href="{$filename}">
            <xsl:text>var search=[</xsl:text>
            
            <xsl:for-each select="$divs">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="class" select="@class" />

                <xsl:variable name="body">
                    <xsl:choose>
                        <xsl:when test="matches($class, '^Heading1')">
                            <xsl:apply-templates select="*" mode="body" />
                        </xsl:when>

                        <xsl:when test="matches($class, '^Heading2')">
                            <xsl:apply-templates select="*[local-name() != 'h3']" mode="body" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="*" mode="body" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:text>&#xa;{</xsl:text>
                <xsl:text disable-output-escaping='yes'>&#xa;&#x9;"body": "</xsl:text>
                <xsl:value-of select="normalize-space(replace(replace($body, '&#xA0;', ' '), '&quot;', ''))" disable-output-escaping="yes" />
                <xsl:text disable-output-escaping='yes'>",</xsl:text>

                <!-- ******************************************************* -->
                <xsl:variable name="title">
                    <xsl:choose>
                        <xsl:when test="matches($class, '^Heading2')">
                            <xsl:value-of select="ancestor::div[1][matches(@class, 'Heading1')]/h2" />
                        </xsl:when>

                        <xsl:when test="matches($class, '^Heading1')">
                            <xsl:apply-templates select="*[1][local-name()= 'h2']" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#xa;&#x9;"title": "</xsl:text>
                <xsl:value-of select="$title" />
                <xsl:text disable-output-escaping='yes'>",</xsl:text>
                
                <!-- ******************************************************* -->
                <xsl:variable name="title2">
                    <xsl:choose>
                        <xsl:when test="matches($class, '^Heading2')">
                            <xsl:apply-templates select="*[1][local-name()= 'h3']" />
                        </xsl:when>

                        <xsl:when test="matches($class, '^Heading1')">
                            <xsl:value-of select="''" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#xa;&#x9;"title2": "</xsl:text>
                <xsl:value-of select="$title2" />
                <xsl:text disable-output-escaping='yes'>",&#xa;</xsl:text>
                
                <!-- ******************************************************* -->
                <xsl:variable name="tocid">
                    <xsl:value-of select="*[1][matches(local-name(), '^h')]/@ast-id" />
                </xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#x9;"toc_id": "</xsl:text>
                <xsl:value-of select="concat('#', $tocid)" />
                <xsl:text disable-output-escaping='yes'>",&#xa;</xsl:text>

                <!-- ******************************************************* -->
                <xsl:variable name="chapter">
                    <xsl:value-of select="ancestor::section[1]/h1" />
                </xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#x9;"chapter": "</xsl:text>
                <xsl:value-of select="$chapter" />
                <xsl:text disable-output-escaping='yes'>",&#xa;</xsl:text>

                <!-- ******************************************************* -->
                <xsl:variable name="chapterI">
                    <xsl:value-of select="count(ancestor::section[1]/preceding-sibling::section) + 1" />
                </xsl:variable>

                <xsl:text disable-output-escaping='yes'>&#x9;"chapter_i": "</xsl:text>
                <xsl:value-of select="$chapterI" />
                <xsl:text disable-output-escaping='yes'>"&#xa;</xsl:text>

                <xsl:choose>
                    <xsl:when test="position() = last()">
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:text>}, </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <xsl:text>]</xsl:text>
        </xsl:result-document>
        
        <dummy />
    </xsl:template>

    <xsl:template match="ul | ol | li | p | td | br | *[starts-with(name(), 'h')] | img| span | b | i" mode="body">
        <xsl:text>&#x20;</xsl:text>
        <xsl:apply-templates mode="body" />
        <xsl:text>&#x20;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
