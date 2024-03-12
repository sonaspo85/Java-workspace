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
        <fo:table-body xsl:use-attribute-sets="tgroup.tbody ast.tbody.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <xsl:apply-templates select="." mode="validate-entry-position"/>
        <fo:table-cell xsl:use-attribute-sets="ast.thead.padding">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>

            <fo:block xsl:use-attribute-sets="thead.row.entry__content">
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
                            <xsl:variable name="align" select="*[contains(@class, ' topic/p ')]/*[contains(@class, ' topic/image ')]/@align" />
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
        <fo:table-row xsl:use-attribute-sets="tbody.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
                <xsl:attribute name="break-before">page</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
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
			<xsl:with-param name="head_check" select="ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/thead ')]" />
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
        
        <xsl:variable name="frame" as="xs:string" select="if ($head_check) then $table.frame-default else 'none'"/>

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

        <xsl:if test="$head_check and ((../following-sibling::*[contains(@class, ' topic/row ')]) or (../parent::node()[contains(@class, ' topic/tbody ')] and ancestor::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/tfoot ')]))">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__bottom'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$head_check and $needTopBorderOnBreak">
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

        <xsl:if test="number($colsep) = 1 and not(following-sibling::*[contains(@class, ' topic/entry ')]) and ((count(preceding-sibling::*) + 1) &lt; ancestor::*[contains(@class, ' topic/tgroup ')][1]/@cols)">
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="'__tableframe__right'"/>
                <xsl:with-param name="path" select="$tableAttrs"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="displayAtts">
        <xsl:param name="element" as="element()"/>
        <xsl:param name="head_check" />
        
        <xsl:variable name="frame" as="xs:string" select="if ($head_check) then $table.frame-default else 'none'"/>

        <xsl:if test="$element/@expanse">
          <xsl:for-each select="$element">
            <xsl:call-template name="setExpanse"/>
          </xsl:for-each>
        </xsl:if>

        <xsl:choose>
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
                    <xsl:with-param name="head_check" select="*[contains(@class, ' topic/thead ')]" />
                </xsl:call-template>

                <xsl:if test="(parent::*/@pgwide) = '1' or
                              parent::*[not(@pgwide)]">
                    <xsl:attribute name="start-indent">0</xsl:attribute>
                    <xsl:attribute name="end-indent">0</xsl:attribute>
                    <xsl:attribute name="width">auto</xsl:attribute>
                </xsl:if>

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
