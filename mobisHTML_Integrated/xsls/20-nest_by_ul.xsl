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
    
    <xsl:template match="topic[p|ul]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:variable name="str0">
                <xsl:for-each select="*">
                    <xsl:variable name="cur" select="." />
                    
                    <xsl:choose>
                        <xsl:when test="self::ul and 
                                        following-sibling::*[1][matches(@class, '(Description_3_2|Description_3-BlankNone)')]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                            
                            <xsl:apply-templates select="$cur/following-sibling::*[1]" />
                        </xsl:when>
                        
                        <xsl:when test="self::ul and 
                                        (following-sibling::*[1][name()='img'][starts-with(@class, 'nested')] or 
                                         following-sibling::*[1][matches(@class, 'Description_(2|3|4)')])">
                            
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*, node()" />
                                        <xsl:if test="position()=last()">
                                            <xsl:copy-of select="$cur/following-sibling::*[1]" />
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:when>
                        
                        <xsl:when test="self::img and 
                                        starts-with(@class, 'nested') and 
                                        preceding-sibling::*[1][name()='ul']" />
                        
                        <xsl:when test="following-sibling::*[1][matches(@class, '(Step-)?(Cmd-)?Description_(2|3|4)')]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:for-each select="node()">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*, node()" />
                                    </xsl:copy>
                                    
                                    <xsl:if test="position()=last()">
                                        <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, '(Step-)?(Cmd-)?Description_(2|3|4)')]" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:when>
                        
                        <xsl:when test="self::p and 
                                        matches(@class, '(Step-)?Description_(2|3|4)')" />
                            
                        <xsl:when test="self::group">
                            <xsl:apply-templates />
                        </xsl:when>
    
                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="str1">
                <xsl:for-each select="$str0/*">
                    <xsl:variable name="cur" select="." />
                    
                    <xsl:choose>
                        <xsl:when test="self::ul">
                            <xsl:choose>
                                <xsl:when test="matches(@class, '(^UL1_\d|Step-UL1_2$)') and
                                                following-sibling::*[1][matches(@class,'Step-Description-Note')]">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*" />
                                        <xsl:for-each select="node()">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                                
                                                <xsl:if test="position()=last()">
                                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class,'Step-Description-Note')]" />
                                                </xsl:if>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:copy>
                                </xsl:when>
                                
                                <xsl:when test="matches(@class, '^Step-UL1-Note$') and
                                                following-sibling::*[1][matches(@class, '^Step-UL2-Note$')]">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*" />
                                        <xsl:for-each select="node()">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                                
                                                <xsl:if test="position()=last()">
                                                    <xsl:copy-of select="$cur/following-sibling::node()[1][@class='Step-UL2-Note']" />
                                                </xsl:if>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:copy>
                                </xsl:when>
                                
                                <xsl:when test="matches(@class, '^Step-UL2-Note$') and
                                                preceding-sibling::*[1][name()='ul'][matches(@class, '^Step-UL1-Note$')]" />
                                
                                <xsl:otherwise>
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*, node()" />
                                    </xsl:copy>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <xsl:when test="self::p[matches(@class, 'Step-Description-Note')]
                                        /preceding-sibling::*[1][name()='ul'][matches(@class, '(^UL1_\d|Step-UL1_2$)')]" />
                        
                        <xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="str2">
                <xsl:for-each select="$str1/*">
                    <xsl:variable name="cur" select="." />
                
                    <xsl:choose>
                        <xsl:when test="self::ul">
                            <xsl:choose>
                                <xsl:when test="matches(@class, '^Step-UL1_2$') and 
                                                following-sibling::*[1][@class='Step-UL1-Note']">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*" />
                                        
                                        <xsl:for-each select="node()">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                                
                                                <xsl:if test="position()=last()">
                                                    <xsl:copy-of select="$cur/following-sibling::node()[1][@class='Step-UL1-Note']" />
                                                </xsl:if>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:copy>
                                </xsl:when>
                                
                                <xsl:when test="matches(@class, '^Step-UL1-Note$') and 
                                                preceding-sibling::*[1][name()='ul'][matches(@class, '^Step-UL1_2$')]" />
                                
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
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="str3">
                <xsl:for-each select="$str2/*">
                    <xsl:variable name="cur" select="." />
                    
                    <xsl:choose>
                        <xsl:when test="self::ul">
                            <xsl:choose>
                                <xsl:when test="matches(@class, '^Step-UL1_2$') and 
                                                following-sibling::*[1][matches(@class, '^(Step-)?UL1_3(-Note)$')]">
                                    <xsl:copy>
                                        <xsl:apply-templates select="@*" />
                                        
                                        <xsl:for-each select="node()">
                                            <xsl:copy>
                                                <xsl:apply-templates select="@*, node()" />
                                                
                                                <xsl:if test="position()=last()">
                                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, '^(Step-)?UL1_3(-Note)$')]" />
                                                </xsl:if>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:copy>
                                </xsl:when>
                                
                                <xsl:when test="matches(@class, '^(Step-)?UL1_3(-Note)$') and 
                                                preceding-sibling::*[1][name()='ul'][@class='Step-UL1_2']" />
                                
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
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:apply-templates select="$str3" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>