<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:import href="00-commonVar.xsl"/>
    <xsl:character-map name="a">
        <xsl:output-character character="&quot;" string="&amp;quot;" />
        <xsl:output-character character="&apos;" string="&amp;apos;" />
    </xsl:character-map>

    <xsl:key name="target" match="*[@id]" use="@id" />

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" use-character-maps="a" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:variable name="id" select="substring-after(@href, '#')" />
        <xsl:variable name="ohref" select="substring-after(@ohref, '#')" />
        <xsl:variable name="cur" select="." />
        
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:choose>
                        <xsl:when test="key('target', $id)[name()='h0']">
                            <xsl:variable name="flwTopic" select="key('target', $id)/following-sibling::topic[1]" />
                            
                            <xsl:attribute name="href">
                                <xsl:value-of select="if (count($flwTopic[@file]/div) &gt; 1) 
                                                      then replace($flwTopic[@file]/@file, '^(.+)_.+(\.html)$', '$1$2')
                                                      else $flwTopic[@file]/@file" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:when test="key('target', $id)[matches(name(), 'h(1|2)')]">
                            <xsl:variable name="str" select="if (count(key('target', $id)[matches(name(), 'h(1|2)')]) &gt; 1) then 
                                                             key('target', $id)[matches(name(), 'h(1|2)')][@oid=$ohref] else 
                                                             key('target', $id)[matches(name(), 'h(1|2)')]" />
                            
                            <xsl:attribute name="href">
                                <xsl:for-each select="$str">
                                    <xsl:choose>
                                        <xsl:when test="self::h1[.=$cur]">
                                            <xsl:variable name="finalFileVal">
                                                <xsl:variable name="ancesTopic" select="ancestor::topic[@file]" />
                                                <xsl:variable name="getlastID" select="tokenize(replace($ancesTopic/@file, '.html', ''), '_')[last()]" />
                                                
                                                <xsl:value-of select="if ($getlastID = $id) then 
                                                                      ancestor::topic[@file]/@file else 
                                                                      concat(ancestor::topic[@file]/@file, '#', $id)"/>
                                            </xsl:variable>
                                            
                                            <xsl:value-of select="$finalFileVal" />
                                        </xsl:when>
                                        
                                        <xsl:when test="self::h2[.=$cur]">
                                            <xsl:choose>
                                                <xsl:when test="matches(@class, 'heading2-continue')">
                                                    <xsl:variable name="firstH2ID" select="parent::*/h2[1]/@id" />
                                                    <xsl:value-of select="concat(ancestor::topic[@file]/@file, '#', $firstH2ID, '#', $id)" />
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat(ancestor::topic[@file]/@file, '#', $id)" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:attribute>
                        </xsl:when>
                        
                        <xsl:when test="key('target', $id)[matches(name(), 'h3')]/ancestor::div">
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat(key('target', $id)/ancestor::topic[@file]/@file, 
                                                                 '#', 
                                                                 key('target', $id)/preceding-sibling::h2[1]/@id, 
                                                                 '#', 
                                                                 $id)" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:when test="key('target', $id)[matches(name(), 'h4')]/ancestor::div">
                            <xsl:variable name="preceding-h3" select="key('target', $id)/preceding-sibling::h3[1]/@id" />
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat(key('target', $id)/ancestor::topic[@file]/@file, 
                                                                 '#', 
                                                                 key('target', $id)/preceding-sibling::h2[1]/@id, 
                                                                 '#', 
                                                                 $preceding-h3, 
                                                                 '#', 
                                                                 $id)" />
                            </xsl:attribute>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:apply-templates select="@href" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="@href" />
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
