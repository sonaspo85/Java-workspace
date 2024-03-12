<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xhtml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="html">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
        <xsl:copy>
            <xsl:attribute name="lang" select="'en'" />
            
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <link rel="apple-touch-icon" href="./img/ast.png" />
                <link rel="shortcut icon" href="./img/ast.png" />
                <link rel="stylesheet" href="./css/style.css" />
                <title>Vendor Evaluation Tool</title>
            </head>
            
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <h1>Vendor Evaluation Tool</h1>
            
            <div id="tabMenu">
                <ul>
                    <xsl:for-each select="child::div">
                        <xsl:variable name="val" select="@h2Value" />
                        <li>
                            <h2>
                                <xsl:value-of select="$val" />
                            </h2>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
            
            <div id="contents">
                <ul>
                    <xsl:for-each select="child::div">
                        <xsl:apply-templates select="child::li" />
                    </xsl:for-each>
                </ul>
            </div>
            
            <script src="./js/contents.js"></script>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>