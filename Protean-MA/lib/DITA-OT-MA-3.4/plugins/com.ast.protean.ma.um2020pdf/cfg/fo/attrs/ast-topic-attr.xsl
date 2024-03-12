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

    <xsl:attribute-set name="topic" use-attribute-sets="base-font">
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">
            <xsl:variable name="fchiSection" select="*[1][contains(@class, 'topic/section ')]" />
            <xsl:variable name="fchiSection.fchUl" select="$fchiSection/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="$fchiSection.fchUl">
                    <xsl:choose>
                        <xsl:when test="$fchiSection.fchUl[not(matches(@outputclass, 'arrow'))]">
                            <xsl:value-of select="'3mm'" />
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
        <xsl:attribute name="column-width">
            <xsl:value-of select="'11mm'" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__column">
      <xsl:attribute name="column-number">2</xsl:attribute>
      <xsl:attribute name="column-width">
        <xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />
        <xsl:variable name="parLi" select="parent::*[contains(@class, 'topic/li ')]" />

        <xsl:choose>
            <xsl:when test="$parLi">
                <xsl:value-of select="'159mm'" />
            </xsl:when>

            <xsl:otherwise>167mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table" use-attribute-sets="common.block">
        <xsl:attribute name="margin-top">
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preNote" select="preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="preTable" select="preceding-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, ' task/info ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, ' task/cmd ')]" />
            <xsl:variable name="parSection" select="parent::*[contains(@class, ' topic/section ')]" />
            <xsl:variable name="parSection.preSteps" select="$parSection/preceding-sibling::*[1][matches(@class, 'task/steps ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo" select="$parSection.preSteps/*[last()]/*[last()][matches(@class, 'task/info ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo.LchiUl" select="$parSection.preSteps.LchiInfo/*[last()][matches(@class, 'topic/ul ')]" />
            <xsl:variable name="parSection.preSteps.LchiInfo.LchiP" select="$parSection.preSteps.LchiInfo/*[last()][matches(@class, 'topic/p ')]" />
            <xsl:variable name="ancesStepCnt02" select="if (count($parSection.preSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="flwP" select="following-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.preTitle" select="$parSection.parBody/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep" select="$parSection.preSteps/*[last()][matches(@class, 'task/step ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiCmd" select="$parSection.preSteps.LchiStep/*[last()][matches(@class, 'task/cmd ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo" select="$parSection.preSteps.LchiStep/*[last()][matches(@class, 'task/info ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo.LchiP" select="$parSection.preSteps.LchiStep.LchiInfo/*[last()][matches(@class, 'topic/p ')]" />
            <xsl:variable name="fchiP" select="*[1][contains(@class, ' topic/p ')]" />

            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">
                    <xsl:choose>
                        <xsl:when test="not(*[1][name()='ul'])">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$preP/*[@placement='inline']">
                                    <xsl:value-of select="'3.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:choose>
                        <xsl:when test="$preUl">
                            <xsl:choose>
                                <xsl:when test="*[1][name()='ul']">
                                    <xsl:value-of select="'5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.6mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$preP">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.6mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preNote">
                    <xsl:choose>
                        <xsl:when test="*[last()][name()='ul']">
                            <xsl:choose>
                                <xsl:when test="not($preNote/*[last()][name()='ul'])">
                                    <xsl:value-of select="'4.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="'4.7mm'" /> -->
                                    <xsl:value-of select="'5.8mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="not($preNote/*[last()][name()='ul'])">
                            <xsl:choose>
                                <xsl:when test="not(*[1][name()='ul'])">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$preNote/*[last()][name()='ul'] and
                                        not(*[1][name()='ul'])">
                            <xsl:value-of select="'4.1mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preP[contains(@outputclass, 'callout-image')] and
                                *[1][name()='ul']">
                    <!-- <xsl:value-of select="'2.7mm'" /> -->
                    <xsl:value-of select="'3.2mm'" />
                </xsl:when>

                <xsl:when test="$preTable">
                    <xsl:choose>
                        <xsl:when test="*[1][matches(name(), '^ul$')]">
                            <xsl:choose>
                                <xsl:when test="$preTable[matches(@outputclass, '^table_text$')]">
                                    <xsl:value-of select="'1mm'" />
                                </xsl:when>

                                <xsl:when test="$preTable[matches(@outputclass, '^table_icon$')]">
                                    <xsl:value-of select="'0.8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'4.8mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'0.7mm'" />
                        </xsl:when>

                        <xsl:when test="$parInfo.preCmd and
                                        not(*[1][name()='ul'])">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$parSection.preSteps.LchiInfo">
                            <xsl:choose>
                                <xsl:when test="not(*[1][name() = 'ul'])">
                                    <xsl:choose>
                                        <xsl:when test="$parSection.preSteps.LchiInfo.LchiUl">
                                            <xsl:value-of select="'3.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$ancesStepCnt02 = 'multi'">
                                            <xsl:choose>
                                                <xsl:when test="$parSection.preSteps.LchiStep.LchiInfo.LchiP
                                                                /*[@placement='break']">
                                                    <xsl:value-of select="'2.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'1.2mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$parSection.preSteps.LchiStep.LchiInfo.LchiP
                                                        /*[@placement='break']">
                                            <xsl:value-of select="'2.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0.8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="*[1][name()='ul']">
                                    <xsl:choose>
                                        <xsl:when test="$ancesStepCnt02 = 'onestep'">
                                            <xsl:choose>
                                                <xsl:when test="$parSection.preSteps.LchiInfo.LchiUl">
                                                    <xsl:value-of select="'4.3mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parSection.preSteps.LchiInfo.LchiP">
                                                    <xsl:value-of select="'3.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'2.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$ancesStepCnt02 = 'multi'">
                                            <xsl:choose>
                                                <xsl:when test="$parSection.preSteps.LchiStep.LchiInfo.LchiP
                                                                /*[@placement='break']">
                                                    <xsl:value-of select="'3.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'2.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.6mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.preSteps">
                            <xsl:choose>
                                <xsl:when test="$ancesStepCnt02 = 'onestep'">
                                    <xsl:choose>
                                        <xsl:when test="*[1][name()='ul']">
                                            <xsl:value-of select="'2.6mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.2mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesStepCnt02 = 'multi'">
                                    <xsl:choose>
                                        <xsl:when test="*[1][name()='ul']">
                                            <xsl:value-of select="'3.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$parSection.preSteps.LchiStep.LchiCmd
                                                                /*[@placement='inline']">
                                                    <xsl:value-of select="'2mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'1.7mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.preTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preP">
                    <xsl:choose>
                        <xsl:when test="not(*[1][name()='ul'])">
                            <xsl:choose>
                                <xsl:when test="$preP[matches(@outputclass, 'callout-image')]">
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:value-of select="'0.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="'0mm'" /> -->
                                    <xsl:value-of select="'1.1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preUl">
                    <xsl:choose>
                        <xsl:when test="not(*[name()='ul'])">
                            <!-- <xsl:value-of select="'2.5mm'" /> -->
                            <xsl:value-of select="'3.5mm'" />
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
            <xsl:variable name="parSection" select="parent::*[matches(@class, 'topic/section ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.flwTopic" select="$parSection.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.flwTopic.fchiTitle" select="$parSection.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic" select="$parSection.parBody.parTopic/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic" select="$parSection.parBody.parTopic.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />
            <xsl:variable name="parAbstract" select="parent::*[matches(@class, 'topic/abstract ')]" />
            <xsl:variable name="parAbstract.parBody" select="$parAbstract/following-sibling::*[1][matches(@class, 'topic/body ')]" />
            <xsl:variable name="parAbstract.parBody.fchiSteps" select="$parAbstract.parBody/*[1][matches(@class, 'task/steps ')]" />
            <xsl:variable name="flwP" select="following-sibling::*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.parTopic" select="$parSection.parBody.parTopic.parTopic/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.parTopic.flwTopic" select="$parSection.parBody.parTopic.parTopic.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.parTopic.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parSection.preSteps" select="$parSection/preceding-sibling::*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep" select="$parSection.preSteps/*[last()][contains(@class, 'task/step ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo" select="$parSection.preSteps.LchiStep/*[last()][contains(@class, ' task/info ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo.LchiP" select="$parSection.preSteps.LchiStep.LchiInfo/*[last()][contains(@class, ' topic/p ')]" />

            <xsl:choose>
                <xsl:when test="not(following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$ancesStep/following-sibling::*">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$parSection.parBody.flwTopic.fchiTitle">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:choose>
                                        <xsl:when test="*[last()][name()='ul']">
                                            <xsl:value-of select="'9.8mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'9mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:choose>
                                        <xsl:when test="*[last()][name()='ul']">
                                            <!-- <xsl:value-of select="'10.4mm'" /> -->
                                            <xsl:value-of select="'10.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:choose>

                                        <xsl:when test="not(*[last()][name()='ul'])">
                                            <!-- <xsl:value-of select="'9.7mm'" /> -->
                                            <xsl:value-of select="'10mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'10.8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:choose>
                                        <xsl:when test="not(*[name()='ul'])">
                                            <!-- <xsl:value-of select="'8.8mm'" /> -->
                                            <xsl:value-of select="'9mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <!-- <xsl:value-of select="'9.2mm'" /> -->
                                            <xsl:value-of select="'9.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading4')]">
                                    <xsl:choose>
                                        <xsl:when test="not(*[name()='ul'])">
                                            <xsl:value-of select="'6.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading1')]">
                                    <xsl:value-of select="'12mm'" />
                                </xsl:when>

                                <xsl:when test="$parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:value-of select="'9.8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>


                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading3')]">
                            <xsl:choose>
                                <xsl:when test="*[last()][name()='ul']">
                                    <xsl:value-of select="'9.2mm'" />
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


                        <xsl:when test="$parAbstract.parBody.fchiSteps">
                            <xsl:value-of select="'4.2mm'" />
                        </xsl:when>

                        <!-- <xsl:when test="$parSection.parBody.parTopic.parTopic.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading1')]">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when> -->

                        <xsl:otherwise>2.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parSection.parBody.flwTopic[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$flwP[count(node()) = 1]/*[1][matches(@placement, 'break')]">
                    <!-- <xsl:value-of select="'5.2mm'" /> -->
                    <xsl:value-of select="'4.7mm'" />
                </xsl:when>

                <xsl:otherwise>2.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="page-break-before">
            <xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />

            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preUl.preP" select="$preUl/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
            <!-- <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" /> -->
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

        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
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
                <xsl:when test="not(matches($OSname, '-OS_upgrade'))">
                    <xsl:value-of select="'1.25mm'" />
                </xsl:when>

                <xsl:otherwise>2.8mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:choose>
                <xsl:when test="not(matches($OSname, '-OS_upgrade'))">
                    <!-- <xsl:value-of select="'3.5mm'" /> -->
                    <xsl:value-of select="'3.8mm'" />
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
        <xsl:attribute name="font-weight">inherit</xsl:attribute>
        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="page-break-before">always</xsl:attribute>

    </xsl:attribute-set>

    <!-- Heading1 title 하늘색 -->
    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="padding-top">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />

            <xsl:variable name="parTopic.preTopic" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/topic ')]/descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
            <xsl:variable name="parTopic.preTopic.fchiBody" select="$parTopic.preTopic/*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection" select="$parTopic.preTopic.fchiBody/*[contains(@class, ' topic/section ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection.LchiUl" select="$parTopic.preTopic.fchiBody.fchiSection/*[last()][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection.LchiNote" select="$parTopic.preTopic.fchiBody.fchiSection/*[last()][contains(@class, ' topic/note ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps" select="$parTopic.preTopic.fchiBody/*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps.LchiStep" select="$parTopic.preTopic.fchiBody.LchiSteps/*[contains(@class, ' task/step ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep/*[contains(@class, ' task/cmd ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo" select="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep/*[contains(@class, ' task/info ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo.LchiP" select="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo/*[contains(@class, ' topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo.LchiUl" select="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo/*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="preStepCnt" select="if (count($parTopic.preTopic.fchiBody.LchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                    <xsl:value-of select="'6.3mm'" />
                </xsl:when>

                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'18.3mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.fchiSection.LchiUl">
                    <xsl:value-of select="'11.8mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.fchiSection.LchiNote[not(*[last()][name()='ul'])]">
                    <xsl:value-of select="'12mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.LchiSteps and
                                $preStepCnt = 'onestep'">

                    <xsl:choose>
                        <xsl:when test="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo.LchiP">
                            <xsl:value-of select="'9.6mm'" />
                        </xsl:when>

                        <xsl:when test="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiCmd
                                        /*[@placement='inline']">
                            <xsl:value-of select="'9.8mm'" />
                        </xsl:when>

                        <xsl:when test="$parTopic.preTopic.fchiBody.LchiSteps.LchiStep.LchiInfo.LchiUl">
                            <xsl:value-of select="'12.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'11mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>11.2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="flwBody" select="following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="flwBody.fchiSection" select="$flwBody/*[1][contains(@class, 'topic/section ')]" />
            <xsl:variable name="flwBody.fchiSection.fchiNote" select="$flwBody.fchiSection/*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="flwTopic" select="following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="flwTopic.fchiTitle" select="$flwTopic/*[1][contains(@class, 'topic/title ')]" />

            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="$flwBody.fchiSection.fchiNote">
                    <xsl:choose>
                        <xsl:when test="$flwBody.fchiSection.fchiNote[not(*[contains(@class, 'topic/ul ')])]">
                            <xsl:value-of select="'3.3mm'" />
                        </xsl:when>

                        <xsl:otherwise>3.3mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$flwTopic.fchiTitle[matches(@outputclass, 'Heading3-TroubleShooting')]">
                    <xsl:value-of select="'2.2mm'" />
                </xsl:when>

                <xsl:otherwise>2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>



        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>
        <xsl:attribute name="font-weight">inherit</xsl:attribute>

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
        <xsl:attribute name="padding-top">
            <xsl:choose>
                <xsl:when test="position() = 1">

                    <xsl:choose>
                        <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'-0.1mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTopic.preTopic" select="$parTopic/preceding-sibling::*[1][contains(@class, 'topic/topic ')]/descendant-or-self::*[contains(@class, 'topic/topic ')][last()]" />
            <xsl:variable name="parTopic.preTopic.fchiBody" select="$parTopic.preTopic/*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiStep" select="$parTopic.preTopic.fchiBody/*[last()][contains(@class, 'task/steps ')]/*[last()][contains(@class, 'task/step ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiStep.LchiInfo" select="$parTopic.preTopic.fchiBody.LchiStep/*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiStep.LchiInfo.LchiP" select="$parTopic.preTopic.fchiBody.LchiStep.LchiInfo/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection" select="$parTopic.preTopic.fchiBody/*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection.LchiP" select="$parTopic.preTopic.fchiBody.fchiSection/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.fchiBody.fchiSection.LchiUl" select="$parTopic.preTopic.fchiBody.fchiSection/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preStepCnt" select="if (count($parTopic.preTopic.fchiBody.LchiStep/parent::*[name()='steps']/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTopic.preTopic.fchiBody.LchiStep.LchiCmd" select="$parTopic.preTopic.fchiBody.LchiStep/*[last()][contains(@class, 'task/cmd ')]" />

            <xsl:choose>
                <xsl:when test="$parTopic.preTitle[matches(@outputclass, 'Heading1')]">
                    <xsl:value-of select="'9mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.LchiStep.LchiInfo.LchiP">
                    <xsl:choose>
                        <xsl:when test="$parTopic.preTopic.fchiBody.LchiStep.LchiInfo.LchiP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'8.6mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'8.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.fchiSection.LchiUl">
                    <xsl:value-of select="'10.5mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.fchiSection.LchiP">
                    <!-- <xsl:value-of select="'9.7mm'" /> -->
                    <xsl:value-of select="'9.5mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.fchiBody.LchiStep">
                    <xsl:choose>
                        <xsl:when test="$preStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preTopic.fchiBody.LchiStep.LchiCmd
                                                /*[@placement='inline']">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'9.1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'5mm'" />
                            <!-- <xsl:value-of select="'9.1mm'" /> -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'5mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="flwTopic" select="following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="flwTopic.fchiTitle" select="$flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="flwBody" select="following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="flwBody.fchiSteps" select="$flwBody/*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep" select="$flwBody.fchiSteps/*[1][contains(@class, 'task/step ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep.fchiCmd" select="$flwBody.fchiSteps.fchiStep/*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="flwStepCnt" select="if (count($flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTopic" select="parent::*[contains(@class, 'topic/topic ')]" />


            <xsl:choose>
                <xsl:when test="$flwTopic.fchiTitle">
                    <xsl:value-of select="'1.5mm'" />
                </xsl:when>

                <xsl:when test="$flwBody.fchiSteps and $flwStepCnt = 'onestep'">
                    <xsl:choose>
                        <xsl:when test="$parTopic[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <!-- <xsl:otherwise>2.3mm</xsl:otherwise> -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$flwBody.fchiSteps.fchiStep.fchiCmd[not(*[@placement='inline'])]">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.6mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$flwBody.fchiSteps and $flwStepCnt = 'multi'">
                    <xsl:choose>
                        <xsl:when test="$flwBody.fchiSteps.fchiStep.fchiCmd
                                        /*[@placement='inline']">
                            <xsl:choose>
                                <xsl:when test="$flwBody.fchiSteps.fchiStep.fchiCmd/*[@placement='inline'][matches(key('jobFile', @href, $job)/@src, '(I-snote_add.png)')]">
                                    <xsl:value-of select="'5.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'5.8mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'5.1mm'" />
                            <!-- <xsl:value-of select="'5.5mm'" /> -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>2.15mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
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

        <xsl:attribute name="font-weight">inherit</xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading3 title 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="padding-top">
            <xsl:choose>
                <xsl:when test="position() = 1 and
                                parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTopic.preTitle" select="$parTopic/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTopic.preTopic" select="$parTopic/preceding-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTopic.preTopic.LdesNote" select="$parTopic.preTopic/descendant::*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTopic.preBody" select="$parTopic/preceding-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTopic.preBody.fchiSection" select="$parTopic.preBody/*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTopic.preBody.fchiSection.LchiP" select="$parTopic.preBody.fchiSection/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps" select="$parTopic.preBody/*[last()][contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep" select="$parTopic.preBody.LchiSteps/*[last()][contains(@class, 'task/step ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/cmd ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep.LchiInfo" select="$parTopic.preBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/info ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiUl" select="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP" select="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody" select="$parTopic.preTopic/*[last()][contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection" select="$parTopic.preTopic.LchiBody/*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection.LchiNote" select="$parTopic.preTopic.LchiBody.fchiSection/*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection.LchiNote.LchiUl" select="$parTopic.preTopic.LchiBody.fchiSection.LchiNote/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection.LchiP" select="$parTopic.preTopic.LchiBody.fchiSection/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection.LchiUl" select="$parTopic.preTopic.LchiBody.fchiSection/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.fchiSection.LchiUl.LchiLi" select="$parTopic.preTopic.LchiBody.fchiSection.LchiUl/*[last()][contains(@class, 'topic/li ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps" select="$parTopic.preTopic.LchiBody/*[last()][contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep" select="$parTopic.preTopic.LchiBody.LchiSteps/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/cmd ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo" select="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/info ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo.LchiP" select="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo/*[last()][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parTopic.preTopic.LchiTopic" select="$parTopic.preTopic/*[last()][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTopic.preTopic.LchiTopic.LchiBody" select="$parTopic.preTopic.LchiTopic/*[last()][contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTopic.preTopic.LchiTopic.LchiBody.LchiSteps" select="$parTopic.preTopic.LchiTopic.LchiBody/*[last()][contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preTopic.LchiTopic.LchiBody.LchiSteps.LchiStep" select="$parTopic.preTopic.LchiTopic.LchiBody.LchiSteps/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parTopic.preTopic.LchiTopic.LchiBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preTopic.LchiTopic.LchiBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/cmd ')]" />



            <xsl:variable name="ancesStepCnt" select="if (count($parTopic.preTopic.LchiBody.LchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="preStepCnt" select="if (count($parTopic.preBody.LchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$parTopic[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                    <xsl:value-of select="'6.8mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preBody.fchiSection.LchiP">
                    <xsl:choose>
                        <xsl:when test="$parTopic.preBody.fchiSection.LchiP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'7.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'8.2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTopic.preBody.LchiSteps">
                    <xsl:choose>
                        <xsl:when test="$preStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiCmd
                                                /*[@placement='inline']">
                                    <xsl:value-of select="'3mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="'3mm'" /> -->
                                    <xsl:value-of select="'7.7mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTopic.preBody.LchiSteps and
                                        $preStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo">
                                    <xsl:choose>
                                        <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP">
                                            <xsl:choose>
                                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP[matches(@outputclass, 'callout-image')]">
                                                    <xsl:value-of select="'7.5mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP[not(*[@placement='inline'])]">
                                                    <xsl:value-of select="'9mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP
                                                                /*[@placement='inline']">
                                                    <xsl:value-of select="'6.3mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'8.3mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'8.3mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'8.3mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiUl">
                                    <xsl:value-of select="'8.8mm'" />
                                </xsl:when>

                                <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiInfo.LchiP[matches(@outputclass, 'callout-image')]">
                                    <xsl:value-of select="'7.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'3mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'3mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.LchiBody.fchiSection.LchiP[matches(@outputclass, 'callout-image')]">
                    <xsl:value-of select="'7.2mm'" />
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.LchiBody.fchiSection.LchiUl">
                    <xsl:choose>
                        <xsl:when test="$parTopic.preTopic.LchiBody.fchiSection.LchiUl.LchiLi
                                        /*[@placement='inline']">
                            <xsl:value-of select="'8.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'9.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps">
                    <xsl:choose>
                        <xsl:when test="$ancesStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo.LchiP">
                                    <xsl:choose>
                                        <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo.LchiP[count(node()) = 1]
                                                        /*[@placement='break']">
                                            <xsl:value-of select="'7.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'8.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiCmd
                                                /*[@placement='inline']">

                                    <!-- <xsl:value-of select="'8.2mm'" /> -->
                                    <xsl:value-of select="'7.4mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTopic.preTopic.LchiTopic.LchiBody.LchiSteps.LchiStep.LchiCmd
                                        /*[@placement='inline']">
                            <xsl:value-of select="'7.5mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo.LchiP">
                                    <xsl:choose>
                                        <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiInfo.LchiP[count(node()) = 1]
                                                        /*[@placement='break']">
                                            <xsl:value-of select="'7.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'8.2mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'8.2mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'8.2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTopic.preTitle">
                    <xsl:choose>
                        <xsl:when test="$parTopic.preTitle[contains(@outputclass, 'Heading2')]">
                            <!-- <xsl:value-of select="'8.8mm'" /> -->
                            <xsl:value-of select="'8.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'8mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>8mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="flwBody" select="following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="flwBody.fchiSteps" select="$flwBody/*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep" select="$flwBody.fchiSteps/*[1][contains(@class, 'task/step ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep.fchiCmd" select="$flwBody.fchiSteps.fchiStep/*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="flwBody.fchiSection" select="$flwBody/*[1][contains(@class, 'topic/section ')]" />
            <xsl:variable name="flwBody.fchiSection.fchiUl" select="$flwBody.fchiSection/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="$parTag[matches(@outputclass, 'pagebreak')]">
                    <xsl:choose>
                        <xsl:when test="$flwBody.fchiSteps">
                            <xsl:choose>
                                <xsl:when test="$ancesStepCnt = 'multi'">
                                    <!-- <xsl:value-of select="'4.3mm'" /> -->
                                    <xsl:value-of select="'4.7mm'" />
                                </xsl:when>

                                <xsl:when test="$ancesStepCnt = 'onestep'">
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="$flwBody.fchiSteps">
                    <xsl:choose>
                        <xsl:when test="$ancesStepCnt = 'onestep'">
                            <!-- <xsl:value-of select="'1.5mm'" /> -->
                            <xsl:choose>
                                <xsl:when test="$flwBody.fchiSteps.fchiStep.fchiCmd
                                                /*[@placement = 'inline']">
                                    <xsl:value-of select="'1.9mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.2mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:value-of select="'5.1mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'4mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$flwBody.fchiSection.fchiUl">
                    <xsl:value-of select="'3.8mm'" />
                </xsl:when>

                <xsl:otherwise>2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width" />
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="font-weight">inherit</xsl:attribute>

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
    </xsl:attribute-set>

    <!-- Heading4 title 연한 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="padding-top">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />

            <xsl:choose>
                <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTopic[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'-0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="parTopic" select="parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTopic" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody" select="$parTopic.preTopic/*[last()][contains(@class, ' topic/body ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps" select="$parTopic.preTopic.LchiBody/*[last()][contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep" select="$parTopic.preTopic.LchiBody.LchiSteps/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parTopic.preTopic.LchiBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preTopic.LchiBody.LchiSteps.LchiStep/*[last()][contains(@class, ' task/cmd ')]" />
            <xsl:variable name="preStepCnt" select="if (count($parTopic.preTopic.LchiBody.LchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTopic.preBody" select="$parTopic/preceding-sibling::*[1][contains(@class, ' topic/body ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps" select="$parTopic.preBody/*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep" select="$parTopic.preBody.LchiSteps/*[contains(@class, ' task/step ')]" />
            <xsl:variable name="parTopic.preBody.LchiSteps.LchiStep.LchiCmd" select="$parTopic.preBody.LchiSteps.LchiStep/*[contains(@class, ' task/cmd ')]" />
            <xsl:variable name="preStepCnt02" select="if (count($parTopic.preBody.LchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTopic[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$parTopic.preTopic.LchiBody.LchiSteps and
                                        $preStepCnt = 'onestep'">
                            <xsl:value-of select="'5.2mm'" />
                        </xsl:when>

                        <xsl:when test="$parTopic.preBody.LchiSteps">
                            <xsl:choose>
                                <xsl:when test="$preStepCnt02 = 'onestep'">
                                    <xsl:choose>
                                        <xsl:when test="$parTopic.preBody.LchiSteps.LchiStep.LchiCmd
                                                        /*[@placement='inline']">
                                            <xsl:value-of select="'5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>


                <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>

                <xsl:otherwise>4mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="flwBody" select="following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="flwBody.fchiSteps" select="$flwBody/*[1][matches(@class, ' task/steps ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep" select="$flwBody.fchiSteps/*[1][matches(@class, ' task/step ')]" />
            <xsl:variable name="flwBody.fchiSteps.fchiStep.fchiCmd" select="$flwBody.fchiSteps.fchiStep/*[1][matches(@class, ' task/cmd ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$flwBody.fchiSteps and
                                $ancesStepCnt = 'onestep'">
                    <xsl:value-of select="'1.2mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width" />
        </xsl:attribute>

        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
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
            <xsl:value-of select="'normal'" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note" use-attribute-sets="common.block base-font">
        <xsl:attribute name="space-before" select="'0mm'" />
        <xsl:attribute name="space-after" select="'0mm'" />
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height" />
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="image__block">
        <xsl:attribute name="margin-top">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.preTitle" select="$parTag.parSection.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwTable" select="$parTag/following-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesSteps.flwResult" select="$ancesSteps/following-sibling::*[1][contains(@class, ' task/result ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote" select="$ancesSteps.flwResult/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote.fchiUl" select="$ancesSteps.flwResult.fchiNote/*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTag.parInfo" select="$parTag/parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parTag.parInfo.preCmd" select="$parTag.parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="parTag.parAbstract" select="$parTag/parent::*[matches(@class, 'topic/abstract ')]" />
            <xsl:variable name="parTag.parAbstract.preTitle" select="$parTag.parAbstract/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[matches(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.flwTopic" select="$parTag.parSection.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />


            <xsl:choose>
                <xsl:when test="not($parTag/preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection.parBody.preTitle[matches(@outputclass, 'Heading3')]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:when test="$parTag.parInfo.preCmd">
                            <xsl:choose>
                                <xsl:when test="$ancesSteps and
                                                $ancesStepCnt = 'onestep'">

                                    <xsl:choose>
                                        <xsl:when test="$parTag.parInfo.preCmd
                                                        /*[@placement='inline']">
                                            <xsl:value-of select="'3.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'3mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesStepCnt = 'multi'">
                                    <xsl:choose>
                                        <xsl:when test="$parTag.parInfo.preCmd
                                                        /*[@placement='inline']">
                                            <!-- <xsl:value-of select="'3mm'" /> -->
                                            <xsl:value-of select="'3.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>

                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parTag.parAbstract.preTitle[matches(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preP">
                    <xsl:choose>
                        <xsl:when test="$parTag.preP[matches(@outputclass, 'callout-image')]">
                            <xsl:value-of select="'2.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>



                <xsl:when test="$parTag.preNote[not(*[name()='ul'])]">
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection.parBody.flwTopic[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'4.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.preUl">
                    <!-- <xsl:value-of select="'3.8mm'" /> -->
                    <xsl:value-of select="'4.5mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
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
            <xsl:variable name="ancesSteps.flwResult.fchiNote.fchiUl" select="$ancesSteps.flwResult.fchiNote/*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="ancesSteps.parBody" select="$ancesSteps/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic" select="$ancesSteps.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="parTag.parSection.parBody.parTopic" select="$parTag.parSection.parBody/parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parSection.parBody.parTopic.flwTopic" select="$parTag.parSection.parBody.parTopic/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parTag.parSection.parBody.parTopic.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.parInfo" select="$parTag/parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parTag.parInfo.parStep" select="$parTag.parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="parTag.parAbstract" select="$parTag/parent::*[matches(@class, ' topic/abstract ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody" select="$parTag.parAbstract/following-sibling::*[1][matches(@class, ' topic/body ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody.fchiSteps" select="$parTag.parAbstract.flwBody/*[1][matches(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt02" select="if (count($parTag.parAbstract.flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="not($parTag/following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection.parBody.flwTopic[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi' and
                                        $parTag.parInfo.parStep/following-sibling::*">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="$parTag.parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="$parTag.parAbstract.flwBody.fchiSteps">
                            <xsl:choose>
                                <xsl:when test="$ancesStepCnt02 = 'multi'">
                                    <!-- <xsl:value-of select="'1.5mm'" /> -->
                                    <xsl:value-of select="'2.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag.flwUl">
                    <xsl:choose>
                        <xsl:when test="$parTag.flwUl
                                        /*[1]/node()[1][name()='image']">
                            <!-- <xsl:value-of select="'0mm'" /> -->
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="$parTag.flwUl
                                        /*[name()='li']/*[1][name()='p'][count(node()) = 1]/*[name()='b']">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <!-- <xsl:value-of select="'0.8mm'" /> -->
                            <xsl:value-of select="'1.8mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="ancesUl" select="ancestor::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.preNote" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwTable" select="$parTag/following-sibling::*[1][contains(@class, 'topic/table ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="ancestable" select="ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesSteps.parBody" select="$ancesSteps/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic" select="$ancesSteps.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.flwTopic.fchiTitle" select="$ancesSteps.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parTag.parSection.parBody" select="$parTag.parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parSection.parBody.flwTopic" select="$parTag.parSection.parBody/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parSection.parBody.flwTopic.fchiTitle" select="$parTag.parSection.parBody.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="ancesSteps.flwResult" select="$ancesSteps/following-sibling::*[1][contains(@class, ' task/result ')]" />
            <xsl:variable name="ancesSteps.flwResult.fchiNote" select="$ancesSteps.flwResult/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="parTag.flwP" select="$parTag/following-sibling::*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parTag.parAbstract" select="$parTag/parent::*[contains(@class, 'topic/abstract ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody" select="$parTag.parAbstract/following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parAbstract.flwBody.fchiSteps" select="$parTag.parAbstract.flwBody/*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />

            <xsl:value-of select="'0mm'" />
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

            <!-- <xsl:value-of select="'97%'" /> -->
            <xsl:value-of select="'scale-down-to-fit'" />
        </xsl:attribute>

        <xsl:attribute name="content-height">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

            <!-- <xsl:value-of select="'97%'" /> -->
            <xsl:value-of select="'scale-down-to-fit'" />
        </xsl:attribute>

        <xsl:attribute name="width">auto</xsl:attribute>
        <xsl:attribute name="height">auto</xsl:attribute>


        <xsl:attribute name="vertical-align">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parTag.flwUl" select="$parTag/following-sibling::*[1][contains(@class, 'topic/ul ')]" />


            <xsl:choose>
                <xsl:when test="$parTag.preUl and $parTag.flwUl">
                    <xsl:value-of select="'baseline'" />
                </xsl:when>

                <xsl:otherwise>text-bottom</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="scaling">uniform</xsl:attribute>

        <xsl:attribute name="baseline-shift">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, 'topic/li ')]" />

            <xsl:value-of select="'0.3mm'" />
            <!-- <xsl:choose>
                <xsl:when test="$ancesTable">
                    <xsl:value-of select="'baseline'" />
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:value-of select="'0.3mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0.3mm'" />
                </xsl:otherwise>
            </xsl:choose> -->
        </xsl:attribute>

        <xsl:attribute name="line-height-shift-adjustment">
            <xsl:value-of select="'disregard-shifts'" />
            <!-- <xsl:value-of select="'consider-shifts'" /> -->
        </xsl:attribute>


        <xsl:attribute name="padding-top">
            <xsl:variable name="ancesEntry" select="ancestor::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />
            <xsl:variable name="ancesTitle" select="ancestor::*[contains(@class, 'topic/title ')]" />

            <xsl:choose>
                <xsl:when test="$ancesTable">
                    <xsl:choose>
                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
                            <!-- <xsl:value-of select="'-2mm'" /> -->
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesTitle">
                    <xsl:value-of select="'-1mm'" />
                </xsl:when>

                <!-- <xsl:otherwise>-1.5mm</xsl:otherwise> -->
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
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
                    <!-- <xsl:value-of select="'5.434mm'" /> -->
                    <xsl:value-of select="'4mm'" />
                </xsl:when>

                <xsl:when test="matches(@type, '(caution|notice)')">
                    <xsl:value-of select="'4mm'" />
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
            <xsl:variable name="preNote" select="preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="preNote.LchiUl" select="$preNote/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwNote" select="following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="fchiUl" select="*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, 'topic/li ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, 'topic/p ')]" />

            <xsl:choose>
                <xsl:when test="$parLi">
                    <xsl:choose>
                        <xsl:when test="$preUl">
                            <xsl:choose>
                                <xsl:when test="*[1][name()='ul']">
                                    <xsl:value-of select="'-0.9mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'-1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$preP">
                            <xsl:choose>
                                <xsl:when test="not(*[1][name()='ul'])">
                                    <!-- <xsl:value-of select="'1.5mm'" /> -->
                                    <xsl:value-of select="'0.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'-1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="*[1][name()='ul']">
                            <xsl:value-of select="'-1.8mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'-1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="*[1][name()='ul']">
                    <xsl:value-of select="'-1.8mm'" />
                </xsl:when>

                <xsl:when test="not(*[1][name()='ul'])">
                    <xsl:choose>
                        <xsl:when test="*[@placement='inline']">
                            <xsl:choose>
                                <xsl:when test="*[@placement='inline'][matches(key('jobFile', @href, $job)/@src, '(I-more_edge_setting[12].png)')]">
                                    <xsl:value-of select="'0.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'-1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'-1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'-1mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-end">
            <xsl:value-of select="'5pt'" />
        </xsl:attribute>

        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__entry">
        <xsl:attribute name="padding-before">
            <!-- <xsl:choose>
                <xsl:when test="*[contains(@class, 'topic/image ')][@placement='inline']">
                    <xsl:value-of select="'0.80mm'" />
                </xsl:when>

                <xsl:otherwise>-0.7mm</xsl:otherwise>
            </xsl:choose> -->
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="matches(@type, '(service|recycle)')">
                    <xsl:value-of select="'10mm'" />
                </xsl:when>

                <xsl:otherwise>0pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__roundbox">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'2.6mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />

            <xsl:choose>
                <xsl:when test="$parSection[not(following-sibling::*)] and $flwTitle">
                    <xsl:choose>
                        <xsl:when test="not(following-sibling::*) and
                                        $flwTitle[matches(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'13mm'" />
                        </xsl:when>

                        <xsl:otherwise>4.6mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>4.6mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding">
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:choose>
                <xsl:when test="$preUl">
                    <xsl:value-of select="'5.7mm 6mm 4mm 6mm'" />
                </xsl:when>

                <xsl:otherwise>5.7mm 6mm 4.5mm 6mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

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

        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- <xsl:attribute-set name="tm">
        <xsl:attribute name="border-start-width">0pt</xsl:attribute>
        <xsl:attribute name="border-end-width">0pt</xsl:attribute>
    </xsl:attribute-set> -->

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="font-size-adjust">0.86</xsl:attribute>
        <xsl:attribute name="baseline-shift">-1.3mm</xsl:attribute>
        <xsl:attribute name="vertical-align">super</xsl:attribute>
        <xsl:attribute name="font-size">inherit</xsl:attribute>

        <!-- <xsl:attribute name="font-size">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontSize">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute> -->

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

        <!-- <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute> -->

        <!-- <xsl:attribute name="font-stretch">
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
        </xsl:attribute> -->

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
        <xsl:attribute name="padding-top">
            <xsl:variable name="parSection" select="parent::*[contains(@class, ' topic/section ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />

            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

             <xsl:choose>
                 <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                     <xsl:value-of select="'-1mm'" />
                 </xsl:when>

                 <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$ancesSteps">
                            <xsl:choose>
                                <xsl:when test="$ancesStepCnt = 'multi'">
                                    <xsl:choose>
                                        <xsl:when test="$parInfo.preCmd
                                                        /*[@placement='inline']">
                                            <!-- <xsl:value-of select="'-0.5mm'" /> -->

                                            <xsl:choose>
                                                <xsl:when test="*[@placement='inline']">
                                                    <!-- <xsl:value-of select="'-1.3mm'" /> -->
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$parInfo.preCmd[not(*[@placement='inline'])]">
                                            <xsl:choose>
                                                <xsl:when test="not(*[@placement='inline'])">
                                                    <xsl:choose>
                                                        <xsl:when test="not($ancesStep/preceding-sibling::*)">
                                                            <xsl:value-of select="'0.3mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'0.8mm'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:when test="*[@placement='inline']">
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>



                                        <xsl:otherwise>
                                            <xsl:value-of select="'0.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                         </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                 </xsl:when>



                 <xsl:otherwise>
                     <xsl:value-of select="'0mm'" />
                 </xsl:otherwise>
             </xsl:choose>
         </xsl:attribute>

        <xsl:attribute name="space-before">
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="preUl.LchiLi" select="$preUl/*[last()][contains(@class, ' topic/li ')]" />
            <xsl:variable name="preUl.LchiLi.LchiUl" select="$preUl.LchiLi/*[last()][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="preNote" select="preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parNote" select="parent::*[contains(@class, 'topic/note ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parResult" select="parent::*[contains(@class, ' task/result ')]" />
            <xsl:variable name="parResult.preStep" select="$parResult/preceding-sibling::*[1][contains(@class, ' task/steps ')]/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parResult.preStep.LchiInfo" select="$parResult.preStep/*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="parResult.preStep.LchiInfo.LchiNote" select="$parResult.preStep.LchiInfo/*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parSection" select="parent::*[contains(@class, ' topic/section ')]" />
            <xsl:variable name="parSection.preSteps" select="$parResult/preceding-sibling::*[1][contains(@class, ' task/steps ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.preTitle" select="$parSection.parBody/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parAbstract" select="parent::*[contains(@class, ' topic/abstract ')]" />
            <xsl:variable name="parAbstract.preTitle" select="$parAbstract/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parAbstract.preTitle.parTopic" select="$parAbstract.preTitle/parent::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep" select="$parSection.preSteps/*[last()][contains(@class, ' task/step ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo" select="$parSection.preSteps.LchiStep/*[last()][contains(@class, ' task/info ')]" />
            <xsl:variable name="parSection.preSteps.LchiStep.LchiInfo.LchiP" select="$parSection.preSteps.LchiStep.LchiInfo/*[last()][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="ancesStepCnt02" select="if (count($parSection.preSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$parSection/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parEntry">
                    <xsl:choose>
                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_key-features')]">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="matches(@outputclass, 'Heading3')">
                                    <xsl:value-of select="'3.7mm'" />
                                </xsl:when>

                                <xsl:otherwise>1.7mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_text')]">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'0.3mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="position() = 1">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0.4mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="position() = 1">
                    <xsl:choose>
                        <xsl:when test="matches($OSname, '-OS_upgrade') and
                                        $ancesTopic[@oid = 'introduction'][@otherprops='introduction']">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                        <xsl:when test="$parNote">
                            <xsl:choose>
                                <xsl:when test="$parNote/preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                                    <xsl:value-of select="'0.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'1.6mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:choose>
                                <xsl:when test="$parResult.preStep.LchiInfo.LchiNote">
                                    <xsl:value-of select="'4.5mm'" />
                                </xsl:when>

                                <xsl:when test="$parSection.preSteps and
                                                $ancesStepCnt02 = 'onestep'">
                                    <xsl:choose>
                                        <xsl:when test="$parSection.preSteps.LchiStep.LchiInfo.LchiP[matches(@outputclass, 'callout-image')]">
                                            <xsl:value-of select="'2.4mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parSection.preSteps and
                                                $ancesStepCnt02 = 'multi'">
                                    <xsl:value-of select="'3.3mm'" />
                                </xsl:when>



                                <xsl:otherwise>2.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:choose>
                                        <xsl:when test="*[@placement='inline']">
                                            <!-- <xsl:value-of select="'0mm'" /> -->
                                            <!-- <xsl:value-of select="'0.3mm'" /> -->

                                            <xsl:choose>
                                                <xsl:when test="$parInfo.preCmd
                                                                /*[@placement='inline']">
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$parInfo.preCmd
                                                        /*[@placement='inline']">
                                            <!-- <xsl:value-of select="'0.2mm'" /> -->
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:when>

                                        <xsl:when test="not($parInfo.preCmd
                                                        /*[@placement='inline'])">
                                            <xsl:choose>
                                                <xsl:when test="not(*[@placement='inline'])">
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <!-- <xsl:value-of select="'0mm'" /> -->
                                            <xsl:value-of select="'0.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <!-- <xsl:value-of select="'1mm'" /> -->
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 2">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <!-- <xsl:otherwise>0.5mm</xsl:otherwise> -->
                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="not(preceding-sibling::*)">
                                    <xsl:choose>
                                        <xsl:when test="$parInfo.preCmd
                                                        /*[@placement='inline']">
                                            <xsl:choose>
                                                <xsl:when test="*[@placement='inline']">
                                                    <!-- <xsl:value-of select="'0mm'" /> -->
                                                    <xsl:value-of select="'1mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'1mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$parInfo.preCmd[not(*[@placement='inline'])]">
                                            <xsl:choose>
                                                <xsl:when test="not(*[@placement='inline'])">
                                                    <!-- <xsl:value-of select="'1mm'" /> -->

                                                    <xsl:choose>
                                                        <xsl:when test="not(following-sibling::*)">
                                                            <xsl:value-of select="'1.6mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'1mm'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.8mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0.8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:value-of select="'0.9mm'" />
                                </xsl:when>

                                <xsl:when test="node()[1][self::*][name()='b']">
                                    <xsl:value-of select="'1.1mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'2mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>


                        <xsl:when test="$parAbstract.preTitle">
                            <xsl:choose>
                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading1')]">
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:when>

                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading2')]">
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:when>

                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:when>

                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading4')]">
                                    <xsl:value-of select="'1.7mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$parSection.parBody.preTitle">
                            <xsl:choose>
                                <xsl:when test="$parSection.parBody.preTitle[matches(@outputclass, 'Heading3')]">
                                    <xsl:value-of select="'0.7mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parLi">
                    <xsl:choose>
                        <xsl:when test="$preP">
                            <xsl:choose>
                                <xsl:when test="$preP[count(node()) = 1]/*[name()='b']">
                                    <xsl:value-of select="'0.3mm'" />
                                </xsl:when>

                                <xsl:when test="*[@placement='inline']">
                                    <xsl:value-of select="'0.8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.8mm'" />
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
                        <xsl:when test="$preP[not(node())]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:value-of select="'1.5mm'" />
                                </xsl:when>

                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 2">
                                    <xsl:value-of select="'0.4mm'" />
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:when>

                                <!-- <xsl:otherwise>0.5mm</xsl:otherwise> -->
                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$preP[matches(@outputclass, 'Heading3')]">
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'2.2mm'" />
                        </xsl:when>

                        <xsl:when test="$preP[count(node()) = 1]/*[name()='b']">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="*[@placement='inline']">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preUl">
                    <xsl:choose>
                        <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="count(node()) = 1 and
                                                *[name()='cmdname']">


                                    <xsl:choose>
                                        <xsl:when test="$preUl.LchiLi.LchiUl">
                                            <xsl:value-of select="'5.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'4.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- <xsl:when test="$flwUl and
                                        matches(@outputclass, 'upsp')">
                            <xsl:choose>
                                <xsl:when test="$parSection">
                                    <xsl:value-of select="'3mm'" />
                                </xsl:when>

                                <xsl:otherwise>2.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when> -->

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'5.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preNote">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:value-of select="'4.5mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'6.9mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="parNote" select="parent::*[contains(@class, 'topic/note ')]" />
            <xsl:variable name="parNote.flwNote" select="$parNote/following-sibling::*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesSteps.parBody" select="$ancesSteps/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic" select="$ancesSteps.parBody/parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.flwTopic" select="$ancesSteps.parBody.parTopic/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="ancesSteps.parBody.parTopic.flwTopic.fchiTitle" select="$ancesSteps.parBody.parTopic.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwP" select="following-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="flwNote" select="following-sibling::*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="flwNote.fchiUl" select="$flwNote/*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parAbstract" select="parent::*[contains(@class, 'topic/abstract ')]" />
            <xsl:variable name="parAbstract.flwBody" select="$parAbstract/following-sibling::*[1][contains(@class, 'topic/body ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection" select="$parAbstract.flwBody/*[1][contains(@class, 'topic/section ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiUl" select="$parAbstract.flwBody.fchiSection/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiUl.fchiLi" select="$parAbstract.flwBody.fchiSection.fchiUl/*[1][contains(@class, 'topic/li ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSteps" select="$parAbstract.flwBody/*[1][contains(@class, 'task/steps ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSteps.fchiStep" select="$parAbstract.flwBody.fchiSteps/*[1][contains(@class, 'task/step ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSteps.fchiStep.fchiCmd" select="$parAbstract.flwBody.fchiSteps.fchiStep/*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="flwStepCnt" select="if (count($parAbstract.flwBody.fchiSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="parSection" select="parent::*[contains(@class, ' topic/section ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
            <xsl:variable name="parSection.parBody.preTitle" select="$parSection.parBody/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="ancesSteps.flwSection" select="$ancesSteps/following-sibling::*[1][contains(@class, ' topic/section ')]" />
            <xsl:variable name="ancesSteps.flwSection.fchiNote" select="$ancesSteps.flwSection/*[1][contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancesSteps.flwSection.fchiNote.fchiUl" select="$ancesSteps.flwSection.fchiNote/*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="preTitle" select="preceding::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parSection.parBody.flwTopic" select="$parSection.parBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.flwTopic.fchiTitle" select="$parSection.parBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[contains(@class, ' topic/title ')]" />
            <xsl:variable name="parAbstract.flwBody.fchiSection.fchiP" select="$parAbstract.flwBody.fchiSection/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="parAbstract.preTitle" select="$parAbstract/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic" select="$parSection.parBody.parTopic/parent::*[contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic" select="$parSection.parBody.parTopic.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

            <xsl:choose>
                <xsl:when test="$parEntry">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$ancesTable[matches(@outputclass, 'table_key-features')]">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="matches(@outputclass, 'Heading3')">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="position() = 1">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="matches(@outputclass, 'upsp')">
                            <xsl:choose>
                                <xsl:when test="$flwNote">
                                    <xsl:value-of select="'1.4mm'" />
                                </xsl:when>

                                <xsl:when test="$flwP[count(node()) = 1]
                                                /*[1][@placement='break']">
                                    <xsl:value-of select="'3.3mm'" />
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:choose>
                                        <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'1mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwUl">
                                    <xsl:choose>
                                        <xsl:when test="count(node()) = 1 and
                                                        *[name()='cmdname']">
                                            <xsl:value-of select="'2.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <xsl:choose>
                                        <xsl:when test="$flwNote">
                                            <xsl:value-of select="'0.3mm'" />
                                        </xsl:when>

                                        <xsl:when test="$flwP[matches(@outputclass, 'callout-image')]">
                                            <xsl:value-of select="'0.65mm'" />
                                        </xsl:when>

                                        <xsl:when test="position() = last()">
                                            <xsl:value-of select="'0.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwP">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="$flwUl">
                                    <xsl:value-of select="'2.2mm'" />
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*) and
                                                $ancesStep/following-sibling::*">
                                    <xsl:choose>
                                        <xsl:when test="*[@placement='inline']">
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0.5mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*) and
                                                not($ancesStep/following-sibling::*)">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:choose>
                                                <xsl:when test="not(*[@placement='inline'])">
                                                    <xsl:value-of select="'0.6mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.2mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'1mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesSteps and
                                        $ancesStepCnt = 'onestep'">
                            <xsl:choose>
                                <xsl:when test="$parInfo.preCmd
                                                /*[@placement='inline']">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle">
                                            <xsl:choose>
                                                <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'0.2mm'" />
                                                </xsl:when>

                                                <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                                    <xsl:value-of select="'1.1mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'2mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$flwUl">
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwP">
                                    <xsl:value-of select="'1.2mm'" />
                                </xsl:when>

                                <xsl:when test="$ancesSteps.flwSection.fchiNote">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:value-of select="'0.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwUl">
                                    <xsl:choose>
                                        <xsl:when test="$parNote">
                                            <xsl:value-of select="'1.8mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'1mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwP[count(node()) = 1]
                                                /*[@placement='break']">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$flwNote">
                            <xsl:choose>
                                <xsl:when test="$flwNote/*[contains(@class, 'topic/ul ')]">
                                    <xsl:value-of select="'1.75mm'" />
                                </xsl:when>

                                <xsl:otherwise>1.45mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="position() = last()">
                            <xsl:choose>
                                <xsl:when test="$parAbstract.flwBody.fchiSteps and
                                                $flwStepCnt = 'onestep'">
                                    <xsl:choose>
                                        <xsl:when test="$parAbstract.flwBody.fchiSteps.fchiStep.fchiCmd
                                                        /*[@placement='inline']">
                                            <xsl:value-of select="'0.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'1.15mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwTitle and $parSection">
                                    <xsl:choose>
                                        <xsl:when test="not(following-sibling::*)">
                                            <xsl:choose>
                                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'0.5mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'1mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                                    <xsl:value-of select="'4.7mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading4')]">
                                                    <xsl:value-of select="'3mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle">
                                            <xsl:choose>
                                                <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'0.8mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading4')]">
                                            <xsl:value-of select="'2.3mm'" />
                                        </xsl:when>

                                        <xsl:when test="$parSection.parBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                            <xsl:value-of select="'4.8mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>1.1mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps/following-sibling::*">
                                            <xsl:choose>
                                                <xsl:when test="$ancesSteps.flwSection.fchiNote[not(*[contains(@class, 'topic/ul ')])]">
                                                    <xsl:value-of select="'1.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>1.5mm</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$ancesSteps[not(following-sibling::*)] and
                                                        $flwTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:value-of select="'0.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>1mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parAbstract.flwBody.fchiSteps and
                                                $flwStepCnt = 'multi'">
                                    <xsl:choose>
                                        <xsl:when test="$parAbstract.flwBody.fchiSteps">
                                            <xsl:choose>
                                                <xsl:when test="$parAbstract.flwBody.fchiSteps.fchiStep.fchiCmd
                                                                /*[@placement='inline']">
                                                    <xsl:value-of select="'3.5mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parAbstract.flwBody.fchiSteps.fchiStep.fchiCmd[not(*[@placement='inline'])]">
                                                    <xsl:value-of select="'3.8mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'3.5mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading2')]">
                                                    <xsl:value-of select="'4mm'" />
                                                </xsl:when>

                                                <xsl:when test="$parAbstract.preTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'4.2mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'3.8mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parAbstract.flwBody.fchiSection.fchiUl">
                                    <!-- <xsl:value-of select="'2mm'" /> -->

                                    <xsl:choose>
                                        <xsl:when test="$parAbstract.flwBody.fchiSection.fchiUl.fchiLi
                                                        /node()[1][@placement='inline']">
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.8mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parAbstract.flwBody.fchiSection.fchiP[count(node()) = 1]/*[@placement='break']">
                                    <xsl:value-of select="'3.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$flwP[count(node()) = 1]/*[matches(@placement, 'break')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$flwUl">
                            <xsl:choose>
                                <xsl:when test="count(node()) = 1 and
                                                *[name()='b']">
                                    <xsl:value-of select="'2.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="'1mm'" /> -->
                                    <xsl:value-of select="'1.8mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$preP">
                    <xsl:choose>
                        <xsl:when test="$parLi">
                            <xsl:choose>
                                <xsl:when test="position() = last()">
                                    <xsl:choose>
                                        <xsl:when test="$parLi/following-sibling::*">
                                            <xsl:value-of select="'-1.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$ancesStepCnt = 'multi'">
                            <xsl:choose>
                                <xsl:when test="count($parInfo.parStep/preceding-sibling::*[contains(@class, 'task/step ')]) +1 = 1">
                                    <!-- <xsl:value-of select="'-0.45mm'" /> -->
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:when test="not(following-sibling::*)">
                                    <xsl:choose>
                                        <xsl:when test="$ancesStep/following-sibling::*">
                                            <xsl:value-of select="'0.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$ancesStep[not(following-sibling::*)]">
                                            <xsl:choose>
                                                <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                                    <xsl:value-of select="'0.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$flwP[count(node()) = 1]
                                                /*[@placement='break']">
                                    <xsl:value-of select="'0.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="not(following-sibling::*)">
                            <xsl:choose>
                                <xsl:when test="$flwTitle and $parSection">
                                    <xsl:choose>
                                        <xsl:when test="$parSection.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:when>

                                        <xsl:when test="$parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:when>

                                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:value-of select="'0.4mm'" />
                                        </xsl:when>

                                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading1-H3')]">
                                            <xsl:value-of select="'0.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>1mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesStepCnt = 'onestep' and $ancesSteps">
                                    <xsl:choose>
                                        <xsl:when test="$ancesSteps.flwSection.fchiNote">
                                            <xsl:value-of select="'2.2mm'" />
                                        </xsl:when>

                                        <xsl:when test="$ancesSteps.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading1')]">
                                            <xsl:choose>
                                                <xsl:when test="*[@placement='inline']">
                                                    <xsl:value-of select="'1.8mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'1.8mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:value-of select="'0.3mm'" />
                                        </xsl:when>

                                        <xsl:when test="$flwTitle[matches(@outputclass, 'Heading4')]">
                                            <xsl:value-of select="'0.1mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>1mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parAbstract.flwBody.fchiSteps">
                                    <xsl:choose>
                                        <xsl:when test="$flwStepCnt = 'multi'">
                                            <!-- <xsl:value-of select="'3mm'" /> -->
                                            <xsl:value-of select="'3.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>

                                            <xsl:choose>
                                                <xsl:when test="$parAbstract.flwBody.fchiSteps.fchiStep.fchiCmd
                                                                /*[@placement='inline']">
                                                    <xsl:value-of select="'0.2mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'1mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parNote.flwNote">
                                    <xsl:value-of select="'-0.3mm'" />
                                </xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$flwNote">
                            <xsl:choose>
                                <xsl:when test="$flwNote[*[1][name()='ul']]">
                                    <xsl:value-of select="'1.3mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="not(*[@placement='inline'])">
                                            <xsl:value-of select="'2.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'2.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$flwUl and $parNote">
                            <!-- <xsl:value-of select="'1.1mm'" /> -->
                            <xsl:value-of select="'1.8mm'" />
                        </xsl:when>

                        <xsl:when test="$flwP[matches(@outputclass, 'callout-image')]">
                            <!-- <xsl:value-of select="'3.7mm'" /> -->
                            <xsl:value-of select="'0.1mm'" />
                        </xsl:when>

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$flwNote">
                    <xsl:value-of select="'1.5mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'upsp')">
                    <xsl:choose>
                        <xsl:when test="$flwP">
                            <xsl:value-of select="'0.9mm'" />
                        </xsl:when>

                        <xsl:when test="$flwUl">
                            <xsl:choose>
                                <xsl:when test="count(node()) = 1 and
                                                *[name()='cmdname']">
                                    <xsl:value-of select="'2.2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>1mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
            <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
            <xsl:variable name="parInfo.parStep" select="$parInfo/parent::*[contains(@class, 'task/step ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

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

        <xsl:attribute name="start-indent">
            <xsl:variable name="preUl" select="preceding-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwUl" select="following-sibling::*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />

            <xsl:choose>
                <xsl:when test="$parSection[matches(@outputclass, 'box')]">
                    <xsl:value-of select="'0mm'" />
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
                    <xsl:choose>
                        <xsl:when test="parent::*[matches(@class, '(topic/section |task/result )')]
                                        /preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                            <xsl:value-of select="'page'" />
                        </xsl:when>

                        <xsl:otherwise>auto</xsl:otherwise>
                    </xsl:choose>
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

    <xsl:attribute-set name="ph">
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
                <xsl:when test="@outputclass = 'nobreak'">
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

    <!-- <xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
        <xsl:param name="nodes" as="node()*" />
        <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function> -->
</xsl:stylesheet>