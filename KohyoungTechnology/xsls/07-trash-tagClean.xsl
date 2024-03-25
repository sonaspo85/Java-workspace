<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a h1 h2 h3 h4 h5 b i strong" />
    
    <xsl:variable name="lang" select="tokenize(replace(root/@sourcename, '\.html?', ''), '_')[last()]" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="span">
        <xsl:choose>
            <xsl:when test="not(string(normalize-space(.))) and not(*)">
                <xsl:text>&#xfeff;</xsl:text>
            </xsl:when>
            
            <xsl:when test="matches(., '^[.,\(\)]')">
                <xsl:text></xsl:text>
            </xsl:when>
        </xsl:choose>
        
        <xsl:apply-templates select="node()" />
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and 
                *[matches(name(), '(span|b|i)')][matches(normalize-space(.), '^৺$')]">
            </xsl:when>
            
            <xsl:when test="preceding-sibling::*[1]/*[matches(normalize-space(.), '^৺$')]">
                <xsl:variable name="class" select="@*[matches(name(), 'class')]" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:attribute name="class" select="$class" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="*[1][name()='table']">
                <xsl:apply-templates />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[matches(name(), '(^b$|strong)')]">
        <xsl:choose>
            <xsl:when test="matches(., '^ $')">
                <xsl:text>&#x20;</xsl:text>
            </xsl:when>
            
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
    
    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="ancestor::p[not(preceding-sibling::node())]/parent::div[not(preceding-sibling::node())]/parent::body">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="parent::*/@*[matches(name(), 'z-index')]">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:if test="not(ancestor::table) and @*[matches(name(), 'alt$')]">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="@class">
                                    <xsl:value-of select="concat(@class, ' excNote')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'excNote'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()"  priority="10">
        <xsl:value-of select="replace(replace(replace(.,'\s+', '&#x20;'), '&#xa0;', ' '), '[৺]+', '&#x20;')" />
    </xsl:template>
    
    <xsl:template match="@*[not(matches(name(), '(outFolderName|class|background|font|color|align|href|name|src|colspan|rowspan)'))]">
        <xsl:choose>
            <xsl:when test="matches(name(), 'border-top') and 
                matches(., 'none')">
                <xsl:attribute name="border-top" select="'none'" />
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <xsl:template match="a[matches(@name, '^_Toc')]">
        <xsl:apply-templates />
    </xsl:template>
    
    
    <xsl:template match="*/@*[matches(name(), 'ast\d+\-class')]">
        <xsl:attribute name="class" select="." />
    </xsl:template>
    
    <xsl:template match="br" />
    
    <xsl:template match="head | style | html | div[matches(@class, 'WordSection')]">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:copy>
            <xsl:attribute name="lang" select="$lang" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tr[matches(name(@*), 'height')]">
        <xsl:choose>
            <xsl:when test="@*[matches(name(), 'height')] = '0'">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:if test="@*[matches(name(), 'height')] and 
                                  not(preceding-sibling::tr)">
                        <xsl:attribute name="height">
                            <xsl:value-of select="@*[matches(name(), 'height')][1]"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="td">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="preTrCnt" select="count(parent::tr/preceding-sibling::tr) + 1" as="xs:integer" />
        <xsl:variable name="firstNodeChildCnt" select="count(ancestor::table/tr[1]/td)" as="xs:integer" />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:if test="@*[matches(name(), 'width')] and 
                $cur/node()">
                <xsl:choose>
                    <xsl:when test="$preTrCnt &gt; 1 and 
                        $firstNodeChildCnt = 1">
                        <xsl:attribute name="widthFix">
                            <xsl:variable name="widthCollection">
                                <xsl:for-each select="@*[matches(name(), 'width')][matches(., '(%|pt|cm)')]">
                                    <W>
                                        <xsl:value-of select="."/>
                                    </W>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:value-of select="if ($widthCollection/W[matches(., '\d+%$')]) then
                                $widthCollection/W[matches(., '\d+%$')][1] else if ($widthCollection/W[matches(., '\d+pt$')]) then
                                $widthCollection/W[matches(., '\d+pt$')][1] else
                                $widthCollection/W[matches(., '\d+cm$')][1]"/>
                        </xsl:attribute>
                    </xsl:when>
                    
                    <xsl:when test="$preTrCnt = 1 and 
                        count(parent::*/td) = 1">
                        <xsl:attribute name="widthFix">
                            <xsl:variable name="widthCollection">
                                <xsl:for-each select="@*[matches(name(), 'width')][matches(., '(%|pt|cm)')]">
                                    <W>
                                        <xsl:value-of select="."/>
                                    </W>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:value-of select="if ($widthCollection/W[matches(., '\d+%$')]) then
                                $widthCollection/W[matches(., '\d+%$')][1] else if ($widthCollection/W[matches(., '\d+pt$')]) then
                                $widthCollection/W[matches(., '\d+pt$')][1] else
                                $widthCollection/W[matches(., '\d+cm$')][1]"/>
                        </xsl:attribute>
                    </xsl:when>    
                    
                    <xsl:when test="$preTrCnt = 1">
                        <xsl:attribute name="width">
                            <xsl:variable name="widthCollection">
                                <xsl:for-each select="@*[matches(name(), 'width')][matches(., '(%|pt|cm)')]">
                                    <W>
                                        <xsl:value-of select="."/>
                                    </W>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:value-of select="if ($widthCollection/W[matches(., '\d+%$')]) then
                                                    $widthCollection/W[matches(., '\d+%$')][1] else if ($widthCollection/W[matches(., '\d+pt$')]) then
                                                    $widthCollection/W[matches(., '\d+pt$')][1] else
                                                    $widthCollection/W[matches(., '\d+cm$')][1]"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="head/style/comment()">
        <xsl:result-document href="07-extract-styleInfo.xml">
            <root>
                <xsl:analyze-string select="." regex="(\}})(\s+)?(\w+)([\w+\s+\.,\-]+)(\{{mso-style-link)(.*?)(;)">
                    <xsl:matching-substring>
                        <stylelist>
                            <xsl:value-of select="regex-group(0)" />
                        </stylelist>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        
                        <xsl:analyze-string select="." regex="(\}})(\s+)?(\w+)([\w+\s+\.,\-]+)(\{{mso-style-name)(.*?)(;)">
                            <xsl:matching-substring>
                                <stylelist>
                                    <xsl:value-of select="regex-group(0)" />
                                </stylelist>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </root>
        </xsl:result-document>
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
