<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs ast functx">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p" />
    
    
    <xsl:variable name="sourcePath" select="html/@sourcePath" />
    <xsl:variable name="defined" select="document(concat(ast:getName(base-uri(.), '/'), '/../xsl_2022/xsls2/', 'defined-regex.xml'))" />
    
    <xsl:variable name="from" as="xs:string*">
        <xsl:for-each select="$defined/def/regex/from">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="to" as="xs:string*">
        <xsl:for-each select="$defined/def/regex/to">
            <xsl:sequence select="." />
        </xsl:for-each>
    </xsl:variable>

    <xsl:param name="language" as="xs:string" required="yes"/>
    <xsl:param name="model" as="xs:string" required="yes"/>
    <xsl:variable name="data-language" select="if (matches($language, '(English|en)')) then 'English' else 'Spanish_LA'" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="html">
        <xsl:apply-templates select="body"/>
    </xsl:template>

    <xsl:template match="div[not(@class)]">
    </xsl:template>

    <xsl:template match="body">
        <body data-language="{$data-language}" model-name="{$model}">
            <xsl:attribute name="sourcePath">
                <xsl:value-of select="$sourcePath"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" />
        </body>
    </xsl:template>

    <xsl:template match="@divclass">
    </xsl:template>

    <xsl:template match="@value">
    </xsl:template>
    
    <xsl:template match="text()" priority="10">
        <xsl:value-of select="functx:replace-multi(., $from, $to)" />
    </xsl:template>

    <xsl:function name="functx:replace-multi" as="xs:string?" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="changeFrom" as="xs:string*"/>
        <xsl:param name="changeTo" as="xs:string*"/>
        <xsl:sequence select="if (count($changeFrom) > 0) then 
                              functx:replace-multi(replace($arg, $changeFrom[1], functx:if-absent($changeTo[1],'')), $changeFrom[position() > 1], $changeTo[position() > 1]) else 
                              $arg"/>
    </xsl:function>

    <xsl:function name="functx:if-absent" as="item()*" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="item()*"/>
        <xsl:param name="value" as="item()*"/>
        <xsl:sequence select="if (exists($arg)) then 
                              $arg else 
                              $value"/>
    </xsl:function>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
    
</xsl:stylesheet>
