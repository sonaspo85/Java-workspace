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

    <xsl:template match="/">
        <xsl:variable name="var0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>
        
        <xsl:apply-templates select="$var0/*" />
    </xsl:template>
    
    <xsl:template match="ol" mode="abc">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="cls" select="@class" />

        <xsl:choose>
            <xsl:when test="matches(@class, 'OrderList_02') and 
                            following-sibling::node()[1][matches(@class, 'notesection')]
                            /following-sibling::node()[1][matches(@class, $cls)]">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>

                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::*)">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()"/>
                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, 'notesection')]" />
                                </xsl:copy>
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()"/>
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>

                    <xsl:copy-of select="following-sibling::node()[2][matches(@class, $cls)]/node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'OrderList_02') and 
                            preceding-sibling::node()[1][matches(@class, 'notesection')]
                            /preceding-sibling::node()[1][matches(@class, 'OrderList_02')]">
            </xsl:when>
            <!-- ************************************************* -->
            <xsl:when test="matches(@class, 'OrderList_02') and 
                            following-sibling::node()[1][matches(@class, 'UnorderList_1')]
                            /following-sibling::node()[1][matches(@class, $cls)]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>

                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::*)">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()"/>
                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, 'UnorderList_1')]" />
                                </xsl:copy>
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" mode="#current" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>

                    <!-- <xsl:copy-of select="following-sibling::node()[2][matches(@class, $cls)]/node()" /> -->
                </xsl:copy>
            </xsl:when>
            <!-- ************************************************* -->
            <xsl:when test="matches(@class, 'OrderList_02') and 
                            following-sibling::node()[1][matches(@class, 'UnorderList_1')]
                            /following-sibling::node()[1][matches(@class, 'notesection')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>

                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::*)">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" mode="#current"/>
                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, 'UnorderList_1')]" />
                                </xsl:copy>
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" mode="#current" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            <!-- ************************************************* -->
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>

    <xsl:template match="ol">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="cls" select="@class" />

        <xsl:choose>
            <xsl:when test="matches(@class, 'OrderList_02') and 
                            following-sibling::node()[1][matches(@class, $cls)]">
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()"/>

                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, 'OrderList_02')]/node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:when test="matches(@class, 'OrderList_02') and 
                            preceding-sibling::node()[1][matches(@class, $cls)]">
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul" mode="abc">
        <xsl:variable name="cur" select="." />

        <xsl:choose>
            <xsl:when test="matches(@class, 'UnorderList_1') and 
                            preceding-sibling::node()[1][matches(@class, 'OrderList_02')] and 
                            following-sibling::node()[1][matches(@class, 'OrderList_02')]">
            </xsl:when>

            <xsl:when test="matches(@class, 'UnorderList_1') and 
                            preceding-sibling::node()[1][matches(@class, 'OrderList_02')] and 
                            following-sibling::node()[1][matches(@class, 'notesection')]">
            </xsl:when>

            <!-- ************************************************* -->
            <xsl:when test="matches(@class, 'UnorderList_\d') and 
                            following-sibling::node()[1][matches(@class, 'indentgroup')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current" />

                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="not(following-sibling::*)">
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" mode="#current" />
                                    <xsl:copy-of select="$cur/following-sibling::node()[1][matches(@class, 'indentgroup')]" />
                                </xsl:copy>
                            </xsl:when>
                        
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@* | node()" mode="#current" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="div" mode="abc">
        <xsl:choose>
            <xsl:when test="matches(@class, 'notesection') and 
                            preceding-sibling::node()[1][matches(@class, 'OrderList_02')] and 
                            following-sibling::node()[1][matches(@class, 'OrderList_02')]">
            </xsl:when>

            <xsl:when test="matches(@class, 'indentgroup') and 
                            preceding-sibling::*[1][matches(@class, 'UnorderList_\d')]">
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
