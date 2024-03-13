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
    

    <xsl:template match="@* | node()">
		<xsl:copy inherit-namespaces="no" copy-namespaces="no">
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>

    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="*" mode="abc">
        <xsl:element name="{lower-case(local-name())}">
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="abc">
        <xsl:choose>
            <xsl:when test="matches(name(), 'href')">
                <xsl:attribute name="{lower-case(local-name())}" select="." />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="{lower-case(local-name())}" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Story" mode="abc">
        <xsl:choose>
            <xsl:when test="parent::body and 
                            not(descendant::text())">
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates mode="abc" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="br">
        <xsl:choose>
            <xsl:when test="not(ancestor::*[matches(@class, '^(OrderList|UnorderList)')])">
                <xsl:choose>
                    <xsl:when test="count(parent::*/node()) = 1" />

                    <xsl:when test="preceding-sibling::node()[1][name()='br']">
                        <br size="2" />
                    </xsl:when>

                    <xsl:when test="following-sibling::node()[1][name()='br']">
                    </xsl:when>
                    
                    <xsl:when test="preceding-sibling::node()[1][name()='table']" />
                    
                    <xsl:when test="not(following-sibling::node()) and 
                                    preceding-sibling::node()[1][name()='content']" />

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(parent::*/node()) = 1" />

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" />
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="content | body">
        <xsl:apply-templates /> 
    </xsl:template>

    <xsl:template match="image">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="matches(@class, 'no character style')">
                    <xsl:apply-templates select="@* except @class" />
                </xsl:when>
            
                <xsl:otherwise>
                    <xsl:apply-templates select="@*" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
