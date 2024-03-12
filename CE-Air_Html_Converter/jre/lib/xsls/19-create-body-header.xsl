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
        <root>
            <header id="header">
                <div class="wrap">
                    <div class="container">
                        <div class="header_top">
                            <div class="mob_nav">
                                <a href="javascript:void(0);" class="nav_btn close">
                                    <i class="top_line">&#xFEFF;</i>
                                    <i class="mid_line">&#xFEFF;</i>
                                    <i class="bot_line">&#xFEFF;</i>
                                </a>
                            </div>
                            <div id="home" class="home">
                                <a class="home_btn" href="./start_here.html">
                                    <img src="./img/home.png" alt="home" />
                                </a>
                            </div>
                            <div class="search_box">
                                <div class="search_wrap">
                                    <input type="text" id="id_search_page" placeholder="search" />
                                    <button type="button" class="search_btn" id="id_search_button_page">
                                        <img src="./img/search_btn.png" alt="search" />
                                    </button>
                                </div>
                            </div>
                            <div id="language" class="language">
                                <button type="button" class="language_btn" data-target="#selectLanguage">
                                    <span class="selected_lang">language</span>
                                </button>
                            </div>
                        </div>

                        <div class="header_bottom">
                            <nav id="nav">
                                <ul class="nav_list">
                                    <xsl:for-each select="root/section">
                                        <xsl:variable name="chapternode" select="h1[1]" />
                                        
                                        <li class="main_menu">
                                            <a href="javascript:void(0);" class="main_btn">
                                                <xsl:value-of select="$chapternode" />
                                                <i class="fa fa-angle-down" aria-hidden="true">&#xFEFF;</i>

                                                <ul class="sub_menu">
                                                    <xsl:for-each select="descendant::h2">
                                                        <xsl:variable name="cur" select="." />
                                                        <xsl:variable name="id" select="@ast-id" />
                                                        <li>
                                                            <a class="sub_btn">
                                                                <xsl:attribute name="href" select="concat('#', $id)" />
                                                                <xsl:value-of select="$cur" />
                                                            </a>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </header>
        </root>
    </xsl:template>
    
</xsl:stylesheet>
