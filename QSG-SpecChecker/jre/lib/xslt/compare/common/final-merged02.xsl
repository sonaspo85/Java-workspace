<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    exclude-result-prefixes="xs son xsi functx"
    version="2.0">

    <xsl:import href="../00-commonVar.xsl" />

    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />

    <xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
    <xsl:strip-space elements="*" />

    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>

        <xsl:apply-templates select="$var0/*" />
    </xsl:template>

    <xsl:template match="doc" mode="abc">
        <xsl:choose>
            <xsl:when test="@fileName = 'edoc'">
                <xsl:variable name="lang" select="@lang" />

                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="abc" />

                    <!-- <xsl:if test="following-sibling::*[@fileName = 'edoc2']">
                        <xsl:copy-of select="following-sibling::*[@fileName = 'edoc2']/div" />
                    </xsl:if> -->

                    <xsl:if test="following-sibling::*[@fileName = 'edoc2'][$lang = @lang]">
                        <!-- <xsl:copy-of select="following-sibling::*[@fileName = 'edoc2'][$lang = @lang]/div" /> -->
                        <xsl:for-each select="following-sibling::*[@fileName = 'edoc2'][$lang = @lang]/div">
                            <xsl:copy>
                                <xsl:apply-templates select="@*"/>
                                <xsl:attribute name="desc" select="''" />
                                <xsl:apply-templates select="node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="@fileName = 'edoc2'">
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="abc" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="#current" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="*[1]/@*" />
            <xsl:attribute name="errorCnt" select="count(//div[@compare = 'Fail'][not(@idmlcnt)])" />
            
            <xsl:variable name="var0">
                <xsl:for-each select="doc">
                    <xsl:sort select="@pos" data-type="number" />
                    
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:for-each-group select="$var0/*" group-by="@lang">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <div>
                            <xsl:attribute name="lang" select="current-group()[1]/@lang" />
                            <xsl:apply-templates select="current-group()/*" />
                            <enter />
                        </div>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <div>
                            <xsl:apply-templates select="current-group()/*" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>

    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>
