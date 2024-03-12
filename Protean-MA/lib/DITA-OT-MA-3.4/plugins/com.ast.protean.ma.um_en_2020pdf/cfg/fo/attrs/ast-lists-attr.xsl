<?xml version='1.0'?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:functx="http://www.functx.com"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">
	
    <xsl:attribute-set name="ol" use-attribute-sets="common.block">
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">4mm</xsl:attribute>
        <xsl:attribute name="line-height">inherit</xsl:attribute>
    </xsl:attribute-set>
	
    <xsl:attribute-set name="ol.li">
		<xsl:attribute name="space-after">0mm</xsl:attribute>
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="start-indent">0.7mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__content" use-attribute-sets="common.block">

    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label__content">
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    	<xsl:attribute name="font-stretch">semi-condensed</xsl:attribute>
    	<xsl:attribute name="baseline-shift">-1pt</xsl:attribute>

		<xsl:attribute name="font-size">
			<xsl:value-of select="$default-font-size" />
		</xsl:attribute>

		<xsl:attribute name="font-family">
    		<xsl:choose>
    		    <xsl:when test="matches($locale, 'zh-CN')">
				    <xsl:value-of select="'FZZhongDengXian-Z07S'" />
				</xsl:when>
    		    <xsl:otherwise>Arial</xsl:otherwise>
    		</xsl:choose>
    	</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul">
		<xsl:attribute name="space-before">
			<xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
			<xsl:variable name="fchiLi" select="*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="parInfo" select="parent::*[contains(@class, 'task/info ')]" />
			<xsl:variable name="parInfo.preCmd" select="$parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
			<xsl:variable name="parNote" select="parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="parNote.preP" select="$parNote/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parNote.preNote" select="$parNote/preceding-sibling::*[1][contains(@class, 'topic/note ')]" />
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/steps ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>

			<xsl:choose>
			    <xsl:when test="$depth = 2">
			        <xsl:value-of select="'0mm'" />
			    </xsl:when>

			    <xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-after">
			<xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
			<xsl:variable name="fchiLi" select="*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="flwP" select="following-sibling::*[1][contains(@class, ' topic/p ')]" />

			<xsl:choose>
			    <xsl:when test="$depth = 2">
			        <xsl:value-of select="'0mm'" />
			    </xsl:when>

			    <xsl:when test="$flwP[matches(@outputclass, 'callout-image')]">
			    	<xsl:value-of select="'3mm'" />
			    </xsl:when>

			    <xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="provisional-distance-between-starts">
		    <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
		    <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parLi" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parInfo" select="parent::*[contains(@class, ' task/info ')]" />
			<xsl:variable name="parNote" select="parent::*[contains(@class, ' topic/note ')]" />
			<xsl:variable name="parNote.parInfo" select="$parNote/parent::*[contains(@class, ' task/info ')]" />
			<xsl:variable name="parNote.parResult" select="$parNote/parent::*[contains(@class, ' task/result ')]" />
			<xsl:variable name="parNote.parResult.preStep" select="$parNote.parResult/preceding-sibling::*[1][contains(@class, ' task/steps ')]/*[last()][contains(@class, ' task/step ')]" />
			<xsl:variable name="parNote.preNote" select="$parNote/preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
			<xsl:variable name="parTag.parInfo" select="$parTag/parent::*[contains(@class, 'task/info ')]" />
			<xsl:variable name="parTag.parInfo.preCmd" select="$parTag.parInfo/preceding-sibling::*[1][contains(@class, 'task/cmd ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, ' topic/note ')]" />
			<xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parTag.preCmd" select="$parTag/preceding-sibling::*[1][contains(@class, ' task/cmd ')]" />
			<xsl:variable name="parNote.preNote" select="$parNote/preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
			<xsl:variable name="parNote.preNote.LchiUl" select="$parNote.preNote/*[last()][contains(@class, ' topic/ul ')]" />
			<xsl:variable name="parNote.preTable" select="$parNote/preceding-sibling::*[1][contains(@class, ' topic/table ')]" />
			<xsl:variable name="ancesTopic" select="ancestor::*[matches(@class, ' topic/topic ')]" />

			<xsl:choose>
			    <xsl:when test="$depth &gt; 1">
					<xsl:choose>
						<xsl:when test="$parNote">
							<xsl:choose>
					    	    <xsl:when test="matches($locale, 'zh-CN')">
					    			<xsl:value-of select="'9mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>5mm</xsl:otherwise>
					    	</xsl:choose>
						</xsl:when>

						<xsl:otherwise>
							<xsl:choose>
					    	    <xsl:when test="matches($locale, 'zh-CN')">
					    			<xsl:value-of select="'6mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>6mm</xsl:otherwise>
					    	</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
			    </xsl:when>

			    <xsl:when test="matches(@outputclass, 'arrow')">
                	<xsl:value-of select="'5.8mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'star')">
                	<xsl:choose>
                	    <xsl:when test="$ancesTopic[matches(@outputclass, 'backcover')]">
                	    	<xsl:value-of select="'4mm'" />
                	    </xsl:when>

                	    <xsl:otherwise>4mm</xsl:otherwise>
                	</xsl:choose>
                </xsl:when>


			    <xsl:otherwise>
			    	<xsl:choose>
			    	    <xsl:when test="matches($locale, 'zh-CN')">
			    			<xsl:value-of select="'9mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>5mm</xsl:otherwise>
			    	</xsl:choose>
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="line-height">
		    <xsl:value-of select="'inherit'" />
		</xsl:attribute>
		
		<xsl:attribute name="start-indent">
		    <xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
		    <xsl:variable name="parTag" select="parent::*" />
		    <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
		    <xsl:variable name="parNote" select="parent::*[contains(@class, 'topic/note ')]" />
		    <xsl:variable name="ancesNote" select="ancestor::*[contains(@class, 'topic/note ')]" />
		    <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />
		    <xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
		    <xsl:variable name="ancesTopic" select="ancestor::*[contains(@class, 'topic/topic ')]" />

		    <xsl:choose>
		    	<xsl:when test="$ancesTopic[matches(@oid, 'backcover')]">
                    <xsl:choose>
                        <xsl:when test="matches($locale, 'zh-TW')">
                            <xsl:choose>
                                <xsl:when test="$depth &gt; 1">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'3.5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'inherit'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

		    	<xsl:when test="$parNote">
                    <xsl:choose>
                        <xsl:when test="$parNote[matches(@outputclass, 'roundbox')]">
                        	<xsl:value-of select="'inherit'" />
                        </xsl:when>

                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesTable">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'arrow')">
                	<xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'star')">
                	<xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$ancesStepCnt = 'multi'">

                	<xsl:choose>
			    	    <xsl:when test="matches($locale, 'zh-CN')">
			    			<xsl:value-of select="'body-start() - 1mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:value-of select="'body-start() + 0.8mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
                </xsl:when>

		        <xsl:when test="$depth &gt; 1">
                    <xsl:choose>
                        <xsl:when test="$ancesNote">
                    		<xsl:choose>
					    	    <xsl:when test="matches($locale, 'zh-CN')">
					    			<xsl:value-of select="'body-start()'" />
					    	    </xsl:when>

					    	    <xsl:when test="$depth = 2">
					    	    	<xsl:value-of select="'body-start() + 3mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>body-start() + 2.7mm</xsl:otherwise>
					    	</xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                        	<xsl:choose>
					    	    <xsl:when test="matches($locale, 'zh-CN')">
					    			<xsl:value-of select="'body-start() - 1.2mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>inherit</xsl:otherwise>
					    	</xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                	<xsl:choose>
			    	    <xsl:when test="matches($locale, 'zh-CN')">
			    			<xsl:value-of select="'0mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>3mm</xsl:otherwise>
			    	</xsl:choose>
                </xsl:when>


                
                <!-- <xsl:when test="$parTag[not(contains(@class, 'topic/section '))]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when> -->
		        

                <xsl:otherwise>
                	<xsl:choose>
			    	    <xsl:when test="matches($locale, 'zh-CN')">
			    			<xsl:value-of select="'0mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>3mm</xsl:otherwise>
			    	</xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>

		
    </xsl:attribute-set>


    <xsl:attribute-set name="ul.li.first">
		<xsl:attribute name="space-before">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parLi" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>

			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
		    <xsl:variable name="parTag.ancesUl" select="$parTag/ancestor::*[contains(@class, ' topic/ul ')][1]" />

			<xsl:choose>
				<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
					    	<!-- <xsl:value-of select="'0.9mm'" /> -->
					    	<xsl:value-of select="'1mm'" />
			    		</xsl:when>

			    		<xsl:when test="$parTag.ancesUl[matches(@outputclass, 'backcover_tw_ul')]">
                            <xsl:value-of select="'0.2mm'" />
                        </xsl:when>

					    <xsl:otherwise>2mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
					<xsl:value-of select="'3mm'" />
				</xsl:when>

				<xsl:when test="$ancesStepCnt = 'multi'">
			    	<xsl:choose>
			    	    <xsl:when test="$parTag.parNote">
			    	    	<xsl:value-of select="'0.9mm'" />
			    	    </xsl:when>

			    	    <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
			    	    	<xsl:value-of select="'1.9mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:value-of select="'1mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag.parNote">
			    	<xsl:value-of select="'0.9mm'" />
	    		</xsl:when>

			    <xsl:otherwise>0.9mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="padding-bottom">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parLi" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />

			<xsl:choose>
				<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
					    	<xsl:value-of select="'0.5mm'" />
			    		</xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
					<xsl:value-of select="'1.5mm'" />
				</xsl:when>

				<xsl:when test="$ancesStepCnt = 'multi'">
			    	<xsl:choose>
			    	    <xsl:when test="$parTag.parNote">
			    	    	<xsl:value-of select="'0.5mm'" />
			    	    </xsl:when>

			    	    <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
			    	    	<xsl:value-of select="'0mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:value-of select="'0mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>


			    <xsl:otherwise>0.5mm</xsl:otherwise>
			</xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
        	<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
        	<xsl:variable name="parTag" select="parent::*" />
        	<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />

            <xsl:choose>
                <xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
					    	<xsl:value-of select="'0mm'" />
			    		</xsl:when>

					    <xsl:otherwise>0.5mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="space-before.conditionality">
			<xsl:choose>
			  <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
					<xsl:value-of select="'retain'" />
			  </xsl:when>

			  <xsl:otherwise>
				  <xsl:value-of select="'discard'" />
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="break-before">
			<xsl:choose>
				<xsl:when test="matches(@outputclass, 'break')">
					<xsl:value-of select="'page'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'auto'" />
				</xsl:otherwise>
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
	
    <xsl:attribute-set name="ul.li">
    	<xsl:attribute name="padding-top">
    		<xsl:variable name="parTag" select="parent::*" />
    		<xsl:variable name="preLi" select="preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
    		<xsl:variable name="preLi.LchiUl" select="$preLi/*[not(following-sibling::*)][contains(@class, ' topic/ul ')]" />

    		<xsl:choose>
    		    <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
    		        <xsl:value-of select="'-0.8mm'" />
    		    </xsl:when>

    		    <xsl:when test="$preLi/*[matches(@class, 'topic/tm')]">
    		    	<xsl:choose>
    		    	    <xsl:when test="matches($locale, '(zh-CN|zh-SG)')">
    		    	        <xsl:value-of select="'-2.5mm'" />
    		    	    </xsl:when>

    		    	    <xsl:otherwise>
    		    	        <xsl:value-of select="'0mm'" />
    		    	    </xsl:otherwise>
    		    	</xsl:choose>
    		    </xsl:when>

    		    <xsl:when test="$parTag[matches(@outputclass, 'backcover_tw_ul')]">
                    <xsl:choose>
                        <xsl:when test="$preLi.LchiUl">
                            <xsl:value-of select="'-1.4mm'" />
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
			<xsl:variable name="fchiP" select="*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
		    <xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
		    <xsl:variable name="ancesTopic" select="ancestor::*[contains(@class, 'topic/topic ')]" />
		    <xsl:variable name="preLi" select="preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
		    <xsl:variable name="preLi.LchiNote" select="$preLi/*[last()][contains(@class, ' topic/note ')]" />
			<xsl:variable name="parTag.ancesUl" select="$parTag/ancestor::*[contains(@class, ' topic/ul ')][1]" />

			<xsl:choose>
				<xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
					<xsl:choose>
					    <xsl:when test="not(*)">
							<xsl:value-of select="'0mm'" />
					    </xsl:when>
					    
					    <xsl:when test="$fchiP">
                            <xsl:choose>
                                <xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
									<xsl:value-of select="'3mm'" />
								</xsl:when>

                                <xsl:otherwise>1mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="position() = 2">
					<xsl:choose>
					    <xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
							<xsl:value-of select="'3mm'" />
						</xsl:when>

						<xsl:when test="$depth &gt; 1">
							<xsl:choose>
							    <xsl:when test="$parTag.parNote">
									<xsl:value-of select="'1mm'" />
							    </xsl:when>

							    <xsl:when test="$parTag.ancesUl[matches(@outputclass, 'backcover_tw_ul')]">
		                            <xsl:value-of select="'0mm'" />
		                        </xsl:when>

							    <xsl:otherwise>2mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="$ancesStepCnt = 'multi'">
					    	<xsl:choose>
					    	    <xsl:when test="$parTag.parNote">
								    <xsl:value-of select="'1mm'" />
								</xsl:when>

								<xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
									<xsl:value-of select="'0.5mm'" />
								</xsl:when>

					    	    <xsl:otherwise>
					    	    	<xsl:value-of select="'0.5mm'" />
					    	    </xsl:otherwise>
					    	</xsl:choose>
					    </xsl:when>

					    <xsl:when test="$parTag[matches(@outputclass, 'star')]">
					    	<xsl:choose>
					    	    <xsl:when test="$ancesTopic[matches(@outputclass, 'backcover')]">
					    	        <xsl:value-of select="'0mm'" />
					    	    </xsl:when>

					    	    <xsl:when test="preceding-sibling::*">
					    	    	<xsl:value-of select="'4mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>
					    	        <xsl:value-of select="'1mm'" />
					    	    </xsl:otherwise>
					    	</xsl:choose>
					    </xsl:when>

					    <xsl:when test="$parTag[matches(@outputclass, 'backcover_tw_ul')]">
			    	        <xsl:value-of select="'0mm'" />
			    	    </xsl:when>

					    <xsl:otherwise>1mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
							<xsl:value-of select="'1mm'" />
					    </xsl:when>

					    <xsl:otherwise>2mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$ancesStepCnt = 'multi'">
			    	<xsl:choose>
			    	    <xsl:when test="$parTag.parNote">
						    <xsl:value-of select="'1mm'" />
						</xsl:when>

						<xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
							<xsl:value-of select="'0.5mm'" />
						</xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:value-of select="'0.5mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag.parNote">
					<xsl:value-of select="'1mm'" />
			    </xsl:when>

			    <xsl:when test="$preLi.LchiNote">
			    	<xsl:choose>
			    	    <xsl:when test="not($preLi.LchiNote/*[last()][name()='ul'])">
			    	        <xsl:value-of select="'1.5mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	        <xsl:value-of select="'1mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag[matches(@outputclass, 'star')]">
			    	<xsl:choose>
			    	    <xsl:when test="$ancesTopic[matches(@outputclass, 'backcover')]">
			    	        <xsl:value-of select="'0mm'" />
			    	    </xsl:when>

			    	    <xsl:when test="preceding-sibling::*">
			    	    	<xsl:value-of select="'4mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	        <xsl:value-of select="'2mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag[matches(@outputclass, 'backcover_tw_ul')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

			    <xsl:otherwise>1mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="padding-bottom">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="ancesNote" select="ancestor::*[contains(@class, ' topic/note ')]" />
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
		    <xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />

            <xsl:choose>
            	<xsl:when test="position() = 2">
            		<xsl:choose>
            			<xsl:when test="$depth &gt; 1">
							<xsl:choose>
							    <xsl:when test="$parTag.parNote">
									<xsl:value-of select="'0.5mm'" />
							    </xsl:when>

							    <xsl:otherwise>0mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

            		    <xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
							<xsl:value-of select="'1.5mm'" />
						</xsl:when>

						<xsl:when test="position() = last()">
							<xsl:choose>
							    <xsl:when test="$ancesNote or $ancesTable">
									<xsl:value-of select="'0mm'" />
							    </xsl:when>

							    <xsl:when test="$ancesStepCnt = 'multi'">
							    	<xsl:choose>
							    	    <xsl:when test="$parTag.parNote">
							    	    	<xsl:value-of select="'0.5mm'" />
							    	    </xsl:when>

							    	    <xsl:otherwise>
							    	    	<xsl:value-of select="'0mm'" />
							    	    </xsl:otherwise>
							    	</xsl:choose>
							    </xsl:when>

							    <xsl:when test="*[last()][contains(@class, 'topic/note ')]">
					    	    	<xsl:value-of select="'0.8mm'" />
					    	    </xsl:when>

							    <xsl:otherwise>0.5mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="$ancesStepCnt = 'multi'">
					    	<xsl:choose>
					    	    <xsl:when test="$parTag.parNote">
					    	    	<xsl:value-of select="'0.5mm'" />
					    	    </xsl:when>

					    	     <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
		                            <xsl:value-of select="'0mm'" />
		                        </xsl:when>

					    	    <xsl:otherwise>
					    	    	<xsl:value-of select="'0mm'" />
					    	    </xsl:otherwise>
					    	</xsl:choose>
					    </xsl:when>

					    <xsl:when test="$parTag.parNote">
			    	    	<xsl:value-of select="'0.5mm'" />
			    	    </xsl:when>

			    	    <xsl:when test="*[last()][contains(@class, 'topic/note ')]">
			    	    	<xsl:value-of select="'0.8mm'" />
			    	    </xsl:when>

            		    <xsl:otherwise>0.5mm</xsl:otherwise>
            		</xsl:choose>
            	</xsl:when>

            	<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
							<xsl:value-of select="'0.5mm'" />
					    </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

            	<xsl:when test="$parTag[matches(@outputclass, 'arrow')]">
					<xsl:value-of select="'1.5mm'" />
				</xsl:when>

				<xsl:when test="$ancesStepCnt = 'multi'">
			    	<xsl:choose>
			    	    <xsl:when test="$parTag.parNote">
			    	    	<xsl:value-of select="'0.5mm'" />
			    	    </xsl:when>

			    	     <xsl:when test="count($ancesStep/preceding-sibling::*[contains(@class, 'task/step ')]) + 1 = 1">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:value-of select="'0mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="position() = last()">
					<xsl:choose>
					    <xsl:when test="$ancesNote or $ancesTable">
							<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:when test="*[last()][contains(@class, 'topic/note ')]">
			    	    	<xsl:value-of select="'0.8mm'" />
			    	    </xsl:when>

					    <xsl:otherwise>0.5mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

			    <xsl:when test="$parTag.parNote">
					<xsl:value-of select="'0.5mm'" />
			    </xsl:when>

			    <xsl:when test="*[last()][contains(@class, 'topic/note ')]">
	    	    	<xsl:value-of select="'0.8mm'" />
	    	    </xsl:when>

			    <xsl:otherwise>0.5mm</xsl:otherwise>
			</xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
        	<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])"/>
        	<xsl:variable name="parTag" select="parent::*" />
        	<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
											   
            <xsl:choose>
                <xsl:when test="position() = 2">
					<xsl:choose>
					    <xsl:when test="$depth &gt; 1">
							<xsl:choose>
							    <xsl:when test="$parTag.parNote">
					    	    	<xsl:value-of select="'0mm'" />
					    	    </xsl:when>

							    <xsl:otherwise>0.5mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$parTag.parNote">
			    	    	<xsl:value-of select="'0mm'" />
			    	    </xsl:when>

					    <xsl:otherwise>0.5mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$parTag.parNote">
	    	    	<xsl:value-of select="'0mm'" />
	    	    </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="space-before.conditionality">
			<xsl:choose>
			  <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
					<xsl:value-of select="'retain'" />
			  </xsl:when>

			  <xsl:otherwise>
				  <xsl:value-of select="'discard'" />
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		

		<xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="break-before">
			<xsl:choose>
				<xsl:when test="matches(@outputclass, 'break')">
					<xsl:value-of select="'page'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'auto'" />
				</xsl:otherwise>
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


    <xsl:attribute-set name="parLi.ul.li.first">
		<xsl:attribute name="space-before.conditionality">
			<xsl:choose>
			  <xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
					<xsl:value-of select="'retain'" />
			  </xsl:when>

			  <xsl:otherwise>
				  <xsl:value-of select="'discard'" />
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="break-before">
			<xsl:choose>
				<xsl:when test="matches(@outputclass, 'break')">
					<xsl:value-of select="'page'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'auto'" />
				</xsl:otherwise>
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

    <xsl:attribute-set name="parLi.ul.li">
		<xsl:attribute name="space-before">
			<xsl:value-of select="'2mm'" />
		</xsl:attribute>

		<xsl:attribute name="space-after">
            <xsl:value-of select="'0.5mm'" />
        </xsl:attribute>


		<xsl:attribute name="space-before.conditionality">
			<xsl:value-of select="'discard'" />
		</xsl:attribute>

		<xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="break-before">
			<xsl:choose>
				<xsl:when test="matches(@outputclass, 'break')">
					<xsl:value-of select="'page'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'auto'" />
				</xsl:otherwise>
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

    <xsl:attribute-set name="ul.li__label__content">
        <xsl:attribute name="padding-top">
        	<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>
        	<xsl:variable name="parTag" select="parent::*" />
        	<xsl:variable name="parTag.ancesUl" select="$parTag/ancestor::*[contains(@class, ' topic/ul ')][1]" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, '(MM|IN)')">0mm</xsl:when>

				<xsl:when test="$parTag/*[matches(@outputclass, 'star')]">
					<xsl:value-of select="'0.2mm'" />
				</xsl:when>

				<xsl:when test="$depth = 1">
					<xsl:choose>
					    <xsl:when test="matches($locale, 'zh-CN')">
					        <xsl:value-of select="'-0.3mm'" />
					    </xsl:when>

					    <xsl:otherwise>
					        <xsl:value-of select="'0mm'" />
					    </xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<!-- <xsl:when test="$parTag.ancesUl[matches(@outputclass, 'backcover_tw_ul')]">
                    <xsl:value-of select="'0.4mm'" />
                </xsl:when> -->

				<xsl:otherwise>
					<xsl:value-of select="'-0.3mm'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="font-family">
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>

            <xsl:variable name="cur">
            	<xsl:choose>
            	    <xsl:when test="matches($locale, 'zh-CN')">
            	        <xsl:choose>
            	            <xsl:when test="$depth = 1">
            	                <xsl:value-of select="'li-Bullet'" />
            	            </xsl:when>

            	            <xsl:when test="$depth = 2">
            	                <xsl:value-of select="'li-Bullet-2'" />
            	            </xsl:when>

            	            <xsl:otherwise>
            	                <xsl:value-of select="'li-Bullet'" />
            	            </xsl:otherwise>
            	        </xsl:choose>
            	    </xsl:when>

            	    <xsl:otherwise>
            	        <xsl:value-of select="'li-Bullet'" />
            	    </xsl:otherwise>
            	</xsl:choose>
            </xsl:variable>

            <xsl:variable name="class" select="@class" />
            <xsl:variable name="localeStrAfter" select="substring-after($locale, '-')" />

            <xsl:call-template name="fontFamily">
                <xsl:with-param name="cur" select="$cur" />
                <xsl:with-param name="class" select="$class" />
                <xsl:with-param name="locale" select="$locale" />
                <xsl:with-param name="localeStrAfter" select="$localeStrAfter" />
            </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="text-align">start</xsl:attribute>

		<xsl:attribute name="font-size">
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="note.bullet" select="parent::*[contains(@class, 'topic/ul ')]/parent::*[contains(@class, 'topic/note ')]"/>
			<xsl:variable name="parUl" select="parent::*[contains(@class, 'topic/ul ')]" />

			<xsl:choose>
				<xsl:when test="matches($localeStrAfter, 'MM')">
					<xsl:choose>
						<xsl:when test="$note.bullet">
							<!-- <xsl:value-of select="'14pt'" /> -->
							<xsl:value-of select="'9pt'" />
						</xsl:when>

					    <xsl:when test="$depth = 2">
							<xsl:value-of select="'9pt'" />
					    </xsl:when>

					    <xsl:when test="$parUl[matches(@outputclass, 'arrow')]">
							<xsl:value-of select="$default-font-size" />
						</xsl:when>

					    <!-- <xsl:otherwise>14pt</xsl:otherwise> -->
					    <xsl:otherwise>9pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="matches($locale, 'en-CN')">
					<xsl:value-of select="'9pt'" />
				</xsl:when>

				<xsl:when test="matches($locale, 'zh-CN')">
					<xsl:value-of select="$default-font-size" />
				</xsl:when>

				<xsl:when test="matches($localeStrAfter, '(HK|SG)')">
					<xsl:value-of select="'9pt'" />
				</xsl:when>

				<xsl:when test="matches($localeStrAfter, '(TW)')">
					<xsl:value-of select="'12pt'" />
				</xsl:when>

				<xsl:when test="$parUl[matches(@outputclass, 'star')]">
					<xsl:value-of select="'inherit'" />
				</xsl:when>

				<xsl:when test="$parUl[matches(@outputclass, 'arrow')]">
					<xsl:value-of select="$default-font-size" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'9pt'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
			<xsl:variable name="note.bullet" select="parent::*[contains(@class, 'topic/ul ')]/parent::*[contains(@class, 'topic/note ')]"/>
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>
			<xsl:variable name="bulletNum" select="if ($note.bullet) then
												  'Unordered List bullet 1'
												  else concat('Unordered List bullet ', (($depth - 1) mod 4) + 1)"/>
			<xsl:choose>
				<xsl:when test="$bulletNum = 'Unordered List bullet 2'">
					<xsl:choose>
						<xsl:when test="matches($localeStrAfter, 'IN')">100%</xsl:when>

						<xsl:when test="matches($locale, '(zh-CN|zh-HK|zh-TW|zh-SG)')">70%</xsl:when>

						<xsl:otherwise>
							<xsl:value-of select="'110%'" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'normal'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="line-height" select="$default-line-height" />
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__body">
        <xsl:attribute name="start-indent">
        	<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' task/steps-unordered ')]">body-start()</xsl:when>
        		<xsl:when test="contains(@class, ' task/substep ')">0mm</xsl:when>
        		<xsl:otherwise>body-start()</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--<xsl:attribute-set name="ol.li.first">
        <xsl:attribute name="space-before">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>3mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>1mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-before" select="'0mm'" />
		<xsl:attribute name="space-after" select="'0mm'" />
        <xsl:attribute name="margin-left">2mm</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>-->

    <xsl:attribute-set name="sl.sli.first">
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!--<xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
            <xsl:param name="nodes" as="node()*" />
            <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function>-->
</xsl:stylesheet>