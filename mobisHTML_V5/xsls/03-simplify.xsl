<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:preserve-space elements="p Content"/>

    <xsl:variable name="data-language" select="/docs/substring-after(@data-language, '_')" />
    <xsl:variable name="dlrtl" select="matches($data-language, '(Ara|Far|Urdu)')" />

    <xsl:key name="HyperSource" match="Hyperlink[@Source]" use="@Source" />
    
    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '\s+', '&#x20;')" />
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="docs">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="docs/HyperlinkURLDestination | docs/Hyperlink">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="doc">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Story">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::Story">
                <xsl:choose>
                    <xsl:when test="ends-with(@class, 'Chapter-Num')">
                    </xsl:when>
                    
                    <xsl:when test="Table">
                        <xsl:apply-templates select="node()" />
                    </xsl:when>
                    
                    <xsl:when test="matches(@class, 'Chapter_Index_TOC') and 
                        following-sibling::*[1][matches(@class, 'Chapter-SupportTxt')]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="caption">
                                <xsl:value-of select="following-sibling::*[1]" />
                            </xsl:attribute>
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:when>
                    
                    <xsl:when test="matches(@class, 'Chapter-SupportTxt')">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="ancestor::*[matches(@class, 'Table_Video')]">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
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
            
            <xsl:when test="matches(@AppliedTableStyle, '(^Table_Symbol$|^Table_Symbol-Vertical$|^Table_VR$)')">
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

            <xsl:when test="current()[descendant-or-self::ph[contains(., 'NOTICE OF USE')]]">
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

    <xsl:template match="img[ancestor::Table/@AppliedTableStyle[contains(., 'Table_Magnifier')]]">
        <xsl:variable name="flw_inch" select="replace(lower-case(ancestor::Table[1]/@AppliedTableStyle), '\-text', '')" />
        
        <xsl:copy>
            <xsl:attribute name="class" select="concat(@class, ' ', $flw_inch)" />
            <xsl:apply-templates select="@* except @class" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="starts-with(@href, 'M-Note') and ends-with(ancestor::Table[1]/@class, 'Table_Symbol')">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="ends-with(@href, 'S-usb_connect.ai')">
                <xsl:copy>
                    <xsl:attribute name="class" select="tokenize(@class, ' ')[position() ne last()]" />
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="ends-with(@href, 'B-track_panel.ai') or 
                              ends-with(@href, 'B-seek_panel.ai')">
                <xsl:if test="$dlrtl">
                    <xsl:text>&#x200e;</xsl:text>
                </xsl:if>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                <xsl:if test="$dlrtl">
                    <xsl:text>&#x200e;</xsl:text>
                </xsl:if>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Oval">
    </xsl:template>

    <xsl:template match="Content">
        <xsl:choose>
            <xsl:when test=".=''">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="HyperlinkTextSource[not(parent::*[matches(@class, 'Chapter')])]">
        <xsl:variable name="CurrentSource" select="." />
        <xsl:variable name="self" select="@Self" />
        <xsl:variable name="DestinationKey" select="key('HyperSource', $self)/@DestinationUniqueKey" />
        
        <xsl:choose>
            <xsl:when test="matches(., '(^https?://?|^www.)')">
                <ph class="C_Noline">
                    <xsl:apply-templates />
                </ph>
            </xsl:when>
            
            <xsl:when test="key('HyperSource', $self)">
                <xsl:for-each select="/docs/HyperlinkURLDestination[@DestinationUniqueKey]">
                    <xsl:variable name="CurrentKey" select="@DestinationUniqueKey" />
                    <xsl:variable name="CurrentParent" select="@parentNode" />
                    <xsl:if test="$CurrentKey = $DestinationKey and 
                                  $CurrentParent = key('HyperSource', $self)/@parentNode">
                        <ph class="C_CrossReference" href="{@DestinationURL}">
                            <xsl:value-of select="$CurrentSource" />
                        </ph>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ph">
        <xsl:choose>
            <xsl:when test="parent::HyperlinkTextSource">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:when test="matches(@class, 'C_URL') and .='%#%'">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="br">
        <br/>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>