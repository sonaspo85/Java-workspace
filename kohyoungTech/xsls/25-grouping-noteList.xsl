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

    <xsl:template match="*[matches(@class, 'note reference')]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, 'note_hyphen')][not(matches(@class, '_start'))])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:apply-templates select="current-group()" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:apply-templates select="$str0" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(@class, 'note reference')])">
                <xsl:choose>
                    <xsl:when test="current-group()[1][matches(@class, 'note reference')][following-sibling::node()[1][matches(@class, 'note reference')]]">
                        <div class="grouping-note">
                            <xsl:apply-templates select="current-group()" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
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