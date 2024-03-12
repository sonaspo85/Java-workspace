<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-mapmerge="http://www.idiominc.com/opentopic/mapmerge"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dita-ot opentopic-mapmerge opentopic-func related-links xs"
    version="2.0">

	<xsl:template match="*" mode="retrieveReferenceTitle" >
		<xsl:choose>
			<xsl:when test="*[contains(@class,' topic/title ')]">
				<xsl:apply-templates select="*[contains(@class, ' topic/title ')]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#none#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/xref ')]" name="topic.xref">
		<xsl:variable name="destination" select="opentopic-func:getDestinationId(@href)" />
		<xsl:variable name="element" select="key('key_anchor',$destination, $root)[1]" as="element()?"/>

		<xsl:variable name="referenceTitle" as="node()*">
			<xsl:apply-templates select="." mode="insertReferenceTitle">
				<xsl:with-param name="href" select="@href" />
				<xsl:with-param name="titlePrefix" select="''" />
				<xsl:with-param name="destination" select="$destination" />
				<xsl:with-param name="element" select="$element" />
			</xsl:apply-templates>
		</xsl:variable>

		<fo:basic-link xsl:use-attribute-sets="xref">
			<xsl:call-template name="commonattributes" />
			<xsl:call-template name="buildBasicLinkDestination">
				<xsl:with-param name="scope" select="@scope" />
				<xsl:with-param name="format" select="@format" />
				<xsl:with-param name="href" select="@href" />
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="not(@scope = 'external' or not(empty(@format) or  @format = 'dita')) and exists($referenceTitle)">
					<xsl:copy-of select="$referenceTitle" />
				</xsl:when>
				<xsl:when test="not(@scope = 'external' or not(empty(@format) or  @format = 'dita'))">
					<xsl:call-template name="insertPageNumberCitation">
						<xsl:with-param name="isTitleEmpty" select="true()" />
						<xsl:with-param name="destination" select="$destination" />
						<xsl:with-param name="element" select="$element" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="*[not(contains(@class,' topic/desc '))] | text()">
							<xsl:apply-templates select="*[not(contains(@class,' topic/desc '))] | text()" />
						</xsl:when>
						<xsl:otherwise>
							<!-- <xsl:value-of select="replace(@href, 'https?://', '')"/> -->
							<xsl:value-of select="@href"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</fo:basic-link>

		<xsl:if test="not(@scope = 'external' or not(empty(@format) or  @format = 'dita')) and exists($referenceTitle) and not($element[contains(@class, ' topic/fn ')])">
			<xsl:if test="not(processing-instruction()[name()='ditaot'][.='usertext'])">
				<xsl:call-template name="insertPageNumberCitation">
					<xsl:with-param name="destination" select="$destination" />
					<xsl:with-param name="element" select="$element" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="buildBasicLinkDestination">
		<xsl:param name="scope" select="@scope" />
		<xsl:param name="format" select="@format" />
		<xsl:param name="href" select="@href" />
		<xsl:choose>
			<xsl:when test="not(matches($href, '(^http|^#)'))">
				<xsl:attribute name="external-destination">
					<xsl:text>url('</xsl:text>
					<xsl:value-of select="concat('http://', $href)" />
					<xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="(contains($href, '://') and not(starts-with($href, 'file://'))) or
							starts-with($href, '/') or
							$scope = 'external' or
							not(empty($format) or $format = 'dita')">
				<xsl:attribute name="external-destination">
					<xsl:text>url('</xsl:text>
					<xsl:value-of select="$href" />
					<xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="$scope = 'peer'">
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="$href" />
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="contains($href, '#')">
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="opentopic-func:getDestinationId($href)" />
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="$href" />
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
