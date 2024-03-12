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


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Table">
        <xsl:variable name="cur" select="." />
        
        <xsl:copy>
            <xsl:if test="parent::ParagraphStyleRange">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <!--<xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1' and 
                                        matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text|Table_Text-UpSp)')">
                            <xsl:value-of select="concat('nested ', @AppliedTableStyle)" />
                        </xsl:when>-->
                        
                        <xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1'">
                            <xsl:choose>
                                <xsl:when test="matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text)')">
                                    <xsl:value-of select="concat('nested ', @AppliedTableStyle)" />
                                </xsl:when>
                                
                                <xsl:when test="matches(@AppliedTableStyle, 'Table_Text-UpSp')">
                                    <xsl:variable name="str0">
                                        <xsl:for-each select="descendant::Cell">
                                            <xsl:variable name="col" select="number(tokenize(@Name, ':')[1])" />
                                            <xsl:variable name="row" select="number(tokenize(@Name, ':')[2])" />
                                            
                                            <xsl:if test="$row >= 1 and $col = 0 and 
                                                          ParagraphStyleRange[count(node()) = 1]/Link">
                                                <xsl:sequence select="." />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="count($str0/*) > 1">
                                            <xsl:value-of select="concat('nested ', @AppliedTableStyle)" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('unnest ', @AppliedTableStyle)" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('unnest ', @AppliedTableStyle)" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <!--<xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1' and 
                            matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text)')">
                            <xsl:value-of select="concat('nested ', @AppliedTableStyle)" />
                        </xsl:when>

                        <xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1'">
                            <xsl:value-of select="concat('unnest ', @AppliedTableStyle)" />
                        </xsl:when>-->

                        <xsl:otherwise>
                            <xsl:value-of select="concat('nested ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Link">
        <img>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="parent::CharacterStyleRange">
                        <xsl:choose>
                            <xsl:when test="parent::*/Content[not(matches(., '^\s+$'))]">
                                <xsl:value-of select="'C_Image'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="parent::CharacterStyleRange/@cStyle" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    
                    <xsl:when test="parent::ParagraphStyleRange">
                        <xsl:choose>
                            <xsl:when test="parent::*/Content[not(matches(., '^\s+$'))]">
                                <xsl:value-of select="'C_Image'" />
                            </xsl:when>
                            
                            <xsl:when test="ancestor::Table[1]/parent::ParagraphStyleRange">
                                <xsl:variable name="ancesPSR" select="ancestor::Table[1]/parent::ParagraphStyleRange" />
                                <xsl:variable name="vals" select="concat(substring-after($ancesPSR/@pStyle, '%3a'), ' ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                                
                                <xsl:choose>
                                    <xsl:when test="ends-with($ancesPSR/@pStyle, 'Empty_1')">
                                        <xsl:choose>
                                            <xsl:when test="$ancesPSR/following-sibling::*[1][name()='ParagraphStyleRange'][matches(@pStyle, 'Description_1-Center')]">
                                                <xsl:value-of select="concat('nested ', $vals)" />
                                            </xsl:when>
                                            
                                            <xsl:when test="ancestor::Table[1][matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text)')]"> 
                                                <xsl:value-of select="concat('nested ', $vals)" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('unnest ', $vals)" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('nested ', $vals)" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                 <xsl:value-of select="if (substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1') then 
                                                       'unnest Empty_1' else 
                                                       concat('nested ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:attribute name="href" select="ast:getNameLast(@LinkResourceURI, '/')" />
        </img>
    </xsl:template>

    <xsl:template match="HyperlinkTextSource">
        <xsl:choose>
            <xsl:when test="parent::CharacterStyleRange[matches(@cStyle, '^C_URL$')]">
                <xsl:if test="string(normalize-space(.))">
                    <ph class="{parent::CharacterStyleRange/@cStyle}">
                        <xsl:apply-templates select="node()" />
                    </ph>
                </xsl:if>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Content[parent::HyperlinkTextSource]">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    
</xsl:stylesheet>
