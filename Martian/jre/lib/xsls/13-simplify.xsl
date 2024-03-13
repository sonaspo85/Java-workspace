<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="setkeys" />
        </xsl:variable>

        <xsl:apply-templates select="$var0/*" />
    </xsl:template>

    <xsl:template match="*[matches(local-name(), '(para|table)')]" priority="5" mode="setkeys">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="time" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')" />
        <xsl:variable name="numcodepoint" select="string-join(distinct-values(string-to-codepoints($cur)), '')" />
        <xsl:variable name="numcodepoint02" select="substring($numcodepoint, 0, 20)" />
        <xsl:variable name="generatekey" select="generate-id()" />
        <xsl:variable name="tempkey" select="if (string-length($cur) &gt; 1) then $numcodepoint02 else $time" />
        <xsl:variable name="concatkey" select="concat($tempkey, $generatekey)" />

        <xsl:copy>
            <!-- <xsl:attribute name="ast-id" select="$concatkey" /> -->
            <xsl:attribute name="ast-id" select="$generatekey" />
            <xsl:apply-templates select="@* | node()" mode="setkeys"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="hyperlinktextdestination" />

    <xsl:template match="para">
        <xsl:variable name="hyperkey" select="descendant::hyperlinktextdestination[1]/@destinationuniquekey" />
        <xsl:variable name="class" select="@class" />

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="matches(lower-case($class), 'orderlist')">
                    <xsl:value-of select="'li'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'p'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$name}">
            <xsl:if test="$hyperkey">
                <xsl:attribute name="hyperkey" select="$hyperkey" />
            </xsl:if>

            <xsl:choose>
                <xsl:when test="matches(lower-case($class), 'orderlist')">
                    <xsl:apply-templates select="@* except @ast-id" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:apply-templates select="@*" />
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="node()" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="span">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and 
                            child::image[matches(@class, 'C_Note')]">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:when test="@class = 'C_URL'">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <a>
                        <xsl:attribute name="href" select="." />
                        <xsl:apply-templates select="node()" />
                    </a>
                </xsl:copy>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" priority="5">
        <xsl:choose>
            <xsl:when test="matches(name(), '^(row|column)$')">
                <xsl:variable name="num" select="." />
                <xsl:variable name="name" select="if (name() = 'row') then 'rowspan' else 'colspan'" />

                <xsl:if test="$num &gt; 1">
                    <xsl:attribute name="{$name}" select="$num" />
                </xsl:if>
            </xsl:when>

            <xsl:when test="name() = 'cellstyle'">
                <xsl:attribute name="class" select="." />
            </xsl:when>

            <xsl:when test="name() = 'bodyrowcount'">
                <xsl:attribute name="rowcnt" select="." />
            </xsl:when>

            <xsl:when test="name() = 'headerrowcount'">
                <xsl:attribute name="headcnt" select="." />
            </xsl:when>

            <xsl:when test="matches(name(), '^(rowNum|name)$')">
            </xsl:when>

            <xsl:when test="matches(., 'indentgroup')">
                <xsl:attribute name="{local-name()}" select="replace(., 'indentgroup', 'indent_')" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
