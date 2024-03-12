<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:functx="http://www.functx.com"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

    <xsl:attribute-set name="ol" use-attribute-sets="common.block">
        <xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">4mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li">
		<xsl:attribute name="space-after">0mm</xsl:attribute>
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="relative-align">inherit</xsl:attribute>
		<xsl:attribute name="start-indent">0.7mm</xsl:attribute>
		<xsl:attribute name="line-height">6.4mm</xsl:attribute>
        <!-- <xsl:attribute name="provisional-distance-between-starts">body-start()</xsl:attribute> -->
    </xsl:attribute-set>


    <xsl:attribute-set name="ol.li__label__content">
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    	<xsl:attribute name="font-family">Arial</xsl:attribute>
    	<xsl:attribute name="font-stretch">semi-condensed</xsl:attribute>
    	<xsl:attribute name="baseline-shift">-1pt</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:value-of select="$default-font-size" />
		</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul">
		<xsl:attribute name="space-before">0mm</xsl:attribute>
		<xsl:attribute name="space-after">0mm</xsl:attribute>

		<xsl:attribute name="provisional-distance-between-starts">
			<!-- <xsl:variable name="depth" select="count(ancestor::*[matches(@class, '( topic/ul | task/step )')])"/> -->
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')]) +
											   count(ancestor::*[contains(@class, ' task/steps ')][count(*) &gt; 1])"/>

			<xsl:choose>
			  <xsl:when test="ancestor::*[contains(@class, ' task/steps ')]">
					<xsl:choose>

						<xsl:when test="$depth = 1">
							<xsl:value-of select="'5mm'" />
						</xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'task/info ')][1]">
                            <xsl:value-of select="'5mm'" />
                        </xsl:when>

						<xsl:otherwise>
							<xsl:value-of select="'4mm'" />
						</xsl:otherwise>
					</xsl:choose>
			  </xsl:when>

			  <xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$depth = 1">
							<xsl:value-of select="'6mm'" />
						</xsl:when>

						<xsl:otherwise>
							<xsl:value-of select="'5mm'" />
						</xsl:otherwise>
					</xsl:choose>
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:attribute name="line-height">
			<xsl:choose>
				<xsl:when test="parent::*[matches(@outputclass, 'roundbox')]">
					<xsl:value-of select="'6.4mm'" />
				</xsl:when>

				<xsl:when test="count(ancestor-or-self::*[contains(@class, 'topic/ul')]) &gt; 1">
					<xsl:value-of select="'6.4mm'" />
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, 'task/info ')][1]
								/preceding-sibling::*[1][contains(@class, 'task/cmd ')] and
								count(ancestor::*[contains(@class, 'task/steps ')]/*) &gt; 1">
					<xsl:value-of select="'6.2mm'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'6.4mm'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li.first">
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li">
		<xsl:attribute name="space-before">
			<xsl:choose>
				<xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                    <xsl:choose>
                        <xsl:when test="descendant::*[contains(@class, 'topic/image ')][@placement='inline']">
					       <xsl:value-of select="'3mm'" />
                        </xsl:when>
                        <xsl:otherwise>2mm</xsl:otherwise>
                    </xsl:choose>
				</xsl:when>

				<xsl:when test="count(ancestor-or-self::*[contains(@class, 'topic/ul')]) &gt; 1">
					<xsl:value-of select="'1.9mm'" />
				</xsl:when>

				<xsl:when test="parent::*/preceding-sibling::*[1][matches(@outputclass, 'Heading3')]">
					<xsl:value-of select="'1.62mm'" />
				</xsl:when>

				<xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/li')][count(*[contains(@class, 'topic/p')]) &gt; 1]">
					<xsl:variable name="cur1" select="preceding-sibling::*[1][contains(@class, 'topic/li')][count(*[contains(@class, 'topic/p')]) &gt; 1]" />
					<xsl:choose>
						<xsl:when test="$cur1/*[last()][contains(@class, ' topic/p ')]
										/*[last()][contains(@class, ' topic/image ')][@placement='break'] and 
										parent::*[matches(@outputclass, 'arrow')]">
							<xsl:value-of select="'6mm'" />
						</xsl:when>
					
						<xsl:otherwise>1mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, 'topic/entry')]">
					<xsl:choose>
						<xsl:when test="not(preceding-sibling::*)">
							<xsl:value-of select="'inherit'" />
						</xsl:when>

						<xsl:otherwise>1.4mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

                <xsl:when test="preceding-sibling::*[1][contains(@class, 'topic/li')]
                                /*[last()][contains(@class, 'topic/note ')]">
                    <xsl:variable name="cur1" select="preceding-sibling::*[1][contains(@class, 'topic/li')]
                                                      /*[last()][contains(@class, 'topic/note ')]" />
                        <xsl:choose>
                            <xsl:when test="$cur1/*[last()][contains(@class, 'topic/ul ')]">
                                <xsl:value-of select="'4mm'" />
                            </xsl:when>
                            <xsl:otherwise>4mm</xsl:otherwise>
                        </xsl:choose>
                </xsl:when>

                <xsl:when test="*[contains(@class, 'topic/tm ')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'1.4mm'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="following-sibling::*[1]/*[contains(@class, 'topic/tm ')] and
                                *[contains(@class, 'topic/tm ')]">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:otherwise>1.5pt</xsl:otherwise>
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

		<xsl:attribute name="start-indent">
			<xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')]) +
											   count(ancestor::*[contains(@class, ' task/steps ')][count(*) &gt; 1])"/>

			<xsl:choose>
				<!-- <xsl:when test="parent::*[@outputclass='arrow']">
					<xsl:value-of select="'0mm'" />
				</xsl:when> -->
				<xsl:when test="parent::*[matches(@outputclass, '(arrow|hyphen|bullet)')]">
					<xsl:choose>
						<xsl:when test="$depth = 1">
							<xsl:choose>
								<xsl:when test="parent::*[matches(@outputclass, 'arrow')]">
									<xsl:value-of select="'0mm'" />
								</xsl:when>
							
								<xsl:otherwise>0mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="$depth = 2">
							<xsl:choose>
								<xsl:when test="parent::*[matches(@outputclass, 'hyphen')]">
									<xsl:value-of select="'8mm'" />
								</xsl:when>

								<xsl:when test="parent::*[matches(@outputclass, 'bullet')]">
									<xsl:value-of select="'3mm'" />
								</xsl:when>
							
								<xsl:otherwise>0mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="$depth = 3">
							<xsl:choose>
								<xsl:when test="parent::*[matches(@outputclass, 'hyphen')]">
									<xsl:value-of select="'9mm'" />
								</xsl:when>
							
								<xsl:otherwise>0mm</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					
						<xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="ancestor::*[contains(@class, ' task/steps ')]">
					<xsl:choose>
						<xsl:when test="$depth = 2">
							<xsl:choose>
								<xsl:when test="ancestor::*[contains(@class, 'topic/note')]">
                                    <xsl:value-of select="'3mm'" />
								</xsl:when>

                                <xsl:when test="count(ancestor::*[contains(@class, ' topic/ul ')]) = 2">
                                    <xsl:value-of select="'8mm'" />
                                </xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="'9mm'" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'topic/note ')][1]
                                        /ancestor::*[contains(@class, 'task/info ')][1]">
                            <xsl:value-of select="'3.5mm'" />
                        </xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'task/info ')][1]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

						<xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$depth = 2">
							<xsl:choose>
								<xsl:when test="ancestor::*[contains(@class, 'topic/note')]">
									<xsl:value-of select="'11mm'" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="'8mm'" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="ancestor::*[matches(@outputclass, 'roundbox')]">
							<xsl:value-of select="'6.1mm'" />
						</xsl:when>

						<xsl:when test="ancestor::*[contains(@class, 'topic/note')]">
							<xsl:value-of select="'3.5mm'" />
						</xsl:when>

						<xsl:when test="$depth = 1 and
										parent::*[parent::*[contains(@class, 'task/info ')]]">
							<xsl:variable name="cur1" select="parent::*[parent::*[contains(@class, 'task/info ')]]" />

							<xsl:choose>
								<xsl:when test="$cur1/preceding-sibling::*[1][contains(@class, 'topic/p ')]
												/*[last()][contains(@class, 'topic/image ')]">
									<xsl:value-of select="'3mm'" />
								</xsl:when>

								<xsl:when test="parent::*/parent::*[contains(@class, 'task/info ')]
												/preceding-sibling::*[1][contains(@class, 'task/cmd ')]">
									<xsl:value-of select="'3mm'" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="'9mm'" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:when test="$depth = 1 and
										parent::*/parent::*[contains(@class, 'task/info ')]
										/preceding-sibling::*[1][contains(@class, 'task/cmd ')] and
										count(ancestor::*[contains(@class, 'task/steps ')][1]/*) &gt; 1">
							<xsl:value-of select="'9mm'" />
						</xsl:when>

						<xsl:when test="$depth = 1">
							<xsl:value-of select="'3mm'" />
						</xsl:when>

						<xsl:otherwise>
							<xsl:value-of select="'0mm'" />
						</xsl:otherwise>
					</xsl:choose>
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
            <xsl:choose>
                <xsl:when test="*[contains(@class, 'topic/tm ')]">
                    <xsl:value-of select="'5mm'" />
                </xsl:when>
                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__label__content">
        <xsl:attribute name="padding-before">
            <xsl:choose>
                <xsl:when test="*[contains(@class, 'topic/tm ')]">
                    <xsl:value-of select="'0.5mm'" />
                </xsl:when>
                <xsl:otherwise>-0.4mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

		<xsl:attribute name="font-family">
			<xsl:choose>
				<xsl:when test="count(ancestor::*[contains(@class, ' topic/ul ')]) &gt; 1">
                    <xsl:value-of select="'Myriad Pro Light'" />
                </xsl:when>
			
				<xsl:otherwise>
					<xsl:value-of select="$base-font-family" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

        <xsl:attribute name="text-align">start</xsl:attribute>

		<xsl:attribute name="font-size">
			<xsl:value-of select="$default-font-size" />
		</xsl:attribute>
    </xsl:attribute-set>

	<!-- <xsl:attribute-set name="ul.li__content">
		<xsl:attribute name="axf:word-break">keep-all</xsl:attribute>
    </xsl:attribute-set> -->

    <xsl:attribute-set name="ul.li__body">
        <xsl:attribute name="start-indent">
        	<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' task/steps-unordered ')]">body-start()</xsl:when>
        		<xsl:when test="contains(@class, ' task/substep ')">0mm</xsl:when>
        		<xsl:otherwise>body-start()</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>



    <xsl:attribute-set name="ol.li.first">
        <xsl:attribute name="margin-left">2mm</xsl:attribute>
        <xsl:attribute name="space-after">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>1mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-before">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>3mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli.first">
        <xsl:attribute name="margin-left">2mm</xsl:attribute>
        <xsl:attribute name="space-after">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>4mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-before">
        	<xsl:choose>
        		<xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">0mm</xsl:when>
        		<xsl:otherwise>3mm</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:function name="functx:last-node" as="node()?" xmlns:functx="http://www.functx.com">
            <xsl:param name="nodes" as="node()*" />
            <xsl:sequence select="($nodes/.)[not(following-sibling::node())]" />
    </xsl:function>
</xsl:stylesheet>