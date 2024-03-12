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
    
    <xsl:template match="title">
        <xsl:choose>
            <xsl:when test="parent::topic and 
                            following-sibling::*[1][name()='group']">
                <xsl:variable name="flw" select="following-sibling::*[1][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:apply-templates select="$flw/node()" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ul">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="matches(@class, 'UL1-White') and
                            following-sibling::*[1][name()='p'][@class='Description-Symbol'] 
                            /following-sibling::*[1][name()='group']">
                <xsl:variable name="flw" select="following-sibling::node()[2][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        
                        <xsl:if test="position()=last()">
                            <xsl:apply-templates select="$flw/node()" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@class, 'Step-UL1_2-Note') and 
                            following-sibling::*[1][name()='group']
                            /following-sibling::*[1][matches(@class, 'Step-UL1_2-Note')]">
                <xsl:variable name="flw" select="following-sibling::node()[1][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                
                <xsl:apply-templates select="$flw/node()" />
            </xsl:when>
            
            <xsl:when test="ends-with(@class, '-Note') and 
                            following-sibling::*[1][name()='group']
                            /count(img) &gt; 1">
                <xsl:variable name="flw" select="following-sibling::node()[1][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                
                <div class="imgNp_desCenter">
                    <xsl:apply-templates select="$flw/node()" />
                </div>
            </xsl:when>

            <xsl:when test="ends-with(@class, '-Note') and 
                            following-sibling::*[1][name()='group']
                            /*[1][matches(@class, 'Table_Symbol-Indent')]">
                <xsl:variable name="flw" select="following-sibling::node()[1][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                <xsl:apply-templates select="$flw/node()" />
            </xsl:when>
            
            <xsl:when test="not(matches(@class, 'Step-UL1_1')) and 
                            following-sibling::node()[1][name()='group']">
                <xsl:variable name="flw" select="following-sibling::node()[1][name()='group']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                            
                            <xsl:if test="position()=last()">
                                <xsl:apply-templates select="$flw/node()" />
                            </xsl:if>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="following-sibling::*[1][name()='group']">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][@class='UL1-White'] and 
                                    following-sibling::*[1][name()='group']">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="node()">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                                
                                <xsl:if test="position()=last()">
                                    <xsl:apply-templates select="$cur/following-sibling::node()[1][name()='group']/node()" />
                                </xsl:if>
                            </xsl:for-each>
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

    <xsl:template match="group[parent::topic]">
        <xsl:choose>
            <xsl:when test="count(*) &gt; 1 and 
                            preceding-sibling::node()[1][matches(@class, 'Step-UL1_1$')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="preceding-sibling::node()[1][matches(@class, 'Step-UL1_1$')]">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:when test="preceding-sibling::node()[1][matches(name(), 'img')]">
                <xsl:apply-templates />
            </xsl:when>
            
            <!--<xsl:when test="preceding-sibling::node()[1][matches(@class, '_2-Note$')] and 
                            *[1][name()='table']">
                <xsl:apply-templates />
            </xsl:when>-->
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>