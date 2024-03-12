<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    exclude-result-prefixes="xs son xsi functx"
    version="2.0">

    <xsl:import href="../00-commonVar.xsl" />

    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />
    <xsl:param name="srcDirs" />

    <xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
    <xsl:strip-space elements="*" />
    
    
    <xsl:variable name="srcDirs01" select="replace(replace(replace($srcDirs, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="concat('file:////', $srcDirs01)"  />
    <xsl:variable name="srcDirs03" select="iri-to-uri(concat($srcDirs02, '/temp/compare/', '?select=*.xml;recurse=no'))"  />
    <xsl:variable name="directory" select="collection($srcDirs03)" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <root>
            <xsl:for-each select="$directory/root/*">
                <xsl:variable name="parRoot" select="parent::*" />
                
                <xsl:if test="position() = 1">
                    <modelInfo>
                        <xsl:apply-templates select="$parRoot/@*" />
                        <xsl:attribute name="productType" select="$specXML/product/@type" />
                        <xsl:attribute name="opticalType" select="$specXML/optical/@name" />
                    </modelInfo>
                </xsl:if>
                
                <xsl:if test="@fileName">
                    <xsl:if test="not(matches(@fileName, '(bandmode|tur-wlan)$'))">
                        <!-- <xsl:choose>
                            <xsl:when test="following-sibling::*[1][@fileName='edoc2']">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()"/>

                                    <xsl:copy-of select="following-sibling::*[1][@fileName='edoc2']/div" />
                                </xsl:copy>
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose> -->
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </root>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:attribute name="desc">
                <xsl:choose>
                    <xsl:when test="matches(parent::doc/@fileName, 'packages-compare')">
                        <xsl:value-of select="if (preceding-sibling::*) then '' else @desc" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="@desc" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>

    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>
