<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>


    <xsl:key name="hyperlink" match="*[@hyperkey]" use="@hyperkey" />
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="crossreferencesource">
        <xsl:variable name="key" select="@crosskey" />
        
        <xsl:choose>
            <xsl:when test="$linkPath/linkcollect/Hyperlink/@Source = $key">
                <xsl:variable name="destkey" select="$linkPath/linkcollect/Hyperlink[@Source = $key]/@DestinationUniqueKey" />

                <xsl:if test="key('hyperlink', $destkey)">
                    <xsl:variable name="destkey02" select="key('hyperlink', $destkey)[1]/@hyperkey" />
                    <xsl:variable name="destvalues" select="key('hyperlink', $destkey)[1]" />

                    <span class="see-page">
                        <xsl:element name="a">
                            <xsl:attribute name="href" select="$destkey02" />
                            <xsl:apply-templates select="@* except @crosskey"/>

                            <xsl:choose>
                                <xsl:when test="not(node())">
                                    <xsl:value-of select="$destvalues" />
                                </xsl:when>
                            
                                <xsl:otherwise>
                                    <xsl:apply-templates select="node()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </span>
                </xsl:if>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="image">
        <xsl:variable name="defaultpath" select="'contents/images/'" />

        <xsl:element name="img">
            <xsl:apply-templates select="@* except @href"/>
            <xsl:attribute name="src" select="concat($defaultpath, replace(@href, '(.ai)$', '.png'))" />
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p">
        <xsl:copy>
            <xsl:if test="@hyperkey">
                <xsl:attribute name="id" select="concat('#', @hyperkey)" />
            </xsl:if>

            <xsl:apply-templates select="@* except @hyperkey" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
