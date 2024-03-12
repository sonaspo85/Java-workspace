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

    <xsl:key name="HyperSource" match="Hyperlink[@Source]" use="@Source" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '\s+', '&#x20;')" />
    </xsl:template>

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="ancestor::Table/@AppliedTableStyle[contains(., 'Table_Magnifier')]">
                <xsl:variable name="flw_inch" select="replace(lower-case(ancestor::Table[1]/@AppliedTableStyle), '\-text', '')" />
                
                <xsl:copy>
                    <xsl:attribute name="class" select="concat(@class, ' ', $flw_inch)" />
                    <xsl:apply-templates select="@* except @class" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="starts-with(@href, 'M-Note') and 
                            ends-with(ancestor::Table[1]/@class, 'Table_Symbol')">
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
                <xsl:if test="$RTLlgs">
                    <xsl:text>&#x200e;</xsl:text>
                </xsl:if>
                
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
                
                <xsl:if test="$RTLlgs">
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

    <xsl:template match="Oval" />
    
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
        <xsl:variable name="cur" select="." />
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
                            <xsl:value-of select="$cur" />
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
            
            <xsl:when test="matches(@class, 'C_URL') and .='%#%'" />

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

</xsl:stylesheet>