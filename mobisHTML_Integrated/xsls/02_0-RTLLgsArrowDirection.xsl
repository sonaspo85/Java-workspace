<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs ast son functx"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>


    <xsl:variable name="compar-gt">
        <xsl:choose>
            <xsl:when test="matches($language, '(Ara|Far|Urdu|Heb)')">
                <xsl:variable name="cur" select="root()//Content[matches(., '^&gt;$')][parent::CharacterStyleRange]" />
                
                <xsl:choose>
                    <xsl:when test="$cur">
                        <xsl:choose>
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/preceding-sibling::*[2][not(matches(., '[A-Za-z]+'))] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/following-sibling::*[2][not(matches(., '[A-Za-z]+'))]">
                                <xsl:text>&#x25C0;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and
                                            $cur/parent::*/preceding-sibling::*[2][matches(., '[A-Za-z]+')] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/following-sibling::*[2][matches(., '[A-Za-z]+')]">
                                <xsl:text>&#x200e;&#x25B6;&#x200e;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '\P{IsBasicLatin}+')] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '\P{IsBasicLatin}+')]">
                                <xsl:text>&#x25C0;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '[A-Za-z]+')] and 
                                            $cur/parent::*/following-sibling::*[1]/*[matches(., '[A-Za-z]+')]">
                                <xsl:text>&#x200f;&#x25B6;&#x200f;</xsl:text>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:text>&#x200f;&#x25C0;&#x200f;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:text>&#x200f;&#x25C0;&#x200f;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:text> &#x25B6; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="compar-lt">
        <xsl:choose>
            <xsl:when test="matches($language, '(Ara|Far|Urdu|Heb)')">
                <xsl:variable name="cur" select="root()//Content[matches(., '^&lt;$')][parent::CharacterStyleRange]" />
                
                <xsl:choose>
                    <xsl:when test="$cur">
                        <xsl:choose>
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/preceding-sibling::*[2][not(matches(., '[A-Za-z]+'))] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/following-sibling::*[2][not(matches(., '[A-Za-z]+'))]">
                                <xsl:text>&#x25C0;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/preceding-sibling::*[2][matches(., '[A-Za-z]+')] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and 
                                            $cur/parent::*/following-sibling::*[2][matches(., '[A-Za-z]+')]">
                                <xsl:text>&#x25C0;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '\P{IsBasicLatin}+')] and 
                                            $cur/parent::*/following-sibling::*[1][matches(., '\P{IsBasicLatin}+')]">
                                <xsl:text>&#x25C0;</xsl:text>
                            </xsl:when>
                            
                            <xsl:when test="$cur/parent::*/preceding-sibling::*[1][matches(., '[A-Za-z]+')] and 
                                            $cur/parent::*/following-sibling::*[1]/*[matches(., '[A-Za-z]+')]">
                                <xsl:text>&#x200f;&#x25B6;&#x200f;</xsl:text>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:text>&#x200f;&#x25C0;&#x200f;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:text>&#x200f;&#x25C0;&#x200f;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:text> &#x25B6; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" priority="10">
        <xsl:choose>
            <xsl:when test="matches(., '(&lt;|&gt;)') and 
                            parent::*/parent::*[matches(@cStyle, 'Symbol')]">
                <xsl:analyze-string select="." regex="(&gt;|&lt;)">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="regex-group(1) = '&gt;'">
                                <xsl:value-of select="replace(., regex-group(1), $compar-gt)" />
                            </xsl:when>
                            
                            <xsl:when test="regex-group(1) = '&lt;'">
                                <xsl:value-of select="replace(., regex-group(1), $compar-lt)" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="docs/HyperlinkURLDestination | docs/Hyperlink">
        <xsl:copy>
            <xsl:apply-templates select="@Source" />
            <xsl:apply-templates select="@DestinationURL" />
            <xsl:apply-templates select="@DestinationUniqueKey" />
            <xsl:apply-templates select="@parentNode" />
        	<xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Story">
        <xsl:choose>
            <xsl:when test="ParagraphStyleRange[contains(@pStyle, 'TOC-Chapter')]" />
            <xsl:when test="matches(string(.), '^[a-z]$')" />

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="CrossReferenceSource/@AppliedFormat | CrossReferenceSource/@Name" />
    
    <xsl:template match="CharacterStyleRange">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and 
                            child::Br">
                <xsl:choose>
                    <xsl:when test="matches(@cStyle, '^C_')">
                        <Br />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        
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
    
    <xsl:template match="ParagraphStyleRange">
        <xsl:choose>
            <xsl:when test="matches(@pStyle, 'Chapter_Index_TOC%3aTOC\d$')">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
