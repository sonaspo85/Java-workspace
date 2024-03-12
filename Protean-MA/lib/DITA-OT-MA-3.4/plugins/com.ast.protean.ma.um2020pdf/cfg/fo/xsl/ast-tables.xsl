<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="opentopic-func xs dita2xslfo dita-ot"
  version="2.0">

   <xsl:variable name="table.frame-default" select="'topbot'"/>

    <xsl:template match="*[contains(@class, ' topic/table ')]">
        <xsl:variable name="scale" as="xs:string?">
            <xsl:call-template name="getTableScale"/>
        </xsl:variable>
        <fo:block-container xsl:use-attribute-sets="table__container">
			<xsl:if test="preceding-sibling::node()[2][self::processing-instruction('pagebreak')]">
				<xsl:attribute name="break-before">page</xsl:attribute>
			</xsl:if>
            <fo:block xsl:use-attribute-sets="table">
                <xsl:call-template name="commonattributes"/>
                <xsl:if test="not(@id)">
                  <xsl:attribute name="id">
                    <xsl:call-template name="get-id"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="exists($scale)">
                    <xsl:attribute name="font-size" select="concat($scale, '%')"/>
                </xsl:if>
                <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
                <xsl:apply-templates/>
                <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]">
        <fo:table-header xsl:use-attribute-sets="ast.tgroup.thead ast.thead.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tbody ')]">
        <fo:table-body xsl:use-attribute-sets="tgroup.tbody ast.tbody">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <xsl:apply-templates select="." mode="validate-entry-position"/>

        <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')][1]" />

        <fo:table-cell xsl:use-attribute-sets="ast.thead.padding">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>

            <fo:block xsl:use-attribute-sets="thead.row.entry__content">
                <xsl:choose>
                    <xsl:when test="$ancesTable[matches(@outputclass, 'table_icon')]">
                        <xsl:attribute name="padding">
                            <xsl:value-of select="'0mm 0mm 0mm 0mm'" />
                        </xsl:attribute>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:attribute name="padding-bottom" select="'0.5mm'" />
                    </xsl:otherwise>
                </xsl:choose>


                <xsl:apply-templates select="." mode="ancestor-start-flag"/>
                <xsl:call-template name="processEntryContent"/>
                <xsl:apply-templates select="." mode="ancestor-end-flag"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template name="applyAlignAttrs">
        <xsl:variable name="align" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@align">
                    <xsl:value-of select="@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/tbody ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/tbody ')][1]/@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/thead ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/thead ')][1]/@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/tgroup ')][1]/@align"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="valign" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@valign">
                    <xsl:value-of select="@valign"/>
                </xsl:when>
                <xsl:when test="parent::*[contains(@class, ' topic/row ')][@valign]">
                    <xsl:value-of select="parent::*[contains(@class, ' topic/row ')]/@valign"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(normalize-space($align) = '')">
                <xsl:attribute name="text-align">
                    <xsl:value-of select="$align"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="(normalize-space($align) = '') and contains(@class, ' topic/colspec ')"/>
            <xsl:otherwise>
                <xsl:attribute name="text-align">
                	<xsl:choose>
                		<xsl:when test="ancestor::*[contains(@class, ' topic/thead ')]">from-table-column()</xsl:when>

						<xsl:when test="ancestor::*[contains(@class, ' topic/tbody ')] and
                                        count(*) = 1 and
                                        *[contains(@class, ' topic/p ')]/*[contains(@class, ' topic/image ')][@align]">
                            <xsl:variable name="align" select="*[contains(@class, ' topic/p ')]/*[contains(@class, ' topic/image ')][1]/@align" />
							<xsl:value-of select="$align" />
                        </xsl:when>

                		<xsl:otherwise>from-table-column()</xsl:otherwise>
                	</xsl:choose>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$valign='top'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'before'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$valign='middle'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'center'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$valign='bottom'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'after'"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]">
        <fo:table-row xsl:use-attribute-sets="ast.tbody.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                <xsl:attribute name="break-before">page</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <xsl:variable name="ancesTable" select="ancestor::*[contains(@class, 'topic/table ')][1]" />
        <xsl:variable name="parRow" select="parent::*[contains(@class, 'topic/row ')]" />
        <xsl:variable name="entryCnt" select="count($parRow/*[contains(@class, ' topic/entry ')])" as="xs:integer" />

        <xsl:apply-templates select="." mode="validate-entry-position"/>

        <xsl:choose>
            <xsl:when test="ancestor::*[contains(@class, ' topic/table ')][1]/@rowheader = 'firstcol'
                            and @dita-ot:x = '1'">
                <fo:table-cell xsl:use-attribute-sets="tbody.row.entry__firstcol">
                    <xsl:apply-templates select="." mode="processTableEntry"/>
                </fo:table-cell>
            </xsl:when>

            <xsl:otherwise>
                <fo:table-cell xsl:use-attribute-sets="tbody.row.entry">
                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_button')]">
                        <xsl:attribute name="border-before-style">solid</xsl:attribute>
                        <xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
                        <xsl:attribute name="border-before-color">black</xsl:attribute>
                        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>

                        <xsl:attribute name="padding">
                            <xsl:if test="$entryCnt = 2">
                                <xsl:choose>
                                    <xsl:when test="*[1][contains(@class, 'topic/ul ')]">

                                        <xsl:choose>
                                            <xsl:when test="count(*[1][contains(@class, 'topic/ul ')]/*[contains(@class, 'topic/li ')]) = 1">
                                                <xsl:value-of select="'2mm 2mm 0mm 5mm'" />
                                            </xsl:when>

                                            <xsl:otherwise>1.9mm 2mm 1.8mm 5mm</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:value-of select="'1.9mm 2mm 1.8mm 2mm'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>

                            <xsl:if test="$entryCnt = 3">
                                <xsl:choose>
                                    <xsl:when test="count(*[1][contains(@class, 'topic/ul ')]/*[contains(@class, 'topic/li ')]) = 1">
                                        <xsl:value-of select="'0.5mm 2mm 0.5mm 5mm'" />
                                    </xsl:when>

                                    <xsl:when test="count(*[1][contains(@class, 'topic/ul ')]/*[contains(@class, 'topic/li ')]) &gt; 1">
                                        <xsl:value-of select="'2mm 2mm 1.7mm 5mm'" />
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:value-of select="'0.5mm 2mm 0.5mm 5mm'" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_key-features')]">
                        <xsl:attribute name="padding">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'3.6mm 0mm 3.5mm 0mm'" />

                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'3.6mm 0mm 3.5mm 0mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_appendix-standard')]">
                        <xsl:attribute name="border-before-style">solid</xsl:attribute>
                        <xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
                        <xsl:attribute name="border-before-color">black</xsl:attribute>
                        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
                        <xsl:attribute name="padding">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="'1.3mm 0mm 0.5mm 2mm'" />

                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'1.3mm 0mm 0.5mm 5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_text')]">
                        <xsl:attribute name="padding">
                            <xsl:value-of select="'0.5mm 5mm 1.3mm 3mm'" />
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_icon')]">
                        <xsl:attribute name="padding">

                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <!-- <xsl:value-of select="'0.6mm 2mm 0.1mm 2mm'" /> -->
                                    <xsl:value-of select="'0mm 2mm 0mm 2mm'" />
                                </xsl:when>

                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="'0.95mm 2mm 0.1mm 5mm'" /> -->
                                    <xsl:value-of select="'0.5mm 2mm 1mm 5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:if test="$ancesTable[matches(@outputclass, 'table_appendix-microusim')]">
                        <xsl:attribute name="padding">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:variable name="currNodeCnt" select="count(*)" as="xs:integer" />
                                    <xsl:variable name="two.ulNodeCnt" select="count(following-sibling::*[1][contains(@class, 'topic/entry ')]
                                                                               /*[contains(@class, 'topic/ul ')]/*[contains(@class, 'topic/li ')])" as="xs:integer" />

                                    <xsl:variable name="cur.length" select="string-length(.)" as="xs:integer" />
                                    <xsl:variable name="two.length" select="string-length(following-sibling::*[1][contains(@class, 'topic/entry ')]
                                                                            /*[contains(@class, 'topic/ul ')])" as="xs:integer" />

                                    <xsl:choose>
                                        <xsl:when test="$currNodeCnt &gt; $two.ulNodeCnt">
                                            <xsl:choose>
                                                <xsl:when test="$two.ulNodeCnt = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="$currNodeCnt &gt; 2">
                                                            <xsl:value-of select="'0mm 0mm 0mm 2mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>1.05mm 0mm 0mm 2mm</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:when test="$cur.length &lt; $two.length">
                                                    <xsl:choose>
                                                        <xsl:when test="$two.length &gt; 200">
                                                            <xsl:value-of select="'0.7mm 0mm 0mm 2mm'" />
                                                        </xsl:when>

                                                        <xsl:when test="$cur.length &gt; 90">
                                                            <xsl:value-of select="'0mm 0mm 0mm 2mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>0.7mm 0mm 0mm 2mm</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>



                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$currNodeCnt eq $two.ulNodeCnt">
                                            <xsl:choose>
                                                <xsl:when test="$two.ulNodeCnt = 1">
                                                    <xsl:value-of select="'0.75mm 0mm 0mm 2mm'" />
                                                </xsl:when>

                                                <xsl:when test="$cur.length &lt; $two.length">
                                                    <xsl:value-of select="'1.05mm 0mm 0mm 2mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$currNodeCnt &lt; $two.ulNodeCnt">
                                            <xsl:value-of select="'1.1mm 0mm 0.1mm 2mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="position() = 2">
                                    <xsl:variable name="currNodeCnt" select="count(*[contains(@class, 'topic/ul ')]/*[contains(@class, 'topic/li ')])" as="xs:integer" />
                                    <xsl:variable name="one.NodeCnt" select="count(preceding-sibling::*[1][contains(@class, 'topic/entry ')]/*)" as="xs:integer" />
                                    <xsl:variable name="cur.length" select="string-length(*[contains(@class, 'topic/ul ')])" as="xs:integer" />
                                    <xsl:variable name="one.length" select="string-length(preceding-sibling::*[1][contains(@class, 'topic/entry ')])" as="xs:integer" />

                                    <xsl:choose>
                                        <xsl:when test="$currNodeCnt &lt; $one.NodeCnt">
                                            <xsl:choose>
                                                <xsl:when test="$currNodeCnt = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="$one.NodeCnt &gt; 2">
                                                            <xsl:value-of select="'0mm 0mm 0mm 5mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>1.05mm 0mm 0mm 5mm</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:when test="$cur.length &gt; $one.length">

                                                    <xsl:choose>
                                                        <xsl:when test="$cur.length &gt; 200">
                                                            <xsl:value-of select="'0.7mm 0mm 0mm 5mm'" />
                                                        </xsl:when>

                                                        <xsl:when test="$one.length &gt; 90">
                                                            <xsl:value-of select="'0mm 0mm 0mm 5mm'" />
                                                        </xsl:when>

                                                        <xsl:otherwise>0.7mm 0mm 0mm 5mm</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>

                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$currNodeCnt eq $one.NodeCnt">
                                            <xsl:choose>
                                                <xsl:when test="$cur.length &gt; $one.length">
                                                    <xsl:value-of select="'0.75mm 0mm 0mm 5mm'" />
                                                </xsl:when>

                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>

                                        <xsl:when test="$currNodeCnt &gt; $one.NodeCnt">
                                            <xsl:value-of select="'1.1mm 0mm 0.1mm 5mm'" />
                                        </xsl:when>

                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="'0mm 0mm 0mm 5mm'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:apply-templates select="." mode="processTableEntry"/>
                </fo:table-cell>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="processTableEntry">
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="applySpansAttrs"/>
        <xsl:call-template name="applyAlignAttrs"/>

        <xsl:call-template name="generateTableEntryBorder">
            <xsl:with-param name="head_check" select="if (ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')]) then 'true' else 'false'"  />
		</xsl:call-template>

        <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
            <xsl:apply-templates select="." mode="ancestor-start-flag"/>
            <xsl:call-template name="processEntryContent"/>
            <xsl:apply-templates select="." mode="ancestor-end-flag"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="generateTableEntryBorder">
        <xsl:param name="head_check" />

        <xsl:variable name="colsep" as="xs:string">
            <xsl:call-template name="getTableColsep"/>
        </xsl:variable>
        <xsl:variable name="rowsep" as="xs:string">
            <xsl:call-template name="getTableRowsep"/>
        </xsl:variable>
        
        <!-- <xsl:variable name="frame" as="xs:string" select="if ($head_check = true()) then $table.frame-default else 'none'"/> -->
        <xsl:variable name="frame" as="xs:string">
            <xsl:choose>
                <xsl:when test="$head_check = 'true'">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>

                <xsl:when test="$head_check = 'false' and 
                                ancestor::*[contains(@class, ' topic/table ')][1][contains(@outputclass, 'table_appendix-standard')]">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>
                
				<xsl:when test="$head_check = 'false' and
                                ancestor::*[contains(@class, ' topic/table ')][1][contains(@outputclass, 'table_text_line')]">
                    <xsl:value-of select="'all'" />
                </xsl:when>

                <xsl:when test="$head_check = 'false' and
                                ancestor::*[contains(@class, ' topic/table ')][1][contains(@outputclass, 'table_text_tw_ncc')]">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="'none'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="needTopBorderOnBreak" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="$frame = ('all', 'topbot', 'top')">
                    <xsl:choose>
                        <xsl:when test="../parent::node()[contains(@class, ' topic/thead ')]">
                            <xsl:sequence select="true()"/>
                        </xsl:when>

                        <xsl:when test="(../parent::node()[contains(@class, ' topic/tbody ')]) and not(../preceding-sibling::*[contains(@class, ' topic/row ')])">
                            <xsl:sequence select="true()"/>
                        </xsl:when>

                        <xsl:when test="../parent::node()[contains(@class, ' topic/tbody ')]">
                            <xsl:variable name="entryNum" select="count(preceding-sibling::*[contains(@class, ' topic/entry ')]) + 1"/>
                            <xsl:variable name="prevEntryRowsep" as="xs:string?">
                                <xsl:for-each select="../preceding-sibling::*[contains(@class, ' topic/row ')][1]/*[contains(@class, ' topic/entry ')][$entryNum]">
                                    <xsl:call-template name="getTableRowsep"/>
                                </xsl:for-each>
                            </xsl:variable>

                            <xsl:choose>
                                <xsl:when test="$prevEntryRowsep != '0'">
                                    <xsl:sequence select="true()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="false()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:sequence select="false()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="(../parent::node()[contains(@class, ' topic/thead ')])">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'thead__tableframe__bottom'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

         <xsl:if test="$head_check = 'true' and 
                      ((../following-sibling::*[contains(@class, ' topic/row ')]) or (../parent::node()[contains(@class, ' topic/tbody ')] and 
                      ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/tfoot ')]))">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__bottom'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$head_check = 'false' and 
                      ancestor::*[contains(@class, ' topic/table ')][contains(@outputclass, 'table_appendix-standard')]">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__bottom'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="$head_check = 'false' and
            ancestor::*[contains(@class, ' topic/table ')][contains(@outputclass, 'table_text_line')]">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__all'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$head_check = 'false' and
                      ancestor::*[contains(@class, ' topic/table ')][contains(@outputclass, 'table_text_tw_ncc')]">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__bottom'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="$head_check = 'true' and $needTopBorderOnBreak">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__top'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if> 
        
        <xsl:if test="number($colsep) = 1 and following-sibling::*[contains(@class, ' topic/entry ')]">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__right'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="ancestor::*[contains(@class, ' topic/table ')][contains(@outputclass, 'table_text_tw_ncc')] and
                      following-sibling::*[contains(@class, ' topic/entry ')]">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__right'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="number($colsep) = 1 and not(following-sibling::*[contains(@class, ' topic/entry ')]) and
                      ((count(preceding-sibling::*) + 1) &lt; ancestor::*[contains(@class, ' topic/tgroup ')][1]/@cols)">
            <!-- <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__right'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template> -->
        </xsl:if>
    </xsl:template>

    <xsl:template name="displayAtts">
        <xsl:param name="element" as="element()"/>
        <xsl:param name="head_check" />
        
        <!-- <xsl:variable name="frame" as="xs:string" select="if ($head_check) then $table.frame-default else 'none'"/> -->
        <xsl:variable name="frame" as="xs:string">
            <xsl:choose>
                <xsl:when test="$head_check = 'false' and 
                                parent::*[matches(@outputclass, 'table_appendix-standard')]">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>
                
                <xsl:when test="$head_check = 'false' and
                    ancestor::*[contains(@class, ' topic/table ')][1][contains(@outputclass, 'table_text_line')]">
                    <xsl:value-of select="'all'" />
                </xsl:when>

                <xsl:when test="$head_check = 'false' and
                                parent::*[matches(@outputclass, 'table_text_tw_ncc')]">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>

                <xsl:when test="$head_check = 'true'">
                    <xsl:value-of select="$table.frame-default" />
                </xsl:when>

                
                <xsl:otherwise>
                    <xsl:value-of select="'none'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$element/@expanse">
          <xsl:for-each select="$element">
            <xsl:call-template name="setExpanse"/>
          </xsl:for-each>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$frame = 'all'">
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="'table__tableframe__all'"/>
                    <xsl:with-param name="path" select="$tableAttrs"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="$frame = 'topbot'">
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="'table__tableframe__topbot'"/>
                    <xsl:with-param name="path" select="$tableAttrs"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" name="tgroup">
        <xsl:if test="not(@cols)">
          <xsl:call-template name="output-message">
            <xsl:with-param name="id" select="'PDFX006E'"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:variable name="scale" as="xs:string?">
            <xsl:call-template name="getTableScale"/>
        </xsl:variable>

        <xsl:variable name="table" as="element()">
            <fo:table xsl:use-attribute-sets="table.tgroup">
                <xsl:call-template name="commonattributes"/>

                <xsl:call-template name="displayAtts">
                    <xsl:with-param name="element" select=".."/>
                    <xsl:with-param name="head_check" select="if (*[contains(@class, ' topic/thead ')]) then 'true' else 'false'" />
                </xsl:call-template>

                <xsl:apply-templates/>
            </fo:table>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="exists($scale)">
                <xsl:apply-templates select="$table" mode="setTableEntriesScale"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$table"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
