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

    <xsl:template match="table">
        <xsl:variable name="trCnt" select="count(tbody/tr)" />
        
        <xsl:choose>
            <xsl:when test="matches(@class, '(Table_Logo|Table_Warning)')">
                <div>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select=".//td">
                        <xsl:choose>
                            <xsl:when test="position()=1">
                                <xsl:apply-templates select="node()" />
                            </xsl:when>
                            
                            <xsl:when test="position()=2">
                                <ul>
                                    <xsl:for-each select="*">
                                        <li>
                                            <xsl:apply-templates select="node()" />
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="starts-with(@class, 'nested')">
                            <xsl:attribute name="class">block</xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="ends-with(@class, 'Table_Symbol-Vertical') and
                                        $trCnt &gt; 1">
                            <xsl:attribute name="class" select="concat(@class, ' tr-', $trCnt)" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:attribute name="class" select="@class" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tr[ancestor::table[ends-with(@class, 'Table_VR')]]/td[@rowspan]">
        <xsl:variable name="value" select="." />
        
        <xsl:choose>
            <xsl:when test=".=parent::tr/preceding-sibling::tr/td[@rowspan]" />
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="rowspan">
                        <xsl:value-of select="@rowspan + sum(parent::tr/following-sibling::tr/td[@rowspan][.=$value]/@rowspan)" />
                    </xsl:attribute>
                    
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>