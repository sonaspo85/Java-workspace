<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    exclude-result-prefixes="xs son xsi idPkg functx"
    version="2.0">
    
    <xsl:character-map name="a">
        <xsl:output-character character="&amp;" string="&amp;amp;" />
        <xsl:output-character character="&lt;" string="&amp;lt;" />
        <xsl:output-character character="&gt;" string="&amp;gt;" />
        <xsl:output-character character="&quot;" string="&amp;quot;" />
        <xsl:output-character character="&apos;" string="&amp;apos;" />
    </xsl:character-map>
    
    <!--<xsl:character-map name="a">
         <xsl:output-character character="&amp;" string="&amp;" />
         <xsl:output-character character="&lt;" string="&lt;" />
         <xsl:output-character character="&gt;" string="&gt;" />
         <xsl:output-character character="&quot;" string="&quot;" />
         <xsl:output-character character="&apos;" string="&apos;" />
    </xsl:character-map>-->
    
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="specSampleDirs" />
    
    <xsl:variable name="srcDirs01" select="replace(replace(replace($specSampleDirs, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="concat('file:////', $srcDirs01)"  />
    <xsl:variable name="srcDirs03" select="iri-to-uri(concat($srcDirs02, '/?select=', '*.xml;recurse=yes'))"  />
    <xsl:variable name="directory" select="collection($srcDirs03)" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="filePath" select="concat($srcDirs02, '/../01-specSampleMerged.xml')" />
        <xsl:result-document href="{$filePath}" method="xml" use-character-maps="a">
            <root srcDir="{$srcDirs02}">
                <xsl:for-each select="$directory/root">
                    <xsl:variable name="i" select="position()" />
                    
                    <div>
                        <xsl:apply-templates select="@* except @fileName" />
                        <xsl:attribute name="fileName" select="son:last(base-uri(.), '/')" />
                        <xsl:apply-templates select="node()" />
                    </div>
                </xsl:for-each>
            </root>
        </xsl:result-document>
        
        <dummy filePath="{$filePath}" />
    </xsl:template>
    
    <xsl:template match="text()" priority="5">
        <xsl:analyze-string select="." regex="(&#xa0;)">
            <xsl:matching-substring>
                <xsl:value-of select="replace(regex-group(1), '&#xa0;', ' ')" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="&amp;lt;br/&amp;gt;">
                    <xsl:matching-substring>
                        <br/>
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="&amp;quot;">
                            <xsl:matching-substring>
                            </xsl:matching-substring>
                            
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="”">
                                    <xsl:matching-substring>
                                    </xsl:matching-substring>
                                    
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="." />
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:function name="son:getpath">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
    </xsl:function>
    
    <xsl:function name="son:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>