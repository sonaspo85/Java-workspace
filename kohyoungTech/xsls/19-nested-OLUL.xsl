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

    <xsl:template match="li[not(following-sibling::*)]">
        <xsl:choose>
            <xsl:when test="matches(@class, '(^OL|^UL)') and 
                            not(matches(@class, 'indent')) and 
                            parent::*/following-sibling::*[1]/*[1][matches(@class, '(_hyphen$|_hyphen\s)')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:copy-of select="parent::*/following-sibling::*[1]" />
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[matches(name(), '(ol|ul)')]">
        <xsl:choose>
            <xsl:when test="*[1][matches(@class, '(_hyphen$|_hyphen\s)')] and 
                            preceding-sibling::*[1]/*[1][matches(@class, '(^OL|^UL)')][not(matches(@class, 'indent'))]">
            </xsl:when>

            <xsl:when test="*[1][matches(@class, '_indent')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[*[matches(name(), '(ol|ul)')]/*[1][matches(@class, '_indent')]]">
        <xsl:variable name="eleIndent" select="*[matches(name(), '(ol|ul)')][*[1][matches(@class, '_indent')]]" />
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
        
        <xsl:copy-of select="$eleIndent/li/node()" />
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