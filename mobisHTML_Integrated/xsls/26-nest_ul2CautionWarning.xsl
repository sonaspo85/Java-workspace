<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p"/>
    
    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="abc"/>
        </xsl:variable>
        <xsl:apply-templates select="$str0/*" />
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
    
    <!-- 'topic[ul|p]' 가 아니라 ul 로 템플릿을 매칭한 이유는
         UL1-Caution-Warning 의 부모가 topic 이 아니라, 
         ul이 부모가 오는 경우가 있기 때문에... -->
    <xsl:template match="ul" mode="abc">
        <xsl:variable name="cur" select="." />
        
        <xsl:choose>
            <xsl:when test="@class='UL1-Caution-Warning' and 
                            following-sibling::*[1][@class='UL2-Caution-Warning']">
                <xsl:variable name="flw" select="following-sibling::*[1][@class='UL2-Caution-Warning']" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*"  mode="abc"/>
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="abc" />
                            
                            <xsl:if test="position()=last()">
                                <xsl:copy-of select="$flw" />
                            </xsl:if>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="@class='UL2-Caution-Warning' and 
                            preceding-sibling::*[1][@class='UL1-Caution-Warning']">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="topic">
        <topic>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="*" group-adjacent="starts-with(@class, 'UL1-Caution-Warning')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ul>
                            <xsl:apply-templates select="current-group()/@class"/>
                            <xsl:apply-templates select="current-group()/node()"/>
                        </ul>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </topic>
    </xsl:template>
    
</xsl:stylesheet>