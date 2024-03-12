<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p li" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="str0">
                
                <xsl:for-each-group select="*" group-adjacent="boolean(self::*[matches(@class, '(Sub-Bullet-1|Bullet-1)')])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <ul class="{current-group()[1]/@class}">
                                <xsl:apply-templates select="current-group()/li"/>
                            </ul>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>

            <xsl:for-each-group select="$str0/*" group-adjacent="boolean(self::*[matches(@class, '(ListHeading|Sub-Bullet-1)')])">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <grouped>
                            <xsl:apply-templates select="current-group()"/>
                        </grouped>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>