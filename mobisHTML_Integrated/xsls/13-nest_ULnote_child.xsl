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

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates select="." mode="abc"/>
        </xsl:variable>

        <xsl:apply-templates select="$str0/*" />
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="abc"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topic" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, '^UL2$')])">
                <xsl:choose>
                    <xsl:when test="current-group()[1][matches(@class, '^UL2$')]">
                        <ul class="UL2">
                            <xsl:apply-templates select="current-group()/node()" mode="abc"/>
                        </ul>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="abc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:variable name="current" select="." />
        
        <xsl:choose>
            <xsl:when test="parent::topic">
                <xsl:variable name="temp">
                    <xsl:choose>
                        <xsl:when test="@class='UL2_1-Note' and 
                                        following-sibling::*[1][@class='UL2_1-Note-Child']">
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$current/following-sibling::*[1]" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL2_1-Note-Child' and 
                                        preceding-sibling::*[1][@class='UL2_1-Note']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL2-Note' and 
                                        following-sibling::*[1][@class='UL2-Note-Child']">
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$current/following-sibling::*[1]" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL2-Note-Child' and 
                                        preceding-sibling::*[1][@class='UL2-Note']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='Step-UL1_1' and 
                                        following-sibling::*[1][@class='Step-UL1_2-Note']">
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$current/following-sibling::*[1]" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='Step-UL1_2-Note' and 
                                        preceding-sibling::*[1][@class='Step-UL1_1']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL1_1' and 
                                        following-sibling::*[1][@class='UL1_2-Note']">
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$current/following-sibling::*[1]" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL1_2-Note' and 
                                        preceding-sibling::*[1][@class='UL1_1']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL1_1' and 
                                        following-sibling::*[1][@class='UL2']">
                            <xsl:variable name="flw" select="following-sibling::*[1][@class='UL2']"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL2' and 
                                        preceding-sibling::*[1][@class='UL1_1']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='Step-UL1_2' and 
                                        following-sibling::*[1][@class='Step-UL1_3-Note']">
                            <xsl:variable name="flw" select="following-sibling::*[1][@class='Step-UL1_3-Note']"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        
                                        <xsl:if test="position()=last()">
                                            <xsl:choose>
                                                <xsl:when test="$flw/following-sibling::*[1][@class='Step-UL1_3-Note-Child']">
                                                    <xsl:variable name="flw2" select="$flw/following-sibling::*[1][@class='Step-UL1_3-Note-Child']"/>
                                                    
                                                    <ul>
                                                        <xsl:apply-templates select="$flw/@*" />
                                                        <xsl:for-each select="$flw/node()">
                                                            <xsl:copy>
                                                                <xsl:apply-templates select="@* | node()" />
                                                                <xsl:if test="position()=last()">
                                                                    <xsl:copy-of select="$flw2" />
                                                                </xsl:if>
                                                            </xsl:copy>
                                                        </xsl:for-each>
                                                    </ul>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:copy-of select="$flw" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='Step-UL1_3-Note' and 
                                        preceding-sibling::*[1][@class='Step-UL1_2']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="matches(@class, 'Step-UL1_3-Note-Child') and 
                            preceding-sibling::*[1][matches(@class, 'Step-UL1_3-Note')]
                            /preceding-sibling::*[1][matches(@class, 'Step-UL1_2')]">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="matches(@class, 'Step-UL1_3-Note') and
                                        following-sibling::*[1][matches(@class, '^Step-UL1_3-Note-Child$')]">
                            <xsl:variable name="flw" select="following-sibling::*[1][matches(@class, '^Step-UL1_3-Note-Child$')]"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="matches(@class, '^Step-UL1_3-Note-Child$') and 
                            preceding-sibling::*[1][matches(@class, 'Step-UL1_3-Note')]">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='Step-UL1_2-Note' and 
                                        following-sibling::*[1][matches(@class, '^Step-UL2_2-Note|Step-UL1_2-Note-Child$')]">
                            <xsl:variable name="flw" select="following-sibling::*[1][matches(@class, '^Step-UL2_2-Note|Step-UL1_2-Note-Child$')]"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="matches(@class, '^Step-UL2_2-Note|Step-UL1_2-Note-Child$') and 
                                        preceding-sibling::*[1][@class='Step-UL1_2-Note']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='Step-UL1_1' and 
                                        following-sibling::*[1][@class='UL1_2-Note']">
                            <xsl:variable name="flw" select="following-sibling::*[1][@class='UL1_2-Note']"/>
                            <ul>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL1_2-Note' and 
                                        preceding-sibling::*[1][@class='Step-UL1_1']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL1_1-Note' and 
                                        following-sibling::*[1][matches(@class, '^Step-UL2_1-Note|UL1_1-Note-Child$')]">
                            <xsl:variable name="flw" select="following-sibling::*[1][matches(@class, '^Step-UL2_1-Note|UL1_1-Note-Child$')]"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="matches(@class, '^Step-UL2_1-Note|UL1_1-Note-Child$') and 
                                        preceding-sibling::*[1][@class='UL1_1-Note']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL1_3' and 
                                        following-sibling::*[1][@class='UL1_4-Note']">
                            <xsl:variable name="flw" select="following-sibling::*[1][@class='UL1_4-Note']"/>
                            
                            <ul>
                                <xsl:apply-templates select="@*" />
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@* | node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$flw" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        
                        <xsl:when test="@class='UL1_4-Note' and 
                                        preceding-sibling::*[1][@class='UL1_3']">
                        </xsl:when>
                        <!-- ********************** -->
                        
                        <xsl:when test="@class='UL1_2-Note' and 
                                        preceding-sibling::*[1][matches(@class, 'Table_Symbol-Indent')]">
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:for-each select="$temp/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:when>
            
            <xsl:when test="parent::td">
                <xsl:choose>
                    <xsl:when test="@class='UL1_1' and 
                                    following-sibling::*[1][@class='UL2']">
                        <ul>
                            <xsl:apply-templates select="@*" />
                            
                            <xsl:for-each select="node()">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" />
                                    <xsl:if test="position()=last()">
                                        <xsl:copy-of select="$current/following-sibling::*[1]" />
                                    </xsl:if>
                                </xsl:copy>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    
                    <xsl:when test="@class='UL2' and 
                                    preceding-sibling::*[1][@class='UL1_1']">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
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

    <xsl:template match="div">
        <xsl:variable name="current" select="." />
        
        <xsl:choose>
            <xsl:when test="parent::topic">
                <xsl:variable name="temp">
                    <xsl:choose>
                        <xsl:when test="matches(@class, 'Table_Symbol-Indent') and 
                                        following-sibling::*[1][@class='UL1_2-Note']">
                            <div>
                                <xsl:apply-templates select="@*, node()" />

                                <xsl:copy-of select="following-sibling::*[1]" />
                            </div>
                        </xsl:when>
                        
                        <!-- ********************** -->
                        
                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@* | node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:for-each select="$temp/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>