<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
    </xsl:character-map>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    
    
    <xsl:template match="/">
        <xsl:variable name="UItextFile" select="'../output/js/02_ui_text.js'" />
        <xsl:variable name="updatelinkFile" select="'../output/js/update_link.js'" />
        
        <xsl:result-document href="{$UItextFile}">
            <xsl:text>&#xA;</xsl:text>
            <xsl:text>var model_all = "test";</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:text>var message = {</xsl:text>
            <xsl:for-each select="root/listitem">
                <xsl:text>&#xA;&#x9;</xsl:text>
                <xsl:variable name="dataLanguages" select="concat('&quot;', $commonRef/company/@value, '_', language, '&quot;', ':&#x20;{')" />
                <xsl:value-of select="$dataLanguages" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>html_title:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', html_title, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>title:</xsl:text>
                <xsl:text>&#x20;&quot;</xsl:text>
                <xsl:apply-templates select="title" />
                <xsl:text>&quot;,</xsl:text>
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>model:</xsl:text>
                <xsl:value-of select="concat('&#x20;', model, ',')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>search:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', search, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>keyword:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', keyword, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>result:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', result, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>result_toc:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', result_toc, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>search_short:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', search_short, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>search_more:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', search_more, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>search_less:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', search_less, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>close:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', close, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>footer_line1:</xsl:text>
                <xsl:value-of  disable-output-escaping="yes" select="concat('&#x20;&quot;', footer_line1, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>footer_line2:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', footer_line2, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>caution_txt:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', caution_txt, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>language_header:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', language_header, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>error_page:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', 'error', '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>error_paragraph1:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', error_paragraph1, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>error_paragraph2:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', error_paragraph2, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                <xsl:text>error_botton:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', error_botton, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:text>all_content:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', all_content, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:text>text_size1:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', text_size1, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:text>text_size2:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', text_size2, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:text>text_size3:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', text_size3, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:text>all_text:</xsl:text>
                <xsl:value-of select="concat('&#x20;&quot;', all_text, '&quot;,')" />
                <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
                
                <xsl:if test="position()!=last()">
                    <xsl:text disable-output-escaping='yes'>},</xsl:text>
                </xsl:if>
                <xsl:if test="position()=last()">
                    <xsl:text disable-output-escaping='yes'>}</xsl:text>
                    <xsl:text>&#xA;};</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:result-document>
        
        <xsl:result-document href="{$updatelinkFile}">
            <xsl:text disable-output-escaping="yes">var updateLink = ["&#x20;"]</xsl:text>
        </xsl:result-document>
        
        <xsl:variable name="tocBase" select="'../resource/tocBase.xml'" />
        <xsl:variable name="srcFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../temp/', '41-tagsClear.xml'))" />
        
        <xsl:result-document href="{$tocBase}">
            <xsl:for-each select="$srcFile">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates mode="tocbase" />
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="div[*[1][matches(name(),'(h1|h2)')]]" mode="tocbase">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="tocbase">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="tocbase" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[parent::listitem]">
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:analyze-string select="." regex="^(.*)(\s*)?(&#xA;)(\s*)?(.*)$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)" />
                            <xsl:value-of select="regex-group(2)" />
                            <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                            <xsl:value-of select="regex-group(4)" />
                            <xsl:value-of select="regex-group(5)" />
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="." />
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
