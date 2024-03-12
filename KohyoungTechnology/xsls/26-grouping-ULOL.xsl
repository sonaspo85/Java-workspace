<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a" />

    <xsl:variable name="open">&lt;div class=&quot;note reference&quot;&gt;</xsl:variable>
    <xsl:variable name="close">&lt;/div&gt;</xsl:variable>


    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="abc"/>
        </xsl:variable>

        <xsl:apply-templates select="$str0/*" />
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="li[not(following-sibling::li)]" mode="abc">
        <xsl:variable name="cur" select="parent::*/@class" />
        <xsl:variable name="flwNote" select="parent::*/following-sibling::node()[1]" />

        <xsl:choose>
            <xsl:when test="parent::*[matches(name(), '(ol|ul)')] and 
                            parent::*/following-sibling::node()[1][matches(@class, 'note reference')] and 
                            parent::*/following-sibling::node()[2][matches(@class, $cur)][@start &gt; 1]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                    <xsl:copy-of select="$flwNote" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="parent::*[matches(name(), '(ol|ul)')] and 
                            parent::*/following-sibling::node()[1][matches(@class, 'grouping\-note')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                    <xsl:copy-of select="$flwNote/node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="parent::*[matches(name(), '(ol|ul)')] and 
                            parent::*/following-sibling::node()[1][matches(@class, 'note reference')] and 
                            parent::*/following-sibling::node()[2][not(matches(@class, $cur))]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                    <xsl:copy-of select="$flwNote" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="parent::*[matches(name(), '(ol|ul)')] and 
                            parent::*/following-sibling::node()[1][matches(@class, 'note reference')][not(following-sibling::*)]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                    <xsl:copy-of select="$flwNote" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="div" mode="abc">
        <xsl:variable name="preStart" select="preceding-sibling::node()[1]/@start" />
        <xsl:choose>
            <xsl:when test="matches(@class, 'note reference') and 
                            preceding-sibling::node()[1][matches(name(), '(ol|ul)')] and 
                            following-sibling::node()[1][matches(name(), '(ol|ul)')]">
                <xsl:variable name="preCla" select="preceding-sibling::node()[1][matches(name(), '(ol|ul)')]/@class" />
                <xsl:variable name="flwCla" select="following-sibling::node()[1][matches(name(), '(ol|ul)')]/@class" />

                <xsl:choose>
                    <xsl:when test="matches($preCla, $flwCla) and 
                                    $preCla/parent::*/@start != $flwCla/parent::*/@start">
                    </xsl:when>
                    
                    <xsl:when test="$preCla != $flwCla">
                    </xsl:when>
                    
                    <!--<xsl:when test="parent::*[matches(name(), '(ol|ul)')] and 
                        parent::*/following-sibling::node()[1][matches(@class, 'note reference')] and 
                        parent::*/following-sibling::node()[2][not(matches(@class, $cur))]">
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="abc" />
                            <xsl:copy-of select="$flwNote" />
                        </xsl:copy>
                    </xsl:when>-->

                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="abc"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!--<xsl:when test="matches(@class, 'grouping\-note')">
            </xsl:when>-->
            
            <xsl:when test="matches(@class, 'grouping\-note') and 
                            preceding-sibling::*[1][matches(name(), '(ol|ul)')]">
            </xsl:when>

            <xsl:when test="matches(@class, 'note reference') and 
                            preceding-sibling::node()[1][matches(name(), '(ol|ul)')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="abc"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each-group select="node()" group-adjacent="boolean(self::*[matches(name(), '(ol|ul)')])">
                <xsl:variable name="curName" select="name(current-group()[1])" />
                <xsl:variable name="curClass" select="current-group()[1]/@*" />
                <xsl:variable name="flwCla" select="following-sibling::*[1]/@class" />
                <xsl:choose>
                    <xsl:when test="current-group()[1][matches(name(), '(ol|ul)')][contains(@class, $flwCla)]">
                        <xsl:element name="{$curName}">
                            <xsl:apply-templates select="$curClass" />
                            <xsl:apply-templates select="current-group()/node()" />
                        </xsl:element>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="node()[last()][self::img][matches(@class, 'ImgBlock')]">
                <xsl:variable name="lastImg" select="node()[last()][self::img][matches(@class, 'ImgBlock')]" />
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
                <xsl:copy-of select="$lastImg" />
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
            <xsl:when test="matches(@class, 'ImgBlock') and 
                            not(following-sibling::node()) and 
                            parent::p">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>

</xsl:stylesheet>