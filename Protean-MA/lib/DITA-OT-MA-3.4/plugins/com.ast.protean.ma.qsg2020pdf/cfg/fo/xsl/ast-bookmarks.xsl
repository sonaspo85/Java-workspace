<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                exclude-result-prefixes="xs opentopic-index opentopic opentopic-func ot-placeholder"
                version="2.0">


    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
        <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]" as="element()?"/>
        <xsl:variable name="topicTitle">
            <xsl:call-template name="getNavTitle"/>
        </xsl:variable>

        <xsl:variable name="topicLevel" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>

        <xsl:variable name="numberSet" select="if (count(ancestor-or-self::*[contains(@class, ' topic/topic ')][last()]
                                                /following-sibling::*[contains(@class, ' topic/topic ')]) = 1) then
                                                4 else
                                                3" as="xs:integer"/>

        <xsl:if test="$topicLevel &lt; $numberSet">
            <xsl:if test="not(*[matches(@outputclass, '^Heading[23]\-APPLINK(\s+)?(nonePV)?$')]) and 
                          not(*[matches(@outputclass, '^Heading1\-H3(\s+)?(nonePV)?$')])">
                <xsl:choose>
                <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                                not($mapTopicref)">
                    <fo:bookmark>
                        <xsl:attribute name="internal-destination">
                            <xsl:call-template name="generate-toc-id"/>
                        </xsl:attribute>
                            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                                <xsl:attribute name="starting-state">hide</xsl:attribute>
                            </xsl:if>
                        <fo:bookmark-title>
                            <xsl:value-of select="normalize-space($topicTitle)"/>
                        </fo:bookmark-title>
                        <xsl:apply-templates mode="bookmark"/>
                    </fo:bookmark>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="bookmark"/>
                </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>