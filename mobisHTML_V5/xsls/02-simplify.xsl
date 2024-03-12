<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:son="http://www.astkorea1.net/"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs ast son functx"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>

    <xsl:variable name="data-language" select="/docs/substring-after(@data-language, '_')" />
    <xsl:variable name="compar-gt">
        <xsl:choose>
            <xsl:when test="matches($data-language, '(Ara|Far|Urdu)')">
                <xsl:variable name="cur" select="root()//Content[matches(., '^&gt;$')][parent::CharacterStyleRange]" />
                <xsl:choose>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/preceding-sibling::*[2][not(matches(., '[A-Za-z]+'))] and $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/following-sibling::*[2][not(matches(., '[A-Za-z]+'))]">
                        <xsl:text>◀</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/preceding-sibling::*[2][matches(., '[A-Za-z]+')] and $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/following-sibling::*[2][matches(., '[A-Za-z]+')]">
                        <xsl:text>&#x200e;▶&#x200e;</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '\P{IsBasicLatin}+')] and $cur/parent::*/following-sibling::*[1][matches(., '\P{IsBasicLatin}+')]">
                        <xsl:text>◀</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '[A-Za-z]+')] and $cur/parent::*/following-sibling::*[1]/*[matches(., '[A-Za-z]+')]">
                        <xsl:text>&#x200f;▶&#x200f;</xsl:text>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:text>&#x200f;◀&#x200f;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> ▶ </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="compar-lt">
        <xsl:choose>
            <xsl:when test="matches($data-language, '(Ara|Far|Urdu)')">
                <xsl:variable name="cur" select="root()//Content[matches(., '^&lt;$')][parent::CharacterStyleRange]" />
                <xsl:choose>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/preceding-sibling::*[2][not(matches(., '[A-Za-z]+'))] and $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/following-sibling::*[2][not(matches(., '[A-Za-z]+'))]">
                        <xsl:text>◀</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/preceding-sibling::*[2][matches(., '[A-Za-z]+')] and $cur/parent::*/following-sibling::*[1][matches(., '^\s+$')] and $cur/parent::*/following-sibling::*[2][matches(., '[A-Za-z]+')]">
                        <xsl:text>◀</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '\P{IsBasicLatin}+')] and $cur/parent::*/following-sibling::*[1][matches(., '\P{IsBasicLatin}+')]">
                        <xsl:text>◀</xsl:text>
                    </xsl:when>
                    <xsl:when test="$cur and $cur/parent::*/preceding-sibling::*[1][matches(., '[A-Za-z]+')] and $cur/parent::*/following-sibling::*[1]/*[matches(., '[A-Za-z]+')]">
                        <xsl:text>&#x200f;▶&#x200f;</xsl:text>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:text>&#x200f;◀&#x200f;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> ▶ </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
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
            <xsl:apply-templates select="@Source" />
            <xsl:apply-templates select="@DestinationURL" />
            <xsl:apply-templates select="@DestinationUniqueKey" />
            <xsl:apply-templates select="@parentNode" />
        	<xsl:apply-templates select="node()" />
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

    <xsl:template match="Story[ParagraphStyleRange[contains(@pStyle, 'TOC-Chapter')]]">
    </xsl:template>

    <xsl:template match="Story[matches(string(.), '^[a-z]$')]">
    </xsl:template>

    <xsl:template match="HyperlinkTextDestination | ParagraphDestination">
    </xsl:template>

    <xsl:template match="ParagraphStyleRange">
        <xsl:variable name="pStyle" select="@pStyle"/>
        <xsl:choose>
            <xsl:when test="starts-with(@pStyle, 'Image')">
                <xsl:apply-templates select="node()" />
            </xsl:when>

            <xsl:when test="Br[preceding-sibling::*[1][name()='Note']]">
                <xsl:for-each-group select="node()" group-ending-with="Br[preceding-sibling::*[1][name()='Note']]">
                    <p class="{$pStyle}">
                        <!--<xsl:if test="position() = 1">-->
                            <xsl:if test="descendant-or-self::HyperlinkTextDestination">
                                <xsl:attribute name="id" select="generate-id(.)" />
                                <xsl:attribute name="hd" select="concat('hd_', string-join(descendant-or-self::HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                            <xsl:if test="descendant-or-self::ParagraphDestination">
                                <xsl:attribute name="id" select="generate-id(.)" />
                                <xsl:attribute name="pd" select="concat('pd_', string-join(descendant-or-self::ParagraphDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                        <!--</xsl:if>-->
                        <xsl:for-each select="current-group()">
                            <xsl:choose>
                                <xsl:when test="name()='Table'">
                                    <xsl:if test=".//Content='NOTICE OF USE'">
                                        <xsl:apply-templates select="Table" />
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="name()='Content'">
                                    <xsl:apply-templates select="node()" />
                                </xsl:when>
                                <xsl:when test="self::Br[preceding-sibling::*[1][name()='Note']]">
                                </xsl:when>
                                <xsl:when test="name()='Br'">
                                    <br/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="." />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </p>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
                <p class="{@pStyle}">
                    <xsl:if test=".//HyperlinkTextDestination">
                        <xsl:attribute name="id" select="generate-id(.)" />
                        <xsl:attribute name="hd" select="concat('hd_', string-join(.//HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                    </xsl:if>
                    <xsl:if test=".//ParagraphDestination">
                        <xsl:attribute name="id" select="generate-id(.)" />
                        <xsl:attribute name="pd" select="concat('pd_', string-join(.//ParagraphDestination/@DestinationUniqueKey, ':'))" />
                    </xsl:if>

                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="name()='Table'">
                                <xsl:if test=".//Content='NOTICE OF USE'">
                                    <xsl:apply-templates select="Table" />
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="name()='Content'">
                                <xsl:apply-templates select="node()" />
                            </xsl:when>
                            <xsl:when test="self::Br[preceding-sibling::*[1][name()='Note']]">
                            </xsl:when>
                            <xsl:when test="name()='Br'">
                                <br/>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:apply-templates select="." />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </p>
                <xsl:apply-templates select="Table except Table[.//Content[matches(., '^NOTICE OF USE$')]]" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:choose>
            <xsl:when test="matches(., '(&lt;|&gt;)') and parent::*/parent::*[matches(@cStyle, 'Symbol')]">
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

    <xsl:template match="CharacterStyleRange">
        <xsl:variable name="current" select="." />
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="name()='Content'">
                    <xsl:if test="string(.)">
                        <ph class="{parent::CharacterStyleRange/@cStyle}">
                            <xsl:if test="$current//HyperlinkTextDestination">
                                <xsl:attribute name="id" select="concat('id_', generate-id(.))" />
                                <xsl:attribute name="hd" select="concat('hd_', string-join($current//HyperlinkTextDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                            <xsl:if test="$current//ParagraphDestination">
                                <xsl:attribute name="id" select="concat('id_', generate-id(.))" />
                                <xsl:attribute name="pd" select="concat('pd_', string-join($current//ParagraphDestination/@DestinationUniqueKey, ':'))" />
                            </xsl:if>
                            <xsl:apply-templates select="node()" />
                        </ph>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="name()='Br'">
                    <br/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="HyperlinkTextDestination[parent::CharacterStyleRange]">
    </xsl:template>

    <xsl:template match="Content[parent::HyperlinkTextSource]">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match="CrossReferenceSource/@AppliedFormat | CrossReferenceSource/@Name">
    </xsl:template>

    <xsl:template match="Br[parent::ParagraphStyleRange]">
    </xsl:template>

    <xsl:template match="Table">
        <xsl:copy>
            <xsl:if test="parent::ParagraphStyleRange">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1' and 
                                        matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text)')">
                            <xsl:value-of select="concat('nested ', @AppliedTableStyle)" />
                        </xsl:when>

                        <xsl:when test="substring-after(parent::ParagraphStyleRange/@pStyle, '%3a')='Empty_1'">
                            <xsl:value-of select="concat('unnest ', @AppliedTableStyle)" />
                        </xsl:when>

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
                            <xsl:when test="ancestor::Table/parent::ParagraphStyleRange">
                                <xsl:choose>
                                    <xsl:when test="ancestor::Table[1]/parent::ParagraphStyleRange[matches(@pStyle, 'Empty_1')]/following-sibling::*[1][name()='ParagraphStyleRange'][matches(@pStyle, 'Description_1-Center')]">
                                        <xsl:value-of select="concat('nested ', substring-after(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, '%3a'), ' ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                                    </xsl:when>

                                    <xsl:when test="ends-with(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, 'Empty_1') and 
                                                      ancestor::Table[1][matches(@AppliedTableStyle, '(Table_Magnifier-Text|Table_Magnifier_8inch-Text)')]">
                                        <xsl:value-of select="concat('nested ', substring-after(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, '%3a'), ' ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                                    </xsl:when>
                                    
                                    <xsl:when test="ends-with(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, 'Empty_1')">
                                        <xsl:value-of select="concat('unnest ', substring-after(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, '%3a'), ' ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('nested ', substring-after(ancestor::Table[1]/parent::ParagraphStyleRange/@pStyle, '%3a'), ' ', substring-after(parent::ParagraphStyleRange/@pStyle, '%3a'))" />
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
             <xsl:attribute name="href" select="ast:getName(@LinkResourceURI, '/')" />
        </img>
    </xsl:template>

    <xsl:template match="Note">
        <xsl:if test="descendant::Content[1][matches(lower-case(.), '(before|after)')]">
            <xsl:element name="video-content">
                <xsl:for-each select="ParagraphStyleRange//Content">
                    <xsl:variable name="cur" select="."/>
                    
                    <xsl:choose>
                        <xsl:when test="matches(., 'before')">
                            <xsl:attribute name="position">
                                <xsl:value-of select="'before'"/>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'after')">
                            <xsl:attribute name="position">
                                <xsl:value-of select="'after'"/>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'filename')">
                            <xsl:attribute name="data-import">
                                <!--<xsl:value-of select="tokenize(., ' ')[2]"/>-->
                                <xsl:choose>
                                    <xsl:when test="tokenize(., ' ')[2]">
                                        <xsl:value-of select="tokenize(., ' ')[2]"/>
                                    </xsl:when>
                                    <xsl:when test="not(tokenize(., ' ')[2]) and 
                                                    following-sibling::*[1][not(matches(., '^@'))]">
                                        <xsl:value-of select="following-sibling::*[1]" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="matches(., 'size')">
                            <xsl:attribute name="video-size">
                                <xsl:value-of select="tokenize(., ' ')[2]"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>

            </xsl:element>
        </xsl:if>
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
            <!--<xsl:when test="parent::CharacterStyleRange[matches(@cStyle, '^C_URL$')]">
                <xsl:apply-templates />
            </xsl:when>-->

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

    <xsl:function name="son:getpath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

</xsl:stylesheet>
