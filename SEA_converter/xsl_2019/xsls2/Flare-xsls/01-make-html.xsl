<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />

    <xsl:key name="bookmark" match="a[matches(@name, '^_bookmark\d+$')]" use="@name" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@href">
        <xsl:choose>
            <xsl:when test="starts-with(., 'mailto') or starts-with(., 'http')">
                <xsl:attribute name="href" select="." />
            </xsl:when>
            <xsl:when test="matches(., '^#_bookmark\d+$')">
                <xsl:call-template name="bookmark">
                    <xsl:with-param name="name" select="substring-after(., '#')" />
                </xsl:call-template>
            </xsl:when>
               <xsl:when test="matches(., '^.+#.+$')">
                <xsl:attribute name="href" select="concat('#', ast:normalized(substring-after(., '#')))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href" select="ast:normalized(.)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="a[MadCap:xref]">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="a[@name]">
    </xsl:template>

    <xsl:template match="a/@MadCap:parentName">
        <xsl:choose>
            <xsl:when test=".='$$toc$$'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="target">
                    <xsl:value-of select="concat('_parent#', ast:normalized(.))"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="MadCap:xref">
        <a>
            <xsl:choose>
                <xsl:when test="matches(@href, '^#_bookmark\d+$')">
                    <xsl:call-template name="bookmark">
                        <xsl:with-param name="name" select="substring-after(@href, '#')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@href">
                    <xsl:choose>
                        <xsl:when test="lower-case(replace(text()[1], '\s+', '')) = lower-case(normalize-space(substring-after(@href, '#')))">
                            <xsl:attribute name="href" select="concat('#', ast:normalized(text()[1]))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="href" select="concat('#', ast:normalized(@href))" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@MadCap:xrefTarget">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#', ast:normalized(@MadCap:xrefTarget))"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="." />
        </a>
    </xsl:template>

    <xsl:template match="@MadCap:xrefTargetName | @MadCap:xrefTarget">
        <xsl:attribute name="id">
            <xsl:value-of select="if ( starts-with(., '$$xref$$') ) then ast:normalized(parent::*/text()) else ast:normalized(.)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="html/@MadCap:*">
    </xsl:template>

    <xsl:template match="b">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="node()">
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()" />
                    </xsl:copy>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#x20;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@alt | @style">
    </xsl:template>

    <xsl:template match="MadCap:section | MadCap:conditionalText">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@MadCap:autonumPosition | @MadCap:generatedBookmark | @MadCap:sourceTitle | @MadCap:conditions">
    </xsl:template>

    <xsl:template name="bookmark">
        <xsl:param name="name" />
        <xsl:attribute name="href">
            <xsl:variable name="str0">
                <xsl:value-of select="key('bookmark', $name)/parent::*/text()"/>
            </xsl:variable>
            <xsl:value-of select="concat('#', ast:normalized($str0))"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:function name="ast:normalized">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(replace(normalize-space(replace($value, '\+', '_plus')), '[!@#$%&amp;();:.,’?]+', ''), '[ &#xA0;]', '_')"/>
    </xsl:function>

    <xsl:template match="root">
       <html>
           <xsl:apply-templates select="@sourcePath" />
           <head>
               <title>User Manual</title>
               <xsl:apply-templates select="*[2]/*[1]/*[3]" />
           </head>
           <body>
               <xsl:for-each select="*[position() &gt; 1]">
                   <xsl:apply-templates select="*[2]/*" />
               </xsl:for-each>
           </body>
        </html>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="contains(@style, 'font-weight: bold;')">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <b>
                        <xsl:apply-templates />
                    </b>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="@class='LegalTOC'">
                <h2>
                    <xsl:apply-templates select="@* | node()" />
                </h2>
            </xsl:when>

            <xsl:when test="matches(@class, '^(Note\s)(KeepParagraphTogether)$')">
                <xsl:copy>
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:attribute name="class" select="'Note'" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
