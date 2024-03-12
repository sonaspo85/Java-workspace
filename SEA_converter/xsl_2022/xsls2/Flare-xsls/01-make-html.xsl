<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast ">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />

    <xsl:key name="bookmark" match="a[matches(@name, '^_bookmark\d+$')]" use="@name" />
    <xsl:key name="link_toc" match="*[@MadCap:xrefTargetName | @MadCap:xrefTarget]" use="@MadCap:xrefTargetName | @MadCap:xrefTarget" />

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
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
            
            <xsl:when test="parent::*[matches(lower-case(@class), 'blue')]">
                <xsl:choose>
                    <xsl:when test="matches(., '.htm$')">
                        <xsl:attribute name="href" select="concat('#', ast:normalized(parent::*/text()))" />
                    </xsl:when>
                
                    <xsl:when test="key('link_toc', substring-after(., '#'))">
                        <xsl:attribute name="href" select="concat('#', ast:normalized(substring-after(., '#')))" />
                    </xsl:when>

                    <xsl:when test="not(key('link_toc', substring-after(., '#'))) and 
                                    key('link_toc', ast:normalized(parent::*/text()))">
                        <xsl:attribute name="href" select="concat('#', ast:normalized(parent::*/text()))" />
                    </xsl:when>

                    <xsl:when test="not(key('link_toc', substring-after(., '#')))">
                        <xsl:attribute name="href" select="concat('#', ast:normalized(substring-after(., '#')))" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:attribute name="href" select="concat('#', ast:normalized(substring-after(., '#')))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="parent::*[matches(@class, 'h3')] and ancestor::*[matches(@class, 'toc')]">
                <xsl:choose>
                    <xsl:when test="matches(., 'Getting_started')">
                        <xsl:attribute name="href" select="." />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="href" select="concat('#', ast:normalized(parent::*/text()))" />
                    </xsl:otherwise>
                </xsl:choose>
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
        <!-- @name을 가지고 있다면 무 조건 a 삭제 -->
    </xsl:template>

    <xsl:template match="a/@MadCap:parentName">
        <!-- @name이 없는 a 중에 -->
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

    <xsl:template match="a[count(node()) = 1 and img]">
        <xsl:apply-templates />
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
                        <xsl:when test="substring-after(@href, '#') != @MadCap:xrefTarget[not(contains(., '$$xref$$'))]">
                            <xsl:attribute name="href" select="concat('#', @MadCap:xrefTarget)" />
                        </xsl:when>
                        
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
            <xsl:choose>
                <xsl:when test="starts-with(., '$$xref$$') and parent::*/a[@name][following-sibling::node()[1][self::text()]]">
                    <xsl:value-of select="parent::*/a[following-sibling::node()[1][self::text()]]/@name" />
                </xsl:when>

                <xsl:when test="starts-with(., '$$xref$$')">
                    <xsl:value-of select="ast:normalized(parent::*/text())" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="ast:normalized(.)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="html/@MadCap:*">
    </xsl:template>

    <xsl:template match="b">
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
    </xsl:template>

    <xsl:template match="@alt | @style | @cellspacing">
    </xsl:template>

    <xsl:template match="MadCap:section | MadCap:conditionalText">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="@MadCap:autonumPosition | @MadCap:generatedBookmark | @MadCap:sourceTitle | @MadCap:conditions">
    </xsl:template>

    <xsl:template match="root">
           <xsl:element name="html" inherit-namespaces="no">
               <xsl:apply-templates select="@*" />
               <xsl:attribute name="sourcePath">
                   <xsl:value-of select="@sourcePath"/>
               </xsl:attribute>
               <head>
                   <title>User Manual</title>
                   <xsl:apply-templates select="*[1]/head/*[3]" />
               </head>
               <body>
                   <xsl:apply-templates select="*/*[2]/*" />
               </body>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="contains(@style, 'font-weight: bold;')">
                <xsl:copy inherit-namespaces="no" copy-namespaces="no">
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
                <xsl:copy inherit-namespaces="no" copy-namespaces="no">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:attribute name="class" select="'Note'" />
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="parent::p">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy inherit-namespaces="no" copy-namespaces="no">
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[*[name()='a'][@name][following-sibling::node()[1][self::text()]]]">
        <xsl:variable name="apos" select="a[@name][following-sibling::node()[1][self::text()]]" />
        <xsl:choose>
            <xsl:when test="not(@MadCap:xrefTargetName | @MadCap:xrefTarget)">
                <xsl:copy>
                    <xsl:attribute name="id">
                        <xsl:value-of select="*[1][name()='a']/@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="(@MadCap:xrefTargetName or @MadCap:xrefTarget) and 
                            a[@name and following-sibling::node()[1][self::text()]]/@name != (@MadCap:xrefTargetName, @MadCap:xrefTarget)">
                <xsl:copy>
                    <xsl:attribute name="aid">
                        <xsl:value-of select="$apos/@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="id">
                        <xsl:value-of select="*[1][name()='a']/@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h2[matches(@MadCap:xrefTargetName, '_..\d')][following-sibling::*[1][descendant::*[matches(@class, 'Blue')]]]">
        <p class="bluelink">
            <xsl:apply-templates select="@* except @class" />
            <xsl:apply-templates select="node()" />
        </p>
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

    <xsl:template match="text()" priority="10">
        <xsl:value-of select="replace(., '[&#xa0;]+', ' ')" />
    </xsl:template>

    <xsl:function name="ast:normalized">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(replace(replace(normalize-space(replace($value, '\+', '_plus')), '[!@#$%&amp;();:,’?]+', ''), '[ &#xA0;]', '_'), '/', '_')"/>
    </xsl:function>
    
</xsl:stylesheet>
