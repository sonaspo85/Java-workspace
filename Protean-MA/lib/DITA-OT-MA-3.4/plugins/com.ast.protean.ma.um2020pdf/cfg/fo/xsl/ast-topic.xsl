<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="dita-ot ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs ast xlink"
    version="2.0">

    <xsl:variable name="map" select="//opentopic:map" as="element()?"/>

    <xsl:template name="commonattributes">
        <xsl:apply-templates select="@id"/>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')] | *[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="flag-attributes"/>
        <xsl:if test="node()[1][self::processing-instruction('cmt')]">
            <xsl:variable name="content" select="replace(replace(substring-after(node()[1], 'contents='), '&amp;quot;', '&quot;'), '&#x9;', '')" />

            <xsl:choose>
                <xsl:when test="$UserName = 'DESK-02 4756'">
                    <xsl:choose>
                        <xsl:when test="matches(normalize-space($content), '^dita2pdf')">
                            <xsl:attribute name="axf:annotation-type" select="'FreeText'" />
                            <xsl:attribute name="axf:annotation-open" select="'false'" />
                            <xsl:attribute name="axf:annotation-text-color" select="'black'" />
                            <xsl:attribute name="axf:annotation-font-size" select="'0.1pt'" />
                            <xsl:attribute name="axf:annotation-border-style" select="'solid'" />
                            <xsl:attribute name="axf:annotation-border-color" select="'black'" />
                            <xsl:attribute name="axf:annotation-border-width" select="'2pt'" />
                            <xsl:attribute name="axf:annotation-contents">
                                <xsl:value-of select="$content" />
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="axf:annotation-type" select="'FreeText'" />
                    <xsl:attribute name="axf:annotation-open" select="'false'" />
                    <xsl:attribute name="axf:annotation-text-color" select="'black'" />
                    <xsl:attribute name="axf:annotation-font-size" select="'0.1pt'" />
                    <xsl:attribute name="axf:annotation-border-style" select="'solid'" />
                    <xsl:attribute name="axf:annotation-border-color" select="'black'" />
                    <xsl:attribute name="axf:annotation-border-width" select="'2pt'" />
                    <xsl:attribute name="axf:annotation-contents">
                        <xsl:value-of select="$content" />
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:apply-templates select="@outputclass"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
        <xsl:choose>
            <xsl:when test="(topicType = 'topicChapter') or (topicType = 'topicAppendix')" />

            <xsl:when test="matches(., 'NO\-TITLE')">
                <fo:block break-before="page"/>
            </xsl:when>

            <xsl:when test="position() = 1 and parent::*/@outputclass[matches(., 'pagebreak')]">
                <!-- <fo:block break-before="page"/> -->
                <!-- <xsl:attribute name="padding-top" select="'-0.1mm'" /> -->
                <xsl:apply-templates select="." mode="processTopicTitle"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processTopicTitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="getTitle">
        <xsl:choose>
            <!-- add keycol here once implemented -->
            <xsl:when test="@spectitle">
                <xsl:value-of select="@spectitle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="processTopicTitle">
        <xsl:variable name="level" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level" />
        </xsl:variable>


        <xsl:variable name="attrSet1">
            <xsl:apply-templates select="." mode="createTopicAttrsName">    <!-- 타이틀 서식화를 위한 변수  -->
                <xsl:with-param name="theCounter" select="$level" />
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="attrSet2" select="concat($attrSet1, '__content')" />    <!-- 특정 타이틀 하위의 content를 서식화를 위한 변수  -->
        <xsl:variable name="CurPos" select="$map//topicref/@id" />

        <fo:block>
            <xsl:call-template name="commonattributes" />
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="$attrSet1" />
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'" />
            </xsl:call-template>
            <fo:block>
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="$attrSet2" />
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'" />
                </xsl:call-template>

                <xsl:if test="$level = 1">
                    <xsl:apply-templates select="." mode="insertTopicHeaderMarker" />
                </xsl:if>

                <xsl:if test="$level = 2">
                    <xsl:apply-templates select="." mode="insertTopicHeaderMarker">
                        <xsl:with-param name="marker-class-name" as="xs:string">current-h2</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>

                <fo:wrapper id="{parent::node()/@id}" />
                <fo:wrapper>
                    <xsl:attribute name="id">
                        <xsl:call-template name="generate-toc-id">
                            <xsl:with-param name="element" select=".." />
                        </xsl:call-template>
                    </xsl:attribute>
                </fo:wrapper>
                <xsl:apply-templates select="." mode="customTopicAnchor" />
                <xsl:call-template name="pullPrologIndexTerms" />
                <xsl:apply-templates select="preceding-sibling::*[contains(@class,' ditaot-d/ditaval-startprop ')]" />
                <xsl:apply-templates select="." mode="getTitle" />
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="*" mode="createTopicAttrsName">
        <xsl:param name="theCounter" as="xs:integer" />
        <xsl:param name="theName" select="''" as="xs:string" />

        <xsl:choose>
            <xsl:when test="$theCounter > 0">
                <xsl:apply-templates select="." mode="createTopicAttrsName">
                    <xsl:with-param name="theCounter" select="$theCounter - 1" />
                    <xsl:with-param name="theName" select="concat($theName, 'topic.')" />
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="cnt" select="count(tokenize(replace($theName, '\.$', ''), '\.'))" />
                <xsl:choose>
                    <xsl:when test="$cnt = 3 and matches(@outputclass, 'Heading3')">
                        <xsl:value-of select="concat($theName, 'topic.title')" />
                    </xsl:when>

                    <xsl:when test="$cnt = 4 and matches(@outputclass, 'Heading4')">
                        <xsl:value-of select="concat($theName, 'topic.title')" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="concat($theName, 'title')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="placeNoteContent">
        <fo:block xsl:use-attribute-sets="note">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/image ')]" name="image">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <xsl:choose>
            <xsl:when test="empty(@href)"/>
            <xsl:when test="@placement = 'break'">
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="@scope = 'external' or opentopic-func:isAbsolute(@href)">
                            <xsl:value-of select="@href"/>
                        </xsl:when>
                        <xsl:when test="exists(key('jobFile', @href, $job))">
                            <xsl:value-of select="key('jobFile', @href, $job)/@src"/>
                        </xsl:when>
                        <xsl:when test="exists(key('jobFile', substring-before(@href, '#page'), $job))">
                            <xsl:value-of select="concat(key('jobFile', substring-before(@href, '#page'), $job)/@src, '#', substring-after(@href, 'pdf#'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($input.dir.url, @href)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <fo:block xsl:use-attribute-sets="image__block">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="if (@align) then @align else 'center'"/>
                        <xsl:with-param name="href" select="$href"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:block>
                <xsl:if test="$artLabel='yes'">
                  <fo:block>
                    <xsl:apply-templates select="." mode="image.artlabel"/>
                  </fo:block>
                </xsl:if>
            </xsl:when>

            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href">
                            <xsl:choose>
                              <xsl:when test="@scope = 'external' or opentopic-func:isAbsolute(@href)">
                                <xsl:value-of select="@href"/>
                              </xsl:when>
                              <xsl:when test="exists(key('jobFile', @href, $job))">
                                <xsl:value-of select="key('jobFile', @href, $job)/@src"/>
                              </xsl:when>
                                <xsl:when test="exists(key('jobFile', substring-before(@href, '#page'), $job))">
                                    <xsl:value-of select="concat(key('jobFile', substring-before(@href, '#page'), $job)/@src, '#', substring-after(@href, 'pdf#'))" />
                                </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="concat($input.dir.url, @href)"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:inline>
                <xsl:if test="$artLabel='yes'">
                  <xsl:apply-templates select="." mode="image.artlabel"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <xsl:template match="*" mode="placeImage">
        <xsl:param name="imageAlign"/>
        <xsl:param name="href"/>
        <xsl:param name="height" as="xs:string?"/>
        <xsl:param name="width" as="xs:string?"/>
        <xsl:param name="scale" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@scale"><xsl:value-of select="@scale"/></xsl:when>
                <xsl:when test="ancestor::*[@scale]"><xsl:value-of select="ancestor::*[@scale][1]/@scale"/></xsl:when>
            </xsl:choose>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="not(@align)">
                <!--Testing whether image @align attribute is present-->
                <xsl:call-template name="processAttrSetReflection">
                    <!--<xsl:with-param name="attrSet" select="concat('__align__', 'center')"/>-->
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/topic-attr.xsl'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!--Using align attribute set according to image @align attribute-->
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="concat('__align__', $imageAlign)"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/topic-attr.xsl'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="@placement = 'break'">
                <xsl:choose>
                    <xsl:when test="ancestor::*[contains(@class, 'topic/table ')]">
                        <xsl:attribute name="margin-left">0mm</xsl:attribute>
                        <xsl:attribute name="margin-right">0mm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="start-indent">0mm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <fo:external-graphic src="url('{$href}')">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[contains(@class, 'topic/table ')]">
                            <xsl:attribute name="margin-left">0mm</xsl:attribute>
                            <xsl:attribute name="margin-right">0mm</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="start-indent">0mm</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$height">
                        <xsl:attribute name="content-height">
                            <xsl:choose>
                              <xsl:when test="not(string(number($height)) = 'NaN')">
                                <xsl:value-of select="concat($height, 'px')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$height"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$width">
                        <xsl:attribute name="content-width">
                            <xsl:choose>
                              <xsl:when test="not(string(number($width)) = 'NaN')">
                                <xsl:value-of select="concat($width, 'px')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$width"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="not($width) and not($height) and $scale">
                        <xsl:attribute name="content-width">
                            <xsl:value-of select="concat($scale,'%')" />
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="@scalefit = 'yes' and not($width) and not($height) and not($scale)">
                        <xsl:attribute name="width">100%</xsl:attribute>
                        <xsl:attribute name="height">100%</xsl:attribute>
                        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="scaling">uniform</xsl:attribute>
                    </xsl:if>

                  <xsl:choose>
                        <xsl:when test="*[contains(@class,' topic/alt ')]">
                            <xsl:apply-templates select="*[contains(@class,' topic/alt ')]" mode="graphicAlternateText" />
                        </xsl:when>
                        <xsl:when test="@alt">
                            <xsl:apply-templates select="@alt" mode="graphicAlternateText" />
                        </xsl:when>
                  </xsl:choose>
                  <xsl:apply-templates select="node() except (text(), *[contains(@class, ' topic/alt ') or contains(@class, ' topic/longdescref ')])"/>
                </fo:external-graphic>
            </xsl:when>

            <xsl:otherwise>
                <fo:external-graphic src="url('{$href}')" xsl:use-attribute-sets="image__inline">
                    <!-- <xsl:attribute name="vertical-align">middle</xsl:attribute> -->
                    <xsl:if test="$height">
                        <xsl:attribute name="content-height">
                            <xsl:choose>
                              <xsl:when test="not(string(number($height)) = 'NaN')">
                                <xsl:value-of select="concat($height, 'px')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$height"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$width">
                        <xsl:attribute name="content-width">
                            <xsl:choose>
                              <xsl:when test="not(string(number($width)) = 'NaN')">
                                <xsl:value-of select="concat($width, 'px')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$width"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="not($width) and not($height) and $scale">
                            <xsl:attribute name="content-width">
                                <xsl:value-of select="concat($scale,'%')"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@scalefit = 'yes' and not($width) and not($height) and not($scale)">
                            <xsl:attribute name="width">100%</xsl:attribute>
                            <xsl:attribute name="height">100%</xsl:attribute>
                            <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                            <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
                            <xsl:attribute name="scaling">uniform</xsl:attribute>
                          </xsl:when>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="*[contains(@class,' topic/alt ')]">
                            <xsl:apply-templates select="*[contains(@class,' topic/alt ')]" mode="graphicAlternateText"/>
                        </xsl:when>
                        <xsl:when test="@alt">
                            <xsl:apply-templates select="@alt" mode="graphicAlternateText"/>
                        </xsl:when>
                    </xsl:choose>
                      <xsl:apply-templates select="node() except (text(), *[contains(@class, ' topic/alt ') or contains(@class, ' topic/longdescref ')])"/>
                </fo:external-graphic>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]" mode="setNoteImagePath">
        <xsl:variable name="noteType" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:value-of select="@type" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="concat($noteType, ' Note Image Path')" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:variable name="noteImagePath">
            <xsl:apply-templates select="." mode="setNoteImagePath"/>
        </xsl:variable>

        <xsl:variable name="id" select="ancestor::*[contains(@class, ' topic/topic ')]/@id" />

        <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
        <xsl:variable name="ancesStepCnt01" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />
        <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')]) +
                                           count(ancestor-or-self::*[contains(@class, ' task/steps ')][count(*) &gt; 1])"/>

        <xsl:choose>
            <xsl:when test="@outputclass = 'roundbox'">
                <fo:block xsl:use-attribute-sets="note__roundbox">
                    <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                        <xsl:attribute name="margin-top" select="'0.4mm'" />
                    </xsl:if>
                    <xsl:apply-templates select="node()" />
                </fo:block>
            </xsl:when>

            <xsl:when test="not($noteImagePath = '')">
                <fo:table xsl:use-attribute-sets="note__table">
                    <!-- <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                        <xsl:attribute name="margin-top" select="'0.8mm'" />
                    </xsl:if> -->

                    <!-- <xsl:if test="position() = 1 and
                                  parent::*/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                        <xsl:attribute name="margin-top" select="'0.7mm'" />
                    </xsl:if> -->

                    <fo:table-column xsl:use-attribute-sets="note__image__column"/>
                    <fo:table-column xsl:use-attribute-sets="note__text__column"/>
                    <fo:table-body>
                        <fo:table-row xsl:use-attribute-sets="note__image__align">
                            <fo:table-cell xsl:use-attribute-sets="note__image__entry">
                                <fo:block>
                                    <fo:external-graphic src="url('{concat($artworkPrefix, $noteImagePath)}')" xsl:use-attribute-sets="image"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="note__text__entry">
                                <xsl:apply-templates select="." mode="placeNoteContent"/>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="." mode="placeNoteContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/abstract ')]">
        <fo:block xsl:use-attribute-sets="abstract">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <xsl:choose>
            <xsl:when test="not(node())">
                <fo:character character="U+000A" suppress-at-line-break="suppress"/>
            </xsl:when>

            <xsl:when test="parent::*[contains(@class, ' topic/entry ')] and
                            count(parent::*[contains(@class, ' topic/entry ')]/*) = 1">
                <xsl:call-template name="commonattributes"/>
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:when test="count(*) = 1 and
                            *[contains(@class, ' topic/image ')][@placement='break']">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:when test="parent::*[contains(@class, ' topic/li ')] and
                            position() = 1">
                <fo:block xsl:use-attribute-sets="parLi.fchiP">
                    <xsl:call-template name="commonattributes"/>

                    <!-- <xsl:if test="parent::*[matches(@class, '(topic/section |task/result )')]
                                  /preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                        <xsl:attribute name="space-before.conditionality" select="'discard'" />
                        <xsl:attribute name="break-before" select="'page'" />
                    </xsl:if> -->

                    <xsl:if test="ancestor::*[contains(@class, 'topic/ul')][1] and following-sibling::*">
                        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
                    </xsl:if>

                    <xsl:if test="@dir='ltr'">
                        <xsl:attribute name="text-align">
                            <xsl:value-of select="if ( matches(substring-before($locale, '-'), 'ar|fa|he') ) then 'end' else 'start'"/>
                        </xsl:attribute>
                        <xsl:attribute name="direction">ltr</xsl:attribute>
                    </xsl:if>

                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="p">
                    <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                        <xsl:attribute name="padding-top">
                            <xsl:choose>
                                <xsl:when test="parent::*[matches(@outputclass, '^box')]">
                                    <!-- <xsl:value-of select="'3.3mm'" /> -->
                                    <xsl:value-of select="'2.7mm'" />
                                </xsl:when>

                                <xsl:otherwise>-0.4mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <!-- <xsl:if test="parent::*[matches(@class, '(topic/section |task/result )')]
                                  /preceding-sibling::node()[1][self::processing-instruction('pagebreak')] and
                                  position() = 1">
                        <xsl:attribute name="space-before.conditionality" select="'discard'" />
                        <xsl:attribute name="break-before" select="'page'" />
                    </xsl:if> -->

                    <xsl:call-template name="commonattributes"/>

                    <xsl:if test="ancestor::*[contains(@class, 'topic/ul')][1] and following-sibling::*">
                        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
                    </xsl:if>

                    <xsl:if test="@dir='ltr'">
                        <xsl:attribute name="text-align">
                            <xsl:value-of select="if ( matches(substring-before($locale, '-'), 'ar|fa|he') ) then 'end' else 'start'"/>
                        </xsl:attribute>
                        <xsl:attribute name="direction">ltr</xsl:attribute>
                    </xsl:if>

                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="inlineTextOptionalKeyref">
        <xsl:param name="copyAttributes" as="element()?"/>
        <xsl:param name="keys" select="@keyref" as="attribute()?"/>
        <xsl:param name="contents" as="node()*">
            <!-- Current node can be preprocessed and may not be part of source document, check for root() to ensure key() is resolvable -->
            <xsl:variable name="target" select="if (exists(root()) and @href) then key('id', substring(@href, 2)) else ()" as="element()?"/>
            <xsl:choose>
                <xsl:when test="not(normalize-space(.)) and $keys and $target/self::*[contains(@class,' topic/topic ')]">
                    <xsl:apply-templates select="$target/*[contains(@class, ' topic/title ')]/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="topicref" select="key('map-id', substring(@href, 2))"/>
        <xsl:choose>
            <xsl:when test="$keys and @href and not($topicref/ancestor-or-self::*[@linking][1]/@linking = ('none', 'sourceonly'))">
                <fo:basic-link xsl:use-attribute-sets="xref">
                    <xsl:sequence select="$copyAttributes/@*"/>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="buildBasicLinkDestination"/>
                    <xsl:copy-of select="$contents"/>
                </fo:basic-link>
            </xsl:when>
            <xsl:when test="matches(substring-before($locale, '-'), 'ar|he|fa') and
                            ( @dir = 'ltr' or @outputclass = 'no-trans' or contains(., '+') or matches(., '\d+\s*x\s*\d+') )">
                <fo:bidi-override direction="ltr" unicode-bidi="bidi-override">
                    <fo:inline>
                        <xsl:sequence select="$copyAttributes/@*"/>
                        <xsl:call-template name="commonattributes"/>
                        <xsl:copy-of select="$contents"/>
                    </fo:inline>
                </fo:bidi-override>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:if test="following-sibling::node()[1][contains(@class, 'topic/tm ')]">
                        <xsl:attribute name="space-end" select="'-1.1mm'" />
                    </xsl:if>

                    <xsl:if test="matches(@outputclass, 'superscript')">
                        <xsl:attribute name="vertical-align" select="'super'" />
                        <xsl:attribute name="baseline-shift" select="'0.7mm'" />
                    </xsl:if>

                    <xsl:sequence select="$copyAttributes/@*"/>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:copy-of select="$contents"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/section ')]">
        <fo:block xsl:use-attribute-sets="section">
            <xsl:call-template name="commonattributes"/>

            <!-- <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                <fo:block break-before="page"/>
            </xsl:if> -->

            <xsl:choose>
                <xsl:when test="@outputclass = 'box'">
                    <xsl:attribute name="border">1px solid black</xsl:attribute>
                    <xsl:attribute name="padding-top">4.5mm</xsl:attribute>
                    <xsl:attribute name="padding-left">3.8mm</xsl:attribute>
                    <xsl:attribute name="margin-left">0mm</xsl:attribute>
                    <xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
                    <xsl:attribute name="margin-bottom">47.3mm</xsl:attribute>
                    <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
                    <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>

                    <xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
                    <fo:block-container xsl:use-attribute-sets="section__content">
                        <xsl:apply-templates select="node() except (*[contains(@class,' topic/title ')])"/>
                    </fo:block-container>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
                    <fo:block xsl:use-attribute-sets="section__content">
                        <xsl:apply-templates select="node() except (*[contains(@class,' topic/title ')])"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>



    <xsl:template match="*" mode="get-toc-level" as="xs:integer">
        <xsl:variable name="topicref"
          select="key('map-id', ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id)[1]"
          as="element()?"
        />
        <xsl:sequence select="count(ancestor-or-self::*[contains(@class,' topic/topic ')])"/>
  </xsl:template>

    <xsl:template name="getNavTitle">
        <xsl:variable name="topicref" select="key('map-id', @id)[1]" as="element()?"/>
        <xsl:choose>
            <xsl:when test="$topicref/@locktitle='yes' and
                            $topicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
               <xsl:apply-templates select="$topicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]/node()"/>
            </xsl:when>
            <xsl:when test="$topicref/@locktitle='yes' and
                            $topicref/@navtitle">
                <xsl:value-of select="$topicref/@navtitle"/>
            </xsl:when>
            <xsl:when test="*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
                <xsl:apply-templates select="*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]/node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tm ')]">
      <xsl:variable name="generate-symbol" as="xs:boolean">
        <xsl:apply-templates select="." mode="tm-scope"/>
      </xsl:variable>
        <fo:inline xsl:use-attribute-sets="tm">
            <xsl:if test="preceding-sibling::node()[1][self::text()]">
                <xsl:attribute name="space-start" select="'-1.3mm'" />
            </xsl:if>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
            <xsl:choose>
              <xsl:when test="not($generate-symbol)"/>
                <xsl:when test="@tmtype='service'">
                  <fo:inline xsl:use-attribute-sets="tm__content__service">&#8480;</fo:inline>
                </xsl:when>
                <xsl:when test="@tmtype='tm'">
                    <fo:inline xsl:use-attribute-sets="tm__content">&#8482;</fo:inline>
                </xsl:when>
                <xsl:when test="@tmtype='reg'">
                    <fo:inline xsl:use-attribute-sets="tm__content">&#174;</fo:inline>
                </xsl:when>
            </xsl:choose>
        </fo:inline>
    </xsl:template>


    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:getFile">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>