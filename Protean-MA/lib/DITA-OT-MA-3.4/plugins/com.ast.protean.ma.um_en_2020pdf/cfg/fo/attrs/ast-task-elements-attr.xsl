<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:functx="http://www.functx.com"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

    <xsl:attribute-set name="info">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>
        
        <xsl:attribute name="space-after">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cmdNoneAttr">
    </xsl:attribute-set>

    <xsl:attribute-set name="cmd">
        <xsl:attribute name="space-before">
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="flwInfo.FchiUl" select="$flwInfo/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwInfo.FchiP" select="$flwInfo/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="flwInfo.FchiUl" select="$flwInfo/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwInfo.FchiP" select="$flwInfo/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />

            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="flwInfo.FchiUl" select="$flwInfo/*[1][contains(@class, 'topic/ul ')]" />
            <xsl:variable name="flwInfo.FchiP" select="$flwInfo/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
            <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />

            <xsl:choose>
                <xsl:when test="($flwInfo.FchiUl or $flwInfo.FchiP) and
                                $ancesStepCnt = 'onestep'">
                    <xsl:choose>
                        <xsl:when test="$flwInfo.FchiP[contains(@outputclass, 'callout-image')]">
                            <!-- <xsl:value-of select="'1mm'" /> -->
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <!-- <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when> -->

                        <xsl:otherwise>1mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>inherit</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__label" use-attribute-sets="ol.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step.first" use-attribute-sets="ol.li">
        <xsl:attribute name="space-before">
            <xsl:value-of select="'2.4mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.FchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="$fchiCmd.flwInfo.FchiUl">
                    <xsl:value-of select="'0.1mm'" />
                </xsl:when>

                <xsl:otherwise>1.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM') and
                                matches($OSname, '-OS_upgrade') and
                                ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'600'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
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
		<xsl:attribute name="space-before">
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:value-of select="'1.5mm'" />
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.fchiNote" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/note ')]" />
            <xsl:variable name="fchiCmd.flwInfo.fchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="position() = 2">
                    <xsl:choose>
                        <xsl:when test="$fchiCmd.flwInfo.fchiNote">
                            <xsl:value-of select="'1.65mm'" />
                        </xsl:when>

                        <xsl:when test="$fchiCmd.flwInfo.fchiUl">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$fchiCmd.flwInfo.fchiNote">
                    <xsl:value-of select="'1.65mm'" />
                </xsl:when>

                <xsl:when test="$fchiCmd.flwInfo.fchiUl">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>0.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches($localeStrAfter, 'MM') and
                                matches($OSname, '-OS_upgrade') and
                                ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'600'" />
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
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
        <!-- <xsl:attribute name="margin-left">0mm</xsl:attribute> -->
        <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>
        <xsl:attribute name="padding-top">-0.2mm</xsl:attribute>
        <xsl:attribute name="baseline-shift">baseline</xsl:attribute>

        <!-- <xsl:attribute name="font-family">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'CN')">
                    <xsl:value-of select="'FZZhongDengXian-Z07S'" />
                </xsl:when>

                <xsl:when test="$writing-mode = 'lr'">
                    <xsl:value-of select="'Arial'" />
                </xsl:when>

                <xsl:when test="$writing-mode = 'rl'">
                    <xsl:value-of select="'Arial'" />
                </xsl:when>

                <xsl:otherwise>Arial</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->

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

    <xsl:attribute-set name="steps" use-attribute-sets="ol">
        <xsl:attribute name="provisional-distance-between-starts">
            <xsl:choose>
                <xsl:when test="matches($locale, 'zh-CN')">
                    <xsl:value-of select="'7mm'" />
                </xsl:when>

                <xsl:otherwise>6.2mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:value-of select="'inherit'" />
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- onestep -->
    <xsl:attribute-set name="steps.step__content--onestep" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="parSteps" select="parent::*[contains(@class, 'task/steps ')]" />
            <xsl:variable name="parSteps.parBody" select="$parSteps/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSteps.parBody.preTitle" select="$parSteps.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />


            <xsl:choose>
                <xsl:when test="$parSteps.parBody.preTitle[matches(@outputclass, 'Heading[23]')]">
                    <!-- <xsl:value-of select="'0.5mm'" /> -->
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise><xsl:choose>
                    <xsl:when test="matches($localeStrAfter, '(KH|LA|IN)')">
                        <xsl:value-of select="'0mm'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'0mm'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:value-of select="'0mm'" />
        </xsl:attribute>

        <xsl:attribute name="padding-bottom">
            <xsl:variable name="fchiCmd" select="*[1][contains(@class, 'task/cmd ')]" />
            <xsl:variable name="flwInfo" select="following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="flwInfo.fchiP" select="$flwInfo/*[1][contains(@class, 'topic/p ')]" />
            <xsl:variable name="fchiCmd.flwInfo" select="$fchiCmd/following-sibling::*[1][contains(@class, 'task/info ')]" />
            <xsl:variable name="fchiCmd.flwInfo.FchiUl" select="$fchiCmd.flwInfo/*[1][contains(@class, 'topic/ul ')]" />

            <xsl:choose>
                <xsl:when test="$fchiCmd.flwInfo.FchiUl">
                    <xsl:value-of select="'0mm'" />
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

    <xsl:attribute-set name="steps.step__content__containsinfo--onestep" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:variable name="parSteps" select="parent::*[contains(@class, 'task/steps ')]" />
            <xsl:variable name="parSteps.parBody" select="$parSteps/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSteps.parBody.preTitle" select="$parSteps.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />


            <xsl:choose>
                <xsl:when test="$parSteps.parBody.preTitle[matches(@outputclass, 'Heading[12]')]">
                    <xsl:value-of select="'0.5mm'" />
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

    <xsl:attribute-set name="result" use-attribute-sets="section">
    </xsl:attribute-set>

</xsl:stylesheet>