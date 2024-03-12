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
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:variable name="var0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::para[matches(@class, '_Indent\d')])">
                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '_Indent\d')][following-sibling::*[1][matches(@class, '_Indent\d')]]">
                            <div class="indentgroup1">
                                <xsl:apply-templates select="current-group()" />
                            </div>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each select="$var0/node()">
                <xsl:choose>
                    <xsl:when test="matches(@class, 'indentgroup1')">
                        <xsl:copy>
                            <xsl:apply-templates select="@*"/>

                            <xsl:for-each-group select="node()" group-adjacent="boolean(self::para[matches(@class, '_Indent2')])">
                                <xsl:choose>
                                    <xsl:when test="current-grouping-key()">
                                        <div class="indentgroup2">
                                            <xsl:apply-templates select="current-group()" />
                                        </div>
                                    </xsl:when>
                                
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="current-group()" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each-group>
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
