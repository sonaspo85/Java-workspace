<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs idPkg ast dita-ot" 
    version="2.0">


    <xsl:output method="xml" encoding="UTF-8" indent="no"/>

    <xsl:param name="specXMLF"/>
    <xsl:param name="region"/>

    <xsl:variable name="specXMLF00" select="replace(replace(replace($specXMLF, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"/>
    <xsl:variable name="specXMLF01" select="concat('file:////', $specXMLF00)"/>
    <xsl:variable name="specXMLF02" select="iri-to-uri($specXMLF01)"/>
    <xsl:variable name="specXML" select="document($specXMLF02)/*[local-name() = 'root']"/>
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="chargingNode" select="$specXML/*[local-name() = 'chargingSupport']/spec"/>
    
    <xsl:template match="bandmode">
        <xsl:choose>
            <xsl:when test="matches($region, 'Ukr')">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="items">
                        <xsl:variable name="lang" select="@lang" />
                        
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^Ukr$')">
                            </xsl:when>
                            
                            <xsl:when test="matches($lang, '^Ukr\(UKR\)$')">
                                <xsl:copy>
                                    <xsl:attribute name="lang" select="'Ukr'" />
                                    <xsl:apply-templates select="@* except @lang" />
                                    <xsl:apply-templates select="node()" />
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="not(matches($region, 'Ukr'))">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="items">
                        <xsl:variable name="lang" select="@lang" />
                        
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^Ukr$')">
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:when test="matches($lang, '^Ukr\(UKR\)$')">
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="item[ancestor::chargingsupport]">
        <xsl:variable name="lang" select="parent::items/@lang"/>
        <xsl:variable name="id" select="@id"/>

        <xsl:variable name="getAttr">
            <xsl:choose>
                <xsl:when test="$chargingNode[@item = $id][@division = $lang]">
                    <xsl:value-of select="$chargingNode[@division = $lang][@item = $id]/@value"/>
                </xsl:when>

                <xsl:when test="matches(@id, 'chargingsupport')">
                    <xsl:value-of select="$chargingNode[@division = 'Common'][@item = 'chargingsupport']/@value"/>
                </xsl:when>

                <xsl:when test="$chargingNode[@item = $id][@division != $lang]">
                    <xsl:value-of select="$chargingNode[@division = 'Common'][@item = $id]/@value"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!--<xsl:variable name="splitTxt">
            <xsl:for-each select="$getAttr">
                <xsl:choose>
                    <xsl:when test="matches(., '/')">
                        <xsl:for-each select="tokenize(., ' / ')">
                            <div class="{position()-1}">
                                <xsl:value-of select="."/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>

                    <xsl:otherwise>
                        <div class="0">
                            <xsl:value-of select="."/>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>-->

        <xsl:copy>
            <xsl:attribute name="value" select="$getAttr" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="5">
        <xsl:value-of select="replace(., '&#x200B;', '')" />
    </xsl:template>
    
    <!-- <xsl:template match="text()" priority="5">
        <xsl:param name="splitTxt" />
        
        <xsl:analyze-string select="." regex="(\{{0\}})">
            <xsl:matching-substring>
                <xsl:value-of select="$splitTxt/div[@class = '0']" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(\{{1\}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="$splitTxt/div[@class = '1']" />                        
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:value-of select="replace(., '&#x200B;', '')" />
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template> -->
    
</xsl:stylesheet>
