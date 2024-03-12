<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="ast xs"
    version="2.0">

    <xsl:variable name="job" select="document(resolve-uri('.job.xml', $work.dir.url))" as="document-node()?" />
    <xsl:key name="jobFile" match="file" use="@uri" />

    <!-- <xsl:variable name="setSizeF" select="document(resolve-uri('setSize.xml', replace(concat('file:\', $languagesData), '\\', '/')))" as="document-node()?"/> -->
    <!-- <xsl:variable name="setSizeF" select="document(concat('file:\', $languagesData, '/setSize.xml'))" as="document-node()?"/>
    <xsl:key name="sizeName" match="item" use="@name"/> -->

    <xsl:attribute-set name="topic" use-attribute-sets="base-font">
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">
            <xsl:variable name="fchiSection" select="*[1][contains(@class, 'topic/section ')]" />
            <xsl:variable name="fchiSection.fchUl" select="$fchiSection/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[contains(@class, 'topic/topic')]" />

            <xsl:choose>
                <xsl:when test="$fchiSection.fchUl">
                    <xsl:choose>
                        <xsl:when test="$fchiSection.fchUl[not(matches(@outputclass, 'star'))]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$fchiSection.fchUl[not(matches(@outputclass, 'arrow'))]">
                            <xsl:choose>
                                <xsl:when test="$ancesTopic[matches(@outputclass, 'backcover')]">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>3mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="section">
        <xsl:attribute name="space-before" select="'0mm'" />
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__center">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__column">
        <!-- <xsl:attribute name="column-number">1</xsl:attribute> -->
        <xsl:attribute name="column-width">
            <xsl:variable name="parTag" select="parent::*" />

            <xsl:value-of select="'11mm'" />

        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preNote" select="preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="preTable" select="preceding-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, ' task/info ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, ' task/cmd ')]" />
            <xsl:variable name="parSection" select="parent::*[matches(@class, 'topic/section ')]" />
            <xsl:variable name="parSection.preSteps" select="$parSection/preceding-sibling::*[1][matches(@class, 'task/steps ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo" select="$parSection.preSteps/*[last()]/*[last()][matches(@class, 'task/info ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo.LchiP" select="$parSection.preSteps.LchiInfo/*[last()][matches(@class, 'topic/p ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo.LchiUl" select="$parSection.preSteps.LchiInfo/*[last()][matches(@class, 'topic/ul ')]" />



            <xsl:choose>
                <xsl:when test="$ancesStepCnt = 'multi'">
                    <!-- <xsl:value-of select="'1.6mm'" /> -->
                    <xsl:value-of select="'1.1mm'" />
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:value-of select="'1.6mm'" />
                </xsl:when>

                <xsl:when test="$preNote and
                                *[1][name()='ul']">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="$preP[contains(@outputclass, 'callout-image')] and
                                *[1][name()='ul']">
                    <xsl:value-of select="'2.7mm'" />
                </xsl:when>

                <xsl:when test="$preTable">
                    <xsl:choose>
                        <xsl:when test="*[1][matches(name(), '^ul$')]">
                            <xsl:value-of select="'4.8mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="not(preceding-sibling::*) and
                                $parInfo.preCmd and
                                not(*[1][name()='ul'])">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$parSection.preSteps.LchiInfo and
                                        *[1][name()='ul']">

                            <xsl:choose>
                                <xsl:when test="$parSection.preSteps.LchiInfo.LchiP[contains(@outputclass, 'callout-image')]">
                                    <xsl:value-of select="'1.8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.preSteps.LchiInfo">
                            <xsl:choose>
                                <xsl:when test="$parSection.preSteps.LchiInfo.LchiUl">
                                    <xsl:value-of select="'1.3mm'" />
                                </xsl:when>

                                <xsl:when test="not(*[1][name() = 'ul'])">
                                    <xsl:value-of select="'1mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.6mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- <xsl:when test="$preP[matches(@outputclass, 'callout-image')]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when> -->

                <xsl:otherwise>1.1mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="parSection" select="parent::*[matches(@class, 'topic/section ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.flwTopic" select="$parSection.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.flwTopic.fchiTitle" select="$parSection.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/ancestor-or-self::*[contains(@class, ' topic/topic ')][last()]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

            <xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />
            <xsl:variable name="parAbstract" select="parent::*[matches(@class, 'topic/abstract ')]" />
            <xsl:variable name="parAbstract.parBody" select="$parAbstract/following-sibling::*[1][matches(@class, 'topic/body ')]" />
            <xsl:variable name="parAbstract.parBody.fchiSteps" select="$parAbstract.parBody/*[1][matches(@class, 'task/steps ')]" />

            <xsl:choose>
                <xsl:when test="not(following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$flwTitle and $parSection">
                            <xsl:choose>
                                <xsl:when test="$flwTitle[matches(@outputclass, 'Heading1')]">
                                    <xsl:choose>
                                        <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|KH|LA|VN|IN)')">
                                            <xsl:value-of select="'11.6mm'" />
                                        </xsl:when>

                                        <xsl:when test="matches($localeStrAfter, 'MM')">
                                            <xsl:value-of select="'10.6mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'12.6mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:choose>
                                        <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|MM|VN)')">
                                            <xsl:value-of select="'7.2mm'" />
                                        </xsl:when>

                                        <xsl:when test="matches($localeStrAfter, 'TH')">
                                            <xsl:value-of select="'6.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <!-- <xsl:value-of select="'8.2mm'" /> -->
                                            <xsl:value-of select="'8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:choose>
                                        <xsl:when test="*[last()][name()='ul']">
                                            <!-- <xsl:value-of select="'6.2mm'" /> -->
                                            <xsl:value-of select="'6.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'6.8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading4')]">
                                    <xsl:value-of select="'5.5mm'" />
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading4')]">
                                    <xsl:value-of select="'5.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>2.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parAbstract.parBody.fchiSteps">
                            <xsl:value-of select="'4.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>2.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>2.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preUl.preP" select="$preUl/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, 'topic/li ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, 'topic/li ')]" />

            <xsl:choose>
                <xsl:when test="$preUl.preP[matches(@outputclass, 'upsp')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="axf:kerning-mode">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'pair'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="axf:punctuation-trim">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'adjacent'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="page.break">
        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title__content">
        <xsl:attribute name="line-height">inherit</xsl:attribute>
    </xsl:attribute-set>

    <!-- Chapter -->
    <xsl:attribute-set name="topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="matches($OSname, '-OS_upgrade')">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>
                <xsl:otherwise>8mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-top">
            <xsl:choose>
                <xsl:when test="matches($OSname, '-OS_upgrade')">
                    <xsl:value-of select="'-1.2mm'" />
                </xsl:when>

                <xsl:otherwise>1.25mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:choose>
                <xsl:when test="not(matches($OSname, '-OS_upgrade'))">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="color">cmyk(0%,0%,0%,80%)</xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:value-of select="'600'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="page-break-before">always</xsl:attribute>

    </xsl:attribute-set>

    <!-- Heading1 title 하늘색 -->
    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="padding-top">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />

            <xsl:choose>
                <xsl:when test="not(preceding-sibling::*) and
                                $ancesTopic[matches(@outputclass, 'pagebreak')]">
                    <!-- <xsl:value-of select="'0.3mm'" /> -->
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />

            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                    <xsl:value-of select="'8mm'" />
                </xsl:when>

                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'17.6mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|KH|LA|VN|IN)')">10mm</xsl:when>
                        <xsl:when test="matches($localeStrAfter, 'MM')">9mm</xsl:when>
                        <xsl:otherwise>11mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />
            <xsl:variable name="flwBody" select="following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="flwBody.fchiSection" select="$flwBody/*[1][matches(@class, ' topic/section ')]" />
            <xsl:variable name="flwBody.fchiSection.fchiTitle" select="$flwBody.fchiSection/*[1][matches(@class, ' topic/table ')]" />

            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                    <!-- <xsl:value-of select="'3.5mm'" /> -->
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'6.1mm'" />
                </xsl:when>

                <xsl:when test="$flwBody.fchiSection.fchiTitle">
                    <xsl:value-of select="'4mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'2mm'" />
                    <!-- <xsl:choose>
                        <xsl:when test="matches($localeStrAfter, 'MM')">1.4mm</xsl:when>
                        <xsl:otherwise>2mm</xsl:otherwise>
                    </xsl:choose> -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                            <xsl:value-of select="'900'" />
                        </xsl:when>

                        <xsl:otherwise>700</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>


        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading2 title 갈색 -->
    <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="common.title">
         <xsl:attribute name="space-before">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.preTitle" select="$parTag/preceding-sibling::*[1][matches(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.preTopic" select="$parTag/preceding-sibling::*[1][matches(@class, 'topic/topic ')]/descendant-or-self::*[last()][matches(@class, 'topic/topic ')]" />
            <!-- <xsl:variable name="parTag.preTopic.LchiSection" select="$parTag.preTopic/*[last()][]" /> -->

            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')]) +
                                               count(ancestor-or-self::*[contains(@class, ' task/steps ')][count(*) &gt; 1])" />


            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|MM|VN)')">
                    <xsl:value-of select="'5.5mm'" />
                </xsl:when>

                <xsl:when test="matches($localeStrAfter, 'TH')">
                    <xsl:value-of select="'4.55mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$parTag.preTitle[matches(@outputclass, 'Heading1')]">
                            <xsl:value-of select="'6.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'6.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:value-of select="'1.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="color">cmyk(30%,60%,50%,10%)</xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:value-of select="'900'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading3 title 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="common.title">
         <xsl:attribute name="space-before">
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="parTag" select="parent::*" />

            <xsl:choose>
                <xsl:when test="$parTag[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                    <xsl:value-of select="'8mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'5mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="flwBody" select="following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="flwBody.fchiSteps" select="$flwBody/*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$parTag[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                    <xsl:value-of select="'2.1mm'" />
                </xsl:when>

                <xsl:when test="$flwBody.fchiSteps and
                                $ancesStepCnt = 'onestep'">
                    <!-- <xsl:value-of select="'2mm'" /> -->
                    <xsl:value-of select="'2.5mm'" />
                </xsl:when>

                <xsl:otherwise>2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width" />
        </xsl:attribute>

        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                    <xsl:value-of select="'cmyk(35%,80%,60%,0%)'" />
                </xsl:when>

                <xsl:otherwise>cmyk(0%,0%,0%,100%)</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:value-of select="'900'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading4 title 연한 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                    <xsl:choose>
                        <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|VN)')">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:otherwise>5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="matches($localeStrAfter, '(KZ|MN|TR|MK|SK|VN)')">
                    <xsl:value-of select="'3mm'" />
                </xsl:when>

                <xsl:otherwise>4mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:otherwise>2.2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width" />
        </xsl:attribute>

        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                </xsl:when>
                <xsl:otherwise>cmyk(0%,0%,0%,70%)</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:value-of select="'900'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note" use-attribute-sets="common.block base-font">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>0.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>1mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height" />
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="image__block">
        <xsl:attribute name="margin-top">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parTag.parAbstract" select="$parTag/parent::*[matches(@class, ' topic/abstract ')]" />
            <xsl:variable name="parTag.parAbstract.preTitle" select="$parTag.parAbstract/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.parInfo" select="$parTag/parent::*[matches(@class, ' task/info ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')][1]" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[matches(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.preTitle" select="$parTag.parSection.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />

            <xsl:variable name="hrefid" select="tokenize(@href, '/')[last()]" />
            <xsl:variable name="gethrefname" select="tokenize(key('jobFile', $hrefid, $job)/@src, '/')[last()]" />

            <xsl:choose>
                <xsl:when test="$parTag/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'1.3mm'" />
                </xsl:when>

                <xsl:when test="not($parTag/preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection.parBody.preTitle[contains(@outputclass, 'Heading3')]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="$parTag.parInfo">
                                    <xsl:choose>
                                        <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
                                            <xsl:value-of select="'4.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'3.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTag.parAbstract.preTitle[matches(@outputclass, 'Heading[23]')]">

                            <xsl:value-of select="'3.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preP">
                    <xsl:choose>
                        <xsl:when test="$ancesUl[matches(@outputclass, 'arrow')]">
                            <xsl:choose>
                                <xsl:when test="$parTag.preP[matches(@outputclass, 'callout-image')]">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'4.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTag.preP[matches(@outputclass, 'callout-image')]">
                            <xsl:choose>
                                <xsl:when test="exists(key('sizeName', $gethrefname, $setSizeF))">
                                    <xsl:value-of select="key('sizeName', $gethrefname, $setSizeF)/@margin-top" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'4.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'3mm'" />

                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preNote">
                    <xsl:choose>
                        <xsl:when test="$parTag.preNote[*[not(contains(@class, 'topic/ul '))]]">
                            <xsl:value-of select="'4.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>inherit</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag[not(preceding-sibling::*)] and
                                $parTag.parAbstract.preTitle[matches(@outputclass, 'Heading[23]')]">
                    <xsl:value-of select="'3mm'" />
                </xsl:when>

                <xsl:when test="$parTag.parInfo and
                                not($parTag/preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'3mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.preTitle" select="$parTag.parSection.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.flwTable" select="$parTag/following-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesSteps.flwResult" select="$ancesSteps/following-sibling::*[1][contains(@class, ' task/result ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote" select="$ancesSteps.flwResult/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote.fchiUl" select="$ancesSteps.flwResult.fchiNote/*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="SrcMatchHref" select="key('jobFile', @href, $job)/@src" />
            <xsl:variable name="parTag.preTitle" select="$parTag/preceding::*[contains(@class, 'topic/title ')][1]" />

            <xsl:choose>
                <xsl:when test="$parTag/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesUl[matches(@outputclass, 'arrow')]">
                    <xsl:choose>
                        <xsl:when test="$parTag.preP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'4.4mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="exists(key('jobFile', @href, $job)) and
                                matches(SrcMatchHref, 'M-HEVC')">
                    <xsl:value-of select="'0.8mm'"/>
                </xsl:when>

                <xsl:when test="exists(key('jobFile', @href, $job)) and
                                matches($SrcMatchHref, 'PRC_Table_[12]')">
                    <xsl:value-of select="'1.1mm'"/>
                </xsl:when>

                <xsl:when test="$parTag.preNote">
                    <xsl:choose>
                        <xsl:when test="$parTag.preNote[not(contains(@class, 'topic/ul '))]">
                            <xsl:value-of select="'4.3mm'" />
                        </xsl:when>

                        <xsl:otherwise>4.3mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- <xsl:when test="$parTag.flwTable">
                    <xsl:value-of select="'2.8mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwUl">
                    <xsl:value-of select="'2.8mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwNote">
                    <xsl:value-of select="'2.8mm'" />
                </xsl:when> -->

                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                    <xsl:choose>
                        <xsl:when test="$ancesSteps.flwResult.fchiNote">
                            <xsl:value-of select="'2.8mm'" />
                        </xsl:when>

                        <xsl:otherwise>2.8mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancestable[matches(@outputclass, 'table_text')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">
                    <xsl:choose>
                        <xsl:when test="$parTag.preUl">
                            <xsl:value-of select="'2.8mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStep[not(following-sibling::*[contains(@class, 'task/step ')])]">
                            <!-- <xsl:choose>
                                <xsl:when test="$ancesSteps.flwResult.fchiNote.fchiUl">
                                    <xsl:value-of select="'3.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>3.2mm</xsl:otherwise>
                            </xsl:choose> -->
                            <xsl:value-of select="'3.2mm'" />
                        </xsl:when>

                        <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
                            <xsl:choose>
                                <xsl:when test="not($parTag/preceding-sibling::*)">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'4.3mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>2.8mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preUl">
                    <xsl:value-of select="'2.8mm'" />
                </xsl:when>

                <xsl:when test="$parTag[not(following-sibling::*)] and $parTag.parSection">
                    <xsl:value-of select="'2.8mm'" />
                </xsl:when>

                <xsl:otherwise>2.8mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesSteps.parBody" select="$ancesSteps/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic" select="$ancesSteps.parBody/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.parTopic" select="$ancesSteps.parBody.parTopic/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.parTopic.flwTopic" select="$ancesSteps.parBody.parTopic.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.parTopic.flwTopic.fchiTitle" select="$ancesSteps.parBody.parTopic.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.flwTopic" select="$ancesSteps.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.flwTopic.fchiTitle" select="$ancesSteps.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

            <xsl:variable name="ancesSteps.parBody.flwTopic" select="$ancesSteps.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic.fchiTitle" select="$ancesSteps.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.flwTopic" select="$parTag.parSection.parBody/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parSection.parBody.flwTopic.fchiTitle" select="$parTag.parSection.parBody.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.flwTable" select="$parTag/following-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancesSteps.flwResult" select="$ancesSteps/following-sibling::*[1][contains(@class, ' task/result ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote" select="$ancesSteps.flwResult/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />



            <xsl:choose>
                <xsl:when test="$parTag.flwNote/*[1][contains(@class, 'topic/p ')]">
                    <xsl:choose>
                        <xsl:when test="$parTag.flwNote/*[1][contains(@class, 'topic/p ')][count(node()) = 1][child::b]">
                            <xsl:value-of select="'0.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preNote">
                    <xsl:choose>
                        <xsl:when test="$parTag.preNote[not(contains(@class, 'topic/ul '))]">
                            <xsl:value-of select="'1.05mm'" />
                        </xsl:when>

                        <xsl:otherwise>1.05mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.flwTable">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwUl">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwNote">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                    <xsl:choose>
                        <xsl:when test="$ancesSteps.flwResult.fchiNote">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesSteps[not(following-sibling::*)]">

                            <xsl:choose>
                                <xsl:when test="$ancesSteps.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.05mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesUl[matches(@outputclass, 'arrow')]">
                    <xsl:value-of select="'0.2mm'" />
                </xsl:when>

                <xsl:when test="$ancestable[matches(@outputclass, 'table_text')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">
                    <xsl:choose>
                        <xsl:when test="$parTag.preUl">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStep[not(following-sibling::*[contains(@class, 'task/step ')])]">
                            <xsl:choose>
                                <xsl:when test="$ancesSteps.flwResult.fchiNote">
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:when>

                                <xsl:when test="$ancesSteps.parBody.flwTopic.fchiTitle">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading4')]">
                                            <xsl:value-of select="'1.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>

                                <xsl:when test="$ancesSteps.parBody.parTopic.parTopic.flwTopic.fchiTitle">
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:when>

                                <xsl:otherwise>1.05mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesSteps[not(following-sibling::*)]">
                            <xsl:value-of select="'1.05mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.05mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preUl">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag[not(following-sibling::*)]">
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection[not(following-sibling::*)]">
                            <xsl:choose>
                                <xsl:when test="$parTag.parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.05mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTag.parSection.parBody[not(following-sibling::*)]">
                            <xsl:value-of select="'1.05mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="$ancesSteps[not(following-sibling::*)]">
                                    <xsl:value-of select="'1.05mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.parAbstract" select="$parTag/parent::*[matches(@class, ' topic/abstract ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody" select="$parTag.parAbstract/following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody.fchiSteps" select="$parTag.parAbstract.flwBody/*[1][matches(@class, ' task/steps ')]" />
            <xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwTable" select="$parTag/following-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="ancesSteps.flwResult" select="$ancesSteps/following-sibling::*[1][contains(@class, ' task/result ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote" select="$ancesSteps.flwResult/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="SrcMatchHref" select="key('jobFile', @href, $job)/@src" />
            <xsl:variable name="ancesTopic" select="$parTag/ancestor::*[contains(@class, 'topic/topic ')][1]" />
            <xsl:variable name="ancesTopic.flwTopic" select="$ancesTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesTopic.flwTopic.fchiTitle" select="$ancesTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesTopic.flwTitle" select="$ancesTopic/following::*[contains(@class, 'topic/title ')][1]" />
            <xsl:variable name="ancesSteps.parBody" select="$ancesSteps/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic" select="$ancesSteps.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic.fchiTitle" select="$ancesSteps.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />

            <xsl:choose>
                <xsl:when test="exists(key('jobFile', @href, $job)) and
                                matches($SrcMatchHref, 'PRC_Table_[12]')">
                    <xsl:value-of select="'1.8mm'"/>
                </xsl:when>

                <xsl:when test="$parTag.flwTable">
                    <xsl:choose>
                        <xsl:when test="$parTag.flwTable[matches(@outputclass, 'table_button')]">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag.preUl">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwUl">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:when test="$parTag.flwNote">
                    <xsl:value-of select="'2.5mm'" />
                </xsl:when>

                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                    <xsl:choose>
                        <xsl:when test="$ancesSteps.flwResult.fchiNote">
                            <xsl:value-of select="'2.3mm'" />
                        </xsl:when>


                        <xsl:when test="$ancesSteps/following-sibling::*">
                            <xsl:value-of select="'5.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>2.3mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preNote">
                    <xsl:value-of select="'5.5mm'" />
                </xsl:when>

                <xsl:when test="$ancesUl[matches(@outputclass, 'arrow')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancestable[matches(@outputclass, 'table_text')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag[not(following-sibling::*)]">
                    <xsl:choose>
                        <xsl:when test="$parTag.parAbstract.flwBody.fchiSteps">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesTopic.flwTopic.fchiTitle[contains(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'7.6mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'5.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="content-width">100%</xsl:attribute>

        <xsl:attribute name="content-height">
            <xsl:choose>
                <xsl:when test="@height">
                    <xsl:value-of select="@height" />
                </xsl:when>
                <xsl:otherwise>100%</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width" />
                </xsl:when>
                <xsl:otherwise>100%</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="scaling">uniform</xsl:attribute>

        <xsl:attribute name="text-align">
            <xsl:choose>
                <xsl:when test="@align">
                    <xsl:value-of select="@align" />
                </xsl:when>
                <xsl:otherwise>center</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="image__inline">
        <xsl:attribute name="content-width">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

            <xsl:value-of select="'100%'" />
        </xsl:attribute>

        <xsl:attribute name="content-height">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

            <xsl:value-of select="'100%'" />
        </xsl:attribute>

        <xsl:attribute name="padding-top">
            <xsl:variable name="ancesEntry" select="ancestor::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

            <xsl:choose>
                <xsl:when test="$ancesTable">
                    <xsl:choose>
                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
                            <xsl:value-of select="'-2mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- <xsl:when test="$ancesEntry">
                    <xsl:value-of select="'0mm'" />
                </xsl:when> -->

                <xsl:otherwise>-0.7mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="width">auto</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <xsl:attribute name="vertical-align">middle</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="image">
         <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="matches(@type, '(service|recycle)')">
                    <xsl:value-of select="'auto'" />
                </xsl:when>

                <xsl:otherwise>6mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

         <xsl:attribute name="height">
            <xsl:choose>
                <xsl:when test="matches(@type, '(service|recycle)')">
                    <xsl:value-of select="'auto'" />
                </xsl:when>

                <xsl:when test="matches(@type, 'warning')">
                    <xsl:value-of select="'5.434mm'" />
                </xsl:when>

                <xsl:when test="matches(@type, '(caution|notice)')">
                    <xsl:value-of select="'6mm'" />
                </xsl:when>

                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="content-width">
            <xsl:value-of select="'scale-to-fit'" />
        </xsl:attribute>

        <xsl:attribute name="scaling">uniform</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__align">

    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__entry">
        <xsl:attribute name="padding-before">
            <xsl:value-of select="'-0.7mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-end">
            <xsl:value-of select="'5pt'" />
        </xsl:attribute>

        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__entry">
        <xsl:attribute name="padding-before">
            <xsl:value-of select="'-0.7mm'" />
        </xsl:attribute>

        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__roundbox">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'2.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'4.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding" select="if ($writing-mode = 'lr') then '6.1mm 6mm 4mm 6mm' else '6.1mm 6mm 4mm 6mm'" />
        <xsl:attribute name="start-indent">
            <xsl:value-of select="'6mm'" />
        </xsl:attribute>
        <xsl:attribute name="end-indent">
            <xsl:value-of select="'6mm'" />
        </xsl:attribute>

        <xsl:attribute name="axf:border-radius">0.5em</xsl:attribute>
        <xsl:attribute name="background-color">cmyk(7.8%,3.6%,0%,0%)</xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="baseline-shift">
            <xsl:choose>
                <xsl:when test="matches($locale, '(zh-CN|zh-SG)')">
                    <xsl:value-of select="'0.7mm'" />
                </xsl:when>

                <xsl:otherwise>1.15mm</xsl:otherwise>
            </xsl:choose>

            <!-- <xsl:value-of select="'1.15mm'" /> -->
        </xsl:attribute>

        <!-- <xsl:attribute name="vertical-align">super</xsl:attribute> -->
        <xsl:attribute name="vertical-align">
            <xsl:choose>
                <xsl:when test="matches($locale, '(zh-CN|zh-SG)')">
                    <xsl:value-of select="'text-top'" />
                </xsl:when>

                <xsl:otherwise>super</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>


        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content__custom">
        <xsl:attribute name="baseline-shift">
            <xsl:value-of select="'2.15mm'" />
            <!-- <xsl:choose>
                <xsl:when test="matches($locale, '(zh-CN|zh-SG)')">
                    <xsl:value-of select="'0.7mm'" />
                </xsl:when>

                <xsl:otherwise>1.15mm</xsl:otherwise>
            </xsl:choose> -->
        </xsl:attribute>

        <!-- <xsl:attribute name="vertical-align">
            <xsl:value-of select="'text-top'" />s
        </xsl:attribute> -->

        <!-- <xsl:attribute name="vertical-align">
            <xsl:choose>
                <xsl:when test="matches($locale, '(zh-CN|zh-SG)')">
                    <xsl:value-of select="'text-top'" />
                </xsl:when>

                <xsl:otherwise>super</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:choose>
                <xsl:when test="matches(@id, 'plus6')">
                    <xsl:value-of select="'8pt'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'8pt'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="parLi.fchiP">
        <xsl:attribute name="text-indent">
            <xsl:value-of select="'0em'" />
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">inherit</xsl:attribute>


        <xsl:attribute name="keep-with-next.within-page">
            <xsl:variable name="ancesEntry" select="ancestor::*[contains(@class, 'topic/entry ')]" />

            <xsl:choose>
                <xsl:when test="$ancesEntry">
                    <xsl:value-of select="'always'" />
                </xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="preNote" select="preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parNote" select="parent::*[contains(@class, 'topic/note ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parResult" select="parent::*[contains(@class, ' task/result ')]" />
            <xsl:variable name="parResult.preStep" select="$parResult/preceding-sibling::*[1][contains(@class, ' task/steps ')]/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parResult.preStep.LchiInfo" select="$parResult.preStep/*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="parResult.preStep.LchiInfo.LchiNote" select="$parResult.preStep.LchiInfo/*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />
            <xsl:variable name="parAbstract" select="parent::*[matches(@class, ' topic/abstract ')]" />
            <xsl:variable name="parAbstract.preTitle" select="$parAbstract/preceding-sibling::*[1][matches(@class, ' topic/title ')]" />
            <xsl:variable name="parAbstract.flwBody" select="$parAbstract/following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection" select="$parAbstract.flwBody/*[1][matches(@class, ' topic/section ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiNote" select="$parAbstract.flwBody.fchiSection/*[1][matches(@class, ' topic/note ')]" />
            <xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSection.parBody.preTitle" select="$parSection.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />

            <xsl:choose>
                <xsl:when test="$parEntry">
                    <xsl:choose>
                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_key-features')]">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="matches(@outputclass, 'Heading3')">
                                    <xsl:value-of select="'4.6mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.3mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_text_tur_address')]">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'4.7mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_rohs')]">

                            <xsl:choose>
                                <xsl:when test="child::*[matches(@outputclass, 'space4')]">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0.3mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="position() = 1">
                    <xsl:choose>
                        <xsl:when test="$parNote">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'1.6mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:choose>
                                <xsl:when test="$parResult.preStep.LchiInfo.LchiNote">
                                    <xsl:value-of select="'4.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>3mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 &gt;= 2">
                                    <xsl:value-of select="'0.4mm'" />
                                </xsl:when>

                                <xsl:otherwise>0.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.parBody.preTitle">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.preTitle[matches(@outputclass, 'Heading[1234]')]">
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <!-- <xsl:otherwise>0.5mm</xsl:otherwise> -->
                                <xsl:otherwise>0.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:choose>
                        <xsl:when test="not(following-sibling::*)">
                            <xsl:choose>
                                <xsl:when test="$preP[count(node()) = 1]
                                                /*[matches(@outputclass, 'semi')]">
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preP">
                    <xsl:choose>
                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 &gt;= 2">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>0.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches($OSname, '-OS_upgrade') and
                                        $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                            <xsl:choose>
                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>0.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'npara')">
                            <!-- <xsl:value-of select="'5mm'" /> -->
                            <xsl:value-of select="'10.5mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'footnote')">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$preP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'5.3mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preUl">
                    <xsl:choose>
                        <xsl:when test="$flwUl and
                                        matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'npara')">
                            <!-- <xsl:value-of select="'5mm'" /> -->
                            <xsl:value-of select="'10.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preNote and
                                matches(@outputclass, 'upsp')">
                    <xsl:value-of select="'4.5mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwP" select="following-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="flwTable" select="following-sibling::*[1][contains(@class, ' topic/table ')]" />
            <xsl:variable name="flwNote" select="following-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />
            <xsl:variable name="parAbstract" select="parent::*[matches(@class, ' topic/abstract ')]" />
            <xsl:variable name="parAbstract.preTitle" select="$parAbstract/preceding-sibling::*[1][matches(@class, ' topic/title ')]" />
            <xsl:variable name="parAbstract.flwBody" select="$parAbstract/following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection" select="$parAbstract.flwBody/*[1][matches(@class, ' topic/section ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiNote" select="$parAbstract.flwBody.fchiSection/*[1][matches(@class, ' topic/note ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiP" select="$parAbstract.flwBody.fchiSection/*[1][matches(@class, ' topic/p ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSteps" select="$parAbstract.flwBody/*[1][matches(@class, ' task/steps ')]" />
            <xsl:variable name="flwStepCnt" select="if (count($parAbstract.flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parSection" select="parent::*[matches(@class, 'topic/section ')]" />

            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:choose>
                <xsl:when test="$parEntry">
                    <xsl:choose>
                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_key-features')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_text_tur_address')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_rohs')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="position() = 1">
                    <xsl:choose>
                        <xsl:when test="$flwP[not(node())]">
                            <xsl:choose>
                                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                                $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                                    <xsl:choose>
                                        <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                            <xsl:value-of select="'1.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>2.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>2.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'1.5mm'" />
                        </xsl:when>

                        <xsl:when test="$parAbstract.flwBody.fchiSection.fchiP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'3.8mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:choose>
                                        <xsl:when test="$flwNote">
                                            <xsl:value-of select="'0.65mm'" />
                                        </xsl:when>

                                        <xsl:when test="not(following-sibling::*)">
                                            <xsl:value-of select="'-0.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <!-- <xsl:value-of select="'1mm'" /> -->
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 &gt;= 2">
                                    <xsl:value-of select="'0.65mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parAbstract.flwBody.fchiSteps">
                            <xsl:choose>
                                <xsl:when test="$ancesStepCnt = 'multi'">
                                    <xsl:value-of select="'1mm'" />
                                </xsl:when>

                                <xsl:when test="$flwStepCnt = 'multi'">
                                    <xsl:value-of select="'1mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parInfo.parStep/following-sibling::*[1][contains(@class, 'task/step ')]">
                            <xsl:choose>
                                <xsl:when test="$parInfo.parStep[not(preceding-sibling::*)]">
                                    <xsl:value-of select="'-0.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$flwP">
                    <xsl:choose>
                        <xsl:when test="$flwP[not(node())]">
                            <xsl:value-of select="'2.5mm'" />
                        </xsl:when>

                        <xsl:when test="$flwP[matches(@outputclass, 'npara')]">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'footnote')">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preP">
                    <xsl:choose>
                        <xsl:when test="$parLi">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:value-of select="'-0.45mm'" />
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 &gt;= 2">
                                    <xsl:value-of select="'0.65mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches($OSname, '-OS_upgrade') and
                                        $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                            <xsl:choose>
                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'footnote')">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi' and
                                        not(following-sibling::*)">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="matches($locale, 'zh-') and
                                                $flwTable[matches(@outputclass, 'table_none')]">
                                    <xsl:value-of select="'0.3mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preUl and $flwUl and
                                matches(@outputclass, 'upsp')">
                    <xsl:value-of select="'1.5mm'" />
                </xsl:when>

                <xsl:when test="not(following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'upsp') and
                                        $parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3-TroubleShooting')]">
                            <xsl:value-of select="'1.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>1mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:value-of select="'0.5mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="text-indent">
            <xsl:value-of select="'0em'" />
        </xsl:attribute>

        <xsl:attribute name="axf:kerning-mode">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'pair'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="axf:punctuation-trim">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'FR')">
                    <xsl:value-of select="'adjacent'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:choose>
                        <xsl:when test="matches($OSname, '-OS_upgrade') and
                                        ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                            <xsl:value-of select="'600'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'900'" />
                        </xsl:when>

                        <xsl:otherwise>inherit</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- <xsl:when test="matches($localeStrAfter, 'MM') and
                                $OSname = 'R-OS_upgrade' and
                                ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'600'" />
                </xsl:when> -->

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[contains(@class, 'topic/topic ')]" />

            <xsl:choose>
                <xsl:when test="$ancesTopic[matches(@oid, 'backcover')]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:when test="$preUl">
                    <xsl:choose>
                        <xsl:when test="$flwUl and
                                        matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="keep-with-next.within-page">
            <xsl:variable name="ancesEntry" select="ancestor::*[contains(@class, 'topic/entry ')]" />

            <xsl:choose>
                <xsl:when test="$ancesEntry">
                    <xsl:value-of select="'always'" />
                </xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before.conditionality">
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:choose>
                        <xsl:when test="parent::*[matches(@class, '(topic/section |task/result )')]
                                        /preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'discard'" />
                        </xsl:when>

                        <xsl:otherwise>retain</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'discard'" />
                </xsl:when>

                <xsl:otherwise>retain</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="break-before">
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:value-of select="'auto'" />
                    <!-- <xsl:choose>
                        <xsl:when test="parent::*[matches(@class, '(topic/section |task/result )')]
                                        /preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'page'" />
                        </xsl:when>

                        <xsl:otherwise>auto</xsl:otherwise>
                    </xsl:choose> -->
                </xsl:when>

                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'page'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="inlineTblock">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'1.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0.3mm'" />
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="color">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="template" select="$OSname" />
            <xsl:variable name="cnt" select="count(ancestor::*[matches(@class, ' topic/topic ')])" />

            <xsl:call-template name="fontColor">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="template" select="$template" />
                <xsl:with-param name="cnt" select="$cnt" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ph">
        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'small')">
                            <xsl:value-of select="'900'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, '(nobreak|preserve)')">
                            <xsl:value-of select="'inherit'" />
                        </xsl:when>

                        <xsl:otherwise>600</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="text-decoration">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'underline')">
                    <xsl:value-of select="'underline'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'none'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="keep-together.within-line">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, '^preserve$')">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'auto'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="wrap-option">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'nobreak')">
                    <xsl:value-of select="'no-wrap'" />
                </xsl:when>
                <xsl:otherwise>wrap</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>