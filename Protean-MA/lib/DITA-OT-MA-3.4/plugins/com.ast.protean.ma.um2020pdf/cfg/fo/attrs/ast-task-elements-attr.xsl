<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:functx="http://www.functx.com"
    version="2.0">

    <xsl:attribute-set name="info">
        <xsl:attribute name="space-before">
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
            <xsl:variable name="preCmd" select="preceding-sibling::*[1][contains(@class, 'task/cmd')]" />

            <xsl:choose>
                <xsl:when test="$ancesSteps and
                                $ancesStepCnt = 'onestep'">

                    <xsl:choose>
                        <xsl:when test="*[1][name()='ul']">
                            <xsl:value-of select="'2mm'" />
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
        
        <xsl:attribute name="space-after">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cmd">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'0.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-top">
            <xsl:variable name="parStep" select="parent::*[contains(@class, ' task/step ')]" />

            <!-- <xsl:choose>
                <xsl:when test="$parStep[count(preceding-sibling::*) &gt; 1]">
                    <xsl:choose>
                        <xsl:when test="*[@placement='inline']">
                            <xsl:value-of select="'-0.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'01mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'02mm'" />
                </xsl:otherwise>
            </xsl:choose> -->
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>



        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info')]" />
            <xsl:variable name="flwInfo.fchiUl" select="$flwInfo/*[1][contains(@class, 'topic/ul')]" />
            <xsl:variable name="flwInfo.fchiP" select="$flwInfo/*[1][contains(@class, 'topic/p')]" />
            <xsl:variable name="flwInfo.fchiUl.fchiLi" select="$flwInfo.fchiUl/*[1][contains(@class, 'topic/li')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$flwInfo">
                    <xsl:choose>
                        <xsl:when test="$flwInfo.fchiUl">
                            <xsl:choose>
                                <xsl:when test="$flwInfo.fchiUl.fchiLi
                                                /*[@placement='inline']">

                                    <xsl:choose>
                                        <xsl:when test="*[@placement='inline']">
                                            <xsl:value-of select="'0.9mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$ancesSteps and $ancesStepCnt = 'multi'">
                                    <xsl:value-of select="'2.8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$flwInfo.fchiP">
                            <xsl:choose>
                                <xsl:when test="$flwInfo.fchiP[matches(@outputclass, 'upsp')]">
                                    <xsl:choose>
                                        <xsl:when test="$flwInfo.fchiP[count(node()) = 1]
                                                        /*[name()='cmdname']">
                                            <xsl:value-of select="'1.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="*[@placement='inline']">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0.5mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="line-height.conditionality">
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:choose>
                <xsl:when test="$ancesStepCnt = 'onestep'">
                    <xsl:value-of select="'retain'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'discard'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__label" use-attribute-sets="ol.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps" use-attribute-sets="ol">
        <xsl:attribute name="provisional-distance-between-starts">
            <xsl:value-of select="'6mm'" />
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:value-of select="'inherit'" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__content--onestep" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="parSteps" select="parent::*[contains(@class, 'task/steps ')]" />
            <xsl:variable name="parSteps.parBody" select="$parSteps/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSteps.parBody.preTitle" select="$parSteps.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />


            <xsl:choose>
                <xsl:when test="$parSteps.parBody.preTitle[matches(@outputclass, 'Heading[23]')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="parTag.parBody" select="$parTag/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parTag.parBody.parTopic" select="$parTag.parBody/parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parBody.parTopic.parTopic" select="$parTag.parBody.parTopic/parent::*[contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parBody.parTopic.parTopic.flwTopic" select="$parTag.parBody.parTopic.parTopic/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parBody.parTopic.parTopic.flwTopic.fchiTitle" select="$parTag.parBody.parTopic.parTopic.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="parTag.parBody.parTopic.flwTopic" select="$parTag.parBody.parTopic/following-sibling::*[1][contains(@class, 'topic/topic ')]" />
            <xsl:variable name="parTag.parBody.parTopic.flwTopic.fchiTitle" select="$parTag.parBody.parTopic.flwTopic/*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="flwInfo.fchiP" select="$flwInfo/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.FchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="not($parTag/following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$parTag.parBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:when test="$parTag.parBody.parTopic.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$fchiCmd.flwInfo.FchiUl">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>


        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>

        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
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
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step.first" use-attribute-sets="ol.li">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.FchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />

            <!-- <xsl:choose>
                <xsl:when test="$fchiCmd.flwInfo.FchiUl">
                    <xsl:value-of select="'0.1mm'" />
                </xsl:when>

                <xsl:otherwise>1.5mm</xsl:otherwise>
            </xsl:choose> -->
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>


        <xsl:attribute name="space-before.conditionality">
            <xsl:choose>
              <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'discard'" />
              </xsl:when>

              <xsl:otherwise>
                  <xsl:value-of select="'discard'" />
              </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step" use-attribute-sets="ol.li">
        <xsl:attribute name="padding-top">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'-1mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="space-before">
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="preStep" select="preceding-sibling::*[1][contains(@class, 'task/step ')]" />
            <xsl:variable name="preStep.LchiCmd" select="$preStep/*[last()][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="preStep.LchiInfo" select="$preStep/*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="preStep.LchiInfo.LchiNote" select="$preStep.LchiInfo/*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="preStep.LchiInfo.LchiNote.LchiUl" select="$preStep.LchiInfo.LchiNote/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preStep.LchiInfo.LchiUl" select="$preStep.LchiInfo/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="preStep.LchiInfo.LchiP" select="$preStep.LchiInfo/*[last()][contains(@class, 'topic/p ')]" />
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />

            <xsl:choose>
                <xsl:when test="position() &gt; 1">
                    <xsl:choose>
                        <xsl:when test="*[contains(@class, 'task/info ')]
                                        /*[last()][name()='ul']">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="$preStep.LchiCmd[*[@placement='inline']]">
                            <xsl:choose>
                                <xsl:when test="not($fchiCmd/*[@placement='inline'])">
                                    <xsl:choose>
                                        <xsl:when test="not(following-sibling::*)">
                                            <xsl:choose>
                                                <xsl:when test="position() &gt; 2 ">
                                                    <xsl:choose>
                                                        <xsl:when test="not(following-sibling::*)">
                                                            <xsl:value-of select="'3mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'2mm'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="$preStep.LchiCmd/*[@placement='inline'][matches(key('jobFile', @href, $job)/@src, '(I-keyboard_sticker.png|I-more_gallery.png|I-gallery_quickcrop.png|I-more_bluetooth.png|I-more_contact.png|I-camera_switch.png|I-camera_video_button.png|I-camera_superslow_single.png|I-camera_slowmotion.png|I-camera_capture.png)')]">
                                                            <xsl:value-of select="'1.7mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'3mm'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <!-- <xsl:value-of select="'2.2mm'" /> -->
                                            <xsl:choose>
                                                <xsl:when test="position() = 2 ">
                                                    <xsl:value-of select="'3mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'2mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="position() = 2">
                                            <xsl:value-of select="'1.7mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$fchiCmd/*[@placement='inline']">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = last()">
                                                            <xsl:value-of select="'2.3mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'1.7mm'" />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'2.3mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$preStep.LchiInfo.LchiNote.LchiUl">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="position() = 2">
                                    <xsl:choose>
                                        <xsl:when test="$fchiCmd/*[@placement='inline']">
                                            <xsl:choose>
                                                <xsl:when test="$preStep.LchiInfo.LchiP[not(*[@placement='inline'])]">
                                                    <xsl:value-of select="'3mm'" />
                                                </xsl:when>

                                                <xsl:when test="$preStep.LchiInfo.LchiUl">
                                                    <xsl:value-of select="'4.5mm'" />
                                                </xsl:when>

                                                <xsl:when test="$preStep.LchiCmd[not(*[@placement='inline'])]">
                                                    <xsl:value-of select="'2.8mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'3.7mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$preStep.LchiInfo.LchiP">
                                            <xsl:value-of select="'2mm'" />
                                        </xsl:when>

                                        <xsl:when test="not($fchiCmd/*[@placement='inline'])">
                                            <xsl:choose>
                                                <xsl:when test="$preStep.LchiInfo.LchiP[matches(@outputclass, 'callout-image')]">
                                                    <xsl:value-of select="'2mm'" />
                                                </xsl:when>

                                                <xsl:when test="not($preStep.LchiCmd
                                                                /*[@placement='inline'])">
                                                    <xsl:value-of select="'3.2mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>
                                                    <xsl:value-of select="'3.7mm'" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'3.7mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$preStep.LchiInfo.LchiP[count(node()) = 1]
                                                /*[@placement='break']">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>

                                <xsl:when test="$fchiCmd/*[@placement='inline']">
                                    <xsl:choose>
                                        <xsl:when test="$preStep.LchiInfo.LchiP
                                                        /*[@placement='inline']">
                                            <!-- <xsl:value-of select="'1.6mm'" /> -->
                                            <xsl:value-of select="'3mm'" />
                                        </xsl:when>

                                        <xsl:when test="$preStep.LchiInfo.LchiUl">
                                            <xsl:value-of select="'3.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'3mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'3.2mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'3.2mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.fchiNote" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="fchiCmd.flwInfo.fchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="LchiInfo" select="*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="LchiInfo.LchiNote" select="$LchiInfo/*[last()][contains(@class, 'topic/note ')]" />
            <xsl:variable name="LchiInfo.LchiNote.LchiUl" select="$LchiInfo.LchiNote/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="LchiInfo.LchiUl" select="$LchiInfo/*[last()][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <!-- <xsl:when test="following-sibling::*">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd/*[@placement='inline']">
                            <xsl:value-of select="'1.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when> -->

                <xsl:when test="$LchiInfo.LchiNote">
                    <!-- <xsl:choose>
                        <xsl:when test="not(*[name()='ul']) and
                                        following-sibling::*">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="$LchiInfo.LchiNote.LchiUl and
                                        following-sibling::*">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose> -->

                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="following-sibling::* and
                                $LchiInfo.LchiUl">
                    <xsl:value-of select="'1mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="LchiInfo" select="*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="LchiInfo.LchiUl" select="$LchiInfo/*[last()][contains(@class, 'topic/ul ')]" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>
        
        <xsl:attribute name="space-before.conditionality">
            <xsl:choose>
              <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'discard'" />
              </xsl:when>

              <xsl:otherwise>
                  <xsl:value-of select="'discard'" />
              </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="ast.step.number">
        <xsl:attribute name="font-stretch">100%</xsl:attribute>
        <xsl:attribute name="color">cmyk(0%,0%,0%,100%)</xsl:attribute>
        <xsl:attribute name="margin-left">0mm</xsl:attribute>
        <!-- <xsl:attribute name="padding-top">-1.15mm</xsl:attribute> -->
        <xsl:attribute name="padding-top">
            <xsl:variable name="preStep" select="preceding-sibling::*[1][contains(@class, 'task/step ')]" />
            <xsl:variable name="preStep.LchiCmd" select="$preStep/*[last()][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="preStep.LchiInfo" select="$preStep/*[last()][contains(@class, 'task/info ')]" />
            <xsl:variable name="preStep.LchiInfo.LchiUl" select="$preStep.LchiInfo/*[last()][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />



            <xsl:choose>
                <xsl:when test="not(preceding-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd/*[@placement='inline']">
                            <xsl:choose>
                                <xsl:when test="$fchiCmd/*[@placement='inline'][matches(key('jobFile', @href, $job)/@src, '(I-voicerecorder_record.png|I-splanner_add.png|I-snote_add.png|I-keyboard_sticker.png|I-ar_zone_profile.png|I-more_gallery.png|I-gallery_quickcrop.png|I-more_bluetooth.png|I-more_contact.png|I-camera_switch.png|I-camera_video_button.png|I-camera_superslow_single.png|I-camera_slowmotion.png|I-camera_capture.png)')]">
                                    <xsl:value-of select="'0.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'-0.9mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'-1.15mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$fchiCmd/*[@placement='inline']">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd/*[@placement='inline'][matches(key('jobFile', @href, $job)/@src, '(I-voicerecorder_record.png|I-splanner_add.png|I-keyboard_sticker.png|I-ar_zone_profile.png|I-more_gallery.png|I-gallery_quickcrop.png|I-more_bluetooth.png|I-more_contact.png|I-camera_switch.png|I-camera_video_button.png|I-camera_superslow_single.png|I-camera_slowmotion.png|I-camera_capture.png)')]">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="$preStep.LchiInfo.LchiUl">
                            <xsl:value-of select="'-0.9mm'" />
                        </xsl:when>

                        <xsl:when test="$preStep.LchiCmd[not(*[@placement='inline'])]">
                            <xsl:value-of select="'-0.9mm'" />
                        </xsl:when>

                        <xsl:when test="$preStep.LchiCmd[*[@placement='inline']]">

                            <xsl:choose>
                                <xsl:when test="$fchiCmd/*[@placement='inline']">
                                    <xsl:value-of select="'-0.9mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0.3mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0.3mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'-1.15mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height.conditionality">discard</xsl:attribute>

        <!-- <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute> -->
        <xsl:attribute name="font-family">
            <xsl:variable name="cur" select="'step-Number'" />
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

        <xsl:attribute name="font-size">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('step-Number)', ' task/step', ' Size')" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="color">cmyk(0%,0%,0%,80%)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__content__containsinfo--onestep" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="parSteps" select="parent::*[contains(@class, 'task/steps ')]" />
            <xsl:variable name="parSteps.parBody" select="$parSteps/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSteps.parBody.preTitle" select="$parSteps.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
            <xsl:variable name="fchiCmd" select="*[contains(@class, 'task/cmd ')]" />

            <xsl:choose>
                <xsl:when test="$parSteps.parBody.preTitle[matches(@outputclass, 'Heading1')]">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd/*[@placement='inline']">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <!-- <xsl:value-of select="'0.8mm'" /> -->
                            <xsl:value-of select="'0.8mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parSteps.parBody.preTitle[matches(@outputclass, 'Heading2')]">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd/*[@placement='inline']">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'1.1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>



        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>

        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
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
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="lineHeight">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="fontStretch">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="letter-spacing">
            <xsl:variable name="cur" select="." />
            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />
            <xsl:variable name="nodeCnt" select="if (count(parent::*/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

            <xsl:call-template name="letterSpacing">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
                <xsl:with-param name="nodeCnt" select="$nodeCnt" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>