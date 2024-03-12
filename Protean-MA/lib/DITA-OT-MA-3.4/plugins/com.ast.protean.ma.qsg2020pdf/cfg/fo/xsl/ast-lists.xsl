<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:template match="*[contains(@class, ' topic/ul ')]/*[contains(@class, ' topic/li ')]">
        <xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ul ')])"/>
        <xsl:variable name="note.bullet" select="parent::*[contains(@class, 'topic/ul ')]/parent::*[contains(@class, 'topic/note ')]"/>
        <xsl:choose>
        	<xsl:when test="not(preceding-sibling::li)">
		        <fo:list-item xsl:use-attribute-sets="ul.li">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="ul.li__label">
		                <fo:block xsl:use-attribute-sets="ul.li__label__content">
							<xsl:choose>
								<xsl:when test="parent::*[contains(@outputclass, 'arrow')]">
									<fo:inline xsl:use-attribute-sets="special-char">
										<xsl:call-template name="getVariable">
											<xsl:with-param name="id" select="'arrow'" />
										</xsl:call-template>
									</fo:inline>
								</xsl:when>

								<xsl:when test="parent::*[contains(@outputclass, 'hyphen')]">
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="'Unordered List bullet 2'" />
									</xsl:call-template>
								</xsl:when>

								<xsl:when test="parent::*[contains(@outputclass, 'bullet')]">
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="'Unordered List bullet 1'" />
									</xsl:call-template>
								</xsl:when>

								<xsl:otherwise>
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="if ($note.bullet) then 'Unordered List bullet 1'
																		else concat('Unordered List bullet ', (($depth - 1) mod 4) + 1)"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="ul.li__body">
		                <fo:block xsl:use-attribute-sets="ul.li__content">
		                    <xsl:apply-templates select="node()" />
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
        	</xsl:when>
        	<xsl:otherwise>
		        <fo:list-item xsl:use-attribute-sets="ul.li">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="ul.li__label">
		                <fo:block xsl:use-attribute-sets="ul.li__label__content">
							<xsl:choose>
								<xsl:when test="parent::*[contains(@outputclass, 'arrow')]">
									<fo:inline xsl:use-attribute-sets="special-char">
										<xsl:call-template name="getVariable">
											<xsl:with-param name="id" select="'arrow'" />
										</xsl:call-template>
									</fo:inline>
								</xsl:when>

								<xsl:when test="parent::*[contains(@outputclass, 'hyphen')]">
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="'Unordered List bullet 2'" />
									</xsl:call-template>
								</xsl:when>

								<xsl:when test="parent::*[contains(@outputclass, 'bullet')]">
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="'Unordered List bullet 1'" />
									</xsl:call-template>
								</xsl:when>

								<xsl:otherwise>
									<xsl:call-template name="getVariable">
										<xsl:with-param name="id" select="if ($note.bullet) then 'Unordered List bullet 1'
																		else concat('Unordered List bullet ', (($depth - 1) mod 4) + 1)"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
		                </fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="ul.li__body">
		                <fo:block xsl:use-attribute-sets="ul.li__content">
		                    <xsl:apply-templates select="node()" />
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]/*[contains(@class, ' topic/li ')]">
        <xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ol ')])"/>
        <xsl:variable name="format">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="concat('Ordered List Format ', $depth)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
        	<xsl:when test="not(preceding-sibling::li)">
		        <fo:list-item xsl:use-attribute-sets="ol.li.first">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[2][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
						<fo:block xsl:use-attribute-sets="ol.li__label__content">
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="concat('Ordered List Number ', $depth)"/>
								<xsl:with-param name="params" as="element()*">
								   <number>
									   <xsl:number format="{$format}"/>
								   </number>
								</xsl:with-param>
							</xsl:call-template>
						</fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
		                <fo:block xsl:use-attribute-sets="ol.li__content">
		                    <xsl:apply-templates select="node()" />
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
        	</xsl:when>
        	<xsl:otherwise>
		        <fo:list-item xsl:use-attribute-sets="ol.li">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[2][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
		                <fo:block xsl:use-attribute-sets="ol.li__label__content">
		                    <xsl:call-template name="getVariable">
		                        <xsl:with-param name="id" select="concat('Ordered List Number ', $depth)"/>
		                        <xsl:with-param name="params" as="element()*">
		                           <number>
		                               <xsl:number format="{$format}"/>
		                           </number>
		                        </xsl:with-param>
		                    </xsl:call-template>
		                </fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
		                <fo:block xsl:use-attribute-sets="ol.li__content">
		                    <xsl:apply-templates select="node()" />
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sl ')]/*[contains(@class, ' topic/sli ')]">
    	<xsl:choose>
    		<xsl:when test="not(preceding-sibling::sli)">
		        <fo:list-item xsl:use-attribute-sets="sl.sli.first">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[2][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="sl.sli__label">
		                <fo:block xsl:use-attribute-sets="sl.sli__label__content">
		                </fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="sl.sli__body">
		                <fo:block xsl:use-attribute-sets="sl.sli__content">
		                    <xsl:apply-templates/>
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
    		</xsl:when>
    		<xsl:otherwise>
		        <fo:list-item xsl:use-attribute-sets="sl.sli">
		            <xsl:call-template name="commonattributes"/>
        			<xsl:if test="preceding-sibling::node()[2][self::processing-instruction('pagebreak')]">
        				<xsl:attribute name="break-before">page</xsl:attribute>
        			</xsl:if>
		            <fo:list-item-label xsl:use-attribute-sets="sl.sli__label">
		                <fo:block xsl:use-attribute-sets="sl.sli__label__content">
		                </fo:block>
		            </fo:list-item-label>
		            <fo:list-item-body xsl:use-attribute-sets="sl.sli__body">
		                <fo:block xsl:use-attribute-sets="sl.sli__content">
		                    <xsl:apply-templates/>
		                </fo:block>
		            </fo:list-item-body>
		        </fo:list-item>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ul">
			<xsl:choose>
				<xsl:when test="preceding-sibling::node()[1][self::processing-instruction('pagebreak')]">
					<xsl:attribute name="margin-top">
						<xsl:value-of select="'3mm'" />
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>

            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ol">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sl ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
		<xsl:if test="node()[2][self::processing-instruction('pagebreak')]">
			<fo:block break-before="page"/>
		</xsl:if>
        <fo:list-block xsl:use-attribute-sets="sl">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

</xsl:stylesheet>