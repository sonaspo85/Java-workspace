<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="scoredb" select="root/scoreDB" />
    <xsl:key name="tagid" match="root/*" use="local-name()" />
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:variable name="basePoint">
        <root>
            <xsl:for-each select="$scoredb/div">
                <xsl:variable name="class" select="@class" />
                
                <xsl:if test="key('tagid', $class)">
                    <div>
                        <xsl:attribute name="id" select="key('tagid', $class)/@id" />
                        
                        <xsl:choose>
                            <xsl:when test="matches($class, 'competitive_price')">
                                <p id="0">
                                    <xsl:value-of select="@basepoint" />
                                </p>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:for-each select="child::div">
                                    <p>
                                        <xsl:attribute name="id" select="@id" />
                                        <xsl:value-of select="@basepoint" />
                                    </p>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </xsl:for-each>
        </root>
    </xsl:variable>
    
    <xsl:template match="item">
        <xsl:variable name="parID" select="ancestor::*[parent::root]/@id" />
        <xsl:variable name="itemID">
            <xsl:choose>
                <xsl:when test="ancestor::*[matches(name(), '(competitive_price|automation|quality|delivery_compliance)')]">
                    <xsl:value-of select="@id" />
                </xsl:when>
                
                <xsl:when test="ancestor::*[matches(name(), '(safety)')]">
                    <xsl:value-of select="parent::grouped/@id" />
                </xsl:when>
                
                <xsl:when test="ancestor::*[matches(name(), '(satisfy)')]">
                    <xsl:value-of select="0" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="ancestor::*[matches(name(), '(competitive_price|automation|safety|quality|delivery_compliance|satisfy)')][parent::root]">
                <xsl:variable name="percent">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[matches(name(), '(competitive_price|automation|quality|delivery_compliance)')]">
                            <xsl:value-of select="number(replace(@*[matches(local-name(), 't\dcell2')], '\s?%', ''))" />
                        </xsl:when>
                        
                        <xsl:when test="ancestor::*[matches(name(), '(safety)')]">
                            <xsl:value-of select="number(replace(@*[matches(local-name(), 't\dcell3')], '\s?%', ''))" />
                        </xsl:when>
                        
                        <xsl:when test="ancestor::*[matches(name(), '(satisfy)')]">
                            <xsl:value-of select="number(replace(parent::items/@percentage, '\s?%', ''))" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="base" select="$basePoint/root/div[@id = $parID]/p[@id = $itemID]" />
                
                <xsl:variable name="gap" select="round($percent div $base)" />
                
                <xsl:variable name="rank">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[matches(name(), '(competitive_price|automation|quality|delivery_compliance)')]">
                            <xsl:value-of select="@ranking - 1" />
                        </xsl:when>
                        
                        <xsl:when test="ancestor::*[matches(name(), '(safety)')]">
                            <xsl:value-of select="parent::grouped/@ranking - 1" />
                        </xsl:when>
                        
                        <xsl:when test="ancestor::*[matches(name(), '(satisfy)')]">
                            <xsl:value-of select="parent::items/@ranking - 1" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="mul" select="$gap * $rank" />
                <xsl:variable name="curPercent" select="round($percent - $mul)" />
                
                
                <xsl:copy>
                    <xsl:attribute name="percent" select="$curPercent" />
                    
                    <!--<xsl:attribute name="per" select="$percent" />
                    <xsl:attribute name="base" select="$base" />
                    <xsl:attribute name="gap" select="$gap" />
                    <xsl:attribute name="mul" select="$mul" />-->
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="scoreDB">
    </xsl:template>

</xsl:stylesheet>