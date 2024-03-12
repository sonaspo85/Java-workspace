<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 p li" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:variable name="flw-ph" select="following-sibling::*[1][name()='span'][@class='C_URL']" />
        <xsl:analyze-string select="." regex="%#%">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="$flw-ph">
                    </xsl:when>
                    <xsl:otherwise>
                        <br/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring> 
            <xsl:non-matching-substring> 
                <xsl:copy/>
            </xsl:non-matching-substring> 
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="contains(@class, 'UL')">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:choose>
                        <xsl:when test="br and not(contains(@class, 'Child'))">
                            <xsl:for-each-group select="node()" group-ending-with="node()[name()='br']">
                                <li>
                                    <xsl:apply-templates select="current-group()[not(name()='br')]" />
                                </li>
                            </xsl:for-each-group>
                        </xsl:when>
                        
                        <xsl:when test="br and contains(@class, 'Child')">
                            <!--<xsl:apply-templates select="node()" />-->
                            <xsl:choose>
                                <xsl:when test="matches(@class, '^Step-UL1_3-Note-Child$')">
                                    <xsl:for-each-group select="node()" group-ending-with="br">
                                        <li>
                                            <xsl:apply-templates select="current-group()[not(name()='br')]" />
                                        </li>
                                    </xsl:for-each-group>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:apply-templates select="node()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <li>
                                <xsl:apply-templates select="node()" />
                            </li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="contains(@class, 'OL') and br">
                <xsl:for-each-group select="node()" group-ending-with="node()[name()='br']">
                    <p class="{parent::p/@class}">
                        <xsl:if test="current-group()[not(following-sibling::node())]">
                            <xsl:if test="parent::p/@video-before">
                                <xsl:attribute name="video-before" select="parent::p/@video-before" />
                            </xsl:if>
                            <xsl:if test="parent::p/@video-after">
                                <xsl:attribute name="video-after" select="parent::p/@video-after" />
                            </xsl:if>
                            <xsl:if test="parent::p/@video-size">
                                <xsl:attribute name="video-size" select="parent::p/@video-size" />
                            </xsl:if>
                        </xsl:if>
                        
                        <xsl:apply-templates select="current-group()[not(name()='br')]" />
                    </p>
                </xsl:for-each-group>
            </xsl:when>
        	
            <xsl:when test="contains(@class, 'Description_1') and br">
                <xsl:for-each-group select="node()" group-ending-with="node()[name()='br']">
                    <p class="{parent::p/@class}">
                        <xsl:if test="parent::p/@video-before">
                            <xsl:attribute name="video-before" select="parent::p/@video-before" />
                        </xsl:if>
                        <xsl:if test="parent::p/@video-after">
                            <xsl:attribute name="video-after" select="parent::p/@video-after" />
                        </xsl:if>
                        <xsl:if test="parent::p/@video-size">
                            <xsl:attribute name="video-size" select="parent::p/@video-size" />
                        </xsl:if>
                        
                        <xsl:apply-templates select="current-group()[not(name()='br')]" />
                    </p>
                </xsl:for-each-group>
            </xsl:when>
        	
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>