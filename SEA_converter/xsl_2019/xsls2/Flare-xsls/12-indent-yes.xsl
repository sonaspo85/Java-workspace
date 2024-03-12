<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
	version="2.0">

    <xsl:variable name="class" select="document(concat(ast:getName(base-uri(.), '/'), '/../xsl_2019/xsls2/Flare-xsls/', 'defined-class.xml'))" />
    <xsl:variable name="class-regex" select="string-join($class/def/class, '|')" />

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="td li p" />

    <xsl:variable name="cr1" select="'&#xA;'" />
    <xsl:variable name="sp1" select="'&#x20;'" />
    <xsl:variable name="crt1" select="'&#xA;&#x9;'" />
    <xsl:variable name="crt2" select="'&#xA;&#x9;&#x9;'" />
    <xsl:variable name="crt3" select="'&#xA;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt4" select="'&#xA;&#x9;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt5" select="'&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt6" select="'&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;'" />

    <xsl:template match="html">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:value-of select="$cr1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="head">
        <xsl:value-of select="$crt1" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:value-of select="$crt1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="title">
        <xsl:value-of select="$crt2" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="link">
        <xsl:value-of select="$crt2" />
        <xsl:copy>
             <xsl:attribute name="href">xsls\review.css</xsl:attribute>
            <xsl:apply-templates select="@rel" />
            <xsl:apply-templates select="@type" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="count(node())=1 and img">
                <xsl:apply-templates select="img" />
            </xsl:when>
            <xsl:when test="count(*)=0 and .='&#xA0;'">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p[parent::li][not(@class)][not(preceding-sibling::p[@class='Step-Body'])]" priority="15">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
    </xsl:template>

    <xsl:template match="@divclass[.='KeepTogether']">
    </xsl:template>

    <xsl:template match="div[count(@*) = 0]">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="div[starts-with(lower-case(@class), 'keep')]">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@class">
        <xsl:choose>
            <xsl:when test="lower-case(.)='step-intro'">
                <xsl:attribute name="class">
                    <xsl:value-of select="lower-case(.)" />
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="lower-case(.)='subsection'">
                <xsl:attribute name="class">
                    <xsl:value-of select="lower-case(.)" />
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="lower-case(.)='screenshot' or lower-case(.)='hardware'">
                <xsl:attribute name="class">block</xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with(lower-case(.), 'step')">
                <xsl:if test="matches(lower-case(.), 'step-body')">
                    <xsl:attribute name="class">step-body</xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:when test="starts-with(lower-case(.), 'bullet')" />
            <xsl:when test="starts-with(lower-case(.), 'navigationh2spacing')" />
            <xsl:when test="starts-with(lower-case(.), 'columnbreakbefore')" />
            <xsl:when test="starts-with(lower-case(.), 'sub')" />
            <xsl:when test="starts-with(lower-case(.), 'keep')" />
            <xsl:when test="starts-with(lower-case(.), 'carrier')" />
            <xsl:when test="ends-with(lower-case(.), 'instructions')" />
            <xsl:when test="lower-case(.)='linebreak' or lower-case(.)='icon' or lower-case(.)='cb'" />
            <xsl:otherwise>
                <xsl:attribute name="class">
                    <xsl:value-of select="lower-case(.)" />
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="b[preceding-sibling::node()[1][self::*]]">
        <xsl:value-of select="$sp1" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sup | span">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="body">
        <xsl:value-of select="$crt1" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:value-of select="$crt1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="table">
        <xsl:value-of select="$crt2" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="h1 | h2 | h3 | h4 | body/p | div/p">
        <xsl:value-of select="$crt2" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/ol/li/p | body/ul/li/p | div/ol/li/p | div/ul/li/p">
        <xsl:value-of select="$crt4" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/ol | body/ul | div/ol | div/ul">
        <xsl:value-of select="$crt2" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:value-of select="$crt2" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/ol/li/ul | body/ul/li/ul | div/ol/li/ul | div/ul/li/ul">
        <xsl:value-of select="$crt4" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:value-of select="$crt4" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/ol/li/ul/li | body/ul/li/ul/li | div/ol/li/ul/li | div/ul/li/ul/li">
        <xsl:value-of select="$crt5" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body/ol/li | body/ul/li | div/ol/li | div/ul/li">
        <xsl:value-of select="$crt3" />
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <xsl:if test="ul or p">
                <xsl:value-of select="$crt3" />
            </xsl:if> 
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="@class='block'">
                <xsl:value-of select="$crt2" />
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                </xsl:copy>
            </xsl:when>
            <xsl:when test="not(@class) or matches(lower-case(@class), $class-regex)">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$crt2" />
                <xsl:copy>
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:attribute name="class">block</xsl:attribute>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:choose>
            <xsl:when test=".= ' ' and preceding-sibling::*[1][name()='b'] and following-sibling::*[1][name()='span'][.='.']">
            </xsl:when>
            <xsl:when test="(parent::p or parent::li or parent::td) and not(preceding-sibling::node())">
                <xsl:value-of select="replace(., '^\s+', '')" />
                <xsl:if test="matches(., '(.+)([^\s+&#xA0;])$') and following-sibling::*[1][name()='img']">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="(parent::p or parent::li or parent::td) and not(following-sibling::node())">
                <xsl:value-of select="replace(., '\s+$', '')" />
            </xsl:when>
            <xsl:when test="matches(., '(.+)([^\s+&#xA0;])$') and parent::*[matches(name(), '(p|li)')] and 
                              following-sibling::*[1][name()='img']">
                <xsl:value-of select="." />
                <xsl:text>&#x20;</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

</xsl:stylesheet>