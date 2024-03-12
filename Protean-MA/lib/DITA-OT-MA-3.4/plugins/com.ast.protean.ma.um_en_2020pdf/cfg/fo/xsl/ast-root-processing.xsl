<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs ot-placeholder axf"
    version="2.0">


    <xsl:variable name="writing-mode" as="xs:string">
        <xsl:variable name="lang" select="substring-after($locale, '-')" />

        <xsl:choose>
            <xsl:when test="some $l in ('SA', 'IR', 'IL', 'PK') satisfies $l eq $lang">rl</xsl:when>
            <xsl:otherwise>lr</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- <xsl:variable name="setSizeF" select="document(resolve-uri('setSize.xml', replace(concat('file:\', $languagesData), '\\', '/')))" as="document-node()?"/> -->
    <xsl:variable name="setSizeF" select="document(concat('file:\', $languagesData, '/setSize.xml'))" as="document-node()?"/>
    <xsl:key name="sizeName" match="item" use="@name"/>

    <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
    <xsl:variable name="OSname" select="$pi.code/*[name()='template']" />

    <xsl:template match="/" name="rootTemplate">
        <xsl:call-template name="validateTopicRefs" />
        <fo:root xsl:use-attribute-sets="__fo__root">
            <xsl:attribute name="white-space-collapse" select="'false'" />
            <xsl:call-template name="createMetadata" />
            <xsl:call-template name="createLayoutMasters" />
            <fo:declarations>
                <axf:document-info name="document-title" value="'DITA PDF'" />
			    <axf:document-info name="fitwindow" value="true" />
				<axf:document-info name="pagelayout" value="SinglePage" />
                <!-- <axf:counter-style name="arab" system="fixed" symbols="١ ٢ ٣" fallback="arabic-abjad"/> -->
                <axf:counter-style name="SA" system="numeric" symbols="٠ ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩" fallback="arabic-indic"/>
                <axf:counter-style name="IN" system="fixed" symbols="০ ১ ২ ৩ ৪ ৫ ৬ ৭ ৮ ৯" fallback="bengali" />
                <axf:counter-style name="normal" system="numeric" symbols="0 1 2 3 4 5 6 7 8 9" />
			 </fo:declarations>

             <!-- 영문 국문일때만 북마크 추출 해야됨 -->
            <xsl:if test="matches($localeStrAfter, '(KR|GB)')">
                <xsl:call-template name="createBookmarks" />
            </xsl:if>
            <xsl:call-template name="createFrontMatter" />
            <xsl:call-template name="createToc" />
            <xsl:apply-templates select="*" mode="generatePageSequences" />
            <xsl:call-template name="createBackCover" />
        </fo:root>
    </xsl:template>

    <xsl:variable name="totalTopic" select="descendant-or-self::*[contains(@class, ' topic/topic ')]
                                            /ancestor::*[contains(@class, ' topic/topic ')][last()]/@oid" />

</xsl:stylesheet>