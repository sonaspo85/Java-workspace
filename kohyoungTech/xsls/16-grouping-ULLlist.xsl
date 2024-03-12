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

    <xsl:template match="@* | node()" mode="grouping1">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="grouping1" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="grouping1" />
        </xsl:variable>

        <xsl:apply-templates select="$str0/node()" />
    </xsl:template>

    <xsl:template match="body" priority="10" mode="grouping1">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, '^UL1')])">
                    <xsl:variable name="elename">
                        <xsl:value-of select="tokenize(current-group()[1]/@class, ' ')[1]" />
                    </xsl:variable>
                    
                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '^UL1')]">
                            <xsl:element name="{$elename}">
                                <xsl:apply-templates select="current-group()" mode="grouping1" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="grouping1" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:variable name="str1">
                <xsl:for-each-group select="$str0/node()" group-adjacent="boolean(self::*[matches(@class, '^UL2')])">
                    <xsl:variable name="elename">
                        <xsl:value-of select="tokenize(current-group()[1]/@class, ' ')[1]" />
                    </xsl:variable>

                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '^UL2')]">
                            <xsl:element name="{$elename}">
                                <xsl:apply-templates select="current-group()" mode="grouping1" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="grouping1" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:variable name="str2">
                <xsl:for-each-group select="$str1/node()" group-adjacent="boolean(self::*[matches(@class, '^UL3')])">
                    <xsl:variable name="elename">
                        <xsl:value-of select="tokenize(current-group()[1]/@class, ' ')[1]" />
                    </xsl:variable>

                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '^UL3')]">
                            <xsl:element name="{$elename}">
                                <xsl:apply-templates select="current-group()" mode="grouping1" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="grouping1" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:apply-templates select="$str2" mode="grouping1" />
        </xsl:copy>
    </xsl:template>

    <!-- grouping UL within td -->
    <xsl:template match="*[not(matches(name(), '(body|^UL|ListIndent)'))][*[matches(@class, '^UL\d')]]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, '^UL\d')])">
                    <xsl:variable name="elename">
                        <xsl:value-of select="tokenize(current-group()[1]/@class, ' ')[1]" />
                    </xsl:variable>

                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@class, '^UL\d')]">
                            <xsl:element name="{$elename}">
                                <xsl:apply-templates select="current-group()" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:copy-of select="$str0" />
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