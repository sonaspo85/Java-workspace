<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title p li" />

    <xsl:variable name="data-language" select="/topic/@data-language" />
    <xsl:variable name="dlrtl" select="matches($data-language, '(Ara|Far|Urdu)')" />

    <xsl:template match="@data-language">
        <xsl:attribute name="data-language">
            <xsl:value-of select="ast:fill(/topic/@data-language, '_')" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="img/@class">
        <xsl:attribute name="class" select="replace(., '\s+magnifier(_8inch)?', '')" />
    </xsl:template>

    <xsl:template match="ol/li/ul[li/div/img]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="li">
                <xsl:choose>
                    <xsl:when test="parent::*/count(li) &gt; 1">
                        <xsl:choose>
                            <xsl:when test="not(parent::*/li[1]/div[img]) and 
                                            position() = last() and 
                                            div[img][not(following-sibling::node())]">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:apply-templates select="node() except div[img]" />
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:when test="div[img][not(following-sibling::node())]">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:apply-templates select="node() except div[img]" />
                                </xsl:copy>
                                
                                <xsl:if test="div[img]">
                                    <xsl:apply-templates select="div[img]" />
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
                            <xsl:when test="div[img][not(following-sibling::node())]">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:apply-templates select="node() except div[img]" />
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
            <xsl:apply-templates select="li/div[img]" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="ul[parent::li[not(following-sibling::li)]/parent::ol/following-sibling::*[1][name()='same-level']]" priority="10">
        <xsl:variable name="same-level" select="parent::li/parent::ol/following-sibling::*[1][name()='same-level']" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
        <xsl:for-each select="$same-level">
            <xsl:apply-templates />
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="same-level">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][name()='ol']">
            </xsl:when>
        	
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="span[matches(@class, 'C_URL')]">
        <span class="C_URL">
            <xsl:apply-templates select="@* | node()" />
        </span>
    </xsl:template>

    <xsl:template match="span" priority="10">
        <xsl:choose>
            <xsl:when test="$dlrtl">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
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
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:fill">
        <xsl:param name="str" />
        <xsl:param name="char" />

        <xsl:choose>
            <xsl:when test="count(tokenize(substring-after($str, $char), $char)) = 2">
                <xsl:choose>
                    <xsl:when test="tokenize(substring-after($str, $char), $char)[position()=1] = translate(substring-after(tokenize(substring-after($str, $char), $char)[position()=2], '('), ')', '')">
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

</xsl:stylesheet>