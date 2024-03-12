<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="no" />

    <xsl:param name="outputPath" />
    <xsl:variable name="outputPathFinal" select="replace($outputPath, '\\', '/')" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()" mode="sortChapter">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="sortChapter" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="sortChapter" />
        </xsl:variable>

        <xsl:apply-templates select="$str0/*" />
    </xsl:template>

    <xsl:template match="ol">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="matches(@class, 'UL2_hyphen')">
                    <xsl:attribute name="class" select="'hyphen'" />
                </xsl:when>

                <xsl:when test="matches(@class, 'UL1_bullet')">
                    <xsl:attribute name="class" select="'disc'" />
                </xsl:when>

                <xsl:when test="matches(@class, 'note_hyphen')">
                    <xsl:attribute name="class" select="'hyphen'" />
                </xsl:when>

                <xsl:when test="matches(@class, 'UL2_bullet')">
                    <xsl:attribute name="class" select="'disc'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:attribute name="class" select="@class" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[@class]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @class" />
            <xsl:attribute name="class" select="if (@*[matches(name(), 'text\-align')]) then @*[matches(name(), 'text\-align')] else @class" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="table">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="count(parent::table/thead/tr[1]/td[1]/node()) &lt;= 2 and 
                                          parent::table/thead/tr[1]/td[1]/img">
                        <xsl:choose>
                            <xsl:when test="self::thead or self::tbody">
                                <xsl:apply-templates />
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
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="td">
        <xsl:copy>
            <xsl:apply-templates select="@* except @width" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="matches(@class, 'ImgBlock')">
                <div>
                    <xsl:attribute name="class" select="@class" />
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </div>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="body" mode="sortChapter">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="sortChapter"/>
            <xsl:attribute name="outputPath" select="$outputPathFinal" />
            
            <xsl:variable name="str0">
                <xsl:for-each-group select="*" group-adjacent="boolean(self::*[matches(@browerTitle, 'CoverInfo')])">
                    <xsl:choose>
                        <xsl:when test="current-group()[1][matches(@browerTitle, 'CoverInfo')]">
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="'CoverInfo'" />
                                <xsl:apply-templates select="current-group()" mode="sortChapter" />
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()" mode="sortChapter" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each select="$str0">
                <xsl:copy-of select="*[not(matches(@class, 'CoverInfo'))]" />
                <xsl:copy-of select="*[matches(@class, 'CoverInfo')]/node()" />
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@class">
        <xsl:attribute name="class">
        <xsl:choose>
            <xsl:when test=". = 'ImgInline'">
                <xsl:value-of select="'inline'" />
            </xsl:when>

            <xsl:when test=". = 'ImgBlock-C'">
                <xsl:value-of select="'capture-c'" />
            </xsl:when>

            <xsl:when test=". = 'ImgBlock'">
                <xsl:value-of select="'capture'" />
            </xsl:when>
            
            <xsl:when test=". = 'ImgBlock_Logo'">
                <xsl:value-of select="'capture'" />
            </xsl:when>

            <xsl:when test=". = 'secondThead'">
                <xsl:value-of select="'theading'" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@widthFix">
        <xsl:attribute name="width" select="." />
    </xsl:template>

    <xsl:template match="chapter[matches(@browerTitle, 'CoverInfo')]">
        <xsl:copy>
            <xsl:attribute name="browerTitle" select="*[1][name()='h1']" />
            <xsl:apply-templates select="@* except @browerTitle" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[not(matches(name(), '(outFolderName|class|id|src|browerTitle|DesKey|href|filename|colspan|rowspan|start|lang|outputPath|sourcename|valign|style)'))]">
        <xsl:choose>
            <xsl:when test="matches(name(), 'border-top')">
                <xsl:attribute name="border-top" select="." />
            </xsl:when>
            <xsl:otherwise>
                
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