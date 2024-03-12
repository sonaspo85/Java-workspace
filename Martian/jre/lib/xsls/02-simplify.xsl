<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>
	
    
	<xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

	<xsl:template match="ParagraphStyleRange">
        <xsl:choose>
            <xsl:when test="matches(@class, '^(TOC\d|PageLang|PageNumber|Heading\d_NoTOC$)')" />

            <!-- <xsl:when test=" not(descendant::text())" /> -->
            
            <xsl:when test="matches(@class, 'NoTOC$') and 
                            ancestor::Story[last()]/following-sibling::*[1]/descendant::ParagraphStyleRange[1][matches(@class, '^TOC')]">
                <!-- TOC 페이지의 Contents 목차 삭제 -->
            </xsl:when>

            <xsl:when test="matches(@class, '_Cover$')" />

            <xsl:when test="matches(@class, 'Description') and 
                            following-sibling::*[1][local-name() = 'ParagraphStyleRange'][matches(@class, 'Empty')]
                            /descendant::Table[matches(@class, '\[No table style\]')]">
            </xsl:when>

            <xsl:when test="matches(@class, 'Empty')">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <para>
                    <xsl:apply-templates select="@*, node()" />
                </para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Table">
        <xsl:choose>
            <xsl:when test="matches(@class, '^(\[Basic Table\]|Table_WEEE)$')"/>

            <xsl:when test="matches(@class, 'Table_Description') and 
                            (preceding-sibling::*[1][matches(@class, 'Table_WEEE')] or 
                            preceding-sibling::*[2][matches(@class, 'Table_WEEE')])">
            </xsl:when>

            <xsl:when test="matches(@class, 'No table style') and 
                            parent::CharacterStyleRange[matches(@class, 'No character style')]
                            /parent::ParagraphStyleRange[matches(@class, 'Empty')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="name" select="if (matches(@class, 'Table_Screen')) then 'div' else local-name()" />
                
                <xsl:element name="{$name}">
                    <xsl:apply-templates select="@*" />

                    <xsl:if test="ancestor::ParagraphStyleRange[1][matches(@class, 'Empty')]">
                        <xsl:variable name="parCls" select="ancestor::ParagraphStyleRange[1][matches(@class, 'Empty')]/@class" />
                        <xsl:variable name="concatCls" select="concat(@class, ' ', $parCls)" />

                        <xsl:attribute name="class" select="$concatCls" />
                    </xsl:if>

                    <xsl:apply-templates select="node()" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>