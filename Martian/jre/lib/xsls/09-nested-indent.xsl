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
    
    <xsl:template match="*" priority="5">
        <xsl:choose>
            <xsl:when test="matches(@class, 'Indent1') and 
                            following-sibling::node()[1][matches(@class, 'indentgroup2')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'indentgroup2')]" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@class, 'indentgroup2') and 
                            preceding-sibling::node()[1][matches(@class, 'Indent1')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'UnorderList_\d') and 
                            following-sibling::node()[1][matches(@class, 'Empty_Indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>

                    <div>
                        <xsl:attribute name="class" select="tokenize(following-sibling::*[1]/@class, ' ')[last()]" />
                        <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'Empty_Indent\d')]" />
                    </div>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'Empty_Indent\d') and 
                            preceding-sibling::node()[1][matches(@class, 'UnorderList_\d')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'UnorderList_\d') and 
                            following-sibling::node()[1][matches(@class, 'indentgroup1')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'indentgroup1')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'indentgroup1') and 
                            preceding-sibling::node()[1][matches(@class, 'UnorderList_\d')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'UnorderList_\d') and 
                            not(matches(@class, 'Indent')) and
                            following-sibling::node()[1][matches(@class, '_Indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, '_Indent\d')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, '_Indent\d') and 
                            preceding-sibling::node()[1][matches(@class, 'UnorderList_\d')][not(matches(@class, 'Indent'))]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, '^OrderList_\d') and 
                            following-sibling::node()[1][matches(@class, 'Empty_Indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'Empty_Indent\d')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'Empty_Indent\d') and 
                            preceding-sibling::node()[1][matches(@class, '^OrderList_\d')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
