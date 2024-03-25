<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="emptyTRDelete">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="emptyTRDelete" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates select="node()" mode="emptyTRDelete" />
        </xsl:variable>

        <xsl:apply-templates select="$str0/node()" />
    </xsl:template>


    <xsl:template match="tr" mode="emptyTRDelete">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::node()) and 
                            count(td) = 1 and 
                            td[not(*)][matches(., '^&#xfeff;$')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tr">
        <xsl:variable name="cur" select="." />

        <xsl:choose>
            <xsl:when test="parent::*[matches(@class, 'MsoTableGridLight')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="count(parent::*/tr) = 1 and 
                            count(td[not(matches(., '^&#xfeff;$'))]) = 1">
                <xsl:variable name="cur1" select="." />
                <xsl:apply-templates select="$cur1/td[not(matches(., '^&#xfeff;$'))]/node()" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="not(preceding-sibling::node()) and 
                                        count(td[@*[matches(name(), 'background')]]) &gt; 0">
                            <xsl:attribute name="class" select="if (@class) then concat(@class, ' theading') else 'theading'" />
                        </xsl:when>

                        <xsl:when test="count(td[@*[matches(name(), 'background')]]) &gt; 0">
                            <xsl:attribute name="class" select="if (@class) then concat(@class, ' secondThead') else 'secondThead'" />
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="td">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="not(node())">
                    <p>&#xfeff;</p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>


    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>
