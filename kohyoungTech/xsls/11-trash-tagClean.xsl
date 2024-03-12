<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a h1 h2 h3 h4 h5 b i" />

    <xsl:key name="destinationKeys" match="a[@name]" use="@name" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" priority="10">
        <xsl:choose>
            <xsl:when test="not(matches(name(), 'td')) and 
                            count(node()) = 1 and img">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:when test="not(matches(., '\w+')) and 
                            count(not(*[matches(name(), 'img')])) &gt; 0 and 
                            img">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:when test="matches(@class, 'MsoToc')">
            </xsl:when>

            <xsl:when test="matches(@class, 'heading2_midtitle') and 
                            following-sibling::node()[1][matches(@class, 'MsoToc')]">
                <xsl:copy>
                    <xsl:attribute name="class" select="'tocTitle'" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="self::td">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:choose>
                        <xsl:when test="not(node())">
                            <xsl:text>&#xfeff;</xsl:text>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(name(), '(^p$|^b$|^i$)') and not(node())">
            </xsl:when>

            <xsl:when test="matches(@class, '(^OL|^UL)') and matches(normalize-space(replace(., '&#xfeff;', '')), '^[•\-ú(\d\.)&#x97;&#x96;]+$')">
            </xsl:when>

            <xsl:when test="self::img">
                <xsl:choose>
                    <xsl:when test="count(parent::*/node()) = 1 and 
                                    parent::*/@*[matches(name(), 'align')]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" />
                            <xsl:apply-templates select="parent::*/@*[matches(name(), 'align')]" />
                            <xsl:apply-templates select="node()" />
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
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