<?xml version="1.0"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
	version="2.0">

	<xsl:attribute-set name="common.table.body.entry">
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
		<xsl:attribute name="text-align">inherit</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tbody.row.entry__content" use-attribute-sets="common.table.body.entry">
		<xsl:attribute name="space-before">
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')]" />
			<xsl:variable name="fchiP" select="*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="fchiUl" select="*[1][contains(@class, ' topic/ul ')]" />

			<xsl:choose>
			    <xsl:when test="$ancesTable[matches(@outputclass, 'table_button')]">
					<xsl:choose>
					    <xsl:when test="$fchiP">
							<xsl:value-of select="'0.3mm'" />
					    </xsl:when>

					    <xsl:when test="$fchiUl">
					    	<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
			    </xsl:when>

			    <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
					<xsl:choose>
					    <xsl:when test="$fchiP[count(node()) = 1]/*[contains(@class, 'topic/image ')][@placement='inline']">
							<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:when test="$fchiP[matches(., '[^a-zA-Z\d]+')]/*[contains(@class, 'topic/image ')][@placement='inline']">
							<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:otherwise>0.5mm</xsl:otherwise>
					</xsl:choose>
			    </xsl:when>

			    <xsl:otherwise>0pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-after">0pt</xsl:attribute>

		<xsl:attribute name="padding-bottom">
		    <xsl:variable name="parEntry" select="parent::*[contains(@class, 'topic/entry ')]" />
            <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')][1]" />
            <xsl:variable name="parTag" select="parent::*" />
            <xsl:variable name="fchiP" select="*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="fchiUl" select="*[1][contains(@class, ' topic/ul ')]" />

    		<xsl:choose>
                <xsl:when test="$ancesTable[ matches(@outputclass, 'table_key-features')]">
                    <!-- <xsl:choose>
                        <xsl:when test="$parTag[count(*[contains(@class, 'topic/entry')]) = 1]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                        	<xsl:choose>
                        	    <xsl:when test="$pi.code/*[name()='template'][matches(., '-OS_upgrade')]">
                        			<xsl:value-of select="'0.5mm'" />
                        	    </xsl:when>

                        	    <xsl:otherwise>7.5mm</xsl:otherwise>
                        	</xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose> -->
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                 <xsl:when test="$ancesTable[matches(@outputclass, 'table_button')]">
					<xsl:choose>
					    <xsl:when test="$fchiP">
							<xsl:choose>
							    <xsl:when test="matches($localeStrAfter, 'IN')">
									<xsl:value-of select="'0.5mm'" />
							    </xsl:when>

							    <xsl:otherwise>1mm</xsl:otherwise>
							</xsl:choose>
					    </xsl:when>

					    <xsl:when test="$fchiUl">
					    	<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_text')]">
					<xsl:value-of select="'0mm'" />
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
					<xsl:choose>
					    <xsl:when test="not(preceding-sibling::*[contains(@class, 'topic/entry ')])">
							<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:when test="position() = last()">
					    	<xsl:value-of select="'1mm'" />
					    </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_none')]">
					<xsl:value-of select="'0mm'" />
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_rohs')]">
					<xsl:value-of select="'0mm'" />
		 	    </xsl:when>

                <xsl:otherwise>7.5mm</xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>

		 <xsl:attribute name="start-indent">
			<xsl:value-of select="'0pt'" />
		</xsl:attribute>
		
		<xsl:attribute name="end-indent">
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, ' topic/table ')]" />

			<xsl:choose>
			    <xsl:when test="$ancesTable[matches(@outputclass, 'table_button')]">
		 			<xsl:value-of select="'0pt'" />
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_text')]">
		 			<xsl:value-of select="'0pt'" />
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
		 			<xsl:value-of select="'0pt'" />
		 	    </xsl:when>

		 	    <xsl:when test="$ancesTable[matches(@outputclass, 'table_rohs')]">
		 			<xsl:value-of select="'0pt'" />
		 	    </xsl:when>

			    <xsl:otherwise>4mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.table.head.entry">
		<xsl:attribute name="font-weight">600</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.table.cell">
	</xsl:attribute-set>


	<xsl:attribute-set name="tbody.row.entry">
		<xsl:attribute name="display-align">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/table ')][matches(@outputclass, 'table_appendix-standard')]">
					<xsl:value-of select="'center'" />
	            </xsl:when>

	            <xsl:when test="ancestor::*[contains(@class, ' topic/table ')][matches(@outputclass, 'table_text_tur_servis')]">
					<xsl:value-of select="'center'" />
	            </xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')]">
					<xsl:value-of select="'center'" />
	            </xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'before'" />
                </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="background-color">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/table ')][1][matches(@outputclass, 'table_text_tur_servis')]">
					<xsl:value-of select="'transparent'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/table ')][1][matches(@outputclass, 'table_rohs')]">
					<xsl:value-of select="'transparent'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')] and
								not(preceding-sibling::*)">
					<xsl:value-of select="'cmyk(0%,0%,0%,10%)'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/table ')][1][matches(@outputclass, 'table_appendix-standard')] and
								not(preceding-sibling::*)">
					<xsl:value-of select="'cmyk(0%,0%,0%,10%)'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1]//*[contains(@class, ' topic/entry ')]/@nameend">
					<xsl:variable name="test" select="number(replace(ancestor::*[contains(@class, ' topic/tgroup ')][1]//*[contains(@class, ' topic/entry ')]/@nameend, '(.+)(\d)', '$2')) + 1" />
					<xsl:choose>
						<xsl:when test="xs:integer(replace(@colname, '(.+)(\d)', '$2')) &lt; $test">
							<xsl:value-of select="'cmyk(0%,0%,0%,10%)'" />
                    	</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'transparent'" />
                        </xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>transparent</xsl:otherwise>
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

	<xsl:attribute-set name="ast.thead.row">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.thead.padding">
		<xsl:attribute name="{if ($writing-mode = 'lr') then 'padding-left' else 'padding-right'}">
            <xsl:choose>
			    <xsl:when test="position() = 1">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:when test="position() = last()">
					<!-- <xsl:value-of select="'4mm'" /> -->
					<xsl:value-of select="'3.2mm'" />
			    </xsl:when>

			    <xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="{if ($writing-mode = 'lr') then 'padding-right' else 'padding-left'}">
            <xsl:choose>
			    <xsl:when test="position() = 1">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:when test="position() = last()">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="padding-bottom">
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

			<xsl:choose>
			    <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
					<xsl:value-of select="'-0.1mm'" />
			    </xsl:when>

			    <xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

        <xsl:attribute name="background-color">
        	<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

			<xsl:choose>
				<xsl:when test="$ancesTable[matches(@outputclass, 'table_text_tur_servis')]">
					<xsl:value-of select="'cmyk(0%,0%,0%,20%)'" />
				</xsl:when>

				<xsl:when test="not(preceding-sibling::*)">
					<xsl:value-of select="'cmyk(0%,0%,0%,20%)'" />
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.tbody">
		<xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.tbody.row">
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.tgroup.thead">
		<xsl:attribute name="line-height"><xsl:value-of select="$default-line-height" /></xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="thead.row.entry__content" use-attribute-sets="common.table.body.entry common.table.head.entry">
		<xsl:attribute name="space-before">1mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="start-indent">0mm</xsl:attribute>
		<xsl:attribute name="end-indent">0mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0mm</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>

		<xsl:attribute name="font-weight" select="'inherit'" />

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

<!-- default table border start -->
	<xsl:attribute-set name="__tableframe__top" use-attribute-sets="table.rule__top">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="table.rule__bottom">
		<xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
		<!-- <xsl:attribute name="border-after-width">0.5pt</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="common.border__bottom">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__left" use-attribute-sets="table.rule__left">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__right" use-attribute-sets="table.rule__right">
		<xsl:attribute name="border-end-color">
        	<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')]" />

			<xsl:choose>
			    <xsl:when test="$ancesTable[contains(@outputclass, 'table_rohs')]">
			        <xsl:choose>
			            <xsl:when test="position() = 1 and
                          				parent::*[matches(@class, 'topic/row')][not(preceding-sibling::*)]">
			                <xsl:value-of select="'white'" />
			            </xsl:when>

			            <xsl:otherwise>
			                <xsl:value-of select="'black'" />
			            </xsl:otherwise>
			        </xsl:choose>
			    </xsl:when>

			    <xsl:otherwise>
			        <xsl:value-of select="'black'" />
			    </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__all" use-attribute-sets="table.rule__all">
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__all">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>

		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>

		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>

		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
  	</xsl:attribute-set>

	<xsl:attribute-set name="table__tableframe__all">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">1pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>

		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">1pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>

		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>

		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
  	</xsl:attribute-set>

  	<xsl:attribute-set name="table__tableframe__thin__topbot">
  		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>

		<!-- <xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-after-color">blue</xsl:attribute> -->
  	</xsl:attribute-set>

	<!-- default talbe border end -->
	<xsl:attribute-set name="common.border__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">0.9pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">0.9pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__right">
		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__left">
		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
	</xsl:attribute-set>

<!-- table rule -->
	<xsl:attribute-set name="table.rule__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<!-- <xsl:attribute name="border-before-width">0.5pt</xsl:attribute> -->
		<xsl:attribute name="border-before-width">
			<xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')][1]" />
			<xsl:choose>
                <xsl:when test="$ancesTable[matches(@outputclass, 'table_text_tur_servis')]">
                    <xsl:value-of select="'0.3pt'" />
                </xsl:when>

                <xsl:otherwise>0.5pt</xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-after-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__right">
		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.rule__left">
		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.tgroup">
		 <xsl:attribute name="space-before">
			<xsl:variable name="parTag" select="parent::*" />
			<xsl:variable name="parTag.preP" select="$parTag/preceding-sibling::*[1][contains(@class, 'topic/p ')]" />
			<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, ' topic/section ')]" />
			<xsl:variable name="parTag.parSection.acesBody" select="$parTag.parSection/ancestor::*[contains(@class, ' topic/body ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preTitle" select="$parTag.parSection.acesBody/preceding-sibling::*[1][contains(@class, 'topic/title ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preAbstract" select="$parTag.parSection.acesBody/preceding-sibling::*[1][contains(@class, 'topic/abstract ')]" />
			<xsl:variable name="parTag.parSection.acesBody.preAbstract.preP" select="$parTag.parSection.acesBody.preAbstract/*[last()][contains(@class, 'topic/p ')]" />
			<xsl:variable name="preP" select="preceding-sibling::*[1][contains(@class, ' topic/p ')]" />
			<xsl:variable name="AncestTopicCnt" select="string(count($parTag.parSection.acesBody.preTitle/ancestor-or-self::*[contains(@class, 'topic/topic ')]))" />
			
			<xsl:choose>
                <xsl:when test="$parTag[ matches(@outputclass, 'table_key-features')]">
                    <xsl:value-of select="'1.5mm'" />
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_button')]">
                    <xsl:value-of select="'1.7mm'" />
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_text')]">
                    <xsl:value-of select="'0.9mm'" />
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_icon')]">
                    <xsl:value-of select="'2mm'" />
                </xsl:when>
                        
                <xsl:otherwise>5pt</xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>

    	<xsl:attribute name="space-after">
    		<xsl:variable name="parTag" select="parent::*" />
    		<xsl:variable name="parTag.ancesBody" select="$parTag/ancestor::*[contains(@class, ' topic/body ')][1]" />
    		<xsl:variable name="parTag.ancesBody.parTopic" select="$parTag.ancesBody/parent::*[contains(@class, ' topic/topic ')]" />
    		<xsl:variable name="parTag.ancesBody.parTopic.flwTopic" select="$parTag.ancesBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
    		<xsl:variable name="parTag.ancesBody.parTopic.flwTopic.fchiTitle" select="$parTag.ancesBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

    		<xsl:variable name="flwNote" select="$parTag/following-sibling::*[1][contains(@class, ' topic/note ')]" />

    		<xsl:choose>
                <xsl:when test="$parTag[matches(@outputclass, 'table_key-features')]">
                    <xsl:value-of select="'5pt'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_button')]">
                    <xsl:choose>
                        <xsl:when test="$parTag[not(following-sibling::*)]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'4.2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_text')]">
                    <xsl:choose>
                        <xsl:when test="$flwNote/*[1][name()='ul']">
                            <xsl:value-of select="'4.7mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'4.2mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_icon')]">
                    <xsl:value-of select="'3.6mm'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_none')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>5pt</xsl:otherwise>
            </xsl:choose>
    	</xsl:attribute>

    	<xsl:attribute name="margin-top">
    		<xsl:variable name="parTag" select="parent::*" />
    		<xsl:variable name="parTag.preUl" select="$parTag/preceding-sibling::*[1][contains(@class, ' topic/ul ')]" />
    		<xsl:variable name="parTag.ancesBody" select="$parTag/ancestor::*[contains(@class, 'topic/body ')][1]" />
    		<xsl:variable name="parTag.ancesBody.preTitle" select="$parTag.ancesBody/preceding-sibling::*[1][matches(@class, ' topic/title ')]" />
    		<xsl:variable name="parTag.ancesBody.preAbstract" select="$parTag.ancesBody/preceding-sibling::*[1][matches(@class, ' topic/abstract ')]" />
    		<xsl:variable name="parTag.ancesBody.preAbstract.LchiP" select="$parTag.ancesBody.preAbstract/*[last()][matches(@class, ' topic/p ')]" />


    		<xsl:choose>
    		    <xsl:when test="$parTag.preUl[matches(@outputclass, 'star')]">
    		        <xsl:value-of select="'11mm'" />
    		    </xsl:when>

    		    <xsl:when test="$parTag[matches(@outputclass, 'table_none')]">
    		    	<xsl:value-of select="'2mm'" />
    		    </xsl:when>

    		    <xsl:when test="$parTag[matches(@outputclass, 'table_text_tw_ncc')]">
    		    	<xsl:value-of select="'3mm'" />
    		    </xsl:when>

    		    <xsl:when test="$parTag[not(preceding-sibling::*)]">
    		    	<xsl:choose>
    		    	    <xsl:when test="$parTag.ancesBody.preTitle[matches(@outputclass, 'Heading3')]">
    		    	        <xsl:value-of select="'1.7mm'" />
    		    	    </xsl:when>

    		    	    <xsl:when test="$parTag.ancesBody.preAbstract">
    		    	    	<xsl:choose>
    		    	    	    <xsl:when test="$parTag.ancesBody.preAbstract.LchiP">
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
    		    </xsl:when>

    		    <xsl:otherwise>
    		        <xsl:value-of select="'0mm'" />
    		    </xsl:otherwise>
    		</xsl:choose>
    	</xsl:attribute>

    	<xsl:attribute name="margin-bottom">
    		<xsl:variable name="parTag" select="parent::*" />
    		<xsl:variable name="flwUl" select="$parTag/following-sibling::*[1][contains(@class, ' topic/ul ')]" />
    		<xsl:variable name="parTag.ancesBody" select="$parTag/ancestor::*[contains(@class, ' topic/body ')][1]" />
    		<xsl:variable name="parTag.ancesBody.flwTopic" select="$parTag.ancesBody/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
    		<xsl:variable name="parTag.ancesBody.parTopic" select="$parTag.ancesBody/parent::*[contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parTag.ancesBody.parTopic.flwTopic" select="$parTag.ancesBody.parTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
			<xsl:variable name="parTag.ancesBody.parTopic.flwTopic.fchiTitle" select="$parTag.ancesBody.parTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />
			<xsl:variable name="parTag.ancesBody.flwTopic.fchiTitle" select="$parTag.ancesBody.flwTopic/*[1][contains(@class, ' topic/title ')]" />

    		<xsl:variable name="parTag.ancesTopic" select="$parTag/ancestor::*[contains(@class, 'topic/topic ')][1]" />
    		<xsl:variable name="parTag.ancesTopic.flwTopic" select="$parTag.ancesTopic/following-sibling::*[1][contains(@class, ' topic/topic ')]" />
            <xsl:variable name="parTag.ancesTopic.flwTopic.fchiTitle" select="$parTag.ancesTopic.flwTopic/*[1][contains(@class, ' topic/title ')]" />

    		<xsl:choose>
    		    <xsl:when test="$flwUl[matches(@outputclass, 'star')]">
    		        <xsl:choose>
    		            <xsl:when test="$parTag[matches(@outputclass, 'table_text_tw_ncc')]">
    		                <xsl:value-of select="'1.5mm'" />
    		            </xsl:when>

    		            <xsl:otherwise>
    		                <xsl:value-of select="'7.5mm'" />
    		            </xsl:otherwise>
    		        </xsl:choose>
    		    </xsl:when>

    		    <xsl:when test="$parTag[matches(@outputclass, 'table_none')] and
                                $parTag.ancesTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading2')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_button')]">
                    <xsl:choose>
                        <xsl:when test="$parTag[not(following-sibling::*)]">
                            <xsl:choose>
                                <xsl:when test="$parTag.ancesBody[not(following-sibling::*)]">
                                    <xsl:choose>
                                        <xsl:when test="$parTag.ancesBody.parTopic.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                                            <xsl:value-of select="'5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:value-of select="'0mm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="$parTag.ancesBody.flwTopic.fchiTitle[matches(@outputclass, 'Heading3')]">
                            		<xsl:value-of select="'4.7mm'" />
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




		<!-- <xsl:attribute name="space-before.conditionality">retain</xsl:attribute> -->
		<!-- <xsl:attribute name="space-after.conditionality">retain</xsl:attribute> -->
		<xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">discard</xsl:attribute>

		 <xsl:attribute name="start-indent">
			<xsl:value-of select="'0mm'" />
		</xsl:attribute>

		<xsl:attribute name="end-indent">0mm</xsl:attribute> 
		<xsl:attribute name="width">auto</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table" use-attribute-sets="base-font">
	</xsl:attribute-set>
</xsl:stylesheet>