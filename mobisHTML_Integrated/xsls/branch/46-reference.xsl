<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="../00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />
   
    
    <xsl:variable name="allContents">
        <div class="all_contents">
            <button type="button">
                <span class="line1">&#xFEFF;</span>
                <span class="line2">&#xFEFF;</span>
                <span class="line3">&#xFEFF;</span>
            </button>
        </div>
    </xsl:variable>
    
    <xsl:variable name="searchBox">
        <div class="search_box">
            <form name="searchSubmit" id="searchSubmit" method="GET" onsubmit="return false;">
                <input type="text" class="ip-sch" name="sch" />
                <a class="search_btn bt-sch">
                    <img src="images/search_gray_bt.png" alt="검색하기" />
                </a>
            </form>
        </div>
    </xsl:variable>
    
    <xsl:template name="faviContents">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="$commonRef/version/@value = '6th'">
                <xsl:value-of select="descendant::div[matches(@class, 'heading1')]/h1[1]" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="$uiTxtLang/html_title" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="faviminiToc">
        <xsl:param name="cur" />
        
        <xsl:choose>
            <xsl:when test="$commonRef/version/@value = '6th'">
                <xsl:value-of select="descendant::h0[1]" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="$uiTxtLang/html_title" />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>