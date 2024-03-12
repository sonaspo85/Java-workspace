<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
	
    <xsl:output method="xhtml" encoding="UTF-8" indent="no" include-content-type="yes" omit-xml-declaration="yes" />
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="String file_name Style"/>
	<xsl:param name="srcPath" />

	
	<xsl:variable name="srcPath1" select="concat('file:////', replace(replace($srcPath, ' ', '%20'), '^(file:/?)(.*)', '$2'))" />
	
	<xsl:variable name="files" select="collection(concat(replace($srcPath1, '\\', '/'), '/?select=*.html;recurse=yes'))" />
	
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:for-each select="$files/*">
			<xsl:variable name="fileName" select="ast:getLast(base-uri(.), '/')" />
			
			<xsl:variable name="fullPath">
				<xsl:choose>
					<xsl:when test="matches($fileName, '^(search.html|bookmark.html)')">
						<xsl:value-of select="replace(concat($srcPath1, '/out/', 'search/' ,$fileName), '\\', '/')" />
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:value-of select="replace(concat($srcPath1, '/out/' , $fileName), '\\', '/')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="dataLgns" select="@data-language" />
			
			<xsl:variable name="str0">
				<xsl:choose>
					<xsl:when test="matches($dataLgns, '(Arabic|Farsi|Urdu|Hebrew)')">
						<xsl:value-of select="'rtl'" />
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:value-of select="'ltr'" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<xsl:result-document href="{$fullPath}">
				<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&#xa;</xsl:text>

			    <xsl:choose>
			        <xsl:when test="matches($fileName, 'start_here.html')">
			            <xsl:copy>
			                <xsl:attribute name="dir" select="$str0" />
			                <xsl:attribute name="data-template" select="'Q4-Q4NormalTalbet'" />
			                <xsl:attribute name="class" select="'normaltablet'" />
			                <xsl:apply-templates select="@* except @data-template, node()" mode="start" />
			            </xsl:copy>
			        </xsl:when>
			        
			        <xsl:when test="matches($fileName, 'search.html')">
			            <xsl:copy>
			                <xsl:attribute name="dir" select="$str0" />
			                <xsl:attribute name="class" select="'normaltablet'" />
			                <xsl:apply-templates select="@*, node()" mode="search" />
			            </xsl:copy>
			        </xsl:when>
			        
			        <xsl:otherwise>
			            <xsl:copy>
			                <xsl:attribute name="dir" select="$str0" />
			                <xsl:attribute name="class" select="'normaltablet'" />
			                <xsl:apply-templates select="@*, node()" />
			            </xsl:copy>
			        </xsl:otherwise>
			    </xsl:choose>
			</xsl:result-document>
		</xsl:for-each>
		
	</xsl:template>
    
    <xsl:template match="text()" priority="7" mode="#all">
        <xsl:value-of select="replace(., '&#x2028;', '')" />
    </xsl:template>

	
    <xsl:template match="input[matches(@id, 'id_search$')]" mode="start">
        <a href="search/search.html" class="search_go" id="id_search"></a>
    </xsl:template>
    
    <xsl:template match="img[matches(@id, 'id_search_button')]" mode="start">
        <div>
            <xsl:apply-templates select="@* except @src" mode="start" />
            <xsl:apply-templates select="node()" mode="start" />
        </div>
    </xsl:template>

    <xsl:template match="div" mode="search">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="search" />
            
            <xsl:choose>
                <xsl:when test="matches(@id, '^recent_area$')">
                    <xsl:choose>
                        <xsl:when test="*[1][not(matches(@id, 'recent_top'))]">
                            <xsl:for-each select="*">
                                <xsl:choose>
                                    <xsl:when test="self::* and not(preceding-sibling::*)">
                                        <div id="recent_top">
                                            <div class="btnPopClose">
                                                <img src="../contents/images/template/search_back.png" />
                                            </div>
                                            <div class="title"></div>
                                        </div>
                                        
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" mode="search" />
                                        </xsl:copy>
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:copy>
                                            <xsl:apply-templates select="@*, node()" mode="search" />
                                        </xsl:copy>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" mode="search" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:when test="matches(@class, '^recom$')">
                    <xsl:for-each select="node()">
                        <xsl:if test="position() = 1 and 
                                      not(matches(@id, 'recom_tit'))">
                            <h3 id="recom_tit"></h3>
                        </xsl:if>
                        
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="search" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:when test="matches(@class, '^related$')">
                    <xsl:for-each select="*">
                        <xsl:if test="position() = 1">
                            <h3 id="related_tit"></h3>
                        </xsl:if>
                        <xsl:copy>
                            <xsl:apply-templates select="@*, node()" mode="search" />
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="node()" mode="search" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
        
        <xsl:if test="matches(@class, '^related$') and 
                      not(following-sibling::*[1][matches(@class, 'recomFunc')])">
            <xsl:text>&#xa;</xsl:text>
            <div class="recomFunc">
                <h3 id="recomFunc_tit"></h3>
                <div class="recomFunc_list"></div>
            </div>
        </xsl:if>
        
        <xsl:if test="matches(@class, '^wrap$') and 
                      not(preceding-sibling::*) and parent::section and 
                      not(following-sibling::*[1][matches(@class, '^popRecom popup$')])">
            <div class="popRecom popup">
                <div class="wrap">
                    <div id="search_top">
                        <div class="btnPopClose">
                            <img src="../contents/images/template/search_back.png" />
                        </div>
                        <div class="title"></div>
                    </div>
                    <div class="pop_list"></div>
                </div>
            </div>
            
            <div class="popRelated popup">
                <div class="wrap">
                    <div id="search_top">
                        <div class="btnPopClose">
                            <img src="../contents/images/template/search_back.svg" />              
                        </div>
                        <div class="title"></div>
                    </div>
                    <div class="pop_list"></div>
                </div>
            </div>
            
            <div class="popRecomFunc popup">
                <div class="wrap">
                    <div id="search_top">
                        <div class="btnPopClose">
                            <img src="../contents/images/template/search_back.png" />
                        </div>
                        <div class="title"></div>
                    </div>
                    <div class="recomFuncCount">
                        <span class="countTitle"></span>
                        <xsl:text>(</xsl:text><span class="countLength"></span><xsl:text>)</xsl:text>
                    </div>
                    <div class="pop_list"></div>
                </div>
            </div>
            
            <div class="popRecomFuncList popup">
                <div class="wrap">
                    <div id="search_top">
                        <div class="btnPopClose">
                            <img src="../contents/images/template/search_back.png" />
                        </div>
                        <div class="title"></div>
                    </div>
                    <div class="pop_list"></div>
                </div>
            </div>
        </xsl:if>
        
        <xsl:if test="matches(@class, '^popRecom popup$') and 
                      not(following-sibling::*[1][matches(@class, '^popRelated popup$')])">
            <xsl:text>&#xa;</xsl:text>
            <div class="popRelated popup">
                <div class="wrap">
                    <div id="search_top">
                        <div class="btnPopClose">
                            <img src="../contents/images/template/search_back.svg" />              
                        </div>
                        <div class="title"></div>
                    </div>
                    <div class="pop_list"></div>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="img" mode="search">
        <xsl:choose>
            <xsl:when test="matches(@id, 'id_search_button')">
                <xsl:copy>
                    <xsl:attribute name="class" select="'findIcon'" />
                    <xsl:apply-templates select="@*, node()" mode="search" />
                </xsl:copy>
                <img class="removeIcon" src="../contents/images/template/toc_close.png" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" mode="search" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
	<xsl:function name="ast:getLast">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="tokenize($str, $char)[last()]" />
	</xsl:function>
	
	<xsl:function name="ast:getPath">
		<xsl:param name="str"/>
		<xsl:param name="char"/>
		<xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
	</xsl:function>
	
</xsl:stylesheet>