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
    
    
    <xsl:template match="table">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>

        <xsl:choose>
            <xsl:when test="tr[not(following-sibling::tr)]
                            /td[not(following-sibling::td)]
                            /*[not(following-sibling::node())][count(node()) = 1]
                            /node()[not(following-sibling::node())][name()='img']">
                <xsl:variable name="tdLastimg" select="tr[not(following-sibling::tr)]/td[not(following-sibling::td)]/*[not(following-sibling::node())][count(node()) = 1]/node()[not(following-sibling::node())][name()='img']" />

                <div>
                    <xsl:apply-templates select="$tdLastimg/parent::*/@class" />
                    <xsl:copy-of select="$tdLastimg" />
                </div>
            </xsl:when>

            <xsl:when test="tr[not(following-sibling::tr)]
                            /td[not(following-sibling::td)]
                            /*[not(following-sibling::node())]
                            /node()[not(following-sibling::node())][name()='img']">
                <xsl:variable name="tdLastimg" select="tr[not(following-sibling::tr)]/td[not(following-sibling::td)]/*[not(following-sibling::node())]/node()[not(following-sibling::node())][name()='img']" />
                
                <div>
                    <xsl:apply-templates select="$tdLastimg/parent::*/@class" />
                    <xsl:copy-of select="$tdLastimg" />
                </div>
            </xsl:when>
        
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="td">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="ancesTable" select="ancestor::table[1]" />


        <xsl:choose>
            <xsl:when test="parent::tr[not(following-sibling::tr)] and 
                            not(following-sibling::td) and 
                            child::*[not(following-sibling::node())][count(node()) = 1][child::img]">
                <!-- <bbb>
                    <xsl:apply-templates select="@* | node()"/>
                </bbb> -->
            </xsl:when>

            <xsl:when test="parent::tr[not(following-sibling::tr)] and 
                            not(following-sibling::td) and 
                            child::*[not(following-sibling::node())][child::img]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()"/>
                </xsl:copy>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img">
        <xsl:choose>
            <xsl:when test="not(following-sibling::node()) and 
                            ancestor::td[not(following-sibling::node())]
                            /parent::tr[not(following-sibling::node())]">
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
