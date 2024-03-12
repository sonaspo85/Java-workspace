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

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic">
        <topic>
            <xsl:apply-templates select="@*" />

            <xsl:variable name="UL1_1Note">
                <xsl:for-each-group select="*" group-adjacent="boolean(self::*[starts-with(@class, 'UL1_1-Note')])">
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

            <xsl:variable name="assign_UL1-Note">
                <xsl:for-each-group select="$UL1_1Note/*" group-adjacent="starts-with(@class, 'UL1-Note')">
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

            <xsl:variable name="before-after_UL1_1">
                <xsl:for-each-group select="$assign_UL1-Note/*" group-adjacent="boolean(self::*[matches(@class, '(Warning|Caution)')])">
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

            <xsl:for-each select="$before-after_UL1_1/*">
                <xsl:choose>
                    <xsl:when test="self::*[@class='UL1_1'][following-sibling::*[1][name()='before-after_UL1_1']]">
                        <xsl:variable name="cur" select="." />
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                            <xsl:copy-of select="$cur/following-sibling::*[1]/node()" />
                        </xsl:copy>
                    </xsl:when>
                    
                    <xsl:when test="self::*[name()='before-after_UL1_1']">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </topic>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>