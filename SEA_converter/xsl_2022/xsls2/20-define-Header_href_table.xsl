<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY trade "™">]>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast saxon"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="li p td" />

    <xsl:key name="xrefs" match="h1 | h2 | h3 | h4 | h5 | h6 | p[matches(@class, 'heading3')]" use="@id" />

    
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

    <xsl:template match="li/text()[not(preceding-sibling::node())][matches(., '^\s+$')]">
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '[&#x9;&#xA;]', ''), '[&#x20;]+', '&#x20;')" />
    </xsl:template>

    <xsl:template match="img">
        <xsl:copy>
            <xsl:apply-templates select="@* except @src" />
            <xsl:attribute name="src">
                <xsl:value-of select="replace(@src, 'output/', '')" />
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
        <xsl:if test="following-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="a">
        <xsl:if test="preceding-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
        
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="matches(@href, '^#')">
                    <xsl:variable name="target" select="key('xrefs', substring-after(@href, '#'))[1]" />
                    <xsl:variable name="filename" select="$target/ancestor::topic[@filename][1]/@filename" />
                    <xsl:variable name="fid" select="$target/ancestor::topic[@filename][1]/*[1]/@id" />
                    <xsl:variable name="html" select="concat($filename, '_', $fid, '.html')" />

                    <xsl:attribute name="href">
                        <xsl:value-of select="if ( $fid = substring-after(@href, '#') ) then $html else concat($html, @href)" />
                    </xsl:attribute>
                    <xsl:attribute name="id" select="@id" />
                    <xsl:attribute name="class" select="@class" />
                    <xsl:apply-templates />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
        
        <xsl:if test="following-sibling::node()[1][self::*]">
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*[starts-with(name(), 'h')][@id]">
        <xsl:choose>
            <xsl:when test="name()='h2'">
                <xsl:choose>
                    <xsl:when test="@class='heading2'">
                        <h2>
                            <xsl:apply-templates select="@*" />
                            <xsl:apply-templates select="node()" />
                        </h2>
                    </xsl:when>

                    <xsl:otherwise>
                        <h1>
                            <xsl:apply-templates select="@*" />
                            <xsl:attribute name="class" select="'topicTitle'" />
                            <xsl:apply-templates select="node()" />
                        </h1>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="name()='h6'">
                <h5>
                    <xsl:apply-templates select="@* | node()" />
                </h5>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="matches(@class, 'heading3')">
                <h3>
                    <xsl:apply-templates select="@* | node()" />
                </h3>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table">
        <xsl:choose>
            <xsl:when test="@class = 'genminitoctable1'">
                <xsl:variable name="current" select="tr/td[2]" />
                <xsl:variable name="idref" select="substring-after(tr/td[2]/a/@href, '#')" />
                <xsl:variable name="target" select="key('xrefs', $idref)[1]" />
                <xsl:variable name="filename" select="$target/ancestor::topic[1]/@filename" />
                <xsl:variable name="fid" select="$target/ancestor::topic[1]/*[1]/@id" />
                <xsl:variable name="html" select="concat($filename, '_', $fid, '.html')" />

                <xsl:if test="not(preceding-sibling::table[@class='genminitoctable1'])">
                    <div class="started_background">&#xFEFF;</div>
                </xsl:if>
                
                <p class="subchapter_toc">
                    <a class="genminitoctext1" href="{concat($filename, '_', $fid, '.html', '#', $idref)}">
                        <xsl:value-of select="$current" />
                    </a>
                </p>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="cellspacing">0</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>