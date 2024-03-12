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
    
    <xsl:variable name="srcDirs0" select="concat('file:////', replace($srcDirs, '\\', '/'))"  />
    <xsl:variable name="directory" select="collection(concat($srcDirs0, '/?select=', '*.xml;recurse=yes'))" />
    
    
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:variable name="engCollection">
        <xsl:for-each select="root/*">
            <xsl:variable name="name" select="name()" />
            <xsl:copy>
                <xsl:apply-templates select="@*" />
                
                <xsl:for-each select="items[matches(@lang, '^(Eng|EN)$')]">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="multiUnit">
        <xsl:for-each select="root/unit">
            <xsl:copy>
                <xsl:apply-templates select="@*, node()" />
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="sars">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="items">
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:for-each select="item">
                        <xsl:variable name="cur" select="." />
                        <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
                        <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
                        
                        <xsl:if test="not(matches($rowNum, '^(9|10|11)$'))">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                    
                    <xsl:if test="matches($lang, 'Fre\(EU\)')">
                        <item id="limbsar1" unit="W/kg">DAS membre</item>
                    </xsl:if>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
        
        <distance>
            <xsl:for-each select="items">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="fileName" select="@fileName" />
                <xsl:variable name="lang" select="@lang" />

                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="lang" select="$lang" />
                    
                    <xsl:attribute name="apply">
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^(Fre\(EU\)|Fre|Tur|Ind|Khm|Mya|Chi\(Singapore\)|Vie|Ben|Lao)$')">
                                <xsl:value-of select="'true'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'false'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:for-each select="item">
                        <xsl:variable name="cur" select="." />
                        <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
                        <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
                        
                        <xsl:if test="matches($rowNum, '^9$')">
                            <xsl:apply-templates select="." />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </distance>
        
        <w-distance>
            <xsl:for-each select="items">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="fileName" select="@fileName" />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="lang" select="$lang" />
                    
                    <xsl:attribute name="apply">
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^(Fre\(EU\)|Fre|Tur|Ind|Khm|Mya|Chi\(Singapore\)|Vie|Ben|Lao)$')">
                                <xsl:value-of select="'true'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'false'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:for-each select="item">
                        <xsl:variable name="cur" select="." />
                        <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
                        <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
                        
                        <xsl:if test="matches($rowNum, '^10$')">
                            <xsl:apply-templates select="." />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </w-distance>
        
        <buds-sars>
            <xsl:for-each select="items">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="fileName" select="@fileName" />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="lang" select="$lang" />
                    
                    <xsl:attribute name="apply">
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^(Fre\(EU\)|Fre|Tur|Ind|Khm|Mya|Chi\(Singapore\)|Vie|Ben|Lao)$')">
                                <xsl:value-of select="'true'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'false'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:for-each select="item">
                        <xsl:variable name="cur" select="." />
                        <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
                        <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
                        
                        <xsl:if test="matches($rowNum, '^11$')">
                            <xsl:copy>
                                <xsl:apply-templates select="@* except @id" />
                                <xsl:attribute name="id" select="'body-wornsar'" />
                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </buds-sars>
    </xsl:template>
    
    <xsl:template match="@class[not(ancestor::unit)]">
    </xsl:template>
    
</xsl:stylesheet>