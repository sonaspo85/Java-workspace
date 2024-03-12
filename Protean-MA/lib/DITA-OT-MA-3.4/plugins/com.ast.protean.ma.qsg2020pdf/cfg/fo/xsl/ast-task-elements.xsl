<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="opentopic opentopic-index dita2xslfo xs"
    version="2.0">

    <xsl:template match="*[contains(@class, ' task/taskbody ')]">
        <fo:block xsl:use-attribute-sets="taskbody">
            <xsl:if test="matches(@outputclass, 'pagebreak')">
                <xsl:attribute name="page-break-before">always</xsl:attribute>
            </xsl:if>

            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/cmd ')]" priority="1">
        <fo:block xsl:use-attribute-sets="cmd">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="../@importance='optional'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Optional Step'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="../@importance='required'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Required Step'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/steps ')]/*[contains(@class, ' task/step ')]">
        <xsl:variable name="format">
			<xsl:call-template name="getVariable">
				<xsl:with-param name="id" select="'Step Format'"/>
			</xsl:call-template>
        </xsl:variable>
        <fo:list-item xsl:use-attribute-sets="steps.step">
            <xsl:call-template name="commonattributes"/>
            <!-- <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]"> -->
            <xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')] or 
                          contains(@outputclass, 'pagebreak')">
				<xsl:attribute name="break-before">page</xsl:attribute>
                <xsl:attribute name="margin-top">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[contains(@class, 'topic/body')][1]
                                        /preceding-sibling::*[1][contains(@class, 'topic/abstract ')]
                                        /*[last()][contains(@class, ' topic/p ')]
                                        /*[last()][contains(@class, ' topic/image ')][@placement='break']">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'topic/body')][1]
                                      /preceding-sibling::*[1][contains(@class, 'topic/abstract ')]
                                      /*[last()][contains(@class, ' topic/p ')]">

                            <xsl:choose>
                                <xsl:when test="*[1]/*[@placement='inline']">
                                    <xsl:value-of select="'5mm'" />
                                </xsl:when>

                                <xsl:otherwise>3mm</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'topic/body')][1]
                                      /preceding-sibling::*[1][contains(@class, 'topic/title ')]">
                            <xsl:value-of select="'3mm'" />
                        </xsl:when>

                    </xsl:choose>
                </xsl:attribute>
			</xsl:if>

            <fo:list-item-label xsl:use-attribute-sets="steps.step__label">
                <fo:block xsl:use-attribute-sets="ast.step.number">
                    <xsl:if test="preceding-sibling::*[contains(@class, ' task/step ')] | following-sibling::*[contains(@class, ' task/step ')]">
	                    <xsl:call-template name="getVariable">
	                        <xsl:with-param name="id" select="'Step Number'"/>
	                        <xsl:with-param name="params" as="element()*">
	                           	<number>
                            		<xsl:number format="{$format}" count="*[contains(@class, ' task/step ')]"/>
                            	</number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="steps.step__body">
                <xsl:apply-templates select="node()" />
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

	<xsl:template match="*[contains(@class, ' task/steps ')]" name="steps">
		<xsl:apply-templates select="." mode="dita2xslfo:task-heading">
			<xsl:with-param name="use-label">
				<xsl:apply-templates select="." mode="dita2xslfo:retrieve-task-heading">
					<xsl:with-param name="pdf2-string">Task Steps</xsl:with-param>
					<xsl:with-param name="common-string">task_procedure</xsl:with-param>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:choose>
			<xsl:when test="count(*[contains(@class, ' task/step ')]) eq 1">
				<fo:block>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates mode="onestep"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:list-block xsl:use-attribute-sets="steps">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</fo:list-block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <xsl:template match="*[contains(@class, ' task/result ')]">
		<xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
			<fo:block break-before="page"/>
		</xsl:if>
        <fo:block xsl:use-attribute-sets="result">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="dita2xslfo:task-heading">
                <xsl:with-param name="use-label">
                    <xsl:apply-templates select="." mode="dita2xslfo:retrieve-task-heading">
                        <xsl:with-param name="pdf2-string">Task Result</xsl:with-param>
                        <xsl:with-param name="common-string">task_results</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:apply-templates>
            <fo:block xsl:use-attribute-sets="result__content">
              <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/info ')]">
		<xsl:choose>
			<xsl:when test="preceding-sibling::*[1][contains(@class, ' task/cmd ')] and
							not(*[contains(@class, ' topic/note ')])">
				<fo:block xsl:use-attribute-sets="info.indent">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="info">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

    <!--Substeps-->
<!--     <xsl:template match="*[contains(@class, ' task/substeps ')][empty(*[contains(@class,' task/substep ')])]" priority="10"/>

    <xsl:template match="*[contains(@class, ' task/substeps ')]">
        <fo:list-block xsl:use-attribute-sets="substeps">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/steps-unordered ')]/*[contains(@class, ' task/step ')]">
        <fo:list-item xsl:use-attribute-sets="steps-unordered.step">
            <xsl:call-template name="commonattributes"/>
            <fo:list-item-label xsl:use-attribute-sets="steps-unordered.step__label">
                <fo:block xsl:use-attribute-sets="steps-unordered.step__label__content">
                </fo:block>
            </fo:list-item-label>

            <fo:list-item-body xsl:use-attribute-sets="steps-unordered.step__body">
                <fo:block xsl:use-attribute-sets="steps-unordered.step__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>

        </fo:list-item>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/substeps ')]/*[contains(@class, ' task/substep ')]">
        <xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>
        <xsl:variable name="format">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Substep Format'"/>
          </xsl:call-template>
        </xsl:variable>
        <fo:list-item xsl:use-attribute-sets="substeps.substep">
            <xsl:call-template name="commonattributes"/>
            <fo:list-item-label xsl:use-attribute-sets="substeps.substep__label">
                <fo:block xsl:use-attribute-sets="ul.li__label__content">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Unordered List bullet'"/>
                    </xsl:call-template>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="substeps.substep__body">
                <fo:block xsl:use-attribute-sets="substeps.substep__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>-->
</xsl:stylesheet>
