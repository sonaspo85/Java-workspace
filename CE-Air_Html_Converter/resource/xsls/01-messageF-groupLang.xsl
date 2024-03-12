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
    <xsl:param name="docinfoF" />

    <xsl:import href="00-commonVar.xsl" />
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="isocode" select="root()/root/@isocode" />

    <xsl:template match="/">
        <xsl:variable name="var0">
            <root>
                <xsl:for-each select="$msgPath/listitem">
                    <xsl:copy>
                        <xsl:apply-templates select="@*"/>

                        <xsl:for-each select="*">
                            <xsl:variable name="name" select="local-name()" />
                            <xsl:variable name="key" select="parent::*/Key[1]" />
                            <xsl:choose>
                                <xsl:when test="not(matches($name, 'Key'))">
                                    <xsl:element name="{$key}">
                                        <xsl:attribute name="lang" select="$name" />
                                        <xsl:apply-templates select="@*, node()" />
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </root>
        </xsl:variable>

        <root>
            <xsl:attribute name="isocode" select="lower-case($isocode)" />

            <xsl:for-each-group select="$var0/root/listitem/*" group-by="@lang">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <listitem>
                            <xsl:attribute name="lang" select="current-group()[1]/@lang" />
                            <!-- <xsl:apply-templates select="current-group()" /> -->
                            <xsl:for-each select="current-group()">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* except @lang"/>
                                    <xsl:apply-templates select="node()"/>
                                </xsl:copy>
                            </xsl:for-each>
                        </listitem>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </root>
    </xsl:template>

    <xsl:template match="text()" priority="5">
        <xsl:analyze-string select="." regex="(&amp;lt;br/&amp;gt;)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" disable-output-escaping="yes" />
            </xsl:matching-substring>

            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

</xsl:stylesheet>
