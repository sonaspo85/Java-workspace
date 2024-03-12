<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p td" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <chapter>
            <xsl:apply-templates select="@*" />
            <xsl:sequence select="ast:group(*, 1)" />
        </chapter>
    </xsl:template>

    <xsl:template match="div">
        <div>
            <xsl:apply-templates select="@*" />
            <xsl:sequence select="ast:group(*, 1)" />
        </div>
    </xsl:template>

    <xsl:template match="*/@class[.='minitocproxy_2']">
        <xsl:attribute name="class" select="'minitocproxy_0'" />
    </xsl:template>

    <xsl:function name="ast:group" as="element()*">
        <xsl:param name="elements" as="element()*" />
        <xsl:param name="level" as="xs:integer" />
        <xsl:for-each-group select="$elements" group-starting-with="*[local-name() eq concat('h', $level)]">
            <xsl:choose>
                <xsl:when test="$level &gt; 5">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                <xsl:when test="self::*[local-name() eq concat('h', $level)]">
                    <topic>
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('ti', generate-id(current-group()[1]))" />
                        </xsl:attribute>
                        <xsl:if test="$level &lt; 4">
                            <xsl:attribute name="filename">
                                <xsl:value-of select="ast:normalized(current-group()[1])" />
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="current-group()[1]" />
                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </topic>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:function>

    <xsl:function name="ast:normalized">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(replace(replace(normalize-unicode(replace(replace(lower-case(normalize-space(replace($value, '\+', '_plus'))), '[!@#$%&amp;();:.,’?]+', ''), '[ &#xA0;]', '_'), 'NFKD'), '\P{IsBasicLatin}', ''), '/' , '_'), '_\|_', '_')"/>
    </xsl:function>

</xsl:stylesheet>