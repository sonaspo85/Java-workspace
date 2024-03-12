<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

    <xsl:attribute-set name="b">
        <!-- <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="parent::*[contains(@class, 'topic/li ')] and
                                local-name()='b'">
                    <xsl:value-of select="'700'" />
                </xsl:when>
                <xsl:otherwise>600</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        
        <xsl:attribute name="font-weight">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:choose>
                        <xsl:when test="parent::*[contains(@class, 'topic/li ')] and
                                        local-name()='b'">
                            <xsl:value-of select="'600'" />
                        </xsl:when>
                        <xsl:otherwise>500</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="parent::*[contains(@class, 'topic/li ')] and
                                        local-name()='b'">
                            <xsl:value-of select="'700'" />
                        </xsl:when>
                        <xsl:otherwise>600</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-family">
            <xsl:choose>
                <xsl:when test="matches(substring-after($locale, '-'), 'KR')">
                    <xsl:value-of select="'삼성긴고딕OTF'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'semi')">
                            <xsl:value-of select="'Myriad Pro Semibold'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="$base-font-family" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="font-stretch">92%</xsl:attribute>

        <xsl:attribute name="text-decoration">
            <xsl:choose>
                <xsl:when test="matches(@outputclass, 'underline')">
                    <xsl:value-of select="'underline'" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:value-of select="'none'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>