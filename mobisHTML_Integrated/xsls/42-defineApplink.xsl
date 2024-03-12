<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="applink">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="applink" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic[@file]">
       <xsl:copy>
           <xsl:apply-templates select="@*" />
           
            <xsl:for-each select="div">
                <div class="Heading2">
                    <div class="swipe_inner_wrap">
                        <xsl:choose>
                            <xsl:when test="count(parent::topic/div[@class='heading2']) = 1">
                                <div class="heading1">
                                    <xsl:apply-templates />
                                </div>
                            </xsl:when>
                            
                            <xsl:when test="h1[matches(@class, 'sublink')]">
                                <div class="heading1">
                                    <!--<xsl:if test="*[1][name()='h1']">
                                        <xsl:attribute name="id" select="*[1]/@id" />
                                    </xsl:if>-->
                                    
                                    <xsl:apply-templates mode="applink" />
                                </div>
                            </xsl:when>
                            
                            <xsl:when test="count(parent::topic/div[@class='heading2']) &gt;= 2">
                                <div class="heading1">
                                    <xsl:apply-templates mode="applink" />
                                </div>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <div class="heading1">
                                    <xsl:apply-templates />
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <!--<xsl:if test="parent::topic/preceding-sibling::node()[1][name()='h0'] and 
                            ancestor::topic[matches(@idml, '(_settings$|_features_)', 'i')][last()]
                            /descendant::*[matches(@class, '-sublink')]">-->
                        <xsl:if test="parent::topic/preceding-sibling::node()[1][name()='h0'] and 
                                      ancestor::topic[@idml][last()][not(matches(@idml, '(\d+_video|\d+_Content)', 'i'))]
                                      /descendant::*[matches(@class, '-sublink')]">
                            <xsl:variable name="cur" select="." />
                            
                            <div class="h1_sublink">
                                <ul class="h1_list">
                                    <xsl:for-each select="ancestor::topic[@idml][last()]
                                                          /descendant::*[matches(@class, '-sublink')]
                                                          /node()[not(matches(@class, 'c_below_heading'))]">
                                        <xsl:variable name="ancesTopicFileAttr" select="ancestor::topic[@file][1]/@file" />
                                        <xsl:variable name="curTopicID" select="parent::*/@id" />
                                        
                                        <xsl:variable name="getSublinkHref">
                                            <xsl:variable name="lastSCID" select="tokenize(replace($ancesTopicFileAttr, '.html', ''), '_')[last()]" />
                                            <xsl:value-of select="if ($lastSCID = $curTopicID) then 
                                                                  $ancesTopicFileAttr else 
                                                                  concat($ancesTopicFileAttr, '#', $curTopicID)"/>
                                        </xsl:variable>
                                        
                                        <li>
                                            <a href="{$getSublinkHref}">
                                                <xsl:value-of select="." />
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </xsl:for-each>
       </xsl:copy>
    </xsl:template>
    
    <!-- applink는 해당 Heading 밑에 하위 Heading을 가지고 있는 경우, 파란색 링크로 제공하기 위해 사용 함 -->
    <xsl:template match="h1 | p1 | h2" mode="applink">
        <xsl:choose>
            <xsl:when test="matches(name(), '(h1|p1)')">
                <xsl:element name="{if (local-name()='p1') then 'h1' else local-name()}">
                    <xsl:variable name="class" select="if (matches(@class, '(-sublink|-features)')) 
                                                       then replace(@class, '(-sublink|-features)', '') 
                                                       else @class" />
                    <xsl:attribute name="class" select="concat($class, ' ', 'Heading1-APPLINK')"/>
                    
                    <xsl:apply-templates select="@id" />
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="self::text()">
                                <xsl:value-of select="replace(., '&#xa;', '')" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="applink" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="matches(name(), 'h2')">
                <xsl:choose>
                    <xsl:when test="matches(@class, 'heading2-none-view')">
                        <xsl:element name="{local-name()}">
                            <xsl:attribute name="class" select="'heading2-none-view'"/>
                            <xsl:apply-templates select="@id" />
                            <xsl:apply-templates select="node()" mode="applink"/>
                        </xsl:element>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:element name="{local-name()}">
                            <xsl:attribute name="class" select="concat(@class, ' ', 'Heading2-APPLINK')"/>
                            <xsl:apply-templates select="@id" />
                            <xsl:apply-templates select="node()" mode="applink"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="applink" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="h1 | p1">
        <xsl:element name="{if (local-name()='p1') then 'h1' else local-name()}">
            <xsl:variable name="class" select="if (matches(@class, '-sublink')) then 
                                               replace(@class, '-sublink', '') else 
                                               @class" />
            <xsl:attribute name="class" select="$class"/>
            <xsl:apply-templates select="@* except @class"/>
            
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::text()">
                        <xsl:value-of select="replace(., '&#xa;', '')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>