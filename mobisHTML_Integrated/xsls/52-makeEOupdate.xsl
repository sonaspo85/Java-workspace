<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xhtml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="a"  />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="EOupdateHtml" select="concat('..', '/output/EO_update.html')" />
        
        <xsl:result-document href="{$EOupdateHtml}">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            <html data-language="{concat($commonRef/company/@value, '_', $commonRef/lgsRegion/@value)}">
                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Error</title>
                    <style>
                        body {
                        width: 100%;
                        margin: 0 auto;
                        font-family: "Noto Sans", "Noto Sans KR", sans-serif;
                        }
                        
                        .wrap {
                        max-width: 900px;
                        min-height: 100vh;
                        margin: 0 auto;
                        display: flex;
                        flex-wrap: wrap;
                        flex-direction: column;
                        justify-content: center;
                        align-items: center;
                        position: relative;
                        padding: 0 10px;
                        }
                        
                        h1 {
                        width: 100%;
                        margin-bottom: 59px;
                        margin-top: 45px;
                        position: absolute;
                        top: 0;
                        padding-left: 10px;
                        box-sizing: border-box;
                        }
                        
                        .caution_img {
                        width: 112px;
                        margin-bottom: 60px;
                        }
                        
                        .caution_img img {
                        width: 100%;
                        }
                        
                        .text {
                        font-size: 20px;
                        text-align: center;
                        }
                        
                        .text:last-of-type {
                        margin-bottom: 55px;
                        }
                        
                        .howto_btn {
                        display: block;
                        padding: 9px 24px;
                        background-color: #313131;
                        border-radius: 20px;
                        font-size: 11px;
                        color: #fff;
                        text-decoration: none;
                        margin-bottom: 60px;
                        }
                        
                        @media screen and (max-width: 380px) {
                        h1 {
                        margin-top: 30px;
                        }
                        
                        .caution_img {
                        width: 26vw;
                        }
                        
                        .text {
                        font-size: 4.72vw;
                        }
                        
                        .howto_btn {
                        margin-bottom: 0;
                        }
                        
                        h1 {
                        padding-left: 30px;
                        }
                        }
                    </style>
                </head>
                
                <body>
                    <div class="wrap">
                        <h1>
                            <a href="./index.html"><img src="images/I-home.png" alt="" /></a>
                        </h1>
                        <div class="caution_img"><img src="images/I-caution.png" alt="" /></div>
                        <div class="text error_description1">﻿</div>
                        <div class="text error_description2">﻿</div>
                        <a class="howto_btn">
                            <xsl:attribute name="href" select="''" />
                            <xsl:value-of select="'&#xFEFF;'" />
                        </a>
                    </div>
                    <script type="text/javascript" src="js/00_jquery-1.9.1.min.js">
                    </script>
                    <script type="text/javascript" src="js/02_ui_text.js">
                    </script>
                </body>
                
                <script>
                    var language = $("html").attr("data-language");
                    $(".error_description1").text(message[language].error_paragraph1);
                    $(".error_description2").text(message[language].error_paragraph2);
                    $(".howto_btn").text(message[language].error_botton);
                </script>
                
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    
</xsl:stylesheet>