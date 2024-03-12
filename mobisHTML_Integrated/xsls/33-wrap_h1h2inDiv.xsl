<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topic">
        <xsl:variable name="current" select="." />
        
        <topic>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="h2[@class='heading2-notoc']">
                    <xsl:variable name="cur" select="current-group()[name()='h2']" />
                    <xsl:variable name="h1-idx" select="count(parent::topic[@file]/preceding-sibling::topic[@file])" />
                    
                    <div class="heading1">
                        <xsl:for-each-group select="*" group-starting-with="*[matches(name(), 'h1|h2')]">
                            <xsl:choose>
                                <xsl:when test="current-group()[name()='h1']">
                                    <xsl:apply-templates select="current-group()"/>
                                </xsl:when>
                                
                                <xsl:when test="current-group()[name()='h2']">
                                    <!--<xsl:choose>
                                        <xsl:when test="current-group()[@class='description-faq']">
                                            <xsl:variable name="copied">
                                                <xsl:copy-of select="current-group()" />
                                            </xsl:variable>
                                            
                                            <xsl:apply-templates select="$copied/*[@class='description-faq'][1]/preceding-sibling::*" />
                                            
                                            <div class="div_wrap">
                                                <xsl:for-each-group select="current-group()" group-starting-with="*[@class='description-faq']">
                                                    <xsl:choose>
                                                        <xsl:when test="current-group()[1][@class='description-faq']">
                                                            <div class="qna">
                                                                <xsl:for-each-group select="current-group()" group-adjacent="boolean(self::p[@class='description_1'])">
                                                                    <xsl:choose>
                                                                        <xsl:when test="current-group()[name()='p'][@class='description_1']">
                                                                            <div class="description_group">
                                                                                <xsl:apply-templates select="current-group()"/>
                                                                            </div>
                                                                        </xsl:when>
                                                                        
                                                                        <xsl:otherwise>
                                                                            <xsl:apply-templates select="current-group()"/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:for-each-group>
                                                            </div>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:for-each-group>
                                            </div>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="current-group()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>-->
                                    <xsl:call-template name="faqGrouping">
                                        <xsl:with-param name="cur" select="$cur" />
                                    </xsl:call-template>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </div>
                </xsl:when>

                <xsl:when test="h2[@class='heading2-continue'] and 
                                matches(@idml, '(_Video|_Content)', 'i')">
                    <!--<xsl:variable name="h1-idx" select="count(parent::topic[@file]/preceding-sibling::topic[@file])" />-->
                    
                    <div class="heading1">
                        <xsl:apply-templates select="node()" />
                    </div>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:for-each-group select="*" group-starting-with="*[matches(name(), 'h1|h2')]">
                        <xsl:choose>
                            <xsl:when test="current-group()[name()='h1']">
                                <div class="heading1">
                                    <xsl:apply-templates select="current-group()"/>
                                </div>
                            </xsl:when>
                            
                            <xsl:when test="current-group()[name()='h2']">
                                <xsl:variable name="cur" select="current-group()[name()='h2']" />
                                <div class="heading2">
                                    <!--<xsl:apply-templates select="current-group()"/>-->
                                    <xsl:call-template name="faqGrouping">
                                        <xsl:with-param name="cur" select="$cur" />
                                    </xsl:call-template>
                                    
                                </div>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </topic>
    </xsl:template>
    
    <xsl:template name="faqGrouping">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="current-group()[@class='description-faq']">
                <xsl:variable name="copied">
                    <xsl:copy-of select="current-group()" />
                </xsl:variable>
                
                <xsl:apply-templates select="$copied/*[@class='description-faq'][1]/preceding-sibling::*" />
                
                <div class="div_wrap">
                    <xsl:for-each-group select="current-group()" group-starting-with="*[@class='description-faq']">
                        <xsl:choose>
                            <xsl:when test="current-group()[1][@class='description-faq']">
                                <div class="qna">
                                    <xsl:for-each-group select="current-group()" group-adjacent="boolean(self::p[@class='description_1'])">
                                        <xsl:choose>
                                            <xsl:when test="current-group()[name()='p'][@class='description_1']">
                                                <div class="description_group">
                                                    <xsl:apply-templates select="current-group()"/>
                                                </div>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="current-group()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>
                                </div>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each-group>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="current-group()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>