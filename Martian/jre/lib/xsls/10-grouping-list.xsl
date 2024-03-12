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

    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>

        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="root" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="abc" />

            <xsl:variable name="str0">
                <xsl:for-each-group select="*" group-adjacent="matches(@class, 'UnorderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ul>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ul>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:variable name="var1">
                <xsl:for-each-group select="$str0/*" group-adjacent="matches(@class, '^OrderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ol>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ol>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:copy-of select="$var1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="td" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="abc" />

            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="matches(@class, 'UnorderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ul>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ul>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each-group select="$str0/node()" group-adjacent="matches(@class, '^OrderList')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ol>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </ol>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="abc" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="abc" />

            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="matches(@class, 'UnorderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ul>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ul>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each-group select="$str0/node()" group-adjacent="matches(@class, '^OrderList')">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <ol>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </ol>
                    </xsl:when>
                
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="abc" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="para[child::para[matches(lower-case(@class), 'orderlist')]]" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="abc" />

            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="matches(@class, 'UnorderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ul>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ul>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:variable name="str1">
                <xsl:for-each-group select="$str0/node()" group-adjacent="matches(@class, '^OrderList')">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ol>
                                <xsl:apply-templates select="current-group()" mode="abc" />
                            </ol>
                        </xsl:when>
                    
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="abc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:copy-of select="$str1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[matches(local-name(), '^(ul|ol)$')]">
        <xsl:copy>
            <xsl:attribute name="class" select="child::*[last()]/@class" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
