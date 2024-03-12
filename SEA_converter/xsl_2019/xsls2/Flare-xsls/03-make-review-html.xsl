<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p li" />

    <xsl:template match="html">
        <xsl:text>&#xA;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:text>&#xA;</xsl:text>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="head">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:text>&#xA;&#x9;</xsl:text>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="title">
        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="link">
        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:attribute name="href">review.css</xsl:attribute>
            <xsl:apply-templates select="@rel" />
            <xsl:apply-templates select="@type" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@* | node()" mode="ddd">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="ddd" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:text>&#xA;&#x9;</xsl:text>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="table">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="*[not(following-sibling::*)][name()='ol'] and following-sibling::*[1][name()='ol']">
                <xsl:call-template name="recall">
                    <xsl:with-param name="cur" select="." />
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="*[1][name()='div'][matches(@class, 'KeepTogether')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:call-template name="recall">
                            <xsl:with-param name="cur" select="." />
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="recall">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="*[not(following-sibling::*)][name()='ol'] and following-sibling::*[1][name()='ol']">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                    <xsl:if test="following-sibling::*[1][name()='ol']">
                        <xsl:for-each select="following-sibling::*[1][name()='ol']">
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" />
                            </xsl:copy>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="self::*[name()='ol'][preceding-sibling::*[1][name()='div']/*[last()][name()='ol']]">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[preceding-sibling::*[1][name()='div']/*[last()][name()='ol']]" priority="10">
    </xsl:template>

    <xsl:template match="*[parent::*[name()='div']]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="h1 | h2 | h3 | h4 | p | ol | ul">
        <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img/@src">
        <xsl:variable name="str0" select="ast:getName(., '/')" />
        <xsl:attribute name="src">
            <xsl:value-of select="concat('images/', lower-case(normalize-space($str0)))" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="p[@class='Graphic'][not(img)]">
    </xsl:template>

    <xsl:template match="li">
        <xsl:text>&#xA;&#x9;&#x9;&#x9;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::p[@class='Step-Body']">
                        <xsl:apply-templates select="." />
                    </xsl:when>
                    <xsl:when test="self::p[preceding-sibling::*[1][@class!='Step-Body']]">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>

        <xsl:if test="not(following-sibling::li)">
            <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="a">
        <xsl:choose>
            <xsl:when test="matches(., '^“.*”$')">
                <xsl:if test="matches(., '^\s+')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:value-of select="normalize-space(.)" />
                </xsl:copy>
                <xsl:if test="matches(., '\s+$')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="parent::li and @href='https://www.samsung.com/us/Legal/SamsungLegal-EULA4/#SPANISH' and 
                            following-sibling::a[@href='https://www.samsung.com/us/Legal/SamsungLegal-EULA4/#SPANISH']">
                <xsl:if test="matches(., '^\s+')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:value-of select="substring-after(@href, 'https://www.')" />
                </xsl:copy>
                <xsl:if test="matches(., '\s+$')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="parent::li and @href='https://www.samsung.com/us/Legal/SamsungLegal-EULA4/#SPANISH' and 
                            preceding-sibling::a[@href='https://www.samsung.com/us/Legal/SamsungLegal-EULA4/#SPANISH']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="matches(., '^\s+')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:value-of select="normalize-space(.)" />
                </xsl:copy>
                <xsl:if test="matches(., '\s+$')">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="b">
        <xsl:if test="matches(., '^[\s&#xA0;]+')">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@* except @href" />
            <xsl:choose>
                <xsl:when test="*">
                    <xsl:apply-templates select="node()" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
        <xsl:if test="matches(., '[\s&#xA0;]$')">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@id">
        <xsl:attribute name="id">
            <xsl:value-of select="replace(., '[’,;]', '')" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@href">
        <xsl:attribute name="href">
            <xsl:value-of select="replace(., '[’,;]', '')" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:choose>
            <xsl:when test="(parent::p or parent::li) and not(preceding-sibling::node())">
                <xsl:value-of select="replace(., '^\s+', '')" />
            </xsl:when>
            
            <xsl:when test="(parent::p or parent::li) and not(following-sibling::node())">
                <xsl:value-of select="replace(., '\s+$', '')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="replace(., '^\s+', '&#x20;')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>