<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:functx="http://www.functx.com" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="2.0">

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
				<xsl:when test="matches(substring-after($locale, '-'), 'CN')">
					<xsl:value-of select="'FZZhongDengXian-Z07S'" />
				</xsl:when>
				<xsl:otherwise>Arial</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<!-- <xsl:attribute-set name="ul.li__content">
    	<xsl:attribute name="padding-before" select="'0mm'" />
    </xsl:attribute-set> -->

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

			<xsl:variable name="parSection" select="parent::*[contains(@class, 'topic/section ')]" />
            <xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, 'topic/body ')]" />
            <xsl:variable name="parSection.parBody.preTitle" select="$parSection.parBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />

			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
			<xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />

			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)">
					<xsl:choose>
					    <xsl:when test="$parSection.parBody.preTitle">
					        <xsl:choose>
					            <xsl:when test="$parSection.parBody.preTitle[matches(@outputclass, 'Heading2')]">
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

				<xsl:when test="$depth = 2">
					<xsl:choose>
					    <xsl:when test="$preP">
					        <xsl:choose>
					            <xsl:when test="$ancesSteps and
					            				$ancesStepCnt = 'onestep'">

					                <xsl:choose>
					                    <xsl:when test="$parNote">
					                        <xsl:value-of select="'0mm'" />
					                    </xsl:when>

					                    <xsl:otherwise>
					                        <xsl:value-of select="'2.8mm'" />
					                    </xsl:otherwise>
					                </xsl:choose>
					            </xsl:when>

					            <xsl:otherwise>
					                <xsl:value-of select="'1.7mm'" />
					            </xsl:otherwise>
					        </xsl:choose>
					    </xsl:when>

					    <xsl:otherwise>
					        <xsl:value-of select="'1.3mm'" />
					    </xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-after">
			<xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parLi" select="parent::*[contains(@class, ' topic/li ')]" />
			<xsl:variable name="fchiLi" select="*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="parSection" select="parent::*[contains(@class, ' topic/section ')]" />
			<xsl:variable name="parSection.parBody" select="$parSection/parent::*[contains(@class, ' topic/body ')]" />
			<xsl:variable name="parSection.parBody.parTopic" select="$parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parSection.parBody.parTopic.flwTopic" select="$parSection.parBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parSection.parBody.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
			<xsl:variable name="parSection.parBody.parTopic.parTopic" select="$parSection.parBody.parTopic/parent::*[contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic" select="$parSection.parBody.parTopic.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parSection.parBody.parTopic.parTopic.flwTopic.fchiTitle" select="$parSection.parBody.parTopic.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

			<xsl:value-of select="'0mm'" />
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
							<xsl:value-of select="'5mm'" />
						</xsl:when>

						<xsl:otherwise>
							<xsl:value-of select="'5mm'" />
						</xsl:otherwise>
					</xsl:choose>
			    </xsl:when>

			    <xsl:when test="matches(@outputclass, 'arrow')">
                	<xsl:value-of select="'5.8mm'" />
                </xsl:when>

                <xsl:when test="matches(@outputclass, 'star')">
                	<xsl:choose>
                	    <xsl:when test="$ancesTopic[matches(@otherprops, 'backcover')]">
                	    	<xsl:value-of select="'4mm'" />
                	    </xsl:when>

                	    <xsl:otherwise>3mm</xsl:otherwise>
                	</xsl:choose>
                </xsl:when>


			    <xsl:otherwise>
			    	<xsl:value-of select="'5mm'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="line-height">
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
		    <xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
		    <xsl:variable name="parNote" select="parent::*[contains(@class, ' topic/note ')]" />
		    <xsl:variable name="parEntry" select="parent::*[contains(@class, ' topic/entry ')]" />
		    <xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />

			<xsl:choose>
				<xsl:when test="$parNote">
			    	<xsl:value-of select="'16pt'" />
			    </xsl:when>

			    <xsl:when test="$parEntry">
			    	<xsl:value-of select="'16pt'" />
			    </xsl:when>

			    <xsl:when test="$ancesSteps">
			    	<xsl:choose>
			    	    <xsl:when test="$depth = 2 and
			    	    				$ancesStepCnt = 'onestep'">
			    	        <xsl:value-of select="'16pt'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	        <xsl:value-of select="'18pt'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:otherwise>
			    	<xsl:value-of select="'18pt'" />
			    </xsl:otherwise>
			</xsl:choose>
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
                    <xsl:value-of select="'inherit'" />
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
                	<xsl:value-of select="'body-start() + 0.8mm'" />
                </xsl:when>

		        <xsl:when test="$depth &gt; 1">
                    <xsl:choose>
                        <xsl:when test="$ancesNote">
                    		<xsl:choose>
					    	    <xsl:when test="$depth = 2">
					    	    	<xsl:value-of select="'body-start() + 2.2mm'" />
					    	    </xsl:when>

					    	    <xsl:otherwise>body-start() + 2.7mm</xsl:otherwise>
					    	</xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                        	<xsl:value-of select="'inherit'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$ancesSteps and $ancesStepCnt = 'onestep'">
                	<xsl:value-of select="'3mm'" />
                </xsl:when>



                <xsl:when test="$parTag[not(contains(@class, 'topic/section '))]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>


                <xsl:otherwise>
                	<xsl:value-of select="'3mm'" />
                </xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="ul.li.first">
		<xsl:attribute name="space-before">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parLi" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />

			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
			<xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="preTitle" select="preceding::*[1][contains(@class, 'topic/title ')]" />

			<xsl:value-of select="'0mm'" />
		</xsl:attribute>

		<xsl:attribute name="padding-bottom">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parLi" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
			<xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="parTag.parEntry" select="$parTag/parent::*[contains(@class, 'topic/entry')]" />
			<xsl:variable name="flwLi" select="following-sibling::*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="flwLi.fchiP" select="$flwLi/*[1][contains(@class, 'topic/p ')]" />


			<xsl:choose>
			    <xsl:when test="$flwLi.fchiP and $flwLi.fchiP">
			        <xsl:value-of select="'-0.8mm'" />
			    </xsl:when>

			    <xsl:otherwise>
			        <xsl:value-of select="'0mm'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-after">
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="flwLi" select="following-sibling::*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="flwLi.fchiP" select="$flwLi/*[1][contains(@class, 'topic/p ')]" />


			<xsl:value-of select="'0mm'" />
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
			<xsl:value-of select="'0mm'" />
		</xsl:attribute>

		<xsl:attribute name="space-before">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="fchiP" select="*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="parTag.parEntry" select="$parTag/parent::*[contains(@class, 'topic/entry ')]" />
			<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
			<xsl:variable name="preLi" select="preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
			<xsl:variable name="preLi.LchiNote" select="$preLi/*[last()][contains(@class, ' topic/note ')]" />
			<xsl:variable name="preLi.LchiNote.LchiUl" select="$preLi.LchiNote/*[last()][contains(@class, ' topic/ul ')]" />


			<xsl:choose>
				<xsl:when test="$depth &gt; 1">
					<xsl:choose>
					    <xsl:when test="$ancesSteps and
					    				$ancesStepCnt = 'onestep'">
					        <xsl:choose>
					            <xsl:when test="$parTag.parNote">
					                <xsl:value-of select="'2.4mm'" />
					            </xsl:when>

					            <xsl:otherwise>
					                <xsl:value-of select="'3.6mm'" />
					            </xsl:otherwise>
					        </xsl:choose>
					    </xsl:when>

					    <xsl:otherwise>
					        <xsl:value-of select="'2.4mm'" />
					    </xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$parTag.parNote">
			    	<xsl:choose>
			    	    <xsl:when test="*[name()='ul']">
			    	        <xsl:value-of select="'1.3mm'" />
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	        <xsl:value-of select="'2.5mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag.parSection">
			    	<xsl:choose>
			    	    <xsl:when test="position() = 2 and
			    	    				$preLi[*[@placement='inline']]">
			    	        <xsl:choose>
			    	        	<xsl:when test="node()[1][@placement='inline']">
			    	                <xsl:value-of select="'2.75mm'" />
			    	            </xsl:when>

			    	            <xsl:when test="*[@placement='inline']">
			    	                <xsl:value-of select="'3mm'" />
			    	            </xsl:when>

			    	            <xsl:otherwise>
			    	                <xsl:value-of select="'2mm'" />
			    	            </xsl:otherwise>
			    	        </xsl:choose>
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	        <xsl:choose>
			    	        	<xsl:when test="node()[1][@placement='inline']">
			    	                <xsl:value-of select="'2.75mm'" />
			    	            </xsl:when>

			    	            <xsl:when test="*[@placement='inline']">
			    	                <xsl:value-of select="'3mm'" />
			    	            </xsl:when>

			    	            <xsl:otherwise>
			    	                <!-- <xsl:value-of select="'3.5mm'" /> -->
			    	                <xsl:value-of select="'3mm'" />
			    	            </xsl:otherwise>
			    	        </xsl:choose>
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$ancesSteps">
			    	<xsl:choose>
			    		<xsl:when test="$ancesStepCnt = 'multi'">
			    			<xsl:choose>
			    			    <xsl:when test="*[@placement='inline']">
			    			        <xsl:choose>
			    			            <xsl:when test="$preLi/*[@placement='inline']">

			    			                <xsl:choose>
			    			                    <xsl:when test="node()[1][@placement='inline']">
			    			                    	<xsl:value-of select="'2mm'" />
			    			                    </xsl:when>

			    			                    <xsl:otherwise>
			    			                    	<xsl:value-of select="'3mm'" />
			    			                    </xsl:otherwise>
			    			                </xsl:choose>

			    			            </xsl:when>

			    			            <xsl:otherwise>
			    			                <!-- <xsl:value-of select="'2mm'" /> -->
			    			                <xsl:value-of select="'3.2mm'" />
			    			            </xsl:otherwise>
			    			        </xsl:choose>
			    			    </xsl:when>

			    			    <xsl:otherwise>
			    			        <!-- <xsl:value-of select="'2.2mm'" /> -->
			    			        <!-- <xsl:value-of select="'3.5mm'" /> -->
			    			        <xsl:choose>
			    			            <xsl:when test="not($preLi/*[@placement='inline'])">
			    			        		<xsl:value-of select="'3.2mm'" />
			    			            </xsl:when>

			    			            <xsl:when test="$preLi/*[@placement='inline']">
			    			            	<xsl:value-of select="'2mm'" />
			    			            </xsl:when>

			    			            <xsl:otherwise>
			    			            	<xsl:value-of select="'3.5mm'" />
			    			            </xsl:otherwise>
			    			        </xsl:choose>

			    			    </xsl:otherwise>
			    			</xsl:choose>
	    	        	</xsl:when>

			    	    <xsl:when test="*[1][count(node()) = 1]/*[name()='b']">
	    	        		<xsl:value-of select="'1.5mm'" />
	    	        	</xsl:when>

	    	        	<xsl:when test="node()[1][@placement='inline']">

	    	        		<xsl:value-of select="'2mm'" />
	    	        		<!-- <xsl:choose>
	    	        		    <xsl:when test="$preLi[node()[1][@placement='inline']]">
	    	        		        <xsl:value-of select="'3.2mm'" />
	    	        		    </xsl:when>

	    	        		    <xsl:otherwise>
	    	        		        <xsl:value-of select="'2mm'" />
	    	        		    </xsl:otherwise>
	    	        		</xsl:choose> -->
	    	        	</xsl:when>

	    	        	<xsl:when test="$preLi.LchiNote.LchiUl">
	    	        		<xsl:value-of select="'4mm'" />
	    	        	</xsl:when>



			    	    <xsl:otherwise>
			    	        <!-- <xsl:value-of select="'3.5mm'" /> -->
			    	        <xsl:value-of select="'3.5mm'" />
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:otherwise>
			    	<!-- <xsl:value-of select="'1mm'" /> -->
			    	<xsl:value-of select="'2.2mm'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="padding-bottom">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="ancesNote" select="ancestor::*[contains(@class, ' topic/note ')]" />
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="ancesStep" select="ancestor::*[contains(@class, ' task/step ')][1]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')][1]" />
			<xsl:variable name="ancesSteps.flwSection" select="$ancesSteps/following-sibling::*[1][contains(@class, ' topic/section ')]" />
			<xsl:variable name="ancesSteps.flwSection.fchiNote" select="$ancesSteps.flwSection/*[1][contains(@class, ' topic/note ')]" />
			<xsl:variable name="ancesSteps.flwSection.fchiNote.fchiUl" select="$ancesSteps.flwSection.fchiNote/*[1][contains(@class, ' topic/ul ')]" />
			<xsl:variable name="ancesStepCnt" select="if (count($ancesSteps/*[contains(@class, 'task/step ')]) &gt; 1) then 'multi' else 'onestep'" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="parTag.flwNote" select="$parTag/following-sibling::*[1][contains(@class, 'topic/note ')]" />
			<xsl:variable name="parTag.flwP" select="$parTag/following-sibling::*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="flwLi" select="following-sibling::*[1][contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
			<xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />
			<xsl:variable name="ancesLi" select="ancestor::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="LchiNote" select="*[last()][contains(@class, 'topic/note ')]" />

			<xsl:value-of select="'0mm'" />

		</xsl:attribute>

		<xsl:attribute name="space-after">
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />

			<xsl:value-of select="'0mm'" />

		</xsl:attribute>

		<!-- <xsl:attribute name="line-height">
			<xsl:value-of select="'16pt'" />
		</xsl:attribute> -->

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
			<xsl:variable name="fchiP" select="*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="preli" select="preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
			<xsl:variable name="preli.preLi" select="$preli/preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
			<xsl:variable name="preli.preLi.LchiLi" select="$preli.preLi/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />

			<xsl:variable name="preli.LchiLi" select="$preli/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />
			<xsl:variable name="preli.LchiLi.LchiNote" select="$preli.LchiLi/*[last()][contains(@class, ' topic/note ')]" />
			<xsl:variable name="preli.LchiLi.LchiNote.LchiLi" select="$preli.LchiLi.LchiNote/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />


			<xsl:variable name="preli.LchiP" select="$preli/*[last()][contains(@class, ' topic/p ')]" />
			<xsl:variable name="preli.LchiNote" select="$preli/*[last()][contains(@class, ' topic/note ')]" />
			<xsl:variable name="preli.LchiNote.preP" select="$preli.LchiNote/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="preli.LchiNote.LchiLi" select="$preli.LchiNote/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parli" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, ' topic/section ')]" />
			<xsl:variable name="parTag.parSection.acesBody" select="$parTag.parSection/ancestor::*[contains(@class, ' topic/body ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preAbstract" select="$parTag.parSection.acesBody/preceding-sibling::*[1][contains(@class, ' topic/abstract ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preAbstract.LchiP" select="$parTag.parSection.acesBody.preAbstract/*[last()][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preTitle" select="$parTag.parSection.acesBody/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preAbstract.preTitle" select="$parTag.parSection.acesBody.preAbstract/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
			<xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parTag.parResult" select="$parTag/parent::*[contains(@class, ' task/result ')]" />

			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, ' topic/note ')]" />
			<xsl:variable name="parTag.parNote.parResult" select="$parTag.parNote/parent::*[contains(@class, ' task/result ')]" />
			<xsl:variable name="parTag.parNote.parResult.preStep" select="$parTag.parNote.parResult/preceding-sibling::*[1][contains(@class, ' task/steps ')]/*[last()][contains(@class, ' task/step ')]" />
			<xsl:variable name="parTag.parNote.parResult.preStep.LchiCmd" select="$parTag.parNote.parResult.preStep/*[last()][contains(@class, ' task/cmd ')]" />
			<xsl:variable name="parTag.parNote.parResult.preStep.LchiInfo" select="$parTag.parNote.parResult.preStep/*[last()][contains(@class, ' task/info ')]" />
			<xsl:variable name="Abbr.preStep.LchiInfo.LchiP" select="$parTag.parNote.parResult.preStep.LchiInfo/*[last()][contains(@class, ' topic/p ')]" />
			<xsl:variable name="Abbr.preStep.LchiInfo.LchiLi" select="$parTag.parNote.parResult.preStep.LchiInfo/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />
			<xsl:variable name="parTag.parNote.preNote" select="$parTag.parNote/preceding-sibling::*[1][contains(@class, ' topic/note ')]" />
			<xsl:variable name="parTag.parNote.preNote.LchiLi" select="$parTag.parNote.preNote/*[last()][contains(@class, ' topic/ul ')]/*[last()][contains(@class, ' topic/li ')]" />
			<xsl:variable name="preli.LchiLi" select="$preli/*[last()][contains(@class, 'topic/ul ')]/*[last()][contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parInfo" select="$parTag/parent::*[contains(@class, ' task/info ')]" />
			<xsl:variable name="parTag.parInfo.parStep" select="$parTag.parInfo/parent::*[contains(@class, ' task/step ')]" />
			<xsl:variable name="parTag.parInfo.preCmd" select="$parTag.parInfo/preceding-sibling::*[1][contains(@class, ' task/cmd ')]" />
			<xsl:variable name="parTag.parNote.preLi" select="$parTag.parNote/preceding-sibling::*[1][contains(@class, ' topic/ul ')]/*[last()][contains(@class, 'topic/li ')]" />
			<xsl:variable name="parTag.parNote.preP" select="$parTag.parNote/preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="parTag.parNote.parInfo" select="$parTag.parNote/parent::*[contains(@class, ' task/info ')]" />
			<xsl:variable name="parTag.parNote.parInfo.preCmd" select="$parTag.parNote.parInfo/preceding-sibling::*[1][contains(@class, ' task/cmd ')]" />
			<xsl:variable name="parTag.parNote.parLi" select="$parTag.parNote/parent::*[contains(@class, ' topic/li ')]" />

			<xsl:variable name="parTag.parNote.parSection" select="$parTag.parNote/parent::*[contains(@class, ' topic/section ')]" />
			<xsl:variable name="parTag.parNote.parSection.parBody" select="$parTag.parNote.parSection/parent::*[contains(@class, ' topic/body ')]" />
			<xsl:variable name="parTag.parNote.parSection.parBody.preTitle" select="$parTag.parNote.parSection.parBody/preceding-sibling::*[1][contains(@class, ' topic/title ')]" />
			<xsl:variable name="parTag.parNote.parSection.parBody.parTopic" select="$parTag.parNote.parSection.parBody/parent::*[contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parTag.parAbstract" select="$parTag[not(preceding-sibling::*)]/parent::*[contains(@class, ' topic/abstract ')]" />
			<xsl:variable name="parTag.parEntry" select="$parTag/parent::*[contains(@class, 'topic/entry ')]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, ' task/steps ')]" />
			<xsl:variable name="ancesTopic" select="ancestor::*[contains(@class, ' topic/topic ')]" />
			<xsl:variable name="ancesNote" select="ancestor::*[contains(@class, ' topic/note ')]" />

			<xsl:variable name="ancesStepCnt01" select="if (count($ancesSteps[1]/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />
			<xsl:variable name="preStepCnt02" select="if (count($parTag.parNote.parResult.preStep/parent::*/*[contains(@class, 'task/step ')]) = 1) then 'onestep' else 'multi'" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')]) +
											   count(ancestor-or-self::*[contains(@class, ' task/steps ')][count(*) &gt; 1])" />

			<xsl:choose>
				<xsl:when test="position() = 2">
					<xsl:value-of select="'2mm'" />
				</xsl:when>

				<xsl:otherwise>2mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-after">
			<xsl:variable name="preli" select="preceding-sibling::*[1][contains(@class, ' topic/li ')]" />
			<xsl:variable name="fchiP" select="*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.parli" select="$parTag/parent::*[contains(@class, 'topic/li ')]" />

			<xsl:choose>
				<xsl:when test="position() = 2">
					<xsl:value-of select="'0.5mm'" />
				</xsl:when>

				<xsl:otherwise>0.5mm</xsl:otherwise>
			</xsl:choose>
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

		<!-- <xsl:attribute name="line-height.conditionality">discard</xsl:attribute> -->
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
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="ancesNote" select="ancestor::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />
			<xsl:variable name="depth" select="count(ancestor-or-self::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />
			<xsl:variable name="ancesSteps" select="ancestor::*[contains(@class, 'task/steps ')]" />
			<xsl:variable name="parTag.parNote" select="$parTag/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="fchiP" select="*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="fchiP.flwP" select="$fchiP/following-sibling::*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="preLi" select="preceding-sibling::*[1][contains(@class, 'topic/li ')]" />

			<xsl:choose>
				<xsl:when test="$depth &gt; 1">
                    <xsl:value-of select="'-0.9mm'" />
                </xsl:when>

			    <xsl:when test="$parTag.parSection">
			    	<xsl:choose>
			    	    <xsl:when test="not(preceding-sibling::*) and
			    	    				*[@placement='inline']">
			    	        <xsl:choose>
			    	            <xsl:when test="node()[1][@placement='inline']">
			    	                <xsl:value-of select="'-0.3mm'" />
			    	            </xsl:when>

			    	            <xsl:otherwise>
			    	                <xsl:value-of select="'1mm'" />
			    	            </xsl:otherwise>
			    	        </xsl:choose>
			    	    </xsl:when>

			    	    <xsl:otherwise>
			    	    	<xsl:choose>
			    	    	    <xsl:when test="node()[1][@placement='inline']">
			    	                <xsl:value-of select="'-0.3mm'" />
			    	            </xsl:when>

			    	    	    <xsl:otherwise>
			    	    	        <xsl:value-of select="'-1mm'" />
			    	    	    </xsl:otherwise>
			    	    	</xsl:choose>
			    	    </xsl:otherwise>
			    	</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$ancesSteps">
			    	<xsl:choose>
                        <xsl:when test="*[1][count(node()) = 1]/*[name()='b']">
                            <xsl:value-of select="'-0.2mm'" />
                        </xsl:when>

                        <xsl:when test="node()[1][@placement='inline']">
                        	<!-- <xsl:value-of select="'0.8mm'" /> -->

	    	                <xsl:choose>
	    	                	<xsl:when test="position() = 1">
	    	                		<xsl:value-of select="'0.3mm'" />
	    	                	</xsl:when>

	    	                    <xsl:when test="$preLi/*[@placement='inline']">
	    	                        <xsl:value-of select="'-0.7mm'" />
	    	                    </xsl:when>

	    	                    <xsl:otherwise>

	    	                        <xsl:value-of select="'0.3mm'" />
	    	                    </xsl:otherwise>
	    	                </xsl:choose>
	    	            </xsl:when>

	    	            <xsl:when test="*[@placement='inline']">
	    	            	<xsl:choose>
	    	            	    <xsl:when test="$preLi/*[@placement='inline']">
	    	            	        <xsl:value-of select="'-1mm'" />
	    	            	    </xsl:when>

	    	            	    <xsl:otherwise>
	    	            	        <xsl:value-of select="'0.7mm'" />
	    	            	    </xsl:otherwise>
	    	            	</xsl:choose>
	    	            </xsl:when>

	    	            <xsl:when test="$fchiP/node()[1][name()='cmdname']">
	    	            	<xsl:value-of select="'-0.2mm'" />
	    	            </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'-1mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
			    </xsl:when>

			    <xsl:when test="$parTag.parNote">
                    <xsl:choose>
                        <!-- <xsl:when test="position() = 2">
                            <xsl:value-of select="'-0.1mm'" />
                        </xsl:when> -->

                        <xsl:when test="not(*[@placement='inline']) and
                        				$fchiP.flwP
                        				/*[@placement='inline']">
                        	<xsl:value-of select="'-0.1mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'-0.7mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

			    <xsl:otherwise>
			    	<xsl:value-of select="'-0.7mm'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="line-height" select="'16pt'" />
		<xsl:attribute name="line-height.conditionality" select="'discard'" />

		<xsl:attribute name="font-family">
			<xsl:variable name="parTag" select="parent::*" />

			<xsl:value-of select="'SamsungOneKorean 400'" />
		</xsl:attribute>

		<xsl:attribute name="text-align">start</xsl:attribute>

		<xsl:attribute name="font-size">
			<!-- <xsl:value-of select="$default-font-size" /> -->
			<xsl:value-of select="'8pt'" />
		</xsl:attribute>

		<xsl:attribute name="font-stretch">
			<xsl:variable name="note.bullet" select="parent::*[contains(@class, 'topic/ul ')]/parent::*[contains(@class, 'topic/note ')]" />
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])" />
			<xsl:variable name="bulletNum" select="if ($note.bullet) then
												  'Unordered List bullet 1'
												  else concat('Unordered List bullet ', (($depth - 1) mod 4) + 1)" />
			<xsl:choose>
				<xsl:when test="$bulletNum = 'Unordered List bullet 2'">
					<xsl:value-of select="'100%'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'normal'" />
				</xsl:otherwise>
			</xsl:choose>
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


	<!--<xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
            <xsl:param name="nodes" as="node()*" />
            <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function>-->
</xsl:stylesheet>