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

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="root">
        <xsl:variable name="root" select="." />
        <xsl:variable name="coverModelName" select="descendant::p[@class = 'ModelName-Cover'][1]" />

        <root>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="coverModelName" select="normalize-space($coverModelName)" />

            <xsl:for-each select="doc">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="lang" select="@lang" />

                <xsl:if test="$lang[. = $allLangF/*/@lang]">
                    <xsl:choose>
                        <xsl:when test="$root/*[matches(@lang, '(QSG|Cover)')] and
                                        $lang[matches(., 'Tur')]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                <xsl:copy-of select="$root/*[matches(@lang, '(QSG|Cover)')]/*" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </xsl:when>
                        
                        <xsl:when test="not(matches($lang, '^(QSG|Cover)$'))">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:when>

                        <!--<xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:otherwise>-->
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template match="text()" priority="5">
        <xsl:value-of select="replace(., '&#x200B;', '')" />
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
