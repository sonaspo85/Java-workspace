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

    <xsl:variable name="open">&lt;div class=&quot;note reference&quot;&gt;</xsl:variable>
    <xsl:variable name="close">&lt;/div&gt;</xsl:variable>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[*[matches(@class, '^note')]]" priority="10">
        <xsl:copy>
            <xsl:apply-templates select="@*" />

            <xsl:for-each-group select="node()" group-starting-with="*[matches(@class, '^note')][matches(., '^(\s+)?※')]">
                <xsl:choose>
                    <xsl:when test="current-group()[matches(@class, '^note')][matches(., '^(\s+)?※')][1]">
                        <xsl:value-of select="$open" disable-output-escaping="yes" />
                        <xsl:for-each select="current-group()[1]">
                            <xsl:copy>
                                <xsl:attribute name="class" select="concat(@class, '_start')" />
                                <xsl:apply-templates select="@* except @class" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </xsl:for-each>
                        
                        <xsl:call-template name="grouping">
                            <xsl:with-param name="group" select="current-group()[position() &gt; 1]" />
                        </xsl:call-template>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="grouping">
        <xsl:param name="group" />

        <xsl:choose>
            <xsl:when test="$group[1][matches(@class, '^note')][not(matches(., '^(\s+)?※'))] or 
                            $group[1][matches(name(), 'table')][not(matches(@class, 'MsoNormalTable'))] or 
                            $group[1][matches(name(), 'img')][preceding-sibling::*[1][matches(name(), 'table')]]">
                <xsl:apply-templates select="$group[1]" />

                <xsl:call-template name="grouping">
                    <xsl:with-param name="group" select="$group[position() &gt; 1]" />
                </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="$group[1]/preceding-sibling::*[1][matches(@class, '^note')][not(matches(., '^(\s+)?※'))] and 
                            $group[1]/following-sibling::*[1][matches(@class, '^note')][not(matches(., '^(\s+)?※'))]">
                <xsl:apply-templates select="$group[1]" />
                
                <xsl:call-template name="grouping">
                    <xsl:with-param name="group" select="$group[position() &gt; 1]" />
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$close" disable-output-escaping="yes" />
                <xsl:apply-templates select="$group" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" mode="abc"  priority="5">
        <xsl:analyze-string select="." regex="(\-)(\s+)?(\w+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(3)" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
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