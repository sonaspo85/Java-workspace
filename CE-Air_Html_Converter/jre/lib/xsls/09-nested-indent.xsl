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
            <xsl:when test="matches(@class, 'indent1') and 
                            following-sibling::node()[1][matches(@class, 'indentgroup2')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'indentgroup2')]" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="matches(@class, 'indentgroup2') and 
                            preceding-sibling::node()[1][matches(@class, 'indent1')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'unorderlist_\d') and 
                            following-sibling::node()[1][matches(@class, 'empty_indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>

                    <div>
                        <xsl:attribute name="class" select="tokenize(following-sibling::*[1]/@class, ' ')[last()]" />
                        <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'empty_indent\d')]" />
                    </div>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'empty_indent\d') and 
                            preceding-sibling::node()[1][matches(@class, 'unorderlist_\d')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'unorderlist_\d') and 
                            following-sibling::node()[1][matches(@class, 'indentgroup1')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'indentgroup1')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'indentgroup1') and 
                            preceding-sibling::node()[1][matches(@class, 'unorderlist_\d')]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, 'unorderlist_\d') and 
                            not(matches(@class, 'indent')) and
                            following-sibling::node()[1][matches(@class, '_indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, '_indent\d')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, '_indent\d') and 
                            preceding-sibling::node()[1][matches(@class, 'unorderlist_\d')][not(matches(@class, 'indent'))]">
            </xsl:when>
            <!-- ************************************************ -->
            <xsl:when test="matches(@class, '^orderlist_\d') and 
                            following-sibling::node()[1][matches(@class, 'empty_indent\d')]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                    <xsl:copy-of select="following-sibling::node()[1][matches(@class, 'empty_indent\d')]" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'empty_indent\d') and 
                            preceding-sibling::node()[1][matches(@class, '^orderlist_\d')]">
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
