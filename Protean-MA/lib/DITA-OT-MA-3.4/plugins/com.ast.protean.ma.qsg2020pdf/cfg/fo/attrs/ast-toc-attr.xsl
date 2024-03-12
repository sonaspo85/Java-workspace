<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:variable name="toc.text-indent" select="'0pt'"/>
    <xsl:variable name="toc.toc-indent" select="'0pt'"/>

    <xsl:attribute-set name="__toc__header" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- <xsl:attribute name="font-size">40pt</xsl:attribute> -->
        <xsl:attribute name="font-size">
            <xsl:choose>
				<xsl:when test="matches(substring-after($locale, '-'), 'KR')">
					<xsl:value-of select="'38pt'" />
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'40pt'" />
				</xsl:otherwise>
			</xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-weight">600</xsl:attribute>
        <xsl:attribute name="padding-top">8mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">20.5mm</xsl:attribute>
        <xsl:attribute name="color">cmyk(0%,0%,0%,80%)</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$base-font-family" />
            <!-- <xsl:choose>
                <xsl:when test="$writing-mode = 'lr'">
                    <xsl:value-of select="'Myriad Pro'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'Arial'" />
                </xsl:otherwise>
            </xsl:choose> -->
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__header_container">
        <!-- <xsl:attribute name="position">absolute</xsl:attribute> -->
        <!-- <xsl:attribute name="top">15mm</xsl:attribute> -->
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="width">170mm</xsl:attribute>
        <!-- <xsl:attribute name="space-before.conditionality">discard</xsl:attribute> -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="margin-bottom">13mm</xsl:attribute>
        <xsl:attribute name="span">all</xsl:attribute>
        <!-- <xsl:attribute name="span">all</xsl:attribute> -->

    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">15pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
        <xsl:attribute name="text-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">-10mm</xsl:when>
                <xsl:when test="$level = 2">0mm</xsl:when>
                <xsl:when test="$level = 3">0mm</xsl:when>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <xsl:attribute name="space-before">
        	<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">13mm</xsl:when>
                <xsl:when test="$level = 2">1mm</xsl:when>
                <xsl:when test="$level = 3">1mm</xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="space-after">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">1.5mm</xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <!-- TOC column break -->
        <!-- <xsl:attribute name="break-before">
        	<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
        	<xsl:if test="$level = 1 and preceding-sibling::*[contains(@class, ' concept/concept ')]">
        		<xsl:text>column</xsl:text>
        	</xsl:if>

        </xsl:attribute> -->
        <!-- TOC column break -->
        <!-- <xsl:attribute name="keep-with-previous.within-column">
        	<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
        	<xsl:text>auto</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">
        	<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
        	<xsl:text>auto</xsl:text>
        </xsl:attribute> -->

        <xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>

            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:choose>
                        <xsl:when test="$level = 1">18.5pt</xsl:when>
                        <xsl:when test="$level = 2">11.5pt</xsl:when>
                    </xsl:choose>
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$level = 1">21pt</xsl:when>
                        <xsl:when test="$level = 2">14pt</xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-family"><xsl:value-of select="$base-font-family" /></xsl:attribute>

        <xsl:attribute name="font-weight">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">600</xsl:when>
                <xsl:when test="$level = 2">normal</xsl:when>
                <xsl:when test="$level = 3">normal</xsl:when>
                <xsl:when test="$level = 4">normal</xsl:when>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height">120%</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
        
        <xsl:attribute name="color">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">cmyk(0%,0%,0%,80%)</xsl:when>
                <xsl:when test="$level = 2">inherit</xsl:when>
                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">10mm</xsl:attribute>
        <!-- <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">10mm</xsl:when>
                <xsl:when test="$level = 2">0mm</xsl:when>
            </xsl:choose>
        </xsl:attribute> -->

        <!-- <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
             <xsl:choose>
            	<xsl:when test="$level = 3">10mm</xsl:when>
            	<xsl:otherwise>
            		<xsl:value-of select="concat($19side-col-width, ' + (', string($level - 1), ' * ', $toc.toc-indent, ') + ', $toc.text-indent)"/>
            	</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        <!-- <xsl:attribute name="color">green</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__page-number">
        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'0mm'" />
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'10mm'" />
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-family">Arial</xsl:attribute>

        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="padding-before">0.5mm</xsl:attribute>
        <xsl:attribute name="padding-after">0.2mm</xsl:attribute>
        <xsl:attribute name="line-height">5.5mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__leader">
        <xsl:attribute name="leader-pattern">space</xsl:attribute>
        <!-- <xsl:attribute name="leader-length">13mm</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__link">
        <!-- <xsl:attribute name="line-height">120%</xsl:attribute> -->

        <!--xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:value-of select="concat(string(20 - number($level) - 4), 'pt')"/>
        </xsl:attribute-->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__title">
      <xsl:attribute name="padding-before">0.5mm</xsl:attribute>
      <xsl:attribute name="padding-after">0.2mm</xsl:attribute>
      <xsl:attribute name="line-height">5.5mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__between__bullet">
        <xsl:attribute name="provisional-distance-between-starts">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'1mm'"/>
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'10mm'"/>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="provisional-label-separation">
            <xsl:choose>
                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) &gt; 3">
                    <xsl:value-of select="'0.5mm'"/>
                </xsl:when>

                <xsl:when test="count(ancestor-or-self::*[contains(@class, ' topic/topic ')]) = 3">
                    <xsl:value-of select="'9.5mm'"/>
                </xsl:when>

                <xsl:otherwise>0mm</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>