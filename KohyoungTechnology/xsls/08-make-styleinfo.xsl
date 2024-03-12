<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    
    <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="p span a" />
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Style">
        <root>
            <xsl:apply-templates select="@*, node()" />
        </root>
    </xsl:template>

    <xsl:template match="stylelist">
        <xsl:variable name="str0">
            <xsl:value-of select="." />
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="$str0" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:analyze-string select="." regex="(\}})(\s+)?([\w+\.\s+,\-]+)(\s+)?(\{{)">
            <xsl:matching-substring>
                <xsl:text disable-output-escaping="yes">&lt;Sname&gt;</xsl:text>
                    <xsl:value-of select="regex-group(3)" />
                <xsl:text disable-output-escaping="yes">&lt;/Sname&gt;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(mso-style-link:)(&quot;)?(.*)(&quot;)?">
                    <xsl:matching-substring>
                        <xsl:text disable-output-escaping="yes">&lt;Svalue&gt;</xsl:text>
                            <xsl:value-of select="regex-group(3)" />
                        <xsl:text disable-output-escaping="yes">&lt;/Svalue&gt;</xsl:text>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(mso-style-name:)(&quot;)?(.*)(&quot;)?">
                            <xsl:matching-substring>
                                <xsl:text disable-output-escaping="yes">&lt;Svalue&gt;</xsl:text>
                                    <xsl:value-of select="regex-group(3)" />
                                <xsl:text disable-output-escaping="yes">&lt;/Svalue&gt;</xsl:text>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:last">
        <xsl:param name="arg1" />
        <xsl:param name="arg2" />
        <xsl:value-of select="tokenize($arg1, $arg2)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>