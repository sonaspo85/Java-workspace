<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:preserve-space elements="p Content"/>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Table">
        <xsl:choose>
            <xsl:when test="starts-with(@AppliedTableStyle, 'video_manual')">
                <div class="{@AppliedTableStyle}">
                    <xsl:apply-templates select="Cell/node()" />
                </div>
            </xsl:when>
            
            <xsl:when test="starts-with(@AppliedTableStyle, 'Table_Video')">
                <div class="{@AppliedTableStyle}">
                    <xsl:apply-templates select="Cell/node()" />
                </div>
            </xsl:when>
            
            <xsl:when test="contains(@AppliedTableStyle, 'Table_Magnifier')">
                <xsl:apply-templates select="Cell/node()" />
            </xsl:when>
            
            <xsl:when test="matches(@AppliedTableStyle, '(Table_Symbol-Indent)')">
                <xsl:variable name="class">
                    <xsl:choose>
                        <xsl:when test="@class">
                            <xsl:value-of select="concat(@class, ' ', @AppliedTableStyle)" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="@class" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                    
                <div>
                    <xsl:attribute name="class" select="$class" />
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="Cell/node()" />
                </div>
            </xsl:when>
            
            <xsl:when test="matches(@AppliedTableStyle, '(^Table_Symbol$|^Table_Symbol-Vertical$|^Table_VR$|Table_Symbol-Indent)')">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@AppliedTableStyle, '(Table_Logo|Table_Warning)')">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="node() except Column" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="descendant-or-self::ph[contains(., 'NOTICE OF USE')]">
                <div class="en_center_area">
                    <xsl:apply-templates select="Cell/node()" />
                </div>
            </xsl:when>
            
            <xsl:when test="starts-with(@AppliedTableStyle, 'Table_Icon')">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@AppliedTableStyle, 'Table_Image_Text_noBorder')">
                <xsl:variable name="class" select="'Table_Image_Text_noBorder'" />
                
                <imgTxtGroup>
                    <xsl:choose>
                        <xsl:when test="@ColumnCount = '1'">
                            <xsl:attribute name="class" select="'nodeCnt-1'" />
                            <div class="{$class}">
                                <xsl:apply-templates select="Cell/node()" />
                            </div>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:variable name="cnt" select="count(descendant::Cell[@Name])" />
                            <xsl:attribute name="class" select="concat('nodeCnt-', $cnt div 2)" />
                            
                            <xsl:for-each-group select="Cell" group-by="tokenize(@Name, ':')[1]">
                                <div class="{$class}">
                                    <xsl:apply-templates select="current-group()/node()" />
                                </div>
                            </xsl:for-each-group>
                        </xsl:otherwise>
                    </xsl:choose>
                </imgTxtGroup>
            </xsl:when>
            
            <xsl:when test="starts-with(@AppliedTableStyle, 'Table_Image_Text')">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="starts-with(@AppliedTableStyle, 'Table_FAQ')">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="not(starts-with(@AppliedTableStyle, 'Table_Text'))">
                <xsl:apply-templates select="Cell/node()" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>