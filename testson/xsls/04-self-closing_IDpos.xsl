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

    <xsl:template match="*[@ASTID]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="matches(., '^&lt;\w+')">
                    <xsl:apply-templates select="." mode="abc" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10" mode="abc">
        <xsl:variable name="cur" select="replace(normalize-space(.), '(^&lt;)(\w+\s)', '$1$2&#xFCA;&#xFCA;&#xFCA;')" />

        <xsl:variable name="cur1">
            <xsl:analyze-string select="$cur" regex="(&quot;)(src)(=)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)" />
                    <xsl:value-of select="'&#x20;'" />
                    <xsl:value-of select="regex-group(2)" />
                    <xsl:value-of select="regex-group(3)" />
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:analyze-string select="." regex="(&lt;(br|img).*?)(&gt;)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)" />
                            <xsl:value-of select="'/'" />
                            <xsl:value-of select="regex-group(3)" />
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="." />
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:value-of select="ast:tokenAttr($cur1, '&#xFCA;&#xFCA;&#xFCA;')" />
    </xsl:template>
    
    <xsl:template name="recall">
        <xsl:param name="cur" />

        <xsl:variable name="str0">
            <xsl:variable name="str1">
                <xsl:sequence select="tokenize($cur, ' ')" />
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="count(tokenize($cur, ' ')) &gt; 1">
                    <xsl:for-each select="tokenize($cur, ' ')">
                        <xsl:value-of select="concat('ast', position(), '-')" />
                        <xsl:value-of select="." />
                        <xsl:if test="position() != last()">
                            <xsl:text>&#x20;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="$cur" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:copy-of select="$str0" />
    </xsl:template>
    
    <xsl:function name="ast:tokenAttr">
        <xsl:param name="str" />
        <xsl:param name="char" />
        
        <xsl:variable name="deliver">
            <xsl:value-of select="normalize-space(tokenize($str, $char)[2])" />
        </xsl:variable>

        <xsl:variable name="attrJoin">
            <xsl:call-template name="recall">
                <xsl:with-param name="cur" select="$deliver" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="concat(tokenize($str, $char)[1], $attrJoin)" />
    </xsl:function>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
</xsl:stylesheet>