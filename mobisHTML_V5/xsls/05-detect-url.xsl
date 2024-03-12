<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="p"/>

    <xsl:variable name="data-language" select="/body/@data-language" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="chapter">
        <chapter>
            <xsl:apply-templates select="@* | node()" />
        </chapter>
    </xsl:template>

    <xsl:template match="p[normalize-space(.)='']" priority="10">
        <xsl:if test="img">
            <xsl:apply-templates select="img" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="p[parent::body] | img[parent::body] | table[parent::body]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="span">
        <xsl:variable name="cur" select="if (matches(., '^(https?)')) then 
                                         replace(replace(., '(.*)(\.)$', '$1'), '&#x200A;', '') else 
                                         concat('https://', replace(replace(., '(.*)(\.)$', '$1'), '&#x200A;', ''))" />
        <xsl:choose>
            <xsl:when test="matches(@class, 'C_URL')">
                <xsl:choose>
                    <xsl:when test="matches(., '^\.$')">
                        <xsl:apply-templates select="node()" />
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="C_URL">
                            <xsl:apply-templates select="@* except @class" />
                            <a href="{$cur}">
                                <xsl:apply-templates select="@* | node()" />
                            </a>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="matches(@class, 'C_Noline')">
                <span class="C_Noline">
                    <xsl:apply-templates select="@* except @class" />
                    <a href="{if (matches(., '^(https?)')) then 
                    		 replace(., '(.*)(\.)$', '$1') else 
                    		 concat('https://', replace(., '(.*)(\.)$', '$1'))}">
                        <xsl:apply-templates select="@* | node()" />
                    </a>
                </span>
            </xsl:when>

            <xsl:when test="matches(@href, '^mailto')">
                <xsl:apply-templates />
            </xsl:when>

            <xsl:when test="matches(@class, '^C_CrossReference$') and 
                            string(@href)">
                <span class="C_CrossReference">
                    <a href="{@href}">
                        <xsl:value-of select="." />
                    </a>
                </span>
            </xsl:when>

            <xsl:when test="following-sibling::node()[1][matches(@class, 'C_Superscript-R-TM')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                    <xsl:for-each select="following-sibling::*[1]">
                        <sup>
                            <xsl:apply-templates select="@* | node()" />
                        </sup>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@class, 'C_Superscript-R-TM') and 
                            preceding-sibling::node()[1][name()='span']">
            </xsl:when>

            <xsl:when test="preceding-sibling::node()[1][name()='span'] and 
            				matches(., '^(\s)(.*)')">
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="parent::*[not(matches(@class, 'Heading'))] and 
                            				self::text()">
                                <xsl:value-of select="replace(., '^(\s)', '&#xA0;')" />
                            </xsl:when>
                            
                            <xsl:when test="parent::*[matches(@class, 'Heading')] and 
                            				self::text()">
                                <xsl:value-of select="replace(., '^(\s)', '&#x20;')" />
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

            <xsl:when test="matches(@class, 'C_Superscript-R-TM')">
                <sup>
                    <xsl:apply-templates select="@* | node()" />
                </sup>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()[parent::*[not(matches(upper-case(@class), '(^C_URL$|^C_CROSSREFERENCE$|^C_NOLINE$)'))]]" priority="10">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="pClass" select="parent::*/@class" />
        
    	<xsl:analyze-string select="." regex="(https?://?(\w*:\w*@)?[\-\w.]+(:\d+)?(/([\-\w/_.]*(\?\S+)?)?)?)">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="$pClass = 'C_URL'">
                        <a href="{replace(regex-group(1), '.$', '')}">
                            <xsl:value-of select="regex-group(1)"/>
                        </a>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <span class="C_URL">
                            <a href="{replace(regex-group(1), '\.$', '')}">
                                <xsl:value-of select="regex-group(1)"/>
                            </a>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(www[a-zA-Z.\-]*)(\.)?">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="matches(., 'www.divx.com')">
                                <a href="{concat('https://', regex-group(1))}">
                                    <xsl:value-of select="regex-group(1)"/>
                                    <xsl:value-of select="regex-group(2)" />
                                </a>
                            </xsl:when>
                            <xsl:when test="$pClass = 'C_URL'">
                                <a href="{concat('https://', regex-group(1))}">
                                    <xsl:value-of select="regex-group(1)"/>
                                </a>
                                <xsl:value-of select="regex-group(2)" />
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="C_URL">
                                    <a href="{concat('https://', regex-group(1))}">
                                        <xsl:value-of select="regex-group(1)"/>
                                    </a>
                                </span>
                                <xsl:value-of select="regex-group(2)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:copy/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>