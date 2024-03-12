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
    
    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:sequence select="ast:group(*, 1)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:function name="ast:group" as="element()*">
        <xsl:param name="elements" as="element()*" />
        <xsl:param name="level" as="xs:integer" />

        <xsl:for-each-group select="$elements" group-starting-with="*[local-name() eq concat('h', $level)]">
            <xsl:choose>
                <xsl:when test="self::*[local-name() eq concat('h', $level)]">
                    <xsl:variable name="name" select="if ($level = 1) then 'section' else 'div'" />
                    <xsl:element name="{$name}">
                        <xsl:if test="$level = 1">
                            <xsl:attribute name="file">
                                <xsl:variable name="pos" select="count(preceding::h1) + 1" />
                                <xsl:value-of select="concat('content', $pos, '.html')" />
                            </xsl:attribute>
                        </xsl:if>

                        <xsl:if test="$level = 2">
                            <xsl:attribute name="class" select="'Heading1'" />
                            <xsl:attribute name="data-class" select="'Heading1'" />
                        </xsl:if>

                        <xsl:if test="$level = 3">
                            <xsl:attribute name="class" select="'Heading2'" />
                            <xsl:attribute name="data-class" select="'Heading2'" />
                        </xsl:if>

                        <xsl:for-each select="current-group()[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*"/>
                                
                                <xsl:if test="$level = 1">
                                    <img src="./img/title_icon.png" alt="" />
                                </xsl:if>

                                <xsl:if test="$level = 2">
                                    <xsl:attribute name="class" select="concat(@class, ' shap-target remove-space')" />
                                </xsl:if>

                                <xsl:apply-templates select="node()"/>
                            </xsl:copy>
                        </xsl:for-each>

                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </xsl:element>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:function>

</xsl:stylesheet>
