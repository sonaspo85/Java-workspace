<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />

    <xsl:variable name="open">&lt;div class=&quot;copyright&quot;&gt;</xsl:variable>
    <xsl:variable name="close">&lt;/div&gt;</xsl:variable>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                <xsl:for-each-group select="*" group-ending-with="*[matches(@class, 'Copyright')]">
                    <xsl:choose>
                        <xsl:when test="current-group()[matches(@class, 'Copyright')][not(preceding-sibling::*[matches(@class, 'Copyright')])]">
                            <div class="coverContent">
                                <xsl:apply-templates select="current-group()" />
                            </div>
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

    <xsl:template match="*[matches(@class, 'tocTitle')]">
    </xsl:template>

    <xsl:template name="grouping">
        <xsl:param name="group" />
        <xsl:param name="current-class" />

        <xsl:choose>
            <xsl:when test="$group[1][matches(@class, 'description')]">
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

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="following-sibling::*[1][matches(@class, '^cover')]">
                <xsl:copy>
                    <xsl:attribute name="class" select="'ImgBlock_Logo'"/>
                    <xsl:apply-templates select="@* except @class" />
                </xsl:copy>
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