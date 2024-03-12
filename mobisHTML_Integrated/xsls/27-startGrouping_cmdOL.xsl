<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />

   
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    

    <xsl:template match="topic[p|ul|ul]" >
        <xsl:copy>
            <xsl:apply-templates select="@*"  />
            <xsl:for-each-group select="*" group-starting-with="*[starts-with(@class,'Step-Cmd-OL')]">
                <xsl:choose>
                    <xsl:when test="current-group()[1][not(starts-with(@class,'Step-Cmd-OL'))]">
                        <xsl:apply-templates select="current-group()"  />
                    </xsl:when>
                    
                    <!-- current-group() 위치 -->
                    <xsl:when test="position() != last()">
                        <xsl:call-template name="not_last_group">
                            <xsl:with-param name="group" select="current-group()" />
                        </xsl:call-template>
                    </xsl:when>
                    
                    <!--마지막 current-group() 위치-->
                    <xsl:when test="current-group()[1][matches(@class, 'Step-Cmd-OL')]">
                        <xsl:variable name="curr" select="current-group()[position() &gt; 1]" />
                        
                        <xsl:for-each select="current-group()[1]">
                            <xsl:variable name="cur.name" select="string(local-name())" />
                            <xsl:variable name="cur.class" select="@class" />
                            
                            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                            <xsl:value-of select="$cur.name" />
                            <xsl:text>&#x20; class="</xsl:text>
                            <xsl:value-of select="$cur.class" />
                            <xsl:text>"</xsl:text>
                            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                            <xsl:apply-templates select="node()"  />
                            
                                <xsl:call-template name="grouping">
                                    <xsl:with-param name="group" select="$curr" />
                                    <xsl:with-param name="curname" select="$cur.name" />
                                </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="last_group">
                            <xsl:with-param name="group" select="current-group()" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="grouping">
        <xsl:param name="group"/>
        <xsl:param name="curname" />
        
        <xsl:choose>
            <xsl:when test="$group[1][name()='img'][following-sibling::node()[1][matches(@class, 'Step-UL1_2-Note')]] or 
                            $group[1][matches(@class, 'Step-UL1_2-Note')] or 
                            $group[1][name()='img'][preceding-sibling::node()[1][matches(@class, 'Step-Cmd-OL2')]]">
                <xsl:apply-templates select="$group[1]"  />

                <xsl:call-template name="grouping">
                    <xsl:with-param name="group" select="$group[position() &gt; 1]" />
                    <xsl:with-param name="curname" select="$curname" />
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
                <xsl:value-of select="$curname" />
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:apply-templates select="$group" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="not_last_group">
        <xsl:param name="group" />
        
        <xsl:for-each select="$group">
            <xsl:if test="position() = 1">
                
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()"  />
                    
                    <xsl:for-each select="$group[position() &gt; 1]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()"  />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="last_group">
        <xsl:param name="group" />
        <xsl:for-each select="$group">
            <xsl:if test="position() = 1">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:for-each select="$group[position() &gt; 1][matches(@class,'Step-(Description|UL1)-Note') or 
                                          matches(@class,'Img')]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()"  />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
                <xsl:apply-templates select="$group[position() &gt; 1][not(matches(@class,'Step-(Description|UL1)-Note') or 
                                             matches(@class, 'Img'))]"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>