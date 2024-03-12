<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="nested">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="nested"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div[matches(@class, 'imgNp_desCenter')]">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
            
            <xsl:if test="following-sibling::node()[1][name()='group']
                          /*[1][matches(@class, 'OL\d_\d-Color')]">
                <xsl:for-each select="following-sibling::node()[1]">
                    <ol class="color">
                        <xsl:apply-templates select="node()" />
                    </ol>
                </xsl:for-each>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p[contains(@class, 'OL')][following-sibling::*[1][name()='group']]">
        <xsl:variable name="current" select="." />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                
                <xsl:if test="position()=last()">
                    <xsl:apply-templates select="$current/following-sibling::node()[1][name()='group']" mode="nested" />
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[parent::topic]
                          [not(matches(name(), 'topic|group|ul|p'))]
                          [not(matches(@class, '^Caution|Warning$|OL|^Description'))]
                          [preceding-sibling::*[1][name()='group']]">
    </xsl:template>

    <xsl:template match="*[parent::topic][name()='ul']
                          [@class='Step-UL1_2-Note']
                          [preceding-sibling::*[1][name()='group']]">
    </xsl:template>

    <xsl:template match="group">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][contains(@class, 'OL')]" />
            
            <xsl:when test="preceding-sibling::*[1][name()='same-level']" />
            
            <xsl:when test="preceding-sibling::*[1][matches(@class, 'imgNp_desCenter')]" />
            
            <xsl:otherwise>
                <ol class="color">
                    <xsl:apply-templates select="@* except @class" />
                    <xsl:apply-templates select="node()" />
                </ol>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="group" mode="nested">
        <ol class="nested color">
            <xsl:apply-templates mode="nested" />
        </ol>
        
        <xsl:if test="li[last()]/ul[@class='Step-UL1_2-Note']">
            <xsl:copy-of select="li[last()]/ul[@class='Step-UL1_2-Note']" />
        </xsl:if>

        <xsl:choose>
            <xsl:when test="following-sibling::*[1][matches(@class, '^Step-UL1_2-Note$')]">
                <xsl:copy-of select="following-sibling::*[1]" />
            </xsl:when>
            
            <xsl:when test="following-sibling::*[1][not(matches(name(), 'topic|group|ul|p'))] and 
                            following-sibling::*[1][not(matches(@class, '^Caution|Warning$|OL|^Description'))]">
                <xsl:copy-of select="following-sibling::*[1]" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul[@class='Step-UL1_2-Note'][parent::li[last()]]" mode="nested" />
        
</xsl:stylesheet>