<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="xs dita-ot ot-placeholder">

	<!--<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>-->
	<!--<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>-->
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="cmd li p title" />
	<xsl:variable name="msgprefix" select="'PDFX'"/>
	<xsl:variable name="separator" select="'_Connect_42_'"/>

	<xsl:variable name="originalMap" as="element()"
    select="/dita-merge/*[contains(@class,' map/map ')][1]"/>

	<xsl:key name="topic" match="dita-merge/*[contains(@class,' topic/topic ')]|dita-merge/dita/*" use="concat('#',@id)"/>
	<xsl:key name="topicref" match="//*[contains(@class,' map/topicref ')]" use="generate-id()"/>

	<xsl:template match="@* | node()">
		<xsl:copy>
		    <!--<xsl:if test="matches(@base, '^extraTR:')">
		        <xsl:attribute name="extraTR" select="replace(@base, 'extraTR:', '')" />
		    </xsl:if>-->
		    <xsl:apply-templates select="@*, node()" />
		</xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[name()='base']">
        <xsl:choose>
            <xsl:when test="matches(., '^extraTR:')">
                <xsl:attribute name="extraTR" select="replace(., 'extraTR:', '')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="base" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="*[contains(@class,' sw-d/cmdname ')]">
		<xsl:copy>
			<xsl:attribute name="rev">
				<xsl:value-of select="normalize-space(.)" />
			</xsl:attribute>
			<xsl:attribute name="order">
				<xsl:value-of select="count(preceding-sibling::*[contains(@class,' sw-d/cmdname ')]) + 1" />
			</xsl:attribute>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="ditaValPath1">@projectName@</xsl:variable>

	<xsl:variable name="ditaValPath2">
		<xsl:if test="$ditaValPath1 != 'none'">
			<xsl:value-of select="concat('file:////', replace($ditaValPath1, '\\', '/'))"/>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="ValPath" select="document($ditaValPath2)/val/prop" />
	<xsl:variable name="ValPath1">
		<xsl:if test="$ValPath">
			<xsl:for-each select="$ValPath[matches(@action, 'include')]/@val">
				<str0>
					<xsl:value-of select="."/>
				</str0>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>

	<xsl:template match="processing-instruction('pagebreak')">
		<xsl:choose>
			<xsl:when test="$ditaValPath1 != 'none'">
				<xsl:variable name="curVal">
					<xsl:for-each select="tokenize(substring-before(substring-after(., 'audience=&quot;'), '&quot;'), ' ')">
						<Pbreak>
							<xsl:value-of select="."/>
						</Pbreak>
					</xsl:for-each>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="empty($curVal/Pbreak)">
						<xsl:processing-instruction name="pagebreak"/>
					</xsl:when>

					<xsl:when test="$ValPath1/str0 = $curVal/Pbreak">
						<xsl:processing-instruction name="pagebreak">
		        			<xsl:value-of select="."/>
		        		</xsl:processing-instruction>
					</xsl:when>

					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<xsl:otherwise>
				<xsl:processing-instruction name="pagebreak">
					<xsl:value-of select="."/>
				</xsl:processing-instruction>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
    
    
    
    <xsl:template match="text()" priority="5">
        <xsl:value-of select="replace(replace(., '(&#x9;)+', ''), '(&#xa;)+', '')"/>
    </xsl:template>

</xsl:stylesheet>