<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="title li p" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ul">
        <xsl:variable name="current" select="." />
        
        <xsl:choose>
            <xsl:when test="parent::topic and 
                            matches(@class,'^UL1(_\d)?-Note$') and 
                            following-sibling::*[1][matches(@class, '^UL2(_\d)-Note$')]">
                <xsl:variable name="flw" select="following-sibling::*[1][matches(@class, '^UL2(_\d)-Note$')]" />
                
                <ul>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                            <xsl:if test="position()=last()">
                                <ul>
                                    <xsl:apply-templates select="$flw/@class" />
                                    <xsl:copy-of select="$flw/node()" />
                                </ul>
                            </xsl:if>
                        </xsl:copy>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            
            <xsl:when test="parent::topic and 
                            matches(@class, '^UL2(_\d)-Note$') and 
                            preceding-sibling::*[1][matches(@class,'^UL1(_\d)?-Note')]">
            </xsl:when>
            <!-- ********************** -->
            
            <xsl:when test="parent::topic and 
                            matches(@class,'^UL1_2$') and 
                            following-sibling::*[1][@class='UL1_3-Note']">
                <xsl:variable name="flw" select="following-sibling::*[1][@class='UL1_3-Note']" />
                
                <ul>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                            <xsl:if test="position()=last()">
                                <ul>
                                    <xsl:apply-templates select="$flw/@class" />
                                    <xsl:copy-of select="$flw/node()" />
                                </ul>
                            </xsl:if>
                        </xsl:copy>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            
            <xsl:when test="parent::topic and 
                            matches(@class, '^UL1_3-Note$') and 
                            preceding-sibling::*[1][matches(@class,'^UL1_2$')]">
            </xsl:when>
            <!-- ********************** -->
            
            <xsl:when test="matches(@class, '^UL1_2-Note$') and 
                            ancestor::ul/following-sibling::*[1][matches(@class, '^UL2_2-Note$')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:copy-of select="ancestor::ul[1]/following-sibling::*[1]" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@class, '^UL2_2-Note$') and 
                            preceding-sibling::*[1][descendant::*[last()][matches(@class, 'UL1_2-Note')]]">
            </xsl:when>
            <!-- ********************** -->
            <xsl:when test="matches(@class, '^UL2$') and 
                ancestor::ul/following-sibling::*[1][matches(@class, '^UL1_3_2-Note$')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:copy-of select="ancestor::ul[1]/following-sibling::*[1]" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="parent::topic and 
                            matches(@class, '^UL1_3_2-Note$') and 
                            preceding-sibling::*[1]/descendant::ul[last()][matches(@class,'^UL2$')]">
            </xsl:when>
            <!-- ********************** -->
            
            <xsl:when test="matches(@class, '^UL2$') and 
                ancestor::ul/following-sibling::*[1][matches(@class, '^UL1_2-Note$')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                <xsl:copy-of select="ancestor::ul[1]/following-sibling::*[1]" />
            </xsl:when>
            
            <xsl:when test="parent::topic and 
                            matches(@class, '^UL1_2-Note$') and 
                            preceding-sibling::*[1]/descendant::ul[last()][matches(@class,'^UL2$')]">
            </xsl:when>
            <!-- ********************** -->
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>