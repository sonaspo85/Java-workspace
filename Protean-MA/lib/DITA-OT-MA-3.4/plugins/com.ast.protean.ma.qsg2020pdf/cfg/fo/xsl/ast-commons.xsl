<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="dita-ot ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs"
    version="2.0">

	<xsl:template match="*" mode="insertTopicHeaderMarker">
		<xsl:param name="marker-class-name" as="xs:string">current-header</xsl:param>
		<xsl:variable name="headerContent" as="node()*">
			<xsl:apply-templates select="." mode="insertTopicHeaderMarkerContents" />
		</xsl:variable>
		<fo:marker marker-class-name="{$marker-class-name}">
			<xsl:variable name="str0">
				<xsl:apply-templates select="$headerContent" mode="dropCopiedIds" />
			</xsl:variable>

			<xsl:value-of select="$str0" />
		</fo:marker>
	</xsl:template>

    <xsl:template match="*" mode="commonTopicProcessing">
    	<xsl:variable name="id" select="@id" />
    	<xsl:if test="not(ancestor::*[contains(@class, ' map/map ')]/opentopic:map//*[contains(@class, ' map/topicref ')][@id=$id]/@product='html')">
    		<xsl:if test="empty(ancestor::*[contains(@class, ' topic/topic ')])">
    			<fo:marker marker-class-name="current-topic-number">
    				<xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)" />
    				<xsl:for-each select="$topicref">
    					<xsl:apply-templates select="." mode="topicTitleNumber" />
    				</xsl:for-each>
    			</fo:marker>
    		</xsl:if>
    		<fo:block>
    			<xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes" />
    			<xsl:apply-templates select="." mode="customTopicMarker" />
    			<xsl:apply-templates select="*[contains(@class, ' topic/title ')]" />
    			<xsl:apply-templates select="*[contains(@class, ' topic/prolog ')]" />
    			<xsl:apply-templates select="* except(*[contains(@class, ' topic/title ') or contains(@class,' ditaot-d/ditaval-startprop ') or contains(@class, ' topic/prolog ') or contains(@class, ' topic/topic ')])" />
    			<!--xsl:apply-templates select="." mode="buildRelationships"/-->
    			<xsl:apply-templates select="*[contains(@class,' topic/topic ')]" />
    			<xsl:apply-templates select="." mode="topicEpilog" />
    		</fo:block>
    	</xsl:if>
    </xsl:template>

</xsl:stylesheet>
