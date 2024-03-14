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

    <xsl:template match="*" priority="5">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and 
                            child::img">
                <xsl:choose>
                    <xsl:when test="not(ancestor::td) and 
                                    self::*[name()='p']">
                        <div>
                            <xsl:apply-templates select="@*" />
                            <xsl:apply-templates select="node()" />
                        </div>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="self::ul">
                <xsl:call-template name="defineul" />
            </xsl:when>

            <xsl:when test="self::ol">
                <xsl:call-template name="defineol" />
            </xsl:when>

            <xsl:when test="self::table">
                <xsl:call-template name="definetable" />
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@id">
        <xsl:attribute name="id" select="replace(., '^#', '')" />
    </xsl:template>

    <xsl:template name="definetable">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="class" select="replace(@class, 'Empty_Indent1', 'Empty')" />

            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template name="defineol">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="class" select="*[2]/@class" />

        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="class" select="$class" />

            <xsl:for-each select="node()">
                <xsl:variable name="pos" select="count(preceding-sibling::li) + 1" />
                
                <xsl:choose>
                    <xsl:when test="self::li">
                        <xsl:copy>
                            <xsl:apply-templates select="@* except @class"/>
                            <span>
                                <xsl:attribute name="class" select="concat('numbered_', $pos)" />
                                <xsl:value-of select="if (matches($class, '_0\d')) then format-number($pos, '00') else $pos" />
                            </span>
                            
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="defineul">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="class" select="@class" />
        <xsl:variable name="symbol">
            <xsl:choose>
                <xsl:when test="matches($class, '(_Indent1$)')">
                    <xsl:value-of select="'- '" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="'• '" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="class" select="*[1]/@class" />

            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::li">
                        <xsl:copy>
                            <xsl:apply-templates select="@* except @class"/>
                            <xsl:value-of select="$symbol" />
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
