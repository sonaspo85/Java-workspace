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
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:variable name="cur" select="." />

        <xsl:variable name="tagname">
            <xsl:choose>
                <xsl:when test="matches(@class, 'chapter')">
                    <xsl:value-of select="'h1'" />
                </xsl:when>
                
                <xsl:when test="matches(@class, 'heading1')">
                    <xsl:value-of select="'h2'" />
                </xsl:when>

                <xsl:when test="matches(@class, 'heading2')">
                    <xsl:value-of select="'h3'" />
                </xsl:when>

                <xsl:when test="matches(@class, 'heading3')">
                    <xsl:value-of select="'h4'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="local-name(.)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$tagname}">
            <xsl:apply-templates select="@*" />

            <xsl:if test="@ast-id and @id">
                <xsl:attribute name="ast-id" select="concat(@ast-id, replace(@id, '^#', ''))" />
            </xsl:if>
            
            <xsl:for-each select="node()">
                

                <xsl:choose>
                    <xsl:when test="not(following-sibling::node()) and 
                                    self::br[@size]">
                    </xsl:when>

                    <xsl:when test="self::img and 
                                    not(following-sibling::node()) and 
                                    not(ancestor::td) and 
                                    not(matches($cur/@class, 'img'))">
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>

        <xsl:if test="node()[last()][local-name() = 'br'][@size]">
            <xsl:for-each select="1 to node()[last()]/@size">
                <br />
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="node()[last()][name()='img'] and 
                      not(ancestor::td) and 
                      not(matches($cur/@class, 'img'))">
            <xsl:copy-of select="node()[last()][name()='img']" />
        </xsl:if>

    </xsl:template>

    <xsl:template match="br">
        <xsl:choose>
            <xsl:when test="not(@size)">
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    

</xsl:stylesheet>


