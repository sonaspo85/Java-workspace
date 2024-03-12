<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title p li" />


    <xsl:template match="@data-language">
        <xsl:attribute name="data-language">
            <xsl:value-of select="/topic/@data-language" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ul">
        <xsl:choose>
            <xsl:when test="parent::li/parent::ol">
                <xsl:choose>
                    <xsl:when test="li/div/img">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="li">
                                <xsl:choose>
                                    <xsl:when test="parent::*/count(li) &gt; 1">
                                        <xsl:choose>
                                            <xsl:when test="not(parent::*/li[1]/div[img]) and 
                                                            position() = last() and 
                                                            child::div[img][not(following-sibling::node())]">
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*" />
                                                    <xsl:apply-templates select="node() except child::div[img]" />
                                                </xsl:copy>
                                            </xsl:when>
                                            
                                            <xsl:when test="child::div[img][not(following-sibling::node())]">
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*" />
                                                    <xsl:apply-templates select="node() except child::div[img]" />
                                                </xsl:copy>
                                                
                                                <xsl:if test="child::div[img]">
                                                    <xsl:apply-templates select="child::div[img]" />
                                                </xsl:if>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*, node()" />
                                                </xsl:copy>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="child::div[img][not(following-sibling::node())]">
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*" />
                                                    <xsl:apply-templates select="node() except child::div[img]" />
                                                </xsl:copy>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:copy>
                                                    <xsl:apply-templates select="@*, node()" />
                                                </xsl:copy>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:copy>
                        
                        <xsl:if test="count(li) = 1 and 
                                      li/div[img][not(following-sibling::node())]">
                            <xsl:apply-templates select="li/div[img]" />
                        </xsl:if>
                        
                        <xsl:if test="count(li) &gt; 1 and 
                                      not(li[1]/div[img]) and 
                                      li[last()]/div[img][not(following-sibling::node())]">
                            <xsl:apply-templates select="li[last()]/div[img]" />
                        </xsl:if>
                    </xsl:when>
                    
                    <!--<xsl:when test="parent::li[not(following-sibling::li)]
                                    /parent::ol
                                    /following-sibling::*[1][matches(@class, 'imgNp_desCenter')]">
                        <xsl:variable name="imgNp_desCenter" select="parent::li/parent::ol/following-sibling::*[1][matches(@class, 'imgNp_desCenter')]" />
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        
                        <xsl:for-each select="$imgNp_desCenter">
                            <xsl:apply-templates />
                        </xsl:for-each>
                    </xsl:when>-->
                    
                    <xsl:when test="parent::li[not(following-sibling::li)]
                                    /parent::ol">
                        <xsl:choose>
                            <xsl:when test="following-sibling::*[1][matches(@class, 'imgNp_desCenter')]">
                                <xsl:variable name="imgNp_desCenter" select="parent::li/parent::ol/following-sibling::*[1][matches(@class, 'imgNp_desCenter')]" />
                                
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                                
                                <xsl:for-each select="$imgNp_desCenter">
                                    <xsl:apply-templates />
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:when test="li[last()]/table[not(following-sibling::node())] and 
                                            matches(@class, 'Step-UL1_2-Note')">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                                <xsl:copy-of select="li[last()]/table" />
                            </xsl:when>
                            
                            <xsl:when test="matches(@class, '_2-Note') and 
                                            not(following-sibling::node())">
                                <xsl:choose>
                                    <xsl:when test="parent::li/parent::ol
                                                    /following-sibling::*[1][matches(@class, 'imgNp_desCenter')]">
                                        <xsl:variable name="imgNp_desCenter" select="parent::li/parent::ol/following-sibling::*[1][matches(@class, 'imgNp_desCenter')]" />
                                        
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                        
                                        <xsl:for-each select="$imgNp_desCenter">
                                            <xsl:apply-templates />
                                        </xsl:for-each>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="div[matches(@class, 'imgNp_desCenter')]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][name()='ol']">
            </xsl:when>
        	
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:choose>
            <xsl:when test="not(following-sibling::node()) and 
                            parent::li/parent::ul[matches(@class, 'Step-UL1_2-Note')]" />
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>-->

    <!--<xsl:function name="ast:fill">
        <xsl:param name="str" />
        <xsl:param name="char" />

        <xsl:choose>
            <xsl:when test="count(tokenize(substring-after($str, $char), $char)) = 2">
                <xsl:choose>
                    <xsl:when test="tokenize(substring-after($str, $char), $char)[position()=1] = 
                                    translate(substring-after(tokenize(substring-after($str, $char), $char)[position()=2], '('), ')', '')">
                        <xsl:variable name="aa" select="tokenize($str, $char)" />
                        <xsl:for-each select="$aa">
                            <xsl:choose>
                                <xsl:when test="position()=2">
                                    <xsl:text>_</xsl:text>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="." />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="$str" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
-->
</xsl:stylesheet>