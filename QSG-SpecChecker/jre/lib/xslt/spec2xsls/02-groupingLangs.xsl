<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" 
    exclude-result-prefixes="xs idPkg ast dita-ot"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
	
    <xsl:param name="srcDirs" />
    
    <!--<xsl:variable name="srcDirs0" select="concat('file:////', replace($srcDirs, '\\', '/'))"  />
	
    
    <xsl:variable name="directory" select="collection(concat($srcDirs0, '/?select=', '*.xml;recurse=yes'))" />-->
    
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="div">
        <xsl:variable name="fileName" select="@fileName" />
        
        <xsl:variable name="changeTag">
            <xsl:choose>
                <xsl:when test="matches($fileName, 'Band-mode')">
                    <xsl:value-of select="'bandmode'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'Charging-support')">
                    <xsl:value-of select="'chargingsupport'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'e-DoC')">
                    <xsl:value-of select="'eDoc'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'etc')">
                    <xsl:value-of select="'etc'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'Fingerprint-sensor')">
                    <xsl:value-of select="'fingerprint'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'Green issue')">
                    <xsl:value-of select="'greenissue'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'INDIA-BIS')">
                    <xsl:value-of select="'indiabis'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'opensource')">
                    <xsl:value-of select="'opensources'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'Package-contents')">
                    <xsl:value-of select="'packages'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'PO-BOX')">
                    <xsl:value-of select="'pobox'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'Safety-info')">
                    <xsl:value-of select="'safetyinfo'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'SAR')">
                    <xsl:value-of select="'sars'" />
                </xsl:when>
                
                <xsl:when test="matches($fileName, 'unit')">
                    <xsl:value-of select="'unit'" />
                </xsl:when>

                <xsl:when test="matches($fileName, 'WLAN')">
                    <xsl:value-of select="'wlan'" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="{$changeTag}">
            <xsl:choose>
                <xsl:when test="matches($fileName, '^(Band-mode|etc|Package-contents|SAR|unit|Fingerprint-sensor|opensource|INDIA-BIS|e-DoC|Green issue|Charging-support|PO-BOX|Safety-info|WLAN)$')">
                    <xsl:for-each-group select="listitem/item" group-by="@lgn">
                        <xsl:choose>
                            <xsl:when test="current-grouping-key()">
                                <items>
                                    <xsl:attribute name="lang" select="current-group()[1]/@lgn" />
                                    <xsl:apply-templates select="current-group()" />
                                </items>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:variable name="parClass" select="parent::*/@class" />
        <xsl:copy>
            <xsl:attribute name="value" select="$parClass" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    
    
</xsl:stylesheet>