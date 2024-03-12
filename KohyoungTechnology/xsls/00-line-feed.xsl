<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/" exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />

    <xsl:param name="filename" />
    <xsl:param name="outfoldername" />
    <xsl:param name="text-uri" as="xs:string" select="concat('file:////', replace(replace($filename, '\\', '/'), ' ', '%20'))"/>
    
    
    <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'" />
    <xsl:variable name="text" select="unparsed-text($text-uri, $text-encoding)" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="/">
        <root sourcename="{$filename}" outFolderName="{$outfoldername}">
            <xsl:for-each select="$text">
                <xsl:call-template name="textReplace">
                    <xsl:with-param name="cur" select="." />
                </xsl:call-template>
            </xsl:for-each>
        </root>
    </xsl:template>

    <!--৺: &#x9FA;-->
    <!--⏎: &#x23CE;-->
    <!--࿊: &#xFCA;-->
    <xsl:template name="textReplace">
        <xsl:param name="cur" />

        <xsl:analyze-string select="." regex="(&#xD;\s+)">
            <xsl:matching-substring>
                <xsl:value-of select="'&#x20;&#x20;'" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(&lt;)(meta)(.*?)(&quot;&gt;)">
                    <xsl:matching-substring> </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <!--alt attribute to common context extract-->
                        <xsl:analyze-string select="." regex="(\s+)?(alt=)(&quot;)(※)?(.*?)(&quot;)(&gt;)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(7)" />
                            </xsl:matching-substring>
                            
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="(&lt;body)(.*?)(&apos;&gt;)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="'&lt;body&gt;'" />
                                    </xsl:matching-substring>
                                    
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="replace(., '&amp;nbsp;', '&#x9FA;')" />
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                                
                                <!--<xsl:value-of select="replace(., '&amp;nbsp;', '&#x9FA;')" />-->
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:function name="ast:getName">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>

</xsl:stylesheet>
