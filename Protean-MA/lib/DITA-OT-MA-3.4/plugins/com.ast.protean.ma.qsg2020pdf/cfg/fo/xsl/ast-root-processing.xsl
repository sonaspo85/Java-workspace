<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index" xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs ot-placeholder"
    version="2.0">
    
    <!-- <xsl:variable name="default-font-size" select="$defaultFontSize" /> -->

    <xsl:variable name="writing-mode" as="xs:string">
        <xsl:variable name="lang" select="if (contains($locale, '-')) then substring-before($locale, '-') else $locale" />

        <xsl:choose>
            <xsl:when test="some $l in ('ar', 'fa', 'he', 'ps', 'ur') satisfies $l eq $lang">rl</xsl:when>
            <xsl:otherwise>lr</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pi.code">
        <xsl:for-each select="root()/dita/node()[self::processing-instruction('ast')]">
            <xsl:element name="{substring-before(., '=')}">
                <xsl:value-of select="substring-after(., '=')" />
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/" name="rootTemplate">
        <xsl:call-template name="validateTopicRefs" />
        <fo:root xsl:use-attribute-sets="__fo__root">
            <xsl:call-template name="createMetadata" />
            <xsl:call-template name="createLayoutMasters" />
            <xsl:call-template name="createBookmarks" />
            <xsl:call-template name="createFrontMatter" />
            <xsl:call-template name="createToc" />

            <xsl:apply-templates select="*" mode="generatePageSequences" />
        </fo:root>
    </xsl:template>

</xsl:stylesheet>