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
    
    <xsl:template match="para">
        <xsl:choose>
            <xsl:when test="child::br">
                <xsl:choose>
                    <xsl:when test="count(node()) = 1" />
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
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

    <xsl:template match="*[parent::*[matches(@class, 'table_screen')]]">
        <xsl:variable name="name" select="local-name(.)" />

        <xsl:choose>
            <xsl:when test="$name = 'cell'">
                <xsl:choose>
                    <xsl:when test="count(node()) = 1 and 
                                    child::para[@class = 'normalparagraphstyle']">
                    </xsl:when>

                    <!-- <xsl:when test="preceding-sibling::node()[1][$name='cell'][count(node()) = 1]
                                    /child::para[@class = 'normalparagraphstyle']">
                        <xsl:apply-templates />
                    </xsl:when> -->
                
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="matches($name, '(row|column)')">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="matches(@class, 'table_screen')">
                <xsl:apply-templates />
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
