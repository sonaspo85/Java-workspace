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
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:variable name="videokeyF" select="document(concat($tempDir, '/19-create-body-header.xml'))/root" />

    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:for-each select="$videolinkPath/root">
            <xsl:copy>
                <xsl:variable name="var0">
                    <xsl:for-each-group select="listitem" group-by="child::Type[1]">
                        <xsl:choose>
                            <xsl:when test="current-grouping-key()">
                                <listitem type="{current-group()[1]/Type[1]}">
                                    <xsl:apply-templates select="current-group()/node()" />
                                </listitem>
                            </xsl:when>
                    
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:variable>

                <xsl:for-each select="$var0/listitem">
                    <xsl:copy>
                        <xsl:apply-templates select="@*"/>

                        <xsl:for-each-group select="*" group-by="tokenize(@class, ':')[1]">
                            <xsl:choose>
                                <xsl:when test="current-grouping-key()">
                                    <div>
                                        <xsl:attribute name="key" select="current-group()[name()='Key']" />
                                        <xsl:attribute name="href" select="current-group()[name()='Link']" />
                                        <xsl:for-each select="current-group()">
                                            <xsl:choose>
                                                <xsl:when test="self::*[matches(name(), '^(Key|Link|Type)$')]">
                                                </xsl:when>
                                                
                                                <!-- <xsl:when test="not(node())">
                                                </xsl:when> -->

                                                <xsl:otherwise>
                                                    <xsl:copy>
                                                        <xsl:apply-templates select="@* | node()"/>
                                                    </xsl:copy>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </div>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:copy>
                </xsl:for-each>

                <videoKey>
                    <xsl:for-each select="$videokeyPath/listitem">
                        <xsl:copy>
                            <xsl:attribute name="key" select="child::Key[1]/text()" />
                            <xsl:apply-templates select="@*" />
                            <xsl:apply-templates select="child::*[not(name()='Key')]" />
                        </xsl:copy>
                    </xsl:for-each>
                </videoKey>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
