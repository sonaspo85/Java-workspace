<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@class">
        <xsl:attribute name="class" select="lower-case(.)" />
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="span">
        <xsl:choose>
            <xsl:when test="self::*[matches(@class, 'C_LtoR')] and 
                              following-sibling::node()[1][name()='span'][not(matches(@class, '(C_NoBreak|C_MMI|C_Symbol|C_Button|C_Important|C_Buttonbracket|C_CrossReference)'))]">
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
    </xsl:template>

    <xsl:template match="*[@class='Description-Note'] | *[@class='Step-Description-Note'] | *[@class='UL1-Note'] | *[@class='Step-UL1-Note']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@class='Caution']">
        <div class="line_mit">
            <img src="contents\images\M-caution.png" class="caution icon" />
            <xsl:copy> 
                <xsl:apply-templates select="@* | node()" />
            </xsl:copy>
        </div>
    </xsl:template>

    <xsl:template match="*[@class='Warning']">
        <div class="line_mit">
            <img src="contents\images\M-warning.png" class="warning icon" />
            <xsl:copy>
                <xsl:apply-templates select="@* | node()" />
            </xsl:copy>
        </div>
    </xsl:template>

    <xsl:template match="topic">
        <xsl:choose>
            <xsl:when test="count(ancestor::topic) &gt;= 4">
                <xsl:apply-templates select="node()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:variable name="idml-number" select="format-number(ancestor-or-self::topic[@idml]/xs:integer(substring-before(@idml, '_')) - 3, '000')" />
                    <xsl:variable name="re-number" select="if (xs:integer($idml-number) &lt; 0) then '000' else $idml-number" />
                    <!--<xsl:variable name="idml-rename" select="concat($re-number, '_', substring-after(ancestor-or-self::topic[@idml]/@idml, '_'))" />-->
                    
                    <xsl:variable name="idml-rename">
                        <xsl:variable name="str0" select="string-join(tokenize(ancestor-or-self::topic[@idml]/@idml, '_')[position() &gt; 1], '_')"/>
                        <xsl:value-of select="concat($re-number, '_', $str0)"/>
                    </xsl:variable>
                        
                    <xsl:choose>
                        <xsl:when test="count(ancestor::topic) = 1">
                            <xsl:attribute name="idml">
                                <xsl:value-of select="$idml-rename"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </xsl:when>
                        
                        <xsl:when test="count(ancestor::topic) = 3">
                            <xsl:variable name="idx" select="count(preceding-sibling::topic) + 1" />
                            <xsl:attribute name="idml">
                                <xsl:value-of select="$idml-rename"/>
                            </xsl:attribute>

                            <xsl:attribute name="file">
                                <xsl:choose>
                                    <xsl:when test="not(preceding-sibling::topic) and ancestor::topic[@idml]/descendant::*[matches(@class, 'Sublink')]">
                                        <!--<xsl:value-of select="concat($idml-rename, '.html')" />-->
                                        
                                        <xsl:choose>
                                            <xsl:when test="ancestor::topic[matches(@idml, '_Features_')] and 
                                                            @scid">
                                                <xsl:value-of select="concat($idml-rename, '_', replace(@scid, '^.+_', ''), '.html')" />
                                            </xsl:when>
                                            
                                            <xsl:when test="ancestor::topic[matches(@idml, '_Features_')] and 
                                                            not(@scid)">
                                                <xsl:value-of select="concat($idml-rename, '_', $idx, '.html')" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($idml-rename, '.html')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>

                                    <xsl:when test="@scid">
                                        <xsl:value-of select="concat($idml-rename, '_', replace(@scid, '^.+_', ''), '.html')" />
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($idml-rename, '_', $idx, '.html')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            
                            <xsl:choose>
                                <xsl:when test="current()[not(following-sibling::*)][parent::*/parent::*[@idml and not(following-sibling::*)]]">     <!--final chapter--> 
                                    <xsl:for-each select="node()">     <!--ancestor::topic 이 3개인 topic/*--> 
                                        <xsl:choose>
                                            <xsl:when test="self::title">
                                                <xsl:variable name="level" select="count(ancestor::topic)" />
                                                <xsl:variable name="name" select="if (position() = 1 ) then concat('h', $level - 3) else concat('h', $level - 2)" />    <!--첫번째 위치의 title 일경우--> 
                                                <xsl:element name="{$name}">
                                                    <xsl:apply-templates select="@*" />
                                                    <xsl:attribute name="id">
                                                        <xsl:value-of select="if ( @class = '' or position() = 1 ) then parent::topic/@id else concat('d', generate-id(.))" />
                                                    </xsl:attribute>
                                                    
                                                    <xsl:apply-templates select="parent::topic/@float" />
                                                    <xsl:apply-templates select="node()" />
                                                </xsl:element>
                                            </xsl:when>
                                            
                                            <xsl:when test="self::topic">    <!--topic/topic 인경우--> 
                                                <xsl:call-template name="titlecount">
                                                    <xsl:with-param name="seq" select="node()" />
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
                                    <xsl:apply-templates select="node()" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="titlecount">
        <xsl:param name="seq" />
        <xsl:for-each select="$seq">
            <xsl:choose>
                <xsl:when test="self::title">
                    <xsl:variable name="level" select="count(ancestor::topic)" />
                    <xsl:variable name="name" select="concat('h', $level - 4)" />
                    
                    <xsl:element name="{$name}">
                        <xsl:apply-templates select="@*" />
                        <xsl:apply-templates select="parent::topic/@id" />
                        <xsl:apply-templates select="parent::topic/@float" />
                        <xsl:apply-templates select="node()" />
                    </xsl:element>
                </xsl:when>
                
                <xsl:when test="self::topic">
                    <xsl:call-template name="titlecount">
                        <xsl:with-param name="seq" select="node()" />
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

    <xsl:template match="title">
        <xsl:variable name="level" select="count(ancestor::topic)" />
        <xsl:variable name="name" select="concat('h', $level - 3)" />
        <xsl:element name="{$name}">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="id" select="if (parent::topic/@chid) then 
                                             parent::topic/@chid else parent::topic/@id" />
            <xsl:if test="parent::*/@oid">
                <xsl:attribute name="oid" select="parent::*/@oid" />
            </xsl:if>
            <xsl:apply-templates select="parent::topic/@float" />
            <xsl:apply-templates select="node()" />
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>