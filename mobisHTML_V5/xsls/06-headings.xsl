<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p" />

    <xsl:variable name="ch-images" select="/body/chapter/*[1][name()='img']" />
    <xsl:variable name="ch-images1" select="'../resource/ch-images.xml'" />

    <xsl:template match="/">
        <xsl:result-document href="{$ch-images1}" omit-xml-declaration="yes">
            <images>
                <xsl:for-each select="$ch-images">
                    <xsl:variable name="pos">
                        <xsl:value-of select="parent::chapter[@idml]/xs:integer(substring-before(@idml, '_')) - 3" />
                    </xsl:variable>
                    <xsl:text>&#xA;&#x9;</xsl:text>
                    
                    <image idx="{format-number($pos, '000')}" src="{replace(@src, 'contents/', '')}" />
                </xsl:for-each>
                <xsl:text>&#xA;</xsl:text>
            </images>
        </xsl:result-document>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="if ( not(following-sibling::node()) ) then replace(., '\s+$', ' ') else ." />
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="self::chapter[matches(@idml, 'Basic')]">
                <chapter>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:if test="position()=3">
                            <xsl:apply-templates select="ancestor::chapter/preceding-sibling::chapter[1]/node()" />
                        </xsl:if>
                        <xsl:apply-templates select="." />
                    </xsl:for-each>
                </chapter>
            </xsl:when>
            
            <xsl:when test="self::chapter[following-sibling::chapter[1][matches(@idml, 'Basic')]]">
            </xsl:when>
            
            <xsl:otherwise>
                <chapter>
                    <xsl:apply-templates select="@*, node()" />
                </chapter>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p[parent::chapter]">
        <xsl:choose>
            <xsl:when test="parent::chapter[matches(@idml, 'Readmefirst')]">
                <xsl:variable name="cur" select="." />
                <xsl:call-template name="Readme_chapter">
                    <xsl:with-param name="cur" select="$cur" />
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with(@class, 'Chapter')">
                        <h0>
                            <xsl:apply-templates select="@* | node()" />
                        </h0>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading1') or 
                                    ends-with(@class, 'H1')">
                        <xsl:choose>
                            <xsl:when test="parent::chapter[not(following-sibling::chapter)]/*[matches(@class, 'Heading1-Continue')]">
                                <p1 class="{@class}">
                                    <xsl:apply-templates select="@id | node()" />
                                </p1>
                            </xsl:when>

                            <xsl:when test="parent::chapter[not(preceding-sibling::chapter)] and matches(@class, 'Heading1-Continue')">
                                <p1 class="{@class}">
                                    <xsl:apply-templates select="@id | node()" />
                                </p1>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <h1 class="{@class}">
                                    <xsl:apply-templates select="@id | node()" />
                                </h1>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading2')">
                        <h2 class="{@class}">
                            <xsl:apply-templates select="@* except @id" />
                            <xsl:apply-templates select="@id | node()" />
                        </h2>
                    </xsl:when>

                    <xsl:when test="@class='Description-GrayBox'">
                        <h2 class="{@class}">
                            <xsl:apply-templates select="@id" />
                            <xsl:attribute name="class">graybox</xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </h2>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading3')">
                        <h3 class="{@class}">
                            <xsl:apply-templates select="@id | node()" />
                        </h3>
                    </xsl:when>

                    <xsl:when test="contains(@class, 'Heading4')">
                        <h4 class="{@class}">
                            <xsl:apply-templates select="@id | node()" />
                        </h4>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Readme_chapter">
        <xsl:param name="cur" />

        <xsl:choose>
            <xsl:when test="starts-with(@class, 'Chapter')">
                <h1>
                    <xsl:attribute name="class" select="'Heading1'" />
                    <xsl:apply-templates select="@id | node()" />
                </h1>
            </xsl:when>

            <xsl:when test="contains(@class, 'Heading1') or 
                            ends-with(@class, 'H1')">
                <h2 class="Heading2">
                    <xsl:apply-templates select="@id | node()" />
                </h2>
            </xsl:when>

            <xsl:when test="contains(@class, 'Heading2')">
                <h3 class="Heading3">
                    <xsl:apply-templates select="@id | node()" />
                </h3>
            </xsl:when>

            <xsl:when test="@class='Description-GrayBox'">
                <h3 class="{@class}">
                    <xsl:apply-templates select="@id" />
                    <xsl:attribute name="class">graybox</xsl:attribute>
                    <xsl:apply-templates select="node()" />
                </h3>
            </xsl:when>

            <xsl:when test="contains(@class, 'Heading3')">
                <h4 class="Heading4">
                    <xsl:apply-templates select="@id | node()" />
                </h4>
            </xsl:when>

            <xsl:when test="contains(@class, 'Heading4')">
                <h5 class="Heading5">
                    <xsl:apply-templates select="@id | node()" />
                </h5>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table[parent::chapter]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img[parent::chapter]">
        <xsl:if test="preceding-sibling::*">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()" />
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="br[parent::p[matches(@class, '(Chapter|Heading1|Heading2)')]]">
    </xsl:template>
    
    <xsl:template match="span[matches(@class, 'C_URL')][a[ends-with(., '.')]]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::a[ends-with(., '.')]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:value-of select="replace(., '(.)$', '')" />
                        </xsl:copy>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
        <xsl:text>.</xsl:text>
    </xsl:template>

</xsl:stylesheet>