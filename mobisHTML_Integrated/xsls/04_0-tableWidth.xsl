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

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Table">
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
                        <xsl:for-each select="$current/Cell[number(tokenize(@Name, ':')[last()]) = $row - $start]">
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

</xsl:stylesheet>