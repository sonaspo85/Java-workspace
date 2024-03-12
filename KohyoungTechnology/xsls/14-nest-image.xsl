<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    
    <xsl:key name="destinationKeys" match="a[@name]" use="@name" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="matches(@class, '(^OL|^UL|^note)')">
                <xsl:variable name="flw_img" select="following-sibling::node()[1][self::ImgGroup] | following-sibling::node()[1][self::img][not(matches(@class, 'excNote'))]" />

                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:choose>
                        <xsl:when test="$flw_img[name()='ImgGroup']">
                            <xsl:for-each select="$flw_img/*">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:attribute name="class" select="if (@class) then concat(@class, ' ImgBlock') else 'ImgBlock'" />
                                </xsl:copy>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$flw_img">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    <xsl:attribute name="class" select="if (@class) then concat(@class, ' ImgBlock') else 'ImgBlock'" />
                                </xsl:copy>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="string-length(replace(replace(., '^\s+', ''), '\s+$', '')) = 0 and 
                            count(replace(replace(., '^\s+', ''), '\s+$', '')) eq 1">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img | ImgGroup">
        <xsl:variable name="BlockInline">
            <xsl:choose>
                <xsl:when test="@*[matches(name(), 'align')][not(matches(name(), 'text'))] = 'center'">
                    <xsl:value-of select="'ImgBlock-C'" />
                </xsl:when>

                <xsl:when test="parent::p">
                    <xsl:value-of select="'ImgInline'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'ImgBlock'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(matches(@class, 'excNote')) and 
                            preceding-sibling::node()[1][self::p[matches(@class, '(^OL|^UL|^note)')]]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="class" select="$BlockInline" />
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