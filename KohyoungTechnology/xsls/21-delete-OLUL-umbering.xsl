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

    <xsl:template match="@* | node()" mode="deleteNumber">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="deleteNumber" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[matches(@class, '(^OL|^UL)')]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" mode="deleteNumber"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ol">
        <xsl:variable name="startNum">
            <xsl:choose>
                <xsl:when test="matches(*[1], '(^[&#x2460;-&#x2469;])')">
                    <xsl:call-template name="circleConvert">
                        <xsl:with-param name="Num">
                            <xsl:value-of select="replace(*[1], '(^[&#x2460;-&#x2469;])(\s+)(.*)', '$1')"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="matches(*[1], '(^\d+)')">
                    <xsl:value-of select="replace(*[1], '(^\d+)(\.\s+)(.*)', '$1')"/>
                </xsl:when>
                
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="start" select="$startNum" />
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="circleConvert">
        <xsl:param name="Num" />
        
        <xsl:choose>
            <xsl:when test="matches($Num, '&#x2460;')">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2461;')">
                <xsl:value-of select="2"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2462;')">
                <xsl:value-of select="3"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2463;')">
                <xsl:value-of select="4"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2464;')">
                <xsl:value-of select="5"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2465;')">
                <xsl:value-of select="6"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2466;')">
                <xsl:value-of select="7"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2467;')">
                <xsl:value-of select="8"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2468;')">
                <xsl:value-of select="9"/>
            </xsl:when>
            <xsl:when test="matches($Num, '&#x2469;')">
                <xsl:value-of select="10"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" mode="deleteNumber" priority="10">
        <xsl:analyze-string select="." regex="(^\d+\.)(\s+)(.*)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(3)" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(^[•\-ú&#x97;&#x96;&#x9f;]+)(\s+)?(.*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(3)" />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>

                        <xsl:analyze-string select="." regex="(^[&#x2460;-&#x2469;]+)(\s+)?(.*)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(3)" />
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="." />
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="*[matches(name(), '^h\d+')]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::*">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="headTextReplace" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="headTextReplace">
        <xsl:analyze-string select="." regex="(^[\d+\.]+)(\s+)(\w+)">
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
