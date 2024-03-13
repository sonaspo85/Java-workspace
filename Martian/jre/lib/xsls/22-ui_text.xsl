<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
        <xsl:output-character character="&apos;" string="&amp;apos;" />
    </xsl:character-map>

    <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />
    
    <xsl:variable name="isocode" select="root()/root/@isocode" />
    
    <xsl:template match="/">
        <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when test="number($langmapCnt) &gt; 1">
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', upper-case(concat($type, '_', $isocode)), '/', 'js/ui_text.js')" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="concat('file:////', $srcDir, '/output/', upper-case(concat($type, '_', $modelcode)), '/', 'js/ui_text.js')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:result-document href="{$filename}">
            <xsl:text>var model_2 = "</xsl:text>
            <xsl:value-of select="$type" />
            <xsl:text>"</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>var message = {</xsl:text>

            <xsl:for-each select="root/listitem">
                <xsl:text>&#xa;</xsl:text>
                <xsl:variable name="langcode" select="@lang" />
                <xsl:text disable-output-escaping="yes">&#x9;"</xsl:text>
                <xsl:value-of select="$langcode" />
                <xsl:text disable-output-escaping="yes">"</xsl:text>
                <xsl:text>: {&#xa;</xsl:text>
                
                <xsl:for-each select="*">
                    <xsl:variable name="name" select="local-name()" />
                    <xsl:variable name="value" select="." />
                    <xsl:text disable-output-escaping="yes">&#x9;&#x9;</xsl:text>
                    <xsl:value-of select="$name" />
                    <xsl:text disable-output-escaping="yes">: "</xsl:text>
                    <xsl:value-of select="$value" disable-output-escaping="yes" />
                    
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:text disable-output-escaping="yes">"</xsl:text>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:text disable-output-escaping="yes">",</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each>
                
                <xsl:choose>
                    <xsl:when test="following-sibling::listitem">
                        <xsl:text>&#x9;}, </xsl:text>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:text>&#x9;} </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>&#xa;};</xsl:text>
        </xsl:result-document>

        <dummy />
    </xsl:template>
    
</xsl:stylesheet>
