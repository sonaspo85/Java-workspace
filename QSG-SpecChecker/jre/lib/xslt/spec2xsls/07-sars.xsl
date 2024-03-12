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
                <xsl:variable name="cur" select="." />
                <xsl:variable name="fileName" select="@fileName" />
                <xsl:variable name="lang" select="@lang" />
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:attribute name="lang" select="$lang" />
                    
                    <xsl:attribute name="apply">
                        <xsl:choose>
                            <xsl:when test="matches($lang, '^(Fre\(EU\)|Fre|Tur|Ind|Khm|Mya|Chi\(Singapore\)|Tha|Vie|Ben|Eng\(India\)|Chi\(Taiwan\)|Ind|Lao)$')">
                                <xsl:value-of select="'true'" />
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:value-of select="'false'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:attribute name="exc">
                        <xsl:value-of select="''" />
                    </xsl:attribute>
                    
                    <xsl:for-each select="item">
                        <xsl:variable name="cur" select="." />
                        <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
                        <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
                        
                        <xsl:variable name="flwUnit" select="following-sibling::*[1]" />
                        <xsl:variable name="preUnit" select="preceding-sibling::*[matches(tokenize(@class, ':')[1], '6')]" />
                        
                        <xsl:variable name="sID">
                            <xsl:variable name="vals" select="$engCollection/sars/items/item[matches(tokenize(@class, ':')[1], $rowNum)]" />
                            
                            <xsl:choose>
                                <xsl:when test="matches($rowNum, '^2$')">
                                    <xsl:value-of select="'maxsar'" />
                                </xsl:when>
                                
                                <xsl:when test="matches($rowNum, '^(9|10)$')">
                                    <xsl:value-of select="'distance'" />
                                </xsl:when>
                                
                                <xsl:when test="matches($rowNum, '^11$')">
                                    <xsl:value-of select="'buds-sars'" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="lower-case(replace($vals, '\s+', ''))" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="sUnit">
                            <xsl:choose>
                                <xsl:when test="matches($rowNum, '^(3|5)$')">
                                    <xsl:value-of select="tokenize($flwUnit, ' ')[2]" />
                                </xsl:when>
                                
                                <xsl:when test="matches($rowNum, '^(11)$')">
                                    <xsl:value-of select="tokenize($preUnit, ' ')[2]" />
                                </xsl:when>
                                
                                <xsl:when test="matches($rowNum, '^(9|10)$')">
                                    <xsl:choose>
                                        <xsl:when test="matches($lang, '^(Ara|Arm|Aze|Bul|Far|Geo|Gre|Heb|Hin|Kaz|Mac|Mon|Rus|Tha|Ukr|Urd|Uzb)$')">
                                            <xsl:variable name="vals" select="$multiUnit/unit/items[matches(@lang, $lang)]/item[matches(tokenize(@class, ':')[1], '5')]" />
                                            <xsl:value-of select="$vals" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($lang, '^HongKong$')">
                                            <xsl:variable name="vals" select="$multiUnit/unit/items[matches(@lang, '^HK-Chinese$')]/item[matches(tokenize(@class, ':')[1], '5')]" />
                                            <xsl:value-of select="$vals" />
                                        </xsl:when>
                                        
                                        <xsl:when test="matches($lang, '^Chi\(Singapore\)$')">
                                            <xsl:variable name="vals" select="$multiUnit/unit/items[matches(@lang, 'Singapore_Chinese')]/item[matches(tokenize(@class, ':')[1], '5')]" />
                                            <xsl:value-of select="$vals" />
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="'cm'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                
                                <xsl:when test="number($rowNum) &gt; 5 and number($rowNum) &lt; 9">
                                    <xsl:value-of select="tokenize($preUnit, ' ')[2]" />
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:if test="matches($rowNum, '^(2|3|5|7|8|9|10|11)$')">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" />
                                
                                <xsl:attribute name="id" select="$sID" />
                                
                                <xsl:if test="not(matches($rowNum, '^(2)$'))">
                                    <xsl:attribute name="unit" select="$sUnit" />
                                </xsl:if>

                                <xsl:apply-templates select="node()" />
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>