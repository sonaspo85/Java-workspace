<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p Content ph"/>

    <xsl:key name="hyperlinks" match="Hyperlink" use="@Source" />
    <xsl:variable name="elms" select="//*[@hd or @pd]" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="docs">
        <body>
            <xsl:apply-templates  select="@*"/>
            <xsl:apply-templates />
        </body>
    </xsl:template>

    <xsl:template match="docs/HyperlinkURLDestination">
    </xsl:template>

    <xsl:template match="docs/Hyperlink">
    </xsl:template>

    <xsl:template match="doc">
        <chapter idml="{substring-before(@idml, '.idml')}">
            <xsl:apply-templates />
        </chapter>
    </xsl:template>

    <xsl:template match="Story">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="*[parent::*[@class='video_manual']]">
        <xsl:copy>
            <xsl:attribute name="videoGroup" select="'video_manual'" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Table" priority="10">
        <xsl:variable name="current" select="." />
        
        <table>
            <xsl:apply-templates select="@class, @tableSize" />
            <colgroup>
                <xsl:variable name="t_width" select="sum(Column/@SingleColumnWidth)" as="xs:double" />
                <xsl:for-each select="Column">
                    <col>
                        <xsl:attribute name="width">
                            <xsl:choose>
                                <xsl:when test="$current/@tableSize">
                                    <xsl:value-of select="$current/@tableSize" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(round(@SingleColumnWidth div $t_width * 100), '%')" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </col>
                </xsl:for-each>
            </colgroup>
            <xsl:if test="@HeaderRowCount=1">
                <thead>
                    <tr>
                        <xsl:for-each select="$current/Cell[number(tokenize(@Name, ':')[2])=0]">
                            <th>
                                <xsl:if test="@RowSpan &gt; 1">
                                    <xsl:attribute name="rowspan" select="@RowSpan" />
                                </xsl:if>
                                <xsl:if test="@ColumnSpan &gt; 1">
                                    <xsl:attribute name="colspan" select="@ColumnSpan" />
                                </xsl:if>
                                <xsl:apply-templates />
                            </th>
                        </xsl:for-each>
                    </tr>
                </thead>
            </xsl:if>

            <tbody>
                <xsl:variable name="start" select="if (@HeaderRowCount=1) then 0 else 1" as="xs:integer" />
                <xsl:for-each select="1 to @BodyRowCount">
                    <xsl:variable name="row" select="." as="xs:integer" />
                    <tr>
                        <xsl:for-each select="$current/Cell[number(tokenize(@Name, ':')[last()])=$row - $start]">
                            <td>
                                <xsl:if test="@AppliedCellStyle='Cell_TableBody-Left'">
                                    <xsl:attribute name="class">bgc-gray</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="@RowSpan &gt; 1">
                                    <xsl:attribute name="rowspan" select="@RowSpan" />
                                </xsl:if>
                                <xsl:if test="@ColumnSpan &gt; 1">
                                    <xsl:attribute name="colspan" select="@ColumnSpan" />
                                </xsl:if>
                                <xsl:apply-templates />
                            </td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="*[parent::Story]">
        <xsl:choose>
            <xsl:when test="self::p[img][count(node())=1]">
                <xsl:apply-templates select="node()" />
            </xsl:when>

            <xsl:when test="self::div[@class='video_manual']">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Cell/@Self">
    </xsl:template>

    <xsl:template match="ph">
        <xsl:choose>
            <xsl:when test=".='&#x20;'">
                <xsl:text>&#x20;</xsl:text>
            </xsl:when>
            
            <xsl:when test="matches(@class, '(^C_Button$|^C_URL$|^C_LtoR$|^C_MMI_LtoR$|^C_Superscript-R-TM$|^C_MMI_NoBold_LtoR$|^C_Below_Description_LtoR$|^C_Below_Heading_LtoR$|^C_Noline$)')">
                <span>
                    <xsl:if test="root()/docs[matches(@data-language, 'Ara')]">
                        <xsl:attribute name="dir" select="'ltr'" />
                    </xsl:if>
                    <xsl:apply-templates select="@*, node()" />
                </span>
            </xsl:when>

            <xsl:otherwise>
                <span>
                    <xsl:apply-templates select="@* | node()" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@class">
        <xsl:attribute name="class" select="if ( contains(., '%3a' ) ) then substring-after(., '%3a') else ." />
    </xsl:template>

    <xsl:template match="HyperlinkTextSource">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="img/@href">
        <xsl:attribute name="src" select="concat('contents/images/', replace(replace(., '\.ai$', '.png'), '\.psd', '.png'))" />
    </xsl:template>

    <xsl:template match="CrossReferenceSource[string(.)]">
        <xsl:variable name="key" select="key('hyperlinks', @Self)/@DestinationUniqueKey" />
        <xsl:variable name="val" select="normalize-space(.)" />
        <xsl:variable name="id">
            <xsl:for-each select="$key">
                <xsl:variable name="this" select="." />
                <xsl:for-each select="($elms[contains(@hd, $this)], $elms[contains(@pd, $this)])">
                    <xsl:if test="normalize-space(.)=$val">
                        <xsl:value-of select="@id"/>
                    </xsl:if>
                    <xsl:text>:</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        
        <a href="{concat('#', distinct-values(tokenize($id, ':')[.!=''])[1])}">
            <xsl:value-of select="." />
        </a>
    </xsl:template>

    <xsl:template match="@hd | @pd">
    </xsl:template>

    <xsl:template match="CrossReferenceSource[preceding-sibling::node()[1][name()='ph'][@class='C_CrossReference'][.='p.']]">
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>