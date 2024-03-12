<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="root">
        <html>
            <body>
                <xsl:apply-templates select="@*, node()" />
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="competitive_price">
        <div>
            <xsl:attribute name="h2Value" select="'Bidding 금액'" />
            <li>
                <div class="contents_Inner">
                    <h2>Bidding 금액</h2>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>업체명</th>
                                <th>평가 항목</th>
                                <th>금액</th>
                                <th>배점</th>
                                <th>업체 순위</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <xsl:for-each select="child::item">
                                <xsl:variable name="filename" select="@filename" />
                                <xsl:variable name="t1cell1" select="@t1cell1" />
                                <xsl:variable name="t1cell3" select="@t1cell3" />
                                <xsl:variable name="result" select="@result" />
                                <xsl:variable name="ranking" select="@ranking" />
                                
                                <tr>
                                    <td>
                                        <xsl:value-of select="$filename" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t1cell1" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t1cell3" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$result" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$ranking" />
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </li>
        </div>
    </xsl:template>
    
    <xsl:template match="automation">
        <div>
            <xsl:attribute name="h2Value" select="'업체 자동화 현황'" />
            
            <li>
                <div class="contents_Inner">
                    <h2>업체 자동화 현황</h2>
                    <xsl:for-each select="child::grouped">
                        <div>
                            <h3>
                                <xsl:value-of select="@class" />
                            </h3>
                            
                            <table class="item">
                                <thead>
                                    <tr>
                                        <th>업체명</th>
                                        <th>직전 툴 수</th>
                                        <th>현재 툴 수</th>
                                        <th>배점</th>
                                        <th>결과</th>
                                        <th>업체 순위</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="child::item">
                                        <xsl:variable name="filename" select="@filename" />
                                        <xsl:variable name="t2cell3" select="@t2cell3" />
                                        <xsl:variable name="t2cell4" select="@t2cell4" />
                                        <xsl:variable name="score" select="@score" />
                                        <xsl:variable name="t2cell5" select="@t2cell5" />
                                        <xsl:variable name="ranking" select="@ranking" />
                                        
                                        <tr>
                                            <td>
                                                <xsl:value-of select="$filename" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t2cell3" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t2cell4" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$score" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t2cell5" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$ranking" />
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </xsl:for-each>
                </div>
            </li>
        </div>
    </xsl:template>
    
    <xsl:template match="safety">
        <div>
            <xsl:attribute name="h2Value" select="'보안'" />
            
            <li>
                <div class="contents_Inner">
                    <h2>보안</h2>
                    
                    <xsl:for-each select="child::grouped">
                        <div>
                            <h3>
                                <xsl:value-of select="@class" />
                            </h3>
                            
                            <xsl:for-each select="child::grouped">
                                <xsl:variable name="filename" select="@filename" />
                                <xsl:variable name="score" select="@score" />
                                <xsl:variable name="result" select="@result" />
                                <xsl:variable name="ranking" select="@ranking" />
                                <xsl:variable name="itemcnt" select="count(child::item)" />
                                
                                <table class="company">
                                    <thead>
                                        <tr>
                                            <th>업체명</th>
                                            <th>배점</th>
                                            <th>결과</th>
                                            <th>업체 순위</th>
                                            <th>평가 항목</th>
                                            <th>O/X</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="child::item">
                                            <xsl:variable name="t3cell2" select="@t3cell2" />
                                            <xsl:variable name="t3cell4" select="@t3cell4" />
                                            
                                            <tr>
                                                <xsl:choose>
                                                    <xsl:when test="not(preceding-sibling::item)">
                                                        <td rowspan="{$itemcnt}">
                                                            <xsl:value-of select="$filename" />
                                                        </td>
                                                        <td rowspan="{$itemcnt}">
                                                            <xsl:value-of select="$score" />
                                                        </td>
                                                        <td rowspan="{$itemcnt}">
                                                            <xsl:value-of select="$result" />
                                                        </td>
                                                        <td rowspan="{$itemcnt}">
                                                            <xsl:value-of select="$ranking" />
                                                        </td>
                                                        
                                                        <td>
                                                            <xsl:value-of select="$t3cell2" />
                                                        </td>
                                                        <td>
                                                            <xsl:value-of select="$t3cell4" />
                                                        </td>
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <td>
                                                            <xsl:value-of select="$t3cell2" />
                                                        </td>
                                                        <td>
                                                            <xsl:value-of select="$t3cell4" />
                                                        </td>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                </div>
            </li>
        </div>
    </xsl:template>
    
</xsl:stylesheet>