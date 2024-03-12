<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body" priority="10">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, '_indent')])">
                    <xsl:variable name="elename">
                        <xsl:value-of select="tokenize(current-group()[1]/@class, ' ')[1]" />
                    </xsl:variable>
                    
                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '_indent')]">
                            <xsl:element name="ListIndent">
                                <xsl:apply-templates select="current-group()" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:for-each select="$str0/node()">
                <xsl:choose>
                    <xsl:when test="following-sibling::node()[1][name()='ListIndent']">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                            <xsl:copy-of select="following-sibling::node()[1][name()='ListIndent']" />
                        </xsl:copy>
                    </xsl:when>

                    <xsl:when test="self::ListIndent">
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '\s+', '&#x20;')" />
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