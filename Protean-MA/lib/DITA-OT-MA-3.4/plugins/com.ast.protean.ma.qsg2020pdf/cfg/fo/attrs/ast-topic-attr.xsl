<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="ast xs"
    version="2.0">

    <xsl:attribute-set name="__align__center">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>

    <!-- note indent -->
    <xsl:attribute-set name="note__table" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::*) and 
                                ancestor::*[contains(@class, ' topic/body ')][1]
                                /preceding-sibling::*[1][matches(@outputclass, 'Frontmatter\-title')]">
                    <xsl:value-of select="'17mm'" />
                </xsl:when>
            
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>           
        </xsl:attribute>
        <!--<xsl:attribute name="margin-top">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:value-of select="'3mm'" />
                </xsl:when>

                <xsl:when test="preceding-sibling::*[1][contains(@outputclass, 'roundbox')]">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>

                <xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/note')]">
                    <xsl:variable name="cur1" select="preceding-sibling::*[1][contains(@class, 'topic/note')]" />
                    <xsl:choose>
                        <xsl:when test="count(ancestor-or-self::*[contains(@class, 'topic/ul')]) &gt; 1 and
                                        $cur1[functx:last-node(descendant::*[contains(@class, ' topic/ul ')])]">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:when test="*[1][contains(@class, 'topic/ul')]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1[functx:last-node(descendant::*[contains(@class, ' topic/ul ')])]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:otherwise>3mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="preceding-sibling::*[1][contains(@class, ' topic/p ')]">
                    <xsl:variable name="cur1" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
                    <xsl:choose>
                        <xsl:when test="*[1][contains(@class, 'topic/ul')]">
                            <xsl:choose>
                                <xsl:when test="preceding-sibling::*[1]
                                                /*[last()][contains(@class, 'topic/image ')][@placement='break']">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>
                                <xsl:otherwise>1.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'topic/ul ')]">
                            <xsl:value-of select="'1mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*[contains(@class, 'task/info ')]
                                        /parent::*[contains(@class, 'task/step ')] and
                                        preceding-sibling::*[1][contains(@class, 'topic/p ')]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:otherwise>2mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*[contains(@class, 'task/result')]">
                    <xsl:variable name="cur1" select="parent::*[contains(@class, 'task/result')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/preceding-sibling::*[1]/*[last()][contains(@class, ' task/step ')]">
                            <xsl:variable name="cur2" select="$cur1/preceding-sibling::*[1]/*[last()][contains(@class, ' task/step ')]" />
                            <xsl:choose>
                                <xsl:when test="position()=1 and
                                                $cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, 'topic/p ')]">
                                    <xsl:variable name="cur3" select="$cur2/*[last()][contains(@class, ' task/info ')]
                                                                      /*[last()][contains(@class, 'topic/p ')]" />
                                    <xsl:choose>
                                      <xsl:when test="$cur1/parent::*[contains(@class, 'topic/body ')]
                                                      /preceding-sibling::*[1][contains(@class, ' topic/title ')] and
                                                      count($cur1/preceding-sibling::*[1][contains(@class, ' task/steps ')]
                                                      /*[contains(@class, ' task/step ')]) = 1">
                                        <xsl:value-of select="'4mm'" />
                                      </xsl:when>

                                      <xsl:when test="$cur1/parent::*[contains(@class, 'topic/body ')]
                                                      /preceding-sibling::*[1][contains(@class, ' topic/title ')]">
                                        <xsl:value-of select="'3mm'" />
                                      </xsl:when>

                                      <xsl:when test="$cur3/*[last()][contains(@class, 'topic/image ')][@placement='break']">
                                            <xsl:value-of select="'0mm'" />
                                      </xsl:when>



                                      <xsl:when test="not(*[contains(@class, 'topic/ul ')])">
                                            <!-\- <xsl:value-of select="'4.5mm'" /> -\->
                                            <xsl:value-of select="'3mm'" />
                                      </xsl:when>

                                      <xsl:otherwise>
                                        <xsl:value-of select="'3mm'" />
                                      </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="position()=1 and $cur2[*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, 'topic/p ')]]">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:when test="position()=1 and $cur2[functx:last-node(descendant::*[contains(@class, ' task/info ')]
                                                /*[not(following-sibling::*)][contains(@class, 'topic/ul ')])]">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:when test="position()=1 and $cur2/*[last()][contains(@class, 'task/cmd ')]">
                                    <xsl:choose>
                                        <xsl:when test="count($cur1/preceding-sibling::*[1][contains(@class, ' task/steps ')]
                                                        /*[contains(@class, ' task/step ')]) &gt; 1">
                                            <!-\- <xsl:value-of select="'3mm'" /> -\->
                                            <xsl:value-of select="'3.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>4.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="preceding-sibling::*[contains(@class, 'topic/ul ')]">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>

                                <xsl:otherwise>3.5mm</xsl:otherwise>
                            </xsl:choose>

                        </xsl:when>

                        <xsl:when test="$cur1/preceding-sibling::*[1][contains(@class, ' task/steps ')][count(*[contains(@class, ' task/step ')]) eq 1]">
                            <xsl:value-of select="'2mm'" />
                        </xsl:when>

                        <xsl:otherwise>4.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*[contains(@class, 'topic/section ')]
                                /parent::*[contains(@class, 'topic/body ')]">
                    <xsl:variable name="cur1" select="parent::*[contains(@class, 'topic/section ')]
                                                      /parent::*[contains(@class, 'topic/body ')]" />
                    <xsl:choose>
                      <xsl:when test="position()=1 and $cur1/preceding-sibling::*[1][contains(@class, 'topic/abstract ')]
                                      [*[last()][contains(@class, ' topic/p ')]]">
                            <xsl:value-of select="'4mm'" />
                      </xsl:when>

                      <xsl:when test="position()=1 and $cur1/preceding-sibling::*[1][contains(@class, 'topic/title ')]
                                      [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=3]">
                            <xsl:choose>
                                <xsl:when test="not(*[1][contains(@class, 'topic/ul ')])">
                                    <xsl:value-of select="'3mm'" />
                                </xsl:when>

                                <xsl:when test="*[1][contains(@class, 'topic/ul ')]">
                                    <xsl:value-of select="'3mm'" />
                                </xsl:when>

                                <xsl:otherwise>4.5mm</xsl:otherwise>
                            </xsl:choose>
                      </xsl:when>

                      <xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/ul ')]">
                            <xsl:value-of select="'1.5mm'" />
                      </xsl:when>

                      <xsl:otherwise>
                          <xsl:value-of select="'0mm'" />
                      </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*[contains(@class, 'task/info ')]">
                    <xsl:variable name="cur1" select="parent::*[contains(@class, 'task/info ')]" />
                    <xsl:choose>
                        <xsl:when test="position()=1 and
                                        $cur1/preceding-sibling::*[1][contains(@class, 'task/cmd ')]">

                            <xsl:choose>
                                <xsl:when test="count(ancestor::*[contains(@class, 'task/steps ')][1]
                                                /*[contains(@class, 'task/step ')]) &gt; 1">
                                    <xsl:value-of select="'-1.2mm'" />
                                </xsl:when>

                                <xsl:when test="count(ancestor::*[contains(@class, 'task/steps ')][1]
                                                /*[contains(@class, 'task/step ')]) &gt; 1 and
                                                not(following-sibling::*)">
                                    <xsl:value-of select="'2mm'" />
                                </xsl:when>


                                <xsl:otherwise>-2mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/ul ')]">
                            <xsl:value-of select="'1.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'0mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="preceding-sibling::*[1][contains(@class, ' topic/ul ')]/*[not(following-sibling::*)]
                                [functx:last-node(descendant::*[contains(@class, ' topic/p ')])]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="parent::*[contains(@class, 'topic/abstract ')]
                                /preceding-sibling::*[1][contains(@class, 'topic/title ')]
                                [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=3]">
                    <xsl:value-of select="'2.7mm'" />
                </xsl:when>



                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="margin-bottom">
            <xsl:choose>
                <xsl:when test="following-sibling::*[1][contains(@class, 'topic/ul ')]">
                    
                    <xsl:value-of select="'4mm'" />
                </xsl:when>

                <xsl:when test="following-sibling::*[1][contains(@class, 'topic/table ')]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>


                <xsl:otherwise>0mm</xsl:otherwise>
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
-->    </xsl:attribute-set>

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


    <!-- Chapter title -->
    <xsl:attribute-set name="topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="color">cmyk(0%,0%,0%,100%)</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="'HelveticaNeue-UltraLight'" />
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:attribute name="font-size">
			<xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:value-of select="'38pt'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="'40pt'" />
                </xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
        </xsl:attribute>
        <xsl:attribute name="line-height">37pt</xsl:attribute>
        <xsl:attribute name="font-weight">lighter</xsl:attribute>
        <xsl:attribute name="space-before">8mm</xsl:attribute>
        <xsl:attribute name="space-after">0mm</xsl:attribute>
        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <!-- <xsl:attribute name="page-break-before">always</xsl:attribute> -->
        <xsl:attribute name="padding-top">23pt</xsl:attribute>
        <xsl:attribute name="letter-spacing">0.5mm</xsl:attribute>
        <xsl:attribute name="background-color">yellow</xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading1 title 하늘색 -->
    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="padding-top">
            <xsl:choose>
                <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                            <xsl:value-of select="'122mm'" />
                        </xsl:when>
                        <xsl:otherwise>3.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/title ')]
                                [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=1]">
                    <xsl:value-of select="'14.5mm'" />
                </xsl:when>

                <xsl:when test="following-sibling::*[1]/*[1][contains(@class, ' topic/title ')]
                                [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=3]">
                    <xsl:choose>
                        <xsl:when test="parent::*[contains(@class, ' topic/topic ')]
                                        /preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                        /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]">
                            <xsl:variable name="cur1" select="parent::*[contains(@class, ' topic/topic ')]
                                                              /preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                              /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
                            <xsl:choose>
                                <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                /*[last()][contains(@class, ' task/result ')]">
                                    <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                                      /*[last()][contains(@class, ' task/result ')]" />
                                    <xsl:choose>
                                        <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                            <xsl:value-of select="'14mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur2/*[last()][contains(@class, ' topic/note ')]">
                                            <xsl:value-of select="'14.2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>0mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                /*[last()]/*[last()][contains(@class, ' task/step ')]
                                                /*[last()][contains(@class, ' task/info ')]">
                                    <xsl:value-of select="'12.5mm'" />
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                /*[last()]/*[last()][contains(@class, ' task/step ')]
                                                /*[last()][contains(@class, ' task/cmd ')]">
                                    <xsl:value-of select="'12.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>3.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                      /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                        /*[last()][contains(@class, ' task/result ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                              /*[last()][contains(@class, ' task/result ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/note ')]">
                                    <xsl:value-of select="'14mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'12mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>

                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                        /*[last()]/*[last()][contains(@class, ' task/step ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                              /*[last()]/*[last()][contains(@class, ' task/step ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'12mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:choose>
                                        <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                        /*[last()][contains(@class, ' topic/ul ')]
                                                        /*[last()][contains(@class, ' topic/note ')]">
                                            <xsl:value-of select="'10.5mm'" />
                                        </xsl:when>
                                        <xsl:otherwise>10.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>12mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]
                                        /*[last()][contains(@class, ' topic/section ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]
                                                             /*[last()][contains(@class, ' topic/section ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:value-of select="'10.5mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:choose>
                                        <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                                            <xsl:value-of select="'7mm'" />
                                        </xsl:when>
                                        <xsl:otherwise>12mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/note ')]">
                                    <xsl:value-of select="'14mm'" />
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

        <xsl:attribute name="padding-bottom">
            <xsl:choose>
                <xsl:when test="following-sibling::*[1][contains(@class, ' topic/abstract ')]">
                    <xsl:choose>
                        <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                            <xsl:value-of select="'-1.2mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/title ')]
                                        [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=1]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[contains(@class, 'topic/topic ')]">
                            <xsl:value-of select="'-1.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="following-sibling::*[1][contains(@class, ' topic/body ')]
                                /*[1][contains(@class, ' topic/section ')]">
                    <xsl:variable name="cur1" select="following-sibling::*[1][contains(@class, ' topic/body ')]
                                                      /*[1][contains(@class, ' topic/section ')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/*[1][contains(@class, ' topic/ul ')]">
                            <xsl:choose>
                                <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                                    <xsl:value-of select="'-1.5mm'" />
                                </xsl:when>
                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[1][contains(@class, ' topic/note ')]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="following-sibling::*[1][contains(@class, ' topic/body ')]">
                    <xsl:variable name="cur1" select="following-sibling::*[1][contains(@class, ' topic/body ')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/*[1][contains(@class, ' task/steps ')]">
                            <xsl:choose>
                                <xsl:when test="count($cur1/*[1][contains(@class, ' task/steps ')]
                                                /*[contains(@class, ' task/step ')]) = 1">
                                    <xsl:value-of select="'0mm'" />
                                </xsl:when>
                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>

                        </xsl:when>
                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'6mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="padding-before.conditionality">retain</xsl:attribute>
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="space-after">0mm</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>

        <xsl:attribute name="border-after-style">none</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>
        <!-- <xsl:attribute name="color">cmyk(65%,30%,0%,0%)</xsl:attribute> -->
        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'cmyk(65%,30%,0%,0%)'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
        
        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                            <xsl:value-of select="'15.5pt'" />
                        </xsl:when>
                        <xsl:otherwise>22.5pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading1\-H3')">
                            <xsl:value-of select="'17pt'" />
                        </xsl:when>
                        <xsl:otherwise>26pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            

        </xsl:attribute>
        <xsl:attribute name="line-height">30pt</xsl:attribute>
        <xsl:attribute name="font-weight">600</xsl:attribute>
        <!-- <xsl:attribute name="background-color">red</xsl:attribute> -->
    </xsl:attribute-set>

    <!-- Heading2 title 갈색 -->
    <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">
            <xsl:variable name="othervalue" select="'0mm'" />
            <xsl:choose>
                <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:value-of select="'3.2mm'" />
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/title ')]
                                [count(ancestor-or-self::*[contains(@class, ' topic/topic ')])=2]">
                    <xsl:value-of select="'2.3mm'" />
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                      /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
                    <xsl:choose>
                        <xsl:when test="$cur1//*[last()][contains(@class, 'task/result ')]
                                        /*[last()][contains(@class, ' topic/note ')]">
                            <xsl:value-of select="'9mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[contains(@class, ' topic/body ')]
                                        /*[last()]/*[last()][contains(@class, ' task/step ')]">
                            <xsl:variable name="cur2" select="$cur1/*[contains(@class, ' topic/body ')]
                                                              /*[last()]/*[last()][contains(@class, ' task/step ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:choose>
                                        <xsl:when test="count($cur1/*[contains(@class, ' topic/body ')]
                                                        /*[last()]/*[contains(@class, ' task/step ')]) &gt; 1">
                                            <!-- <xsl:value-of select="'9mm'" /> -->
                                            <xsl:value-of select="'8mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>7.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:variable name="cur3" select="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/ul ')]" />
                                    <xsl:choose>
                                        <xsl:when test="count($cur1/*[contains(@class, ' topic/body ')]
                                                              /*[last()]/*[contains(@class, ' task/step ')]) &gt; 1">
                                            <xsl:value-of select="'7.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()]/*[last()][contains(@class, 'topic/note ')]">
                                            <xsl:value-of select="'9mm'" />
                                        </xsl:when>

                                        <xsl:when test="count($cur1/*[contains(@class, ' topic/body ')]
                                                              /*[last()]/*[contains(@class, ' task/step ')]) eq 1">
                                            <xsl:value-of select="'6.5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>6.7mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <!-- <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]
                                                /*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when> -->

                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/cmd ')]">
                                    <xsl:variable name="cur3" select="$cur2/*[last()][contains(@class, ' task/cmd ')]" />
                                    <xsl:choose>
                                        <xsl:when test="$cur3/*[contains(@class, 'topic/image ')][@placement='inline']">
                                            <xsl:value-of select="'7.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/node()[not(contains(@class, 'topic/image '))]">
                                            <xsl:choose>
                                                <xsl:when test="count($cur1/*[contains(@class, ' topic/body ')]
                                                                /*[last()]/*[contains(@class, ' task/step ')]) &gt; 1">
                                                    <!-- <xsl:value-of select="'9mm'" /> -->
                                                    <xsl:value-of select="'8mm'" />
                                                </xsl:when>
                                                <xsl:otherwise>7mm</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>9mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>9mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]" />
                            <xsl:choose>
                                <!-- <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:value-of select="'7.5mm'" />
                                </xsl:when> -->

                                <xsl:when test="$cur2/*[last()][matches(@class, ' topic/section $')]">
                                    <xsl:variable name="cur3" select="$cur2/*[last()][matches(@class, ' topic/section $')]" />

                                    <xsl:choose>
                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/note ')]">
                                            <xsl:value-of select="'9mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/ul ')]">
                                            <xsl:value-of select="'7mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/table ')]">
                                            <xsl:value-of select="'8.2mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]
                                                        /*[last()][contains(@class, ' topic/image ')][@placement='break']">
                                            <xsl:value-of select="'9mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]">
                                            <xsl:value-of select="'8mm'" />
                                        </xsl:when>


                                        <xsl:otherwise>0mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>7.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/abstract ')]
                                        /*[last()][contains(@class, ' topic/p ')]">
                            <xsl:value-of select="'7.5mm'" />
                        </xsl:when>

                        <xsl:otherwise>9mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="following-sibling::*[1]//*[contains(@class, ' topic/section ')]/*[1][contains(@class, ' topic/note ')]">
                    <xsl:value-of select="'-1.5mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="color">cmyk(30%,60%,50%,10%)</xsl:attribute>
        <!-- <xsl:attribute name="font-size">20pt</xsl:attribute> -->
        <xsl:attribute name="font-size">
            <xsl:choose>
			<xsl:when test="matches(substring-after($locale, '-'), 'KR')">
				<xsl:value-of select="'18.5pt'" />
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="'20pt'" />
			</xsl:otherwise>
		</xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height">24pt</xsl:attribute>
        <xsl:attribute name="font-weight">600</xsl:attribute>
        <!-- <xsl:attribute name="background-color">yellow</xsl:attribute> -->
    </xsl:attribute-set>

    <!-- Heading3 title 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="parent::*[matches(@outputclass, 'pagebreak')]">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                            <xsl:value-of select="'3.7mm'" />
                        </xsl:when>
                        <xsl:otherwise>3.5mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                    <xsl:choose>
                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/abstract ')]">
                            <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/abstract ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'9mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                        /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]">
                            <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                              /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
                                <xsl:choose>
                                    <xsl:when test="$cur1/*[last()][contains(@class, ' topic/body ')]">
                                        <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/body ')]" />

                                        <xsl:choose>
                                            <xsl:when test="$cur2/*[last()][contains(@class, ' topic/section ')]">
                                                <xsl:variable name="cur3" select="$cur2/*[last()][contains(@class, ' topic/section ')]" />
                                                <xsl:choose>
                                                    <xsl:when test="$cur3/*[last()][contains(@class, ' topic/ul ')]">
                                                        <xsl:value-of select="'8.5mm'" />
                                                    </xsl:when>

                                                    <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]">
                                                        <xsl:value-of select="'8.5mm'" />
                                                    </xsl:when>

                                                    <xsl:otherwise>8.5mm</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>

                                            <xsl:when test="$cur2/*[last()][contains(@class, ' task/steps ')]
                                                            /*[last()][contains(@class, ' task/step ')]">
                                                <xsl:value-of select="'9mm'" />
                                            </xsl:when>

                                            <xsl:otherwise>0mm</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>

                                     <xsl:when test="$cur1/*[last()][contains(@class, ' topic/abstract ')]
                                                            /*[last()][contains(@class, ' topic/p ')]">
                                                <xsl:value-of select="'9mm'" />
                                            </xsl:when>

                                    <xsl:otherwise>0mm</xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]
                                /*[last()][contains(@class, ' topic/body ')]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                      /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]
                                                      /*[last()][contains(@class, ' topic/body ')]" />
                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()][matches(@class, ' topic/section $')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][matches(@class, ' topic/section $')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/table ')]">
                                    <xsl:value-of select="'6.5mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/note ')]">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:value-of select="'5.5mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/p ')][*[@placement='break']]">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'6mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' task/result ')]
                                        /*[last()][contains(@class, ' topic/note ')]">
                            <xsl:value-of select="'8.2mm'" />
                        </xsl:when>



                        <xsl:when test="$cur1/*[last()]/*[last()][contains(@class, 'task/step ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()]/*[last()][contains(@class, 'task/step ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/cmd ')]">
                                    <xsl:choose>
                                        <xsl:when test="count($cur1/*[last()]/*[contains(@class, 'task/step ')]) &gt; 1">
                                            <xsl:value-of select="'7mm'" />
                                        </xsl:when>
                                        <xsl:otherwise>6.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' task/info ')]">
                                    <xsl:variable name="cur3" select="$cur2/*[last()][contains(@class, ' task/info ')]" />

                                    <xsl:choose>
                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]
                                                        /*[last()][contains(@class, ' topic/image ')][@placement='break'] and
                                                        count($cur1/*[last()]/*[contains(@class, 'task/step ')]) &gt; 1 ">
                                            <xsl:value-of select="'8.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]
                                                        /*[last()][contains(@class, ' topic/image ')][@placement='break']">
                                            <xsl:value-of select="'8.5mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/p ')]">
                                            <!-- <xsl:value-of select="'7mm'" /> -->
                                            <xsl:value-of select="'6mm'" />
                                        </xsl:when>

                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/note ')]
                                                        /*[last()][contains(@class, ' topic/ul ')]">
                                            <xsl:value-of select="'8mm'" />
                                        </xsl:when>



                                        <xsl:when test="$cur3/*[last()][contains(@class, ' topic/ul ')]">
                                            <xsl:variable name="cur4" select="$cur3/*[last()][contains(@class, ' topic/ul ')]" />

                                            <xsl:choose>
                                                <xsl:when test="$cur4/*[last()][contains(@class, ' topic/li ')][*[@placement='inline']]">
                                                    <xsl:value-of select="'6.5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>5mm</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:otherwise>0mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>



                        <xsl:otherwise>
                            <xsl:value-of select="'6mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/topic ')]
                                                      /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]" />
                        <xsl:choose>
                            <xsl:when test="$cur1/*[last()][contains(@class, ' topic/abstract ')]
                                            /*[last()][contains(@class, ' topic/p ')]">
                                <xsl:value-of select="'6mm'" />
                            </xsl:when>
                            <xsl:otherwise>0mm</xsl:otherwise>
                        </xsl:choose>
                </xsl:when>


                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/title ')]
                                [count(ancestor-or-self::*[contains(@class, 'topic/topic')]) = 3]">
                    <xsl:value-of select="'6.7mm'" />
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/body ')]
                                /*[last()][contains(@class, ' topic/section ')]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/body ')]
                                                      /*[last()][contains(@class, ' topic/section ')]" />
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3') and
                                        $cur1/*[last()][contains(@class, ' topic/ul ')]">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/note ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, ' topic/note ')]" />

                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

                                <xsl:otherwise>8mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]">
                            <xsl:value-of select="'6.5mm'" />
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/ul ')]">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/body ')]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/body ')]" />

                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()]/*[last()][contains(@class, ' task/step ')]
                                        /*[last()][contains(@class, ' task/cmd ')]">
                            <xsl:choose>
                                <xsl:when test="count($cur1/*[last()]/*[contains(@class, ' task/step ')]) &gt; 1">
                                    <xsl:value-of select="'7.5mm'" />
                                </xsl:when>
                                <xsl:otherwise>6mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="$cur1/*[last()]/*[last()][contains(@class, ' task/step ')]
                                        /*[last()][contains(@class, ' task/info ')]">
                            <xsl:variable name="cur2" select="$cur1/*[last()]/*[last()][contains(@class, ' task/step ')]
                                                              /*[last()][contains(@class, ' task/info ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/p ')]">
                                    <xsl:value-of select="'6mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/note ')]">
                                    <xsl:value-of select="'7.5mm'" />
                                </xsl:when>

                                <xsl:when test="$cur2/*[last()][contains(@class, ' topic/ul ')]">
                                    <xsl:value-of select="'5.5mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>



                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>



                <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, ' topic/abstract ')]">
                    <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, ' topic/abstract ')]" />

                    <xsl:choose>
                        <xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]">
                             <xsl:value-of select="'6mm'" />
                        </xsl:when>
                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>



                <xsl:otherwise>
                    <xsl:value-of select="'0mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="cur1" select="following-sibling::*[1]//*[1][contains(@class, 'topic/section')]" />
            <xsl:choose>
                <xsl:when test="$cur1/*[1][contains(@class, 'topic/ul')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="font-weight">600</xsl:attribute>
        <!-- <xsl:attribute name="color">cmyk(0%,0%,0%,100%)</xsl:attribute> -->
        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                    <xsl:value-of select="'cmyk(35%,80%,60%,0%)'" />
                </xsl:when>
                <xsl:otherwise>cmyk(0%,0%,0%,100%)</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <!-- <xsl:attribute name="font-size">17pt</xsl:attribute> -->
        <!-- <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                    <xsl:value-of select="'18pt'" />
                </xsl:when>
                <xsl:otherwise>17pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        
        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                            <xsl:value-of select="'16.5pt'" />
                        </xsl:when>
                        <xsl:otherwise>15.5pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                            <xsl:value-of select="'18pt'" />
                        </xsl:when>
                        <xsl:otherwise>17pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="line-height">20pt</xsl:attribute>
        <!-- <xsl:attribute name="background-color">green</xsl:attribute> -->
    </xsl:attribute-set>

    <!-- Heading4 title 연한 검은색 -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'Heading4') and
                                parent::*/preceding-sibling::*[1][contains(@class, 'topic/title ')][matches(@outputclass, 'Heading3')]">
                  <xsl:value-of select="'5.2mm'" />
                </xsl:when>

                <xsl:when test="(matches(@outputclass, 'Heading4') or
                                count(ancestor-or-self::*[contains(@class, 'topic/topic')]) = 5) and
                                parent::*/preceding-sibling::*[1][matches(@class, '(topic/body |topic/topic |topic/abstract )')]">
                    <xsl:choose>
                        <xsl:when test="parent::*[@outputclass = 'pagebreak']">
                            <xsl:value-of select="'3.3mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/body ')]
                                        //*[last()][contains(@class, 'topic/section')]
                                        /*[last()][contains(@class, 'topic/note ')]">
                            <xsl:value-of select="'6.5mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/topic ')]
                                        /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]
                                        /*[last()][contains(@class, 'topic/body ')]">
                            <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, 'topic/topic ')]
                                                              /descendant-or-self::*[contains(@class, ' topic/topic ')][last()]
                                                              /*[last()][contains(@class, 'topic/body ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur1/*[last()][contains(@class, 'topic/section ')]
                                                /*[last()][contains(@class, 'topic/ul ')]">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()]/*[last()][contains(@class, 'task/step ')]">
                                    <xsl:variable name="cur2" select="$cur1/*[last()]/*[last()][contains(@class, 'task/step ')]" />
                                    <xsl:choose>
                                        <xsl:when test="$cur2/*[last()][contains(@class, 'task/info ')]
                                                        /*[last()][contains(@class, 'topic/p ')]">
                                            <xsl:value-of select="'5.5mm'" />
                                        </xsl:when>
                                        <xsl:otherwise>4.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()][contains(@class, 'task/result ')]
                                                /*[last()][contains(@class, 'topic/note ')]">
                                    <xsl:value-of select="'6mm'" />
                                </xsl:when>

                                <xsl:otherwise>0mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/abstract ')]
                                        /*[last()][contains(@class, 'topic/p ')]">
                            <xsl:value-of select="'4.7mm'" />
                        </xsl:when>


                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/topic ')]
                                        /*[last()][contains(@class, 'topic/abstract ')]
                                        /*[last()][contains(@class, 'topic/p ')]">
                            <xsl:value-of select="'4.7mm'" />
                        </xsl:when>

                        <xsl:when test="parent::*/preceding-sibling::*[1][contains(@class, 'topic/body ')]
                                        /*[last()]/*[last()][contains(@class, 'task/step ')]">
                            <xsl:variable name="cur1" select="parent::*/preceding-sibling::*[1][contains(@class, 'topic/body ')]/*[last()]/*[last()][contains(@class, 'task/step ')]" />
                            <xsl:choose>
                                <xsl:when test="$cur1/*[last()][contains(@class, 'task/info ')]
                                                /*[last()][contains(@class, 'topic/p ')]
                                                /*[last()][contains(@class, 'topic/image ')][@placement='break']">
                                    <xsl:value-of select="'7mm'" />
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()][contains(@class, 'task/info ')]
                                                /*[last()][contains(@class, 'topic/p ')]">
                                    <xsl:variable name="cur2" select="$cur1/*[last()][contains(@class, 'task/info ')]
                                                                      /*[last()][contains(@class, 'topic/p ')]" />
                                    <!-- <xsl:value-of select="'5.5mm'" /> -->
                                    <xsl:choose>
                                        <xsl:when test="$cur2//*[contains(@class, 'topic/image ')][@placement='inline']">
                                            <xsl:value-of select="'4.3mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>5.5mm</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$cur1/*[last()][contains(@class, 'task/info ')]">
                                    <xsl:value-of select="'4mm'" />
                                </xsl:when>

                                <xsl:otherwise>4.5mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>6mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'"/>
                </xsl:when>
                <xsl:otherwise>cmyk(0%,0%,0%,70%)</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
        <!-- <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                    <xsl:value-of select="'17pt'"/>
                </xsl:when>
                <xsl:otherwise>15pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->

        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                            <xsl:value-of select="'15.5pt'"/>
                        </xsl:when>
                        <xsl:otherwise>13.5pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                            <xsl:value-of select="'17pt'"/>
                        </xsl:when>
                        <xsl:otherwise>15pt</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-weight">600</xsl:attribute>
        <!-- <xsl:attribute name="background-color">red</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="ast-warning" use-attribute-sets="common.block">
        <xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <xsl:attribute name="color">cmyk(0%,0%,0%,100%</xsl:attribute>
        <xsl:attribute name="space-before">5mm</xsl:attribute>
        <xsl:attribute name="space-after">5mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note" use-attribute-sets="common.block base-font">
        <xsl:attribute name="space-before">0.5mm</xsl:attribute>
        <xsl:attribute name="space-after">1mm</xsl:attribute>
        <xsl:attribute name="line-height">3mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="image__block">
        <!-- <xsl:attribute name="margin-left">7mm</xsl:attribute> -->
        <xsl:attribute name="margin-left">0mm</xsl:attribute>
        <!-- <xsl:attribute name="margin-right">15mm</xsl:attribute> -->
        <xsl:attribute name="margin-right">0mm</xsl:attribute>
        <xsl:attribute name="space-before">4.5mm</xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="ancestor::*[contains(@class, 'topic/abstract ')][1]
                                /following-sibling::*[1][contains(@class, 'topic/body ')]
                                /*[1][contains(@class, 'task/steps ')]">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:when test="parent::*/following-sibling::*[1][contains(@class, 'topic/note ')]
                                /*[1][contains(@class, 'topic/ul ')]">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:when test="ancestor::*[contains(@class, 'task/info ')]
                                /parent::*[contains(@class, 'task/step ')][last()]
                                /parent::*/following-sibling::*[1][contains(@class, 'task/result ')]
                                /*[1][contains(@class, 'topic/note ')]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:otherwise>4.5mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="content-width">33%</xsl:attribute>
        <!-- <xsl:attribute name="content-height">
            <xsl:choose>
                <xsl:when test="@height"><xsl:value-of select="@height"/></xsl:when>
                <xsl:otherwise>100%</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
                <xsl:otherwise>100%</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <!-- <xsl:attribute name="text-align">center</xsl:attribute> -->
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
        <!-- <xsl:attribute name="content-width">auto</xsl:attribute>
        <xsl:attribute name="content-height">auto</xsl:attribute>
        <xsl:attribute name="width">auto</xsl:attribute> -->
        <xsl:attribute name="content-width">97%</xsl:attribute>
        <xsl:attribute name="content-height">97%</xsl:attribute>
        <xsl:attribute name="width">auto</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <xsl:attribute name="padding-top">-1mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="image">
        <!-- <xsl:attribute name="height">10mm</xsl:attribute>
        <xsl:attribute name="width">10mm</xsl:attribute>
        <xsl:attribute name="content-width">
            <xsl:choose>
                <xsl:when test="contains(@class, 'topic/note ')">
                    <xsl:value-of select="'scale-to-fit'" />
                </xsl:when>
                <xsl:otherwise>100%</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        <xsl:attribute name="content-width">4mm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <!-- <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__column">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">3mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__align">

    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__entry">
        <xsl:attribute name="padding-end">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>

        <xsl:attribute name="padding-top">
            <!-- <xsl:choose>
                <xsl:when test="*[1][contains(@class, 'topic/ul')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose> -->
            <xsl:value-of select="'-1mm'" />
        </xsl:attribute>

        <!-- <xsl:attribute name="display-align">before</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__entry">
        <xsl:attribute name="start-indent">3mm</xsl:attribute>

        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__roundbox">
        <xsl:attribute name="padding-top">6mm</xsl:attribute>
        <!-- <xsl:attribute name="padding-bottom">4.2mm</xsl:attribute> -->
        <xsl:attribute name="padding-bottom">3.5mm</xsl:attribute>
        <xsl:attribute name="margin-top">
            <xsl:choose>
                <xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/ul')]">
                    <xsl:value-of select="'3.5mm'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'3.7mm'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="padding-left">7mm</xsl:attribute>
        <xsl:attribute name="padding-right">6.5mm</xsl:attribute>
        <xsl:attribute name="start-indent">7mm</xsl:attribute>
        <xsl:attribute name="end-indent">6.5mm</xsl:attribute>

        <xsl:attribute name="border-collapse">separate</xsl:attribute>
        <xsl:attribute name="axf:border-radius">0.5em</xsl:attribute>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border">1px solid white</xsl:attribute>
        <xsl:attribute name="background-color">cmyk(7.8%,3.6%,0%,0%)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="font-size">150%</xsl:attribute>
        <xsl:attribute name="baseline-shift">-15%</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="p" use-attribute-sets="common.block">
        <xsl:attribute name="line-height">3mm</xsl:attribute>
        

        <xsl:attribute name="space-before">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'prodname')">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>


                <xsl:when test="preceding-sibling::*[1][contains(@class, ' topic/note ')]">
                    <xsl:value-of select="'2.2mm'" />
                </xsl:when>
            
                <xsl:otherwise>1mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-after">0mm</xsl:attribute>
        

        <xsl:attribute name="keep-with-next.within-page">
            <xsl:value-of select="'auto'" />
        </xsl:attribute>
        
    </xsl:attribute-set>

    <xsl:attribute-set name="special-char">
        <xsl:attribute name="font-size">120%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title__content">
        <xsl:attribute name="line-height">inherit</xsl:attribute>
        <xsl:attribute name="border-start-width">0pt</xsl:attribute>
        <xsl:attribute name="border-end-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
            <xsl:param name="nodes" as="node()*" />
            <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function>
</xsl:stylesheet>
