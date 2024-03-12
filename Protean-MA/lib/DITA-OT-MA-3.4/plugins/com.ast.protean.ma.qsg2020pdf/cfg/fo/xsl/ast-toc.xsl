<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
	xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
	xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
	exclude-result-prefixes="xs dita-ot opentopic opentopic-func ot-placeholder opentopic-index" version="2.0">

	<xsl:template name="createTocHeader">
		<fo:block-container xsl:use-attribute-sets="__toc__header_container">
			<fo:block xsl:use-attribute-sets="__toc__header" id="{$id.toc}">
				<xsl:apply-templates select="." mode="customTopicAnchor" />
				<xsl:call-template name="getVariable">
					<xsl:with-param name="id" select="'frontmatter-toc-contents'" />
				</xsl:call-template>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="toc">
		<xsl:param name="include" />
		<xsl:variable name="topicLevel" as="xs:integer">
			<xsl:apply-templates select="." mode="get-topic-level" />
		</xsl:variable>

		<xsl:variable name="numberSet" select="if (count(ancestor-or-self::*[contains(@class, ' topic/topic ')][last()]
												/following-sibling::*[contains(@class, ' topic/topic ')]) = 1) then
												4 else
												3" as="xs:integer" />

		<xsl:if test="$topicLevel &lt; $numberSet">
			<xsl:variable name="mapTopicref" select="key('map-id', @id)[1]" as="element()?" />

			<xsl:choose>
				<xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
							  (not($mapTopicref) and $include = 'true')">
					<xsl:if test="not(*[matches(@outputclass, '^Heading[23]\-APPLINK(\s+)?(nonePV)?$')]) and 
								  not(*[matches(@outputclass, '^Heading1\-H3(\s+)?(nonePV)?$')])">
						<fo:block xsl:use-attribute-sets="__toc__indent">
							<xsl:variable name="tocItemContent">
								<fo:basic-link xsl:use-attribute-sets="__toc__link">
									<xsl:attribute name="internal-destination">
										<xsl:call-template name="generate-toc-id" />
									</xsl:attribute>

									<!-- 최상위 chapter 명(Basics, Apps and features, Settings, Appendix) -->
									<xsl:if test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 1">
										<fo:inline xsl:use-attribute-sets="__toc__title">
											<xsl:variable name="pulledNavigationTitle" as="item()*">
												<xsl:call-template name="getNavTitle" />
											</xsl:variable>
											<xsl:apply-templates select="$pulledNavigationTitle" mode="dropCopiedIds" />
										</fo:inline>
									</xsl:if>

									<!-- h1, h2, h3 등의 작은 title -->
									<xsl:if test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 1">
										<fo:list-block xsl:use-attribute-sets="__toc__between__bullet">
											<fo:list-item>
												<fo:list-item-label keep-together.within-line="always"
													end-indent="label-end()">
													<fo:block xsl:use-attribute-sets="__toc__page-number">
														<fo:basic-link xsl:use-attribute-sets="__toc__link">
															<xsl:attribute name="internal-destination">
																<xsl:call-template name="generate-toc-id" />
															</xsl:attribute>

															<fo:page-number-citation>
																<xsl:attribute name="ref-id">
																	<xsl:call-template name="generate-toc-id" />
																</xsl:attribute>
															</fo:page-number-citation>
														</fo:basic-link>
													</fo:block>
												</fo:list-item-label>

												<fo:list-item-body start-indent="body-start()">
													<fo:block xsl:use-attribute-sets="__toc__title">
														<xsl:variable name="pulledNavigationTitle" as="item()*">
															<xsl:call-template name="getNavTitle" />
														</xsl:variable>

														<xsl:variable name="str0">
															<xsl:apply-templates select="$pulledNavigationTitle"
																mode="dropCopiedIds" />
														</xsl:variable>

														<xsl:value-of select="$str0" />
													</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
								</fo:basic-link>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="not($mapTopicref)">
									<xsl:apply-templates select="." mode="tocText">
										<xsl:with-param name="tocItemContent" select="$tocItemContent" />
										<xsl:with-param name="currentNode" select="." />
									</xsl:apply-templates>
								</xsl:when>

								<xsl:otherwise>
									<xsl:apply-templates select="$mapTopicref" mode="tocText">
										<xsl:with-param name="tocItemContent" select="$tocItemContent" />
										<xsl:with-param name="currentNode" select="." />
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
						<xsl:apply-templates mode="toc">
							<xsl:with-param name="include" select="'true'" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates mode="toc">
						<xsl:with-param name="include" select="'true'" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="tocText" priority="-10">
		<xsl:param name="tocItemContent" />
		<xsl:param name="currentNode" />
		<xsl:for-each select="$currentNode">
			<fo:block xsl:use-attribute-sets="__toc__topic__content">
				<xsl:copy-of select="$tocItemContent" />
			</fo:block>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="createToc">
		<xsl:if test="$generate-toc">
			<xsl:variable name="toc">
				<xsl:choose>
					<xsl:when test="root()/dita">
						<xsl:apply-templates select="/" mode="toc" />
						<xsl:call-template name="toc.index" />
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="count($toc/*) > 0">
				<fo:page-sequence master-reference="toc-sequence" xsl:use-attribute-sets="page-sequence.toc">
					<xsl:call-template name="insertTocStaticContents" />
					<fo:flow flow-name="xsl-region-body">
						<xsl:call-template name="createTocHeader" />
						<fo:block>
							<fo:marker marker-class-name="current-header">
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="'frontmatter-toc-contents'" />
								</xsl:call-template>
							</fo:marker>

							<xsl:apply-templates select="." mode="customTopicMarker" />
							<xsl:copy-of select="$toc" />
						</fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>