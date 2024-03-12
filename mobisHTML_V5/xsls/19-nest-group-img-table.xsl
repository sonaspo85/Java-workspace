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

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@class[parent::p][.='nested Description_1-Center']">
        <xsl:attribute name="class" select="replace(., 'nested ', '')" />
    </xsl:template>

    <xsl:template match="img/@class[matches(., 'nested Empty_(2|3)')]">
        <xsl:choose>
            <xsl:when test="ends-with(., 'magnifier')">
                <xsl:attribute name="class">block magnifier</xsl:attribute>
            </xsl:when>

            <xsl:when test="ends-with(., 'magnifier_8inch')">
                <xsl:attribute name="class">block magnifier_8inch</xsl:attribute>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="class">block</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="table">
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
                        
                        <xsl:when test="ends-with(@class, 'Table_Symbol') and tbody/count(tr)=1">
                            <xsl:attribute name="class" select="concat(@class, ' tsone')" />
                        </xsl:when>
                        
                        <xsl:when test="ends-with(@class, 'Table_Symbol') and tbody/count(tr) &gt; 1">
                            <xsl:attribute name="class" select="concat(@class, ' tstwo')" />
                        </xsl:when>
                        
                        <xsl:when test="ends-with(@class, 'Table_Symbol-Vertical') and count(tbody/tr)=4">
                            <xsl:attribute name="class" select="concat(@class, ' tsfour')" />
                        </xsl:when>
                        
                        <xsl:when test="ends-with(@class, 'Table_Symbol-Vertical') and count(tbody/tr)=10">
                            <xsl:attribute name="class" select="concat(@class, ' tsten')" />
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
            <xsl:when test=".=parent::tr/preceding-sibling::tr/td[@rowspan]">
            </xsl:when>
            
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

    <xsl:template match="title[parent::topic][following-sibling::*[1][name()='group']]" priority="10">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
        <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']/node()" />
    </xsl:template>

    <xsl:template match="ul[parent::topic][@class='UL1-White'][following-sibling::*[1][name()='p'][@class='Description-Symbol']][following-sibling::*[2][name()='group']]">
        <xsl:variable name="current" select="." />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="position()=last()">
                    <xsl:apply-templates select="$current/following-sibling::node()[2][name()='group']/node()" />
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[parent::topic][name()!='topic'][following-sibling::*[1][name()='group']]" priority="20">
        <xsl:variable name="current" select="." />
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][name()='ul'][@class='UL1-White'][following-sibling::*[1][name()='group']]">
            </xsl:when>

            <xsl:when test="current()[name()='ul' or name()='ol'][matches(@class, 'Step-UL1_2-Note')][following-sibling::*[1][name()='group']][following-sibling::*[2][name()='ul' or name()='ol'][matches(@class, 'Step-UL1_2-Note')]]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']/node()" />
            </xsl:when>
            
            <xsl:when test="current()[name()='ul' or name()='ol'][ends-with(@class, '-Note')][following-sibling::*[1][name()='group']/count(img) &gt; 1]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                <same-level>
                    <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']/node()" />
                </same-level>
            </xsl:when>

            <xsl:when test="current()[name()='ul' or name()='ol']">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                            <xsl:if test="position()=last() and 
                                          ancestor::*[name()='ul' or name()='ol'][not(matches(@class, 'Step\-UL1_1'))]">
                                <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']/node()" />
                            </xsl:if>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                        <xsl:if test="position()=last()">
                            <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']/node()" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[parent::topic][name()='group']">
        <xsl:choose>
            <xsl:when test="count(*) &gt; 1 and 
                            preceding-sibling::node()[1][matches(@class, 'Step\-UL1_1$')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="preceding-sibling::node()[1][matches(@class, 'Step\-UL1_1$')]">
                <xsl:apply-templates />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>