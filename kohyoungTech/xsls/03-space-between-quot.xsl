<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />
    

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10">
        <xsl:variable name="cur" select="normalize-space(.)" />
        
        <xsl:analyze-string select="$cur" regex="(&quot;)(\w+)(=)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" />
                <xsl:value-of select="' '" />
                <xsl:value-of select="regex-group(2)" />
                <xsl:value-of select="regex-group(3)" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(=&quot;)(.*?)(&quot;)">
                    <xsl:matching-substring>
                        <xsl:value-of select="replace(regex-group(0), '\s+', '_')" />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(\s+)(&gt;)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(2)" />
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="." />
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
</xsl:stylesheet>