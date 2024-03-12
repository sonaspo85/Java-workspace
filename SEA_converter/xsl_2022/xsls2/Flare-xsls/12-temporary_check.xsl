<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
	version="2.0">

	<xsl:variable name="class" select="document(concat(ast:getName(base-uri(.), '/'), '/../xsl_2022/xsls2/Flare-xsls/', 'defined-class.xml'))" />
	<xsl:variable name="class-regex" select="string-join($class/def/class, '|')" />

	<xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
	<xsl:strip-space elements="*" />


    <xsl:template match="link">
    	<xsl:copy>
	     	<xsl:attribute name="href">xsls\review.css</xsl:attribute>
    		<xsl:apply-templates select="@rel" />
    		<xsl:apply-templates select="@type" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p">
		<xsl:choose>
			<xsl:when test="count(node())=1 and img">
				<xsl:apply-templates select="img" />
            </xsl:when>
			
			<xsl:when test="count(*)=0 and .='&#xA0;'">
			</xsl:when>

			<xsl:when test="matches(@class, 'Heading2')">
				<h2>
					<xsl:apply-templates select="@*, node()" />
                </h2>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:for-each select="node()">
						<xsl:choose>
							<xsl:when test="self::* and following-sibling::node()[1][self::*]">
								<xsl:copy>
									<xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
								<xsl:text>&#x20;</xsl:text>
                        	</xsl:when>

							<xsl:otherwise>
								<xsl:copy>
									<xsl:apply-templates select="@*, node()" />
								</xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

    <xsl:template match="p[parent::li][not(@class)][not(preceding-sibling::p[@class='Step-Body'])]" priority="15">
      <xsl:copy>
		<xsl:apply-templates select="@* | node()" />
      </xsl:copy>
    </xsl:template>

	<xsl:template match="@divclass[.='KeepTogether']">
	</xsl:template>

	<xsl:template match="div[count(@*) = 0]">
    	<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="div[starts-with(lower-case(@class), 'keep')]">
    	<xsl:apply-templates />
	</xsl:template>

    <xsl:template match="@class">
    	<xsl:choose>
    		<xsl:when test="lower-case(.)='step-intro'">
				<xsl:attribute name="class">
					<xsl:value-of select="lower-case(.)" />
				</xsl:attribute>
    		</xsl:when>
			
    		<xsl:when test="lower-case(.)='subsection'">
				<xsl:attribute name="class">
					<xsl:value-of select="lower-case(.)" />
				</xsl:attribute>
    		</xsl:when>
			
    		<xsl:when test="lower-case(.)='screenshot' or lower-case(.)='hardware'">
				<xsl:attribute name="class">block</xsl:attribute>
    		</xsl:when>
			
			<xsl:when test="starts-with(lower-case(.), 'step')">
				<xsl:if test="matches(lower-case(.), 'step-body')">
					<xsl:attribute name="class">step-body</xsl:attribute>
                </xsl:if>
			</xsl:when>
			
    		<xsl:when test="starts-with(lower-case(.), 'bullet')" />
    		<xsl:when test="starts-with(lower-case(.), 'navigationh2spacing')" />
    		<xsl:when test="starts-with(lower-case(.), 'columnbreakbefore')" />
    		<xsl:when test="starts-with(lower-case(.), 'sub')" />
    		<xsl:when test="starts-with(lower-case(.), 'keep')" />
    		<xsl:when test="starts-with(lower-case(.), 'carrier')" />
   		 <xsl:when test="ends-with(lower-case(.), 'instructions')" />
    		<xsl:when test="lower-case(.)='linebreak' or lower-case(.)='icon' or lower-case(.)='cb'" />
			
    		<xsl:otherwise>
				<xsl:attribute name="class">
					<xsl:value-of select="lower-case(.)" />
				</xsl:attribute>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

    <xsl:template match="@* | node()">
    	<xsl:copy>
    		<xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="b[preceding-sibling::node()[1][self::*]]">
    	<xsl:copy>
    		<xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sup | span">
    	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="img">
    	<xsl:choose>
    		<xsl:when test="@class='block'">
		    	<xsl:copy>
		    		<xsl:apply-templates select="@*" />
		        </xsl:copy>
    		</xsl:when>
			
    		<xsl:when test="not(@class) or matches(lower-case(@class), $class-regex)">
		    	<xsl:copy>
		    		<xsl:apply-templates select="@*" />
		        </xsl:copy>
    		</xsl:when>
			
    		<xsl:otherwise>
		    	<xsl:copy>
		    		<xsl:apply-templates select="@* except @class" />
					<xsl:attribute name="class">block</xsl:attribute>
					<xsl:apply-templates select="node()" />
		        </xsl:copy>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

    <xsl:template match="text()" priority="10">
    	<xsl:choose>
    	    <xsl:when test=".= ' ' and preceding-sibling::*[1][name()='b'] and following-sibling::*[1][name()='span'][.='.']">
    		</xsl:when>
			
    		<xsl:when test="(parent::p or parent::li or parent::td) and not(preceding-sibling::node())">
    			<xsl:value-of select="replace(., '^\s+', '')" />
				<xsl:if test="matches(., '(.+)([^\s+&#xA0;])$') and following-sibling::*[1][name()='img']">
					<xsl:text>&#x20;</xsl:text>
                </xsl:if>
    		</xsl:when>
			
    		<xsl:when test="(parent::p or parent::li or parent::td) and not(following-sibling::node())">
    			<xsl:value-of select="replace(., '\s+$', '')" />
    		</xsl:when>
			
			<xsl:when test="matches(., '(.+)([^\s+&#xA0;])$') and parent::*[matches(name(), '(p|li)')] and 
					  		following-sibling::*[1][name()='img']">
				<xsl:value-of select="." />
				<xsl:text>&#x20;</xsl:text>
			</xsl:when>
			
    		<xsl:otherwise>
    			<xsl:value-of select="." />
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>

	<xsl:function name="ast:getName">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
	</xsl:function>

</xsl:stylesheet>