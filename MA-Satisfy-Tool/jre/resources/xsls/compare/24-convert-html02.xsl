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

    <xsl:template match="quality">
        <div>
            <xsl:attribute name="h2Value" select="'결과물 품질'" />
            <li>
                <div class="contents_Inner">
                    <h2>결과물 품질</h2>
                    <xsl:for-each select="child::grouped">
                        <div>
                            <h3>
                                <xsl:value-of select="@class" />
                            </h3>
                            
                            <table class="item">
                                <thead>
                                    <tr>
                                        <th>업체명</th>
                                        <th>직전 오류 수</th>
                                        <th>진행 종수</th>
                                        <th>배점</th>
                                        <th>결과</th>
                                        <th>업체 순위</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="child::item">
                                        <xsl:variable name="filename" select="@filename" />
                                        <xsl:variable name="t4cell3" select="@t4cell3" />
                                        <xsl:variable name="t4cell4" select="@t4cell4" />
                                        <xsl:variable name="score" select="@score" />
                                        <xsl:variable name="t4cell5" select="@t4cell5" />
                                        <xsl:variable name="ranking" select="@ranking" />
                                        
                                        <tr>
                                            <td>
                                                <xsl:value-of select="$filename" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t4cell3" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t4cell4" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$score" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="$t4cell5" />
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
    
    <xsl:template match="delivery_compliance">
        <div>
            <xsl:attribute name="h2Value" select="'납기 준수율'" />
            
            <li>
                <div class="contents_Inner">
                    <h2>납기 준수율</h2>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>업체명</th>
                                <th>평가 항목</th>
                                <th>직전 지연 수</th>
                                <th>진행 종수</th>
                                <th>배점</th>
                                <th>결과</th>
                                <th>업체 순위</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <xsl:for-each select="child::item">
                                <xsl:variable name="filename" select="@filename" />
                                <xsl:variable name="t5cell1" select="@t5cell1" />
                                <xsl:variable name="t5cell3" select="@t5cell3" />
                                <xsl:variable name="t5cell4" select="@t5cell4" />
                                <xsl:variable name="score" select="@score" />
                                <xsl:variable name="t5cell5" select="@t5cell5" />
                                <xsl:variable name="ranking" select="@ranking" />
                                
                                <tr>
                                    <td>
                                        <xsl:value-of select="$filename" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t5cell1" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t5cell3" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t5cell4" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$score" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t5cell5" />
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
    
    <xsl:template match="satisfy">
        <div>
            <xsl:attribute name="h2Value" select="'만족도'" />
            
            <li>
                <div class="contents_Inner">
                    <h2>만족도</h2>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>업체명</th>
                                <th>배점</th>
                                <th>결과</th>
                                <th>업체 순위</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <xsl:for-each select="child::items">
                                <xsl:variable name="filename" select="@filename" />
                                <xsl:variable name="sum" select="@sum" />
                                <xsl:variable name="result" select="@result" />
                                <xsl:variable name="ranking" select="@ranking" />
                                
                                <tr>
                                    <td>
                                        <xsl:value-of select="$filename" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$sum" />
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
                    
                    
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>항목</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <xsl:for-each select="child::items[1]/item">
                                <xsl:variable name="id" select="@id" />
                                <xsl:variable name="t6cell1" select="@t6cell1" />
                                
                                <tr>
                                    <td>
                                        <xsl:value-of select="$id" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$t6cell1" />
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </li>
        </div>
    </xsl:template>
    
    <xsl:template match="total">
        <div>
            <xsl:attribute name="h2Value" select="'업체 총점 / 순위'" />
            
            <li>
                <div class="contents_Inner">
                    <h2>업체 총점 / 순위</h2>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>업체명</th>
                                <th>총점</th>
                                <th>업체 순위</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <xsl:for-each select="child::div">
                                <xsl:variable name="filename" select="@filename" />
                                <xsl:variable name="total" select="@total" />
                                <xsl:variable name="ranking" select="@ranking" />
                                
                                <tr>
                                    <td>
                                        <xsl:value-of select="$filename" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="$total" />
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
    
</xsl:stylesheet>