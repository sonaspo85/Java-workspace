﻿<?xml version="1.0"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
							<xsl:value-of select="'0mm'" />
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

					    <xsl:otherwise>0mm</xsl:otherwise>
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
                    <xsl:choose>
                        <xsl:when test="$parTag[count(*[contains(@class, 'topic/entry')]) = 1]">
                            <xsl:value-of select="'0mm'" />
                        </xsl:when>

                        <!-- <xsl:otherwise>7.5mm</xsl:otherwise> -->
                        <xsl:otherwise>0mm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                 <xsl:when test="$ancesTable[matches(@outputclass, 'table_button')]">
					<xsl:choose>
					    <xsl:when test="$fchiP">
							<xsl:value-of select="'0mm'" />
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
					    	<xsl:value-of select="'0mm'" />
					    </xsl:when>

					    <xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
		 	    </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>



		<xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
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


	</xsl:attribute-set>

	<xsl:attribute-set name="ast.thead.row">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="ast.thead.padding">
		<xsl:attribute name="padding-left">
			<xsl:choose>
			    <xsl:when test="position() = 1">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:when test="position() = last()">
					<xsl:value-of select="'5mm'" />
			    </xsl:when>

			    <xsl:otherwise>2mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="padding-right">
			<xsl:choose>
			    <xsl:when test="position() = 1">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:when test="position() = last()">
					<xsl:value-of select="'2mm'" />
			    </xsl:when>

			    <xsl:otherwise>2mm</xsl:otherwise>
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
		<!-- <xsl:attribute name="space-before">0.8mm</xsl:attribute> -->
		<xsl:attribute name="space-before">1mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>
		<xsl:attribute name="start-indent">0mm</xsl:attribute>
		<xsl:attribute name="end-indent">0mm</xsl:attribute>
		<!-- <xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>

		<xsl:attribute name="font-weight" select="'inherit'" />
	</xsl:attribute-set>

<!-- default table border start -->
	<xsl:attribute-set name="__tableframe__top" use-attribute-sets="table.rule__top">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="table.rule__bottom">
		<xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="common.border__bottom">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__left" use-attribute-sets="table.rule__left">
	</xsl:attribute-set>

	<xsl:attribute-set name="__tableframe__right" use-attribute-sets="table.rule__right">
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

<!-- default talbe border end -->


	<xsl:attribute-set name="common.border__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">1pt</xsl:attribute>
		<xsl:attribute name="border-before-color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="common.border__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">1pt</xsl:attribute>
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
		<xsl:attribute name="border-before-width">1pt</xsl:attribute>
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
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_button')]">
                    <!-- <xsl:value-of select="'2.7mm'" /> -->
                    <xsl:choose>
                        <xsl:when test="$parTag.parSection.acesBody.preTitle[matches(@outputclass, 'Heading3')]">
                            <xsl:value-of select="'3.2mm'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'2.7mm'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_text')]">
                    <!-- <xsl:value-of select="'0.4mm'" /> -->
                    <xsl:value-of select="'2mm'" />
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_icon')]">
                    <xsl:value-of select="'1.7mm'" />
                </xsl:when>


                <xsl:otherwise>5pt</xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>

    	<xsl:attribute name="space-after">
    		<xsl:variable name="parTag" select="parent::*" />
    		<xsl:variable name="flwTitle" select="following::*[contains(@class, 'topic/title ')][1]" />
    		<xsl:variable name="parTag.parSection" select="$parTag/parent::*[contains(@class, 'topic/section ')]" />


    		<xsl:choose>
                <xsl:when test="$parTag[matches(@outputclass, 'table_key-features')]">
                    <xsl:value-of select="'5pt'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_button')]">
                    <!-- <xsl:value-of select="'1.7mm'" /> -->
                    <xsl:value-of select="'1.5mm'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_text')]">
                    <xsl:value-of select="'4.5mm'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_icon')]">
                    <xsl:value-of select="'3.8mm'" />
                </xsl:when>

                <xsl:when test="$parTag[matches(@outputclass, 'table_appendix-standard')]">
                	<xsl:choose>
                	    <xsl:when test="$parTag[not(following-sibling::*)] and $parTag.parSection">
                	    	<xsl:choose>
                	    	    <xsl:when test="$flwTitle[matches(@outputclass, 'Heading3-TroubleShooting')]">
                                    <xsl:value-of select="'3.3mm'" />
                                </xsl:when>

                	    	    <xsl:otherwise>4.3mm</xsl:otherwise>
                	    	</xsl:choose>
                	    </xsl:when>

                	    <xsl:otherwise>4.3mm</xsl:otherwise>
                	</xsl:choose>
                </xsl:when>

                <xsl:when test="$parTag[ matches(@outputclass, 'table_appendix-microusim')]">
                    <xsl:value-of select="'3.8mm'" />
                </xsl:when>


                <xsl:otherwise>5pt</xsl:otherwise>
            </xsl:choose>
    	</xsl:attribute> 

		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>

		 <xsl:attribute name="start-indent">
			<xsl:value-of select="'0mm'" />
		</xsl:attribute>

		<xsl:attribute name="end-indent">0mm</xsl:attribute> 
		<xsl:attribute name="width">auto</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table" use-attribute-sets="base-font">
	</xsl:attribute-set>
</xsl:stylesheet>