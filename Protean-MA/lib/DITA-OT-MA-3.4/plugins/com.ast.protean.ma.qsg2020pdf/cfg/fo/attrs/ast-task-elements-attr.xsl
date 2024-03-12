<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:functx="http://www.functx.com"
    version="2.0">

    <xsl:attribute-set name="info">
        <xsl:attribute name="padding-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::*[1][contains(@class, 'task/cmd')]">
                    <xsl:choose>
                        <xsl:when test="*[1][contains(@class, 'topic/note ')]">
                            <xsl:variable name="cur1" select="*[1][contains(@class, 'topic/note ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur1/*[1][contains(@class, 'topic/ul ')]">
                                    <xsl:value-of select="'5mm'" />
                                </xsl:when>
                                <xsl:otherwise>4.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="*[1][contains(@class, 'topic/ul ')]">
                            <xsl:value-of select="'0.5mm'" />
                        </xsl:when>

                        <xsl:when test="*[1][contains(@class, 'topic/p ')]">
                            <xsl:value-of select="'1.7mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>3.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="start-indent">
			<xsl:choose>
				<xsl:when test="parent::*[contains(@class, ' task/substep ')]">inherit</xsl:when>
                <xsl:when test="preceding-sibling::*[contains(@class, ' task/cmd ')] and *[contains(@class, ' topic/note ')]">
                    <xsl:value-of select="'0pt'" />
                </xsl:when>

				<xsl:otherwise>0pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="info.indent">
        <xsl:attribute name="margin-top">
            <xsl:choose>
              <xsl:when test="preceding-sibling::*[1][contains(@class, 'task/cmd')] and
                              parent::*[contains(@class, 'task/step ')]">
                  <xsl:choose>
                      <xsl:when test="count(ancestor::*[contains(@class, 'task/steps ')]/*) &gt; 1 and
                                  *[1]/*[1][contains(@class, 'topic/image ')][@placement='break']">
                          <xsl:value-of select="'3mm'" />
                      </xsl:when>

                      <xsl:when test="count(ancestor::*[contains(@class, 'task/steps ')]/*) &gt; 1 and
                                *[1][contains(@class, 'topic/p ')]">
                          <xsl:value-of select="'1.7mm'" />
                      </xsl:when>

                      <xsl:when test="*[1][contains(@class, 'topic/ul ')]">
                          <xsl:choose>
                              <xsl:when test="count(ancestor::*[contains(@class, 'task/steps ')]/*) &gt; 1">
                                    <xsl:value-of select="'3mm'" />
                              </xsl:when>
                              <xsl:otherwise>2mm</xsl:otherwise>
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

        <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cmd">
    </xsl:attribute-set>

    <xsl:attribute-set name="ast.steps.step__content" use-attribute-sets="ol.li__content">
        <xsl:attribute name="margin-left" select="concat('-', 'body-start()')"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__label__content" use-attribute-sets="ol.li__label__content">
    	<xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__label" use-attribute-sets="ol.li__label">
    	<xsl:attribute name="font-family">Arial</xsl:attribute>
    	<xsl:attribute name="font-size">24pt</xsl:attribute>
    	<xsl:attribute name="font-stretch">semi-condensed</xsl:attribute>
        <xsl:attribute name="color">cmyk(0%,0%,0%,100%)</xsl:attribute>
    	<xsl:attribute name="baseline-shift">-5pt</xsl:attribute>
		<xsl:attribute name="padding-top">0pt</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="steps.step" use-attribute-sets="ol.li">
		<xsl:attribute name="start-indent">0.7mm</xsl:attribute>
		<xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="preceding-sibling::*[1]/*[last()][contains(@class, ' task/info ')]">
                    <xsl:variable name="cur1" select="preceding-sibling::*[1]/*[last()][contains(@class, ' task/info ')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]
                                        /*[last()][contains(@class, ' topic/image ')][@placement='break']">
                            <xsl:value-of select="'8mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]">
                            <xsl:value-of select="'6mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/ul ')]">
                            <xsl:value-of select="'4mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/note ')]">
                            <xsl:value-of select="'7mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>6mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="line-height">6.4mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ast.step.number">
		<xsl:attribute name="margin-left">-1mm</xsl:attribute>
		<xsl:attribute name="padding-top">0pt</xsl:attribute>
		<xsl:attribute name="font-family">Arial</xsl:attribute>
        <xsl:attribute name="font-weight">500</xsl:attribute>
		<xsl:attribute name="font-size">24pt</xsl:attribute>
    	<xsl:attribute name="font-stretch">100.1%</xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="color">cmyk(0%,0%,0%,80%)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps" use-attribute-sets="ol">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'-3mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-before">
            <xsl:choose>
                <xsl:when test="parent::*[contains(@class, 'topic/body')]
                                /preceding-sibling::*[1][contains(@class, 'topic/abstract')]">
                    <xsl:variable name="cur1" select="parent::*[contains(@class, 'topic/body')]
                                                      /preceding-sibling::*[1][contains(@class, 'topic/abstract')]" />

                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]
                                        /*[last()][contains(@class, ' topic/image ')][@placement='break']">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]">
                            <xsl:value-of select="'-1mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/note ')]
                                        /*[last()][contains(@class, ' topic/ul ')]">
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/note ')]">
                            <xsl:value-of select="'1mm'" />
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

        <xsl:attribute name="margin-top">
            <xsl:choose>
                <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="parent::*[contains(@class, 'topic/body')]
                                /preceding-sibling::*[1][contains(@class, 'topic/title')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__content--onestep" use-attribute-sets="common.block">
        <xsl:attribute name="padding-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'3mm'" />
                </xsl:when>

                <xsl:when test="ancestor::*[contains(@class, 'topic/body')][1]
                                /preceding-sibling::*[1][contains(@class, 'topic/abstract')]">
                    <xsl:variable name="cur1" select="ancestor::*[contains(@class, 'topic/body')][1]
                                                      /preceding-sibling::*[1][contains(@class, 'topic/abstract')]" />
                    <xsl:choose>
                      <xsl:when test="$cur1/*[last()][contains(@class, 'topic/p ')]">
                            <xsl:value-of select="'1.5mm'" />
                      </xsl:when>

                      <xsl:when test="$cur1/*[last()][contains(@class, 'topic/note')]">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                      <xsl:otherwise>
                          <xsl:value-of select="'0mm'" />
                      </xsl:otherwise>
                    </xsl:choose>

                </xsl:when>

                <xsl:when test="ancestor::*[contains(@class, 'topic/body')][1]
                                /preceding-sibling::*[1][contains(@class, 'topic/title')]">
                    <xsl:variable name="cur1" select="ancestor::*[contains(@class, 'topic/body')][1]
                                                      /preceding-sibling::*[1][contains(@class, 'topic/title')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1[matches(@outputclass, 'Heading3\-TroubleShooting')]">
                            <xsl:value-of select="'2.5mm'" />
                        </xsl:when>

                        <xsl:when test="descendant::*[contains(@class, 'topic/image ')][@placement='inline']">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>
                        <xsl:otherwise>2.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-after">
            <xsl:choose>
                <xsl:when test="parent::*[contains(@class, 'task/steps')]/following-sibling::*[1][contains(@class, 'task/result')]/*[1][contains(@class, 'topic/note')]">
                    <xsl:value-of select="'-2.2mm'" />
                </xsl:when>

                <xsl:when test="ancestor::*[contains(@class, 'topic/topic')][1]/following-sibling::*[1][contains(@class, 'topic/topic')]/*[1][contains(@class, 'topic/title')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="padding-before.conditionality">retain</xsl:attribute>
        <xsl:attribute name="page-break-before">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'always'" />
                </xsl:when>

                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered" use-attribute-sets="ul">

    </xsl:attribute-set>

    <xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
            <xsl:param name="nodes" as="node()*" />
            <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function>
</xsl:stylesheet>