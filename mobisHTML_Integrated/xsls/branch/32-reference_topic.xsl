<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="../00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />
    
    <xsl:variable name="ver" select="$commonRef/version/@value" />

    <xsl:template match="topic" mode="#all">
        <xsl:variable name="idmlTopic" select="ancestor-or-self::topic[@idml]" />
        
        <xsl:variable name="IdmlNumber">
            <xsl:choose>
                <xsl:when test="$commonRef/version/@value = '6th'">
                    <!--<xsl:value-of select="number(tokenize($idmlTopic/@idml, '_')[1])" />-->
                    <xsl:variable name="num0" select="replace(tokenize($idmlTopic/@idml, '_')[1], '-', '.')" />
                    <xsl:value-of select="number($num0)" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="number(tokenize($idmlTopic/@idml, '_')[1]) - 3" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="IdmlNumber2" select="if ($IdmlNumber &lt; 0) then 
                                                 format-number(0, '000') else 
                                                 format-number($IdmlNumber, '000.#')" />
         
        <xsl:variable name="IdmlName" select="tokenize($idmlTopic/@idml, '_')[position() &gt; 1]" />
        
        <xsl:variable name="idmlAttr">
            <xsl:choose>
                <xsl:when test="$ver = '6th'">
                    <xsl:value-of select="concat($IdmlNumber2, '_', string-join($IdmlName, '_'))" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="concat($IdmlNumber2, '_', string-join($IdmlName, '_'))"/>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>
        
        <xsl:variable name="pos" select="count(preceding-sibling::topic) + 1" />
        
        <xsl:choose>
            <xsl:when test="count(ancestor::topic) = 1">
                <xsl:copy>
                    <xsl:attribute name="idml">
                        <xsl:value-of select="$idmlAttr"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="count(ancestor::topic) = 3">
                <xsl:copy>
                    <xsl:attribute name="idml">
                        <xsl:value-of select="$idmlAttr"/>
                    </xsl:attribute>
                
                    <xsl:attribute name="file">
                        <xsl:choose>
                            <xsl:when test="$commonRef/version/@value = '6th' and 
                                            not(preceding-sibling::topic) and 
                                            $idmlTopic[matches(@idml, '(Systemoverview|Appendix)', 'i')]">
                                <xsl:choose>
                                    <xsl:when test="@scid">
                                        <xsl:value-of select="concat($idmlAttr, '_', replace(@scid, '^.+_', ''), '.html')" />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($idmlAttr, '_', $pos, '.html')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:when test="not(preceding-sibling::topic) and 
                                            $idmlTopic/descendant::*[matches(@class, '-sublink')]">
                                <xsl:choose>
                                    <xsl:when test="matches($idmlTopic/@idml, '_features_', 'i')">
                                        <xsl:choose>
                                            <xsl:when test="@scid">
                                                <xsl:value-of select="concat($idmlAttr, '_', replace(@scid, '^.+_', ''), '.html')" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($idmlAttr, '_', $pos, '.html')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($idmlAttr, '.html')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:when test="@scid">
                                <xsl:choose>
                                    <xsl:when test="$commonRef/version/@value = '6th'">
                                        <xsl:choose>
                                            <!--<xsl:when test="$IdmlName = @scid and 
                                                            count($idmlTopic/topic/topic) eq 1">
                                                <xsl:value-of select="concat($idmlAttr, '.html')" />
                                            </xsl:when>-->
                                            
                                            <xsl:when test="$IdmlName = @scid">
                                                <xsl:value-of select="concat($idmlAttr, '.html')" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($idmlAttr, '_', replace(@scid, '^.+_', ''), '.html')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($idmlAttr, '_', replace(@scid, '^.+_', ''), '.html')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="concat($idmlAttr, '_', $pos, '.html')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:choose>
                        <xsl:when test="$idmlTopic[not(following-sibling::*)] and 
                                        matches($idmlTopic/@idml, 'Appendix')">
                        <!--<xsl:when test="not(following-sibling::*) and 
                                        $idmlTopic[not(following-sibling::*)]">-->  <!--final chapter-->
                            <xsl:for-each select="node()">  <!--ancestor::topic 이 3개인 topic/*--> 
                                <xsl:choose>
                                    <xsl:when test="self::title">
                                        <xsl:variable name="level" select="count(ancestor::topic)" />
                                        <xsl:variable name="name" select="if (position() = 1) then 
                                                                          concat('h', $level - 3) else 
                                                                          concat('h', $level - 2)" />    <!--첫번째 위치의 title 일경우--> 
                                        <xsl:element name="{$name}">
                                            <xsl:apply-templates select="@*" />
                                            <xsl:attribute name="id">
                                                <xsl:value-of select="if (@class='' or position() = 1) then 
                                                                      parent::topic/@id 
                                                                      else concat('d', generate-id(.))" />
                                            </xsl:attribute>

                                            <xsl:apply-templates select="node()" />
                                        </xsl:element>
                                    </xsl:when>
                                    
                                    <xsl:when test="self::topic">    <!--topic/topic 인경우--> 
                                        <xsl:call-template name="TitleLevel">
                                            <xsl:with-param name="childTopic" select="node()" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@* | node()" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--<xsl:if test="$commonRef/version/@value = '6th'">
                                <xsl:copy-of select="preceding-sibling::node()[1][matches(@class, 'modeltitle')]" />
                            </xsl:if>-->
                            
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="count(ancestor::topic) &gt;= 4">
                <xsl:apply-templates select="node()" />
            </xsl:when>
            
            <xsl:when test="count(ancestor::topic) = 2">
                <xsl:copy>
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="TitleLevel">
        <xsl:param name="childTopic" />
        
        <xsl:for-each select="$childTopic">
            <xsl:choose>
                <xsl:when test="self::title">
                    <xsl:variable name="level" select="count(ancestor::topic)" />
                    <xsl:variable name="name" select="concat('h', $level - 3)" />
                    
                    <xsl:element name="{$name}">
                        <xsl:apply-templates select="@*" />
                        <xsl:apply-templates select="parent::topic/@id" />
                        <xsl:apply-templates select="node()" />
                    </xsl:element>
                </xsl:when>
                
                <xsl:when test="self::topic">
                    <xsl:call-template name="TitleLevel">
                        <xsl:with-param name="childTopic" select="node()" />
                    </xsl:call-template>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="title" mode="#all">
        <xsl:variable name="level" select="count(ancestor::topic)" />
        <xsl:variable name="name" select="concat('h', $level - 3)" />
        <xsl:element name="{$name}">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="id" select="parent::topic/@id" />
            <xsl:if test="parent::*/@oid">
                <xsl:attribute name="oid" select="parent::*/@oid" />
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:element>
    </xsl:template>
    
    <!--<xsl:template match="p[matches(@class, 'modeltitle')]" />-->
    
</xsl:stylesheet>