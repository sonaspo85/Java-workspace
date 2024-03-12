<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
				xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                version="2.0"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg ditaarch">


	<xsl:preserve-space elements="*"/>

	<xsl:template name="chapter-setup">
		<xsl:call-template name="chapterBody"/>
	</xsl:template>

	<xsl:template match="*" mode="chapterBody">
		<xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="child.topic" name="child.topic">
		<xsl:param name="nestlevel" as="xs:integer">
			<xsl:choose>
				<xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 9">9</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="ancestor-or-self::*/title[starts-with(@outputclass, 'Heading3')]">
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
				<xsl:apply-templates/>
				<xsl:call-template name="gen-endnotes"/>
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
			</xsl:when>
			<xsl:otherwise>
				<article class="nested{$nestlevel}">
					<xsl:if test="@props">
						<xsl:attribute name="props" select="@props"/>
					</xsl:if>
					
					<xsl:call-template name="gen-topic">
						<xsl:with-param name="nestlevel" select="$nestlevel"/>
					</xsl:call-template>
				</article>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="processing-instruction('ast')"/>

	<xsl:template match="*" mode="addContentToHtmlBodyElement">
		<html>
			<head>
				<xsl:for-each select="/dita/processing-instruction('ast')">
					<xsl:choose>
					    <xsl:when test="matches(substring-before(., '='), 'userManual')">
					    	<xsl:variable name="beforeName" select="substring-before(., '=')" />
					    	<xsl:variable name="title">
	                        	<xsl:choose>
	                        	    <xsl:when test="$beforeName = 'userManual_sub'">
	                        	    	<xsl:value-of select="substring-after(., '=')" />
	                        	    </xsl:when>

	                        	    <xsl:otherwise>
	                        	    	<xsl:call-template name="getVariable">
			                            	<xsl:with-param name="id" select="'frontmatter-title'" />
			                        	</xsl:call-template>
	                        	    </xsl:otherwise>
	                        	</xsl:choose>
	                        </xsl:variable>

	                        <meta name="{substring-before(., '=')}" content="{$title}"/>
					    </xsl:when>

					    <xsl:when test="matches(substring-before(., '='), 'language')">
					    	<xsl:variable name="title">
	                        	<xsl:call-template name="getVariable">
	                            	<xsl:with-param name="id" select="'frontmatter-language'" />
	                        	</xsl:call-template>
	                        </xsl:variable>

	                        <meta name="{substring-before(., '=')}" content="{$title}"/>
					    </xsl:when>

					    <xsl:otherwise>
					    	<meta name="{substring-before(., '=')}" content="{substring-after(., '=')}"/>
					    </xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<link rel="stylesheet" type="text/css" href="preview.css"/>
			</head>
			<body>
				<main xsl:use-attribute-sets="main">
					<article xsl:use-attribute-sets="article">
						<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
						<xsl:apply-templates/>
						<xsl:call-template name="gen-endnotes"/>
						<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
					</article>
				</main>
			</body>
		</html>
	</xsl:template>

	<!-- paragraphs -->
	<xsl:template match="*[contains(@class, ' topic/p ')]" name="topic.p">
		<!-- To ensure XHTML validity, need to determine whether the DITA kids are block elements.
		If so, use div_class="p" instead of p -->
		<xsl:choose>
			<xsl:when test="descendant::*[dita-ot:is-block(.)]">
				<xsl:choose>
					<xsl:when test="count(*) = 1 and image[@placement='break']">
						<xsl:apply-templates/>
					</xsl:when>
					<xsl:otherwise>
						<div class="p">
							<xsl:call-template name="commonattributes"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="count(node()) = 1 and image[@placement='inline']">
				<div class="image">
					<xsl:apply-templates />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

 	<xsl:template match="*[contains(@class, ' topic/image ')]" name="topic.image">
		<xsl:choose>
			<xsl:when test="parent::*[contains(@class, ' topic/fig ')][contains(@frame, 'top ')]"/>
			<xsl:when test="@placement = 'break'"/>
		</xsl:choose>

    	<xsl:call-template name="setaname"/>
		
		<xsl:choose>
			<xsl:when test="@placement = 'break'">
				<xsl:choose>
					<xsl:when test="@align = 'left'">
						<div>
							<xsl:attribute name="class" select="if (parent::p/@outputclass) then parent::p/@outputclass else 'infoimg'"/>
							<xsl:call-template name="topic-image"/>
						</div>
					</xsl:when>
					<xsl:when test="@align = 'right'">
						<div>
							<xsl:attribute name="class" select="if ( parent::p/@outputclass ) then parent::p/@outputclass else 'image'"/>
							<xsl:call-template name="topic-image"/>
						</div>
					</xsl:when>
					<xsl:when test="@align = 'center'">
						<div>
							<xsl:attribute name="class" select="if ( parent::p/@outputclass ) then parent::p/@outputclass else 'image'"/>
							<xsl:call-template name="topic-image"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="topic-image"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="topic-image"/>
			</xsl:otherwise>
		</xsl:choose>
	    <xsl:if test="not(@placement = 'inline')"></xsl:if>
	    <xsl:if test="$ARTLBL = 'yes'"> [<xsl:value-of select="@href"/>] </xsl:if>
	</xsl:template>


 	<xsl:template name="topic-image">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
		<img>
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class">
					<xsl:if test="@placement = 'break'"><!--Align only works for break-->
						<xsl:choose>
							<xsl:when test="@align = 'left'">imageleft</xsl:when>
							<xsl:when test="@align = 'right'">imageright</xsl:when>
							<xsl:when test="@align = 'center'">imagecenter</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="setid"/>
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/longdescref ')]">
					<xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@longdescref"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@href|@height|@width"/>
			<xsl:apply-templates select="@scale"/>
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/alt ')]">
					<xsl:variable name="alt-content"><xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/></xsl:variable>
					<xsl:attribute name="alt" select="normalize-space($alt-content)"/>
				</xsl:when>
				<xsl:when test="@alt">
					<xsl:attribute name="alt" select="@alt"/>
				</xsl:when>
			</xsl:choose>
		</img>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
	</xsl:template>


	<xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
		<xsl:param name="headinglevel" as="xs:integer">
			<xsl:choose>
				<xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 6">6</xsl:when>
				<xsl:when test="matches(@outputclass, 'Heading3')">
					<xsl:value-of select="'3'" />
				</xsl:when>
				<xsl:when test="matches(@outputclass, 'Heading4')">
					<xsl:value-of select="'4'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')]) - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$headinglevel = 0">
				<xsl:attribute name="chapterTitle">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="h{$headinglevel}">
					<xsl:attribute name="class">topictitle<xsl:value-of select="$headinglevel"/></xsl:attribute>
					<xsl:call-template name="commonattributes">
						<xsl:with-param name="default-output-class">topictitle<xsl:value-of select="$headinglevel"/></xsl:with-param>
					</xsl:call-template>
					<xsl:if test="parent::*/@id">
						<xsl:attribute name="id">
							<xsl:value-of select="parent::*/@id"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- process the TM tag -->
	<!-- removed priority 1 : should not be needed -->
	<xsl:template match="*[contains(@class, ' topic/tm ')]" name="topic.tm">
		<xsl:param name="root" select="root()" as="document-node()" tunnel="yes"/>

		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
		<xsl:apply-templates/> <!-- output the TM content -->

		<!-- Test for TM area's language -->
		<xsl:variable name="tmtest">
			<xsl:apply-templates select="." mode="mark-tm-in-this-area"/>
		</xsl:variable>

		<!-- If this language should get trademark markers, continue... -->
		<xsl:if test="$tmtest = 'tm'">
			<xsl:variable name="tmvalue" select="@trademark"/>

			<!-- Determine if this is in a title, and should be marked -->
			<!-- TODO: should return boolean -->
			<xsl:variable name="usetitle">
				<xsl:if test="ancestor::*[contains(@class, ' topic/title ')]/parent::*[contains(@class, ' topic/topic ')]">
					<xsl:choose>
						<!-- Not the first one in a title -->
						<xsl:when test="generate-id(.) != generate-id($root/key('tm', .)[1])">skip</xsl:when>
						<!-- First one in the topic, BUT it appears in a shortdesc or body -->
						<xsl:when test="//*[contains(@class, ' topic/shortdesc ') or contains(@class, ' topic/body ')]//*[contains(@class, ' topic/tm ')][@trademark = $tmvalue]">skip</xsl:when>
						<xsl:otherwise>use</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>

			<!-- Determine if this is in a body, and should be marked -->
			<!-- TODO: should return boolean -->
			<xsl:variable name="usebody">
				<xsl:choose>
					<!-- If in a title or prolog, skip -->
					<xsl:when test="ancestor::*[contains(@class, ' topic/title ') or contains(@class, ' topic/prolog ')]/parent::*[contains(@class, ' topic/topic ')]">skip</xsl:when>
					<!-- If first in the document, use it -->
					<xsl:when test="generate-id(.) = generate-id($root/key('tm', .)[1])">use</xsl:when>
					<!-- If there is another before this that is in the body or shortdesc, skip -->
					<xsl:when test="preceding::*[contains(@class, ' topic/tm ')][@trademark = $tmvalue][ancestor::*[contains(@class, ' topic/body ') or contains(@class, ' topic/shortdesc ')]]">skip</xsl:when>
					<!-- Otherwise, any before this must be in a title or ignored section -->
					<xsl:otherwise>use</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- If it should be used in a title or used in the body, output your favorite TM marker based on the attributes -->
			<xsl:if test="$usetitle = 'use' or $usebody = 'use'">
				<xsl:choose>  <!-- ignore @tmtype=service or anything else -->
					<xsl:when test="@tmtype = 'tm'"><sup>&#x2122;</sup></xsl:when>
					<xsl:when test="@tmtype = 'reg'"><sup>&#174;</sup></xsl:when>
					<xsl:when test="@tmtype = 'service'">&#8480;</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note">
	    <xsl:call-template name="spec-title"/>
	    <xsl:choose>
	      <xsl:when test="@type = 'note'">
	        <xsl:apply-templates select="." mode="process.note"/>
	      </xsl:when>
	      <xsl:when test="@type = 'tip'">
	        <xsl:apply-templates select="." mode="process.note.tip"/>
	      </xsl:when>
	      <xsl:when test="@type = 'fastpath'">
	        <xsl:apply-templates select="." mode="process.note.fastpath"/>
	      </xsl:when>
	      <xsl:when test="@type = 'important'">
	        <xsl:apply-templates select="." mode="process.note.important"/>
	      </xsl:when>
	      <xsl:when test="@type = 'remember'">
	        <xsl:apply-templates select="." mode="process.note.remember"/>
	      </xsl:when>
	      <xsl:when test="@type = 'restriction'">
	        <xsl:apply-templates select="." mode="process.note.restriction"/>
	      </xsl:when>
	      <xsl:when test="@type = 'attention'">
	        <xsl:apply-templates select="." mode="process.note.attention"/>
	      </xsl:when>
	      <xsl:when test="@type = 'caution'">
	        <xsl:apply-templates select="." mode="process.note.caution"/>
	      </xsl:when>
	      <xsl:when test="@type = 'danger'">
	        <xsl:apply-templates select="." mode="process.note.danger"/>
	      </xsl:when>
	      <xsl:when test="@type = 'warning'">
	        <xsl:apply-templates select="." mode="process.note.warning"/>
	      </xsl:when>
	      <xsl:when test="@type = 'trouble'">
	        <xsl:apply-templates select="." mode="process.note.trouble"/>
	      </xsl:when>
	      <xsl:when test="@type = 'other'">
	        <xsl:apply-templates select="." mode="process.note.other"/>
	      </xsl:when>
	      <xsl:when test="@type = 'service'">
	        <xsl:apply-templates select="." mode="process.note.service"/>
	      </xsl:when>
	      <xsl:when test="@type = 'recycle'">
	        <xsl:apply-templates select="." mode="process.note.recycle"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:apply-templates select="." mode="process.note"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:template>

	  <xsl:template match="*" mode="process.note.service">
	    <xsl:apply-templates select="." mode="process.note.common-processing"/>
	  </xsl:template>

	  <xsl:template match="*" mode="process.note.recycle">
	    <xsl:apply-templates select="." mode="process.note.common-processing"/>
	  </xsl:template>

	<xsl:template match="*" mode="process.note.common-processing">
		<xsl:param name="type" select="@type"/>
		<xsl:param name="title">
			<xsl:call-template name="getVariable">
				<xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
			</xsl:call-template>
		</xsl:param>
		<div>
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class" select="string-join(($type, concat('note_', $type)), ' ')"/>
			</xsl:call-template>
			<xsl:call-template name="setidaname"/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
			<xsl:apply-templates/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
		</div>
	</xsl:template>
	
	<xsl:template match="*" mode="set-output-class">
		<xsl:param name="default"/>
		<xsl:variable name="output-class">
			<xsl:apply-templates select="." mode="get-output-class"/>
		</xsl:variable>
		<xsl:variable name="draft-revs" as="xs:string*">
			<!-- If draft is on, add revisions to default class. Simplifies processing in DITA-OT 1.6 and earlier
           that created an extra div or span around revised content, just to hold @class with revs. -->
			<xsl:if test="$DRAFT = 'yes'">
				<xsl:sequence select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop/@val"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="using-output-class" as="xs:string*">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($output-class)) > 0">
					<xsl:value-of select="tokenize(normalize-space($output-class), '\s+')"/>
				</xsl:when>
				<xsl:when test="string-length(normalize-space($default)) > 0">
					<xsl:value-of select="tokenize(normalize-space($default), '\s+')"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ancestry" as="xs:string?">
			<xsl:if test="$PRESERVE-DITA-CLASS = 'yes'">
				<xsl:value-of>
					<xsl:apply-templates select="." mode="get-element-ancestry"/>
				</xsl:value-of>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="outputclass-attribute" as="xs:string">
			<xsl:value-of>
				<xsl:apply-templates select="@outputclass" mode="get-value-for-class"/>
			</xsl:value-of>
		</xsl:variable>
		<!-- Revised design with DITA-OT 1.5: include class ancestry if requested; 
         combine user output class with element default, giving priority to the user value. -->
		<xsl:variable name="classes" as="xs:string*"
                  select="tokenize($ancestry, '\s+'),
                          $using-output-class,
                          $draft-revs, 
                          tokenize($outputclass-attribute, '\s+')"/>
		<xsl:if test="exists($classes)">
			<xsl:attribute name="class" select="replace(string-join(distinct-values($classes), ' '), '(&#x20;)?(pagebreak)', '')"/>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="pi.code">
        <xsl:for-each select="root()/dita/node()[self::processing-instruction('ast')]">
            <xsl:element name="{substring-before(., '=')}">
                <xsl:value-of select="substring-after(., '=')" />
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
	
	<xsl:template match="*[contains(@class, ' topic/body ')]" name="topic.body">
		<article>
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setidaname"/>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('topic ', local-name(parent::*), ' nested2')"/>
			</xsl:attribute>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
			<xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/abstract ')]" mode="outofline"/>
			<xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/shortdesc ')]" mode="outofline"/>
			<xsl:apply-templates select="following-sibling::*[contains(@class, ' topic/related-links ')]" mode="prereqs"/>
			<xsl:apply-templates/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
		</article>
	</xsl:template>

	<!-- <xsl:template match="processing-instruction()">
	    <xsl:choose>
	        <xsl:when test="name()='userManual'">
	    		<xsl:value-of select="'sonaspo'" />
	        </xsl:when>
	        <xsl:otherwise>
	        	<xsl:apply-templates select="." />
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template> -->

</xsl:stylesheet>