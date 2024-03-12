<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    exclude-result-prefixes="xs son xsi idPkg functx"
    version="2.0">
    
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="region" />
    
    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="removeBr" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="*[child::br]" mode="removeBr">
        <xsl:variable name="cur" select="." />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="not(self::br) and not(preceding-sibling::br)">
                        <xsl:choose>
                            <xsl:when test="ancestor::div[matches(@fileName, 'mea_turkish')]">
                                <xsl:choose>
                                    <xsl:when test="$cur[tokenize(@class, ':')[2] = '1']">
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" />
                                        </xsl:copy>
                                        
                                        <xsl:copy-of select="normalize-space(following-sibling::text())" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="matches(@fileName, 'device')">
                <xsl:for-each select="listitem">
                    <xsl:variable name="pos" select="position()" />
                    
                    <xsl:for-each select="*[text()]">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:variable name="name">
                            <xsl:choose>
                                <xsl:when test="matches(name(), '모델명')">
                                    <xsl:value-of select="'model'" />
                                </xsl:when>
                                
                                <xsl:when test="matches(name(), '자재_코드')">
                                    <xsl:value-of select="'meterialcode'" />
                                </xsl:when>
                                
                                <xsl:when test="matches(name(), '제품_유형')">
                                    <xsl:value-of select="'product'" />
                                </xsl:when>
                                
                                <xsl:when test="matches(name(), '화면_지문_인식_유형')">
                                    <xsl:value-of select="'optical'" />
                                </xsl:when>
                                
                                <xsl:when test="matches(name(), '충전_방식')">
                                    <xsl:value-of select="'chargingtype'" />
                                </xsl:when>

                                <xsl:when test="matches(name(), 'LTE5G_PC2')">
                                    <xsl:value-of select="'lte5gpc2'" />
                                </xsl:when>

                                <xsl:when test="matches(name(), 'Wi-Fi_주파수_대역')">
                                    <xsl:value-of select="'frequencyband'" />
                                </xsl:when>

                                <xsl:when test="matches(name(), '유럽_인증_방식')">
                                    <xsl:value-of select="'wlanregion'" />
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:element name="{$name}">
                            <xsl:choose>
                                <xsl:when test="matches(name(), '^(모델명|자재_코드|제품_유형|화면_지문_인식_유형|LTE5G_PC2|Wi-Fi_주파수_대역|유럽_인증_방식)$')">
                                    
                                    <xsl:choose>
                                        <xsl:when test="matches(name(), '^(유럽_인증_방식)$')">
                                            <xsl:attribute name="name" select="lower-case(replace(replace(., '\+', 'and'), '\s+', ''))" />
                                        </xsl:when>

                                        <xsl:when test="matches(name(), '^(제품_유형)$')">
                                            <xsl:attribute name="type" select="." />
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:attribute name="name" select="." />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>

                                <xsl:when test="matches(name(), '충전_방식')">
                                    <xsl:variable name="str">
                                        <xsl:choose>
                                            <xsl:when test="matches(., '^고속$')">
                                                <xsl:value-of select="'Y'" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of select="'N'" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>

                                    <xsl:attribute name="type" select="$str" />
                                </xsl:when>

                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            
            <xsl:when test="matches(@fileName, 'red_band_mode')">
                <xsl:choose>
                    <xsl:when test="matches(@fileName, 'red_band_mode\(ukr\)\.xml')">
                        <xsl:call-template name="bandNode">
                            <xsl:with-param name="str" select="'bandmode_ukr'" />
                        </xsl:call-template>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:call-template name="bandNode">
                            <xsl:with-param name="str" select="'bandmode'" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- <xsl:element name="{$fileName}">
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:choose>
                                    <xsl:when test="$subListPos = '1'">
                                        <xsl:attribute name="division" select="$cur" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '2'">
                                        <xsl:variable name="str">
                                            <xsl:variable name="cur" select="replace(., '~', '_')" />
                                            
                                            <xsl:analyze-string select="$cur" regex="(LTE)(\s+)(\d+)">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="regex-group(1)" />
                                                    <xsl:value-of select="'_'" />
                                                    <xsl:value-of select="regex-group(3)" />
                                                </xsl:matching-substring>
                                                
                                                <xsl:non-matching-substring>
                                                    <xsl:analyze-string select="." regex="\((FR)(\d+)\)">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="concat('_(', regex-group(1), regex-group(2), ')')" />
                                                        </xsl:matching-substring>
                                                        
                                                        <xsl:non-matching-substring>
                                                            <xsl:analyze-string select="." regex="WCDMA Band VIII">
                                                                <xsl:matching-substring>
                                                                    <xsl:value-of select="'wcdma900'" />
                                                                </xsl:matching-substring>
                                                                
                                                                <xsl:non-matching-substring>
                                                                    <xsl:analyze-string select="." regex="WCDMA Band I">
                                                                        <xsl:matching-substring>
                                                                            <xsl:value-of select="'wcdma2100'" />
                                                                        </xsl:matching-substring>
                                                                        
                                                                        <xsl:non-matching-substring>
                                                                            <xsl:analyze-string select="." regex="NFC 13.56MHz">
                                                                                <xsl:matching-substring>
                                                                                    <xsl:value-of select="'nfc1'" />
                                                                                </xsl:matching-substring>
                                                                                
                                                                                <xsl:non-matching-substring>
                                                                                    <xsl:value-of select="." />
                                                                                </xsl:non-matching-substring>
                                                                            </xsl:analyze-string>
                                                                        </xsl:non-matching-substring>
                                                                    </xsl:analyze-string>
                                                                </xsl:non-matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:non-matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                            
                                        </xsl:variable>
                                        
                                        <xsl:attribute name="bandandmode" select="replace(lower-case(replace(replace(replace($str, '\s+', ''), 
                                                            '[.]', '_'), 
                                                        'Wi-Fi', 'wifi'))
                                                , '_\((fr)(\d)\)', '_(FR$2)')"  />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '3'">
                                        <xsl:attribute name="outputpower" select="$cur" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '4'">
                                        <xsl:attribute name="supportstatus" select="$cur" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </xsl:element> -->
            </xsl:when>
            
            <xsl:when test="matches(@fileName, 'sar')">
                <sars>
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:choose>
                                    <xsl:when test="$subListPos = '1'">
                                        <xsl:attribute name="division" select="replace($cur, 'Chi\(TC\)', 'Chi(Taiwan)')" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '2'">
                                        <xsl:attribute name="item" select="lower-case(replace($cur, '\s+', ''))" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '3'">
                                        <xsl:attribute name="value" select="$cur" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </sars>
            </xsl:when>
            
            <xsl:when test="matches(@fileName, 'mea_turkish')">
                <productSpec>
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:choose>
                                    <xsl:when test="$subListPos = '1'">
                                        <xsl:attribute name="division" select="$cur" />
                                        <xsl:attribute name="item" select="lower-case(replace($cur, '\s+', ''))" />
                                    </xsl:when>
                                    
                                    
                                    <xsl:when test="$subListPos = '2'">
                                        <xsl:attribute name="value" select="$cur"  />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </productSpec>
            </xsl:when>
            
            <xsl:when test="matches(@fileName, 'sea_indonesian')">
                <registration>
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                
                                <xsl:attribute name="division" select="'regNum'" />
                                <xsl:attribute name="item" select="'regNum'" />
                                <xsl:attribute name="value" select="$cur" />
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </registration>
            </xsl:when>
            
            <xsl:when test="matches(@fileName, 'package_contents')">
                <packages>
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:choose>
                                    <xsl:when test="$subListPos = '1'">
                                        <xsl:attribute name="division" select="$cur" />
                                        <xsl:attribute name="item" select="lower-case(replace(replace($cur, '\s+', ''), '[()]', '_'))" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '2'">
                                        <xsl:attribute name="supportstatus" select="$cur" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </packages>
            </xsl:when>
            
            
            <xsl:when test="matches(@fileName, 'charging_support')">
                <chargingSupport>
                    <xsl:for-each select="listitem">
                        <xsl:variable name="pos" select="position()" />
                        <spec>
                            <xsl:for-each select="*">
                                <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:choose>
                                    <xsl:when test="$subListPos = '1'">
                                        <xsl:attribute name="division" select="replace($cur, 'Chi\(TC\)', 'Chi(Taiwan)')" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '2'">
                                        <xsl:variable name="changeVal">
                                            <xsl:choose>
                                                <xsl:when test="$cur = 'USB cable'">
                                                    <xsl:value-of select="'usbcablesupport'" />
                                                </xsl:when>
                                                
                                                <xsl:when test="$cur = 'Charger (min-max)'">
                                                    <xsl:value-of select="'chargingsupport'" />
                                                </xsl:when>

                                                <!-- <xsl:when test="$cur = '일반 충전'">
                                                    <xsl:value-of select="'maximumchargingsupport(n)'" />
                                                </xsl:when>

                                                <xsl:when test="$cur = '고속 충전'">
                                                    <xsl:value-of select="'maximumchargingsupport(y)'" />
                                                </xsl:when> -->
                                            </xsl:choose>
                                        </xsl:variable>

                                        <xsl:attribute name="item" select="$changeVal" />
                                    </xsl:when>
                                    
                                    <xsl:when test="$subListPos = '3'">
                                        <xsl:attribute name="value" select="$cur" />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </spec>
                    </xsl:for-each>
                </chargingSupport>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="underBar" priority="5">
        <xsl:analyze-string select="." regex="(LTE)(\s+)(\d+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" />
                <xsl:value-of select="'_'" />
                <xsl:value-of select="regex-group(3)" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="\s+">
                    <xsl:matching-substring>
                        <xsl:value-of select="''" />
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(.*?)(\()">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)" />
                                <xsl:value-of select="'_'" />
                                <xsl:value-of select="regex-group(2)" />
                            </xsl:matching-substring>
                            
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="(\d+)(-)(\d+)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)" />
                                        <xsl:value-of select="regex-group(2)" />
                                        <xsl:value-of select="regex-group(3)" />
                                    </xsl:matching-substring>
                                    
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="(\d+)([~.])(\d+)">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)" />
                                                <xsl:value-of select="'_'" />
                                                <xsl:value-of select="regex-group(3)" />
                                            </xsl:matching-substring>
                                            
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(.*)([~.]+)(.*)">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="regex-group(1)" />
                                                        <xsl:value-of select="'_'" />
                                                        <xsl:value-of select="regex-group(3)" />
                                                    </xsl:matching-substring>
                                                    
                                                    <xsl:non-matching-substring>
                                                        <xsl:analyze-string select="." regex="(\w+)([-])(\w+)">
                                                            <xsl:matching-substring>
                                                                <xsl:value-of select="regex-group(1)" />
                                                                <xsl:value-of select="regex-group(3)" />                                                        
                                                            </xsl:matching-substring>
                                                            
                                                            <xsl:non-matching-substring>
                                                                <xsl:value-of select="." />
                                                            </xsl:non-matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="bandNode">
        <xsl:param name="str" />
        
        <xsl:element name="{$str}">
            <xsl:for-each select="listitem">
                <xsl:variable name="pos" select="position()" />
                <spec>
                    <xsl:for-each select="*">
                        <xsl:variable name="subListPos" select="tokenize(@class, ':')[2]" />
                        <xsl:variable name="cur" select="." />

                        <xsl:choose>
                            <xsl:when test="$subListPos = '1'">
                                <xsl:attribute name="division" select="$cur" />
                            </xsl:when>

                            <xsl:when test="$subListPos = '2'">
                                <xsl:variable name="str">
                                    <xsl:variable name="cur" select="replace(., '~', '_')" />

                                    <xsl:analyze-string select="$cur" regex="(LTE)(\s+)(\d+)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)" />
                                            <xsl:value-of select="'_'" />
                                            <xsl:value-of select="regex-group(3)" />
                                        </xsl:matching-substring>

                                        <xsl:non-matching-substring>
                                            <xsl:analyze-string select="." regex="\((FR)(\d+)\)">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="concat('_(', regex-group(1), regex-group(2), ')')" />
                                                </xsl:matching-substring>

                                                <xsl:non-matching-substring>
                                                    <xsl:analyze-string select="." regex="WCDMA Band VIII">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="'wcdma900'" />
                                                        </xsl:matching-substring>

                                                        <xsl:non-matching-substring>
                                                            <xsl:analyze-string select="." regex="WCDMA Band I">
                                                                <xsl:matching-substring>
                                                                    <xsl:value-of select="'wcdma2100'" />
                                                                </xsl:matching-substring>

                                                                <xsl:non-matching-substring>
                                                                    <xsl:analyze-string select="." regex="NFC 13.56MHz">
                                                                        <xsl:matching-substring>
                                                                            <xsl:value-of select="'nfc1'" />
                                                                        </xsl:matching-substring>

                                                                        <xsl:non-matching-substring>
                                                                            <xsl:value-of select="." />
                                                                        </xsl:non-matching-substring>
                                                                    </xsl:analyze-string>
                                                                </xsl:non-matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:non-matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>

                                </xsl:variable>

                                <xsl:attribute name="bandandmode" select="replace(lower-case(replace(replace(replace($str, '\s+', ''),
                                                                        '[.]', '_'),
                                                                        'Wi-Fi', 'wifi'))
                                                                        , '_\((fr)(\d)\)', '_(FR$2)')"  />
                            </xsl:when>

                            <xsl:when test="$subListPos = '3'">
                                <xsl:attribute name="outputpower" select="$cur" />
                            </xsl:when>

                            <xsl:when test="$subListPos = '4'">
                                <xsl:attribute name="supportstatus" select="$cur" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </spec>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>
    
    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>
