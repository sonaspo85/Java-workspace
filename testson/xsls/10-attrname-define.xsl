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

    <xsl:variable name="styleinfoFiles" select="document(concat(ast:getPath(base-uri(.), '/'), '/09-clear-styleinfo.xml'))/root" />
    
    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>
        <xsl:apply-templates select="$str0/node()" />
    </xsl:template>
    
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
    

    <xsl:template match="p" priority="10">
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
                        <xsl:variable name="curText" select="replace(., '&#xfeff;', '')" />
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::node()) and 
                                            not(preceding-sibling::node()) and 
                                            matches($curText, '(^\s+)(.*)(\s+$)')">
                                <xsl:value-of select="replace(replace(., '&#xfeff;', ''), '(^\s+)(.*)(\s+$)', '$2')" />
                            </xsl:when>

                            <xsl:when test="not(preceding-sibling::node()) and 
                                            matches($curText, '^\s+')">
                                <xsl:value-of select="replace(replace(., '&#xfeff;', ''), '^\s+', '')" />
                            </xsl:when>

                            <xsl:when test="not(following-sibling::node()) and 
                                            matches($curText, '\s+$')">
                                <xsl:value-of select="replace(replace(., '&#xfeff;', ''), '\s+$', '')" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="replace(., '&#xfeff;', '')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[matches(name(), '(b|strong)')]">
        <xsl:choose>
            <xsl:when test="not(string(normalize-space(.))) and not(*)">
            </xsl:when>

            <xsl:when test="count(node()) = 1 and 
                            count(span/node()) = 1 and span/img">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@class">
        <xsl:choose>
            <xsl:when test="count(tokenize(., ' ')) &gt; 1">
                <xsl:call-template name="changClass">
                    <xsl:with-param name="classpiece" select="." />
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="str2">
                    <xsl:call-template name="tokenOne">
                        <xsl:with-param name="str0" select="." />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:attribute name="class" select="$str2" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="changClass">
        <xsl:param name="classpiece" />

        <xsl:variable name="str0">
            <xsl:value-of select="tokenize($classpiece, '&#x20;')[1]" />
        </xsl:variable>

        <xsl:variable name="str1">
            <xsl:value-of select="string-join(tokenize($classpiece, '&#x20;')[position() &gt; 1], ' ')" />
        </xsl:variable>

        <xsl:variable name="str2">
            <xsl:call-template name="tokenOne">
                <xsl:with-param name="str0" select="$str0" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:attribute name="class" select="concat($str2,' ', $str1)" />
    </xsl:template>

    <xsl:template name="tokenOne">
        <xsl:param name="str0" />

        <xsl:choose>
            <xsl:when test="$str0 = $styleinfoFiles/*/@class">
                <xsl:value-of select="$styleinfoFiles/*[@class = $str0]/@changeclass" />
            </xsl:when>

            <xsl:when test="$str0 = 'MsoNormal'">
                <xsl:value-of select="'description'" />
            </xsl:when>

            <xsl:when test="matches($str0, 'MsoListBullet2CxSp')">
                <xsl:value-of select="'UL2_hyphen'" />
                <!--<xsl:value-of select="'hyphen'" />-->
            </xsl:when>

            <xsl:when test="matches($str0, 'MsoListBullet3CxSp')">
                <xsl:value-of select="'UL3_square'" />
            </xsl:when>

            <xsl:when test="matches($str0, 'MsoListBullet2')">
                <xsl:value-of select="'UL2_hyphen'" />
            </xsl:when>

            <xsl:when test="$str0 = 'a0'">
                <xsl:value-of select="'heading2_midtitle'" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="$str0" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="a" mode="abc">
        <xsl:variable name="nomalize" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="count($nomalize) = 1 and 
                            img">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
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