<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>


    <xsl:variable name="scoredb" select="root/scoreDB" />
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="ancestor::*[matches(@id, 'tv\d')]">
                <xsl:variable name="cur" select="." />
                <xsl:variable name="id" select="@id" />
                <xsl:variable name="ancesId" select="ancestor::*[matches(@id, 'tv\d')]/@id" />
                <xsl:variable name="name" select="name(ancestor::*[matches(@id, $ancesId)])" />
                <xsl:variable name="scoreNode" select="$scoredb/div[matches(@class, $name)]/div[@id = $id]" />
                
                <xsl:variable name="calculate">
                    <xsl:choose>
                        <xsl:when test="$ancesId = 'tv4'">
                            <!--<xsl:value-of select="number(replace(@*[matches(local-name(), 't\dcell2')], '\s?%', ''))" />-->
                            
                            <xsl:variable name="cell2" select="number($cur/@t4cell2)" />
                            <xsl:variable name="cell3" select="if ($cur/@t4cell3 != '') then number($cur/@t4cell3) else 0" />
                            <xsl:variable name="cell4" select="number($cur/@t4cell4)" />
                            
                            <xsl:for-each select="$scoreNode/item">
                                <xsl:variable name="itemCls" select="@class" />
                                <xsl:variable name="min" select="number(@min)" />
                                <xsl:variable name="max" select="number(@max)" />
                                <xsl:variable name="vals" select="@vals" />
                                <xsl:variable name="score" select="@score" />
                                
                                <xsl:choose>
                                    <xsl:when test="$id = 0">
                                        <!--<xsl:variable name="mul" select="number(format-number($cell3 div $cell4, '#.00')) * 100" />-->
                                        <!--<xsl:variable name="mul" select="(number(format-number($cell3 div $cell4, '#.00')) * $cell2) * 0.1" />-->
                                        <xsl:variable name="mul" select="number(format-number($cell3 div $cell4, '#.00')) * $cell2" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="$mul = 0 and 
                                                            $itemCls = 'great'">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                                <!--<nul>
                                                    <xsl:value-of select="$mul" />
                                                </nul>-->
                                            </xsl:when>

                                            <xsl:when test="$min &lt;= $mul and 
                                                            $mul &lt; $max">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                                <!--<nul>
                                                    <xsl:value-of select="$mul" />
                                                </nul>-->
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <xsl:when test="$id = 1">
                                        <xsl:choose>
                                            <xsl:when test="(not($max) and $max!=0) and 
                                                            $min &lt;= $cell4">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                            
                                            <xsl:when test="$min &lt;= $cell4 and 
                                                            $cell4 &lt;= $max">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:when test="$ancesId = 'tv5'">
                            <xsl:variable name="cell2" select="number($cur/@t5cell2)" />
                            <xsl:variable name="cell3" select="if ($cur/@t5cell3 != '') then number($cur/@t5cell3) else 0" />
                            <xsl:variable name="cell4" select="number($cur/@t5cell4)" />
                            
                            <xsl:for-each select="$scoreNode/item">
                                <xsl:variable name="itemCls" select="@class" />
                                <xsl:variable name="min" select="number(@min)" />
                                <xsl:variable name="max" select="number(@max)" />
                                <xsl:variable name="vals" select="@vals" />
                                <xsl:variable name="score" select="@score" />
                                
                                <xsl:choose>
                                    <xsl:when test="$id = 0">
                                        <!--<xsl:variable name="mul" select="number(format-number($cell3 div $cell4, '#.00')) * 100" />-->
                                        <!--<xsl:variable name="mul" select="(number(format-number($cell3 div $cell4, '#.00')) * $cell2) * 0.1" />-->
                                        <xsl:variable name="mul" select="number(format-number($cell3 div $cell4, '#.00')) * $cell2" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="$mul = 0 and 
                                                            $itemCls = 'great'">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                                <!--<nul>
                                                    <xsl:value-of select="$mul" />
                                                </nul>-->
                                            </xsl:when>

                                            <xsl:when test="$min &lt;= $mul and 
                                                            $mul &lt; $max">
                                                <result>
                                                    <xsl:value-of select="$vals" />
                                                </result>
                                                <score>
                                                    <xsl:value-of select="$score" />
                                                </score>
                                                <!--<nul>
                                                    <xsl:value-of select="$mul" />
                                                </nul>-->
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--<xsl:copy>
                                <xsl:apply-templates select="@*, node()" />
                            </xsl:copy>-->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:copy>
                    <xsl:apply-templates select="@*" />
                    
                    <xsl:if test="$ancesId = 'tv4'">
                        <xsl:if test="@*[matches(local-name(), 't\dcell3')]">
                            <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell3')]" />
                            <xsl:variable name="value" select="if (@*[matches(local-name(), 't\dcell3')] != '') then @*[matches(local-name(), 't\dcell3')] else 0" />
                            
                            <xsl:attribute name="{local-name($name)}" select="$value" />
                        </xsl:if>
                        
                        <xsl:attribute name="t4cell5" select="$calculate/result" />
                        <xsl:attribute name="score" select="$calculate/score" />
                        <!--<xsl:attribute name="nul" select="$calculate/nul" />-->
                    </xsl:if>
                    
                    <xsl:if test="$ancesId = 'tv5'">
                        <xsl:if test="@*[matches(local-name(), 't\dcell3')]">
                            <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell3')]" />
                            <xsl:variable name="value" select="if (@*[matches(local-name(), 't\dcell3')] != '') then @*[matches(local-name(), 't\dcell3')] else 0" />
                            
                            <xsl:attribute name="{local-name($name)}" select="$value" />
                        </xsl:if>
                        
                        <xsl:attribute name="t5cell5" select="$calculate/result" />
                        <xsl:attribute name="score" select="$calculate/score" />
                        <!--<xsl:attribute name="nul" select="$calculate/nul" />-->
                    </xsl:if>
                    
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="grouped">
        <xsl:variable name="cur" select="." />
        <xsl:variable name="id" select="@id" />
        <xsl:variable name="ancesId" select="ancestor::*[matches(@id, 'tv\d')]/@id" />
        <xsl:variable name="name" select="name(ancestor::*[matches(@id, $ancesId)])" />

        <xsl:choose>
            <xsl:when test="not(child::item)">
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>