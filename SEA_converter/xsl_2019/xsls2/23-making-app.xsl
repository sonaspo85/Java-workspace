<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs saxon ast"
    version="2.0">

    <xsl:character-map name="a">
        <xsl:output-character character='&lt;' string="&lt;"/>
        <xsl:output-character character='&gt;' string="&gt;"/>
        <xsl:output-character character='&amp;' string="&amp;"/>
    </xsl:character-map>

    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:variable name="apphtml" select="document(concat(ast:getName(base-uri(.), '/'), '/../xsl_2019/xsls2/', 'app.html'))" />
    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="sourcePath" select="body/@sourcePath" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates />
        <xsl:result-document href="dummy.xml">
            <dummy/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="body">
        <xsl:variable name="file" select="concat($sourcePath, '/output/', 'app.html')" />

        <xsl:result-document href="{$file}" method="xml" use-character-maps="a">
            <xsl:value-of select="replace($apphtml/dummy, 'language-code', $data-language)" />
        </xsl:result-document>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

</xsl:stylesheet>
