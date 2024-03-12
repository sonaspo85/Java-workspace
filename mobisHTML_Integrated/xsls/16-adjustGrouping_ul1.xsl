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
    
    <xsl:template match="@class">
        <xsl:attribute name="class">
            <xsl:value-of select="replace(., '-UpSp', '')" />
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="topic[p|ul]">
        <topic>
            <xsl:apply-templates select="@*" />
            
            <xsl:variable name="str0">
                <xsl:for-each select="*">
                    <xsl:choose>
                        <xsl:when test="self::ul and 
                                        matches(@class, 'UL1-Note')">
                            <xsl:choose>
                                <xsl:when test="following-sibling::*[1][matches(name(),'^(img|table)$')] 
                                                /following-sibling::*[1][@class='UL1-Note']">
                                    <xsl:variable name="flw" select="following-sibling::*[1][matches(name(),'^(img|table)$')]" />
                                    
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*" />
                                        
                                        <xsl:for-each select="node()">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                                
                                                <xsl:if test="position()=last()">
                                                    <xsl:copy-of select="$flw"/>
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
                        </xsl:when>
                        
                        <xsl:when test="matches(name(),'^(img|table)$') and 
                                        preceding-sibling::*[1][@class='UL1-Note'] and 
                                        following-sibling::*[1][@class='UL1-Note']" />

                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="str1">
                <xsl:for-each-group select="$str0/*" group-adjacent="boolean(self::*[starts-with(@class, 'UL1_1-Note')])">
                    <xsl:choose>
                        <xsl:when test="current-group()[starts-with(@class, 'UL1_1-Note')]">
                            <ul>
                                <xsl:apply-templates select="current-group()/@class"/>
                                <xsl:apply-templates select="@* except @class"/>
                                
                                <xsl:if test="current-group()[last()][@video-before|@video-after]">
                                    <xsl:apply-templates select="current-group()[last()]/@*[matches(name(), 'video')]" />
                                </xsl:if>
                                
                                <xsl:apply-templates select="current-group()/node()"/>
                            </ul>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:variable name="str2">
                <xsl:for-each-group select="$str1/*" group-adjacent="starts-with(@class, 'UL1-Note')">
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
            </xsl:variable>

            <xsl:variable name="str3">
                <xsl:for-each-group select="$str2/*" group-adjacent="boolean(self::*[matches(@class, '(Warning|Caution)')])">
                    <xsl:choose>
                        <xsl:when test="current-group()[matches(@class, '(Warning|Caution)')] and 
                                        current-group()[preceding-sibling::*[1][@class='UL1_1']] and 
                                        current-group()[following-sibling::*[1][@class='UL1_1']]">
                            <before-after_UL1_1>
                                <xsl:apply-templates select="current-group()" />
                            </before-after_UL1_1>
                        </xsl:when>

                        <xsl:when test="current-group()[matches(@class, '(Warning|Caution)')] and 
                                        current-group()[preceding-sibling::*[1][@class='UL1_1']] and 
                                        current-group()[not(matches(name(), 'ul'))][not(following-sibling::*)]">
                            <before-after_UL1_1>
                                <xsl:apply-templates select="current-group()" />
                            </before-after_UL1_1>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:variable name="str4">
                <xsl:for-each select="$str3/*">
                    <xsl:choose>
                        <xsl:when test="self::*[@class='UL1_1']
                                        /following-sibling::*[1][name()='before-after_UL1_1']">
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" />
                                <xsl:copy-of select="following-sibling::*[1]/node()" />
                            </xsl:copy>
                        </xsl:when>
                        
                        <xsl:when test="self::*[name()='before-after_UL1_1']" />
                        
                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="str5">
                <xsl:for-each-group select="$str4/*" group-adjacent="starts-with(@class, 'nested')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <group>
                                <xsl:apply-templates select="current-group()"/>
                            </group>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:apply-templates select="$str5" />
        </topic>
    </xsl:template>

</xsl:stylesheet>