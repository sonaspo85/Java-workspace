<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs ast">
    
    <xsl:character-map name="a">
        <xsl:output-character character="&#950;" string="&amp;amp;amp;" />
    </xsl:character-map>
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" use-character-maps="a" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@ASTID]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:choose>
                <xsl:when test="matches(., '^&lt;\w+')">
                    <xsl:apply-templates select="." mode="abc" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="10" mode="abc">
        <xsl:variable name="cur">
            <xsl:analyze-string select="normalize-space(.)" regex="([#_]+)?(\w+)([_])?(&amp;amp;)([\s+_]+)?">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)" />
                    <xsl:value-of select="regex-group(2)" />
                    <xsl:value-of select="regex-group(3)" />
                    <xsl:value-of select="replace(regex-group(4), '(&amp;amp;)', '&#950;')" />
                    <xsl:value-of select="regex-group(5)" />
                    
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:analyze-string select="." regex="(&quot;)(.*?)(&quot;)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)" />
                            <xsl:value-of select="replace(regex-group(2), '\s+', '')" />
                            <xsl:value-of select="regex-group(3)" />
                        </xsl:matching-substring>
                        
                        <xsl:non-matching-substring>
                            <xsl:value-of select="." />
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:variable name="str0">
            <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                              $cur, '(\w+)(-\w+)?(=)(&quot;&quot;)', ''),
                              '''', ''),
                              'style=', ''),
                              ';', '; '),
                              '(https?)(:)','$1﹕'),
                              '(_\d+)(:)(_)', '$1﹕$3'),
                              '(\w+)(:)', '$1='),
                              '(^&lt;)(\w+\s)', '$1$2&#xFCA;&#xFCA;&#xFCA;'),
                              '&quot;', ''),
                              '(=\s+)', '='),
                              '(=)(\-)?(\.)', '$1$20$3'),
                              '([sS])(\s)([tT])', '$1$2T'),
                              '(\d+)(\.)(\d+%)', '$1%'),
                              '(\s+)?&amp;gt;(\s+)?', ''),
                              ' windowtext ', ''),
                              '\s+ideograph-other(\s+)?', ''),
                              '(,_)', '_')" />
            
        </xsl:variable>

        <xsl:value-of select="replace(ast:tokenAttr($str0, '&#xFCA;&#xFCA;&#xFCA;'), ';', '')" />
    </xsl:template>

    <xsl:template match="text()" mode="deliver">
        <xsl:analyze-string select="." regex="(=)(https?&#xFE55;//)(.*?)(&gt;)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" />
                <xsl:value-of select="'&quot;'" />
                <xsl:value-of select="replace(regex-group(2), '&#xFE55;', ':')" />
                <xsl:value-of select="replace(regex-group(3), '=', ':')" />
                <xsl:value-of select="'&quot;'" />
                <xsl:value-of select="regex-group(4)" />
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(=)(#?_.*_?)(\d+)(&#xFE55;)(_)(.*?)(&gt;)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)" />
                        <xsl:value-of select="'&quot;'" />
                        <xsl:value-of select="regex-group(2)" />
                        <xsl:value-of select="regex-group(3)" />
                        <xsl:value-of select="':'" />
                        <xsl:value-of select="regex-group(5)" />
                        <xsl:value-of select="regex-group(6)" />
                        <xsl:value-of select="'&quot;'" />
                        <xsl:value-of select="regex-group(7)" />
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(src=)(.*?)(\.(jpg|png|gif))">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)" />
                                <xsl:value-of select="'&quot;'" />
                                <xsl:value-of select="regex-group(2)" />
                                <xsl:value-of select="regex-group(3)" />
                                <xsl:value-of select="'&quot;'" />
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="(=)(\d+)(\s+)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)" />
                                        <xsl:value-of select="'&quot;'" />
                                        <xsl:value-of select="regex-group(2)" />
                                        <xsl:value-of select="'&quot;'" />
                                        <xsl:value-of select="regex-group(3)" />
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="( padding| border| text)(-\w+)?(=)(.*?)([;&gt;])">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)" />
                                                <xsl:value-of select="regex-group(2)" />
                                                <xsl:value-of select="regex-group(3)" />
                                                <xsl:value-of select="'&quot;'" />
                                                <xsl:value-of select="regex-group(4)" />
                                                <xsl:value-of select="'&quot;'" />
                                                <xsl:value-of select="regex-group(5)" />
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(font)(-\w+)?(=)(.*?)([;&gt;])">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="regex-group(1)" />
                                                        <xsl:value-of select="regex-group(2)" />
                                                        <xsl:value-of select="regex-group(3)" />
                                                        <xsl:value-of select="'&quot;'" />
                                                        <xsl:value-of select="replace(regex-group(4), '\s+', '')" />
                                                        <xsl:value-of select="'&quot;'" />
                                                        <xsl:value-of select="regex-group(5)" />
                                                    </xsl:matching-substring>
                                                    <xsl:non-matching-substring>
                                                        <xsl:analyze-string select="." regex="(=)(\w+?)(\s+)">
                                                            <xsl:matching-substring>
                                                                <xsl:value-of select="regex-group(1)" />
                                                                <xsl:value-of select="'&quot;'" />
                                                                <xsl:value-of select="regex-group(2)" />
                                                                <xsl:value-of select="'&quot;'" />
                                                                <xsl:value-of select="regex-group(3)" />
                                                            </xsl:matching-substring>
                                                            <xsl:non-matching-substring>
                                                                <xsl:analyze-string select="." regex="(=)([#_-])?(\w+)(-\w+)?([.;%]?)?(\w+)?([;&gt;\s+])">
                                                                    <xsl:matching-substring>
                                                                        <xsl:value-of select="regex-group(1)" />
                                                                        <xsl:value-of select="'&quot;'" />
                                                                        <xsl:value-of select="regex-group(2)" />
                                                                        <xsl:value-of select="regex-group(3)" />
                                                                        <xsl:value-of select="regex-group(4)" />
                                                                        <xsl:value-of select="regex-group(5)" />
                                                                        <xsl:value-of select="regex-group(6)" />
                                                                        <xsl:value-of select="'&quot;'" />
                                                                        <xsl:value-of select="regex-group(7)" />
                                                                    </xsl:matching-substring>
                                                                    <xsl:non-matching-substring>
                                                                        <xsl:analyze-string select="." regex="(=)(\w+)([,])(\w+)(-\w+)?([;])">
                                                                            <xsl:matching-substring>
                                                                                <xsl:value-of select="regex-group(1)" />
                                                                                <xsl:value-of select="'&quot;'" />
                                                                                <xsl:value-of select="regex-group(2)" />
                                                                                <xsl:value-of select="regex-group(3)" />
                                                                                <xsl:value-of select="regex-group(4)" />
                                                                                <xsl:value-of select="regex-group(5)" />
                                                                                <xsl:value-of select="'&quot;'" />
                                                                                <xsl:value-of select="regex-group(6)" />
                                                                            </xsl:matching-substring>
                                                                            <xsl:non-matching-substring>
                                                                                <xsl:analyze-string select="." regex="(=)([#])?(\w+)([-.])?(\w+)?(;)?([&gt;\s])">
                                                                                    <xsl:matching-substring>
                                                                                        <xsl:value-of select="regex-group(1)" />
                                                                                        <xsl:value-of select="'&quot;'" />
                                                                                        <xsl:value-of select="regex-group(2)" />
                                                                                        <xsl:value-of select="regex-group(3)" />
                                                                                        <xsl:value-of select="regex-group(4)" />
                                                                                        <xsl:value-of select="regex-group(5)" />
                                                                                        <xsl:value-of select="regex-group(6)" />
                                                                                        <xsl:value-of select="'&quot;'" />
                                                                                        <xsl:value-of select="regex-group(7)" />
                                                                                    </xsl:matching-substring>
                                                                                    <xsl:non-matching-substring>
                                                                                        <xsl:analyze-string select="." regex="(=)([ㄱ-ㅎ가-힣#_\w+/\d+\.\-\(\)–]+?)(&gt;)">
                                                                                            <xsl:matching-substring>
                                                                                                <xsl:value-of select="regex-group(1)" />
                                                                                                <xsl:value-of select="'&quot;'" />
                                                                                                <xsl:value-of select="regex-group(2)" />
                                                                                                <xsl:value-of select="'&quot;'" />
                                                                                                <xsl:value-of select="regex-group(3)" />
                                                                                            </xsl:matching-substring>
                                                                                            <xsl:non-matching-substring>
                                                                                                <xsl:analyze-string select="." regex="(\w+)(=)(\w+)">
                                                                                                    <xsl:matching-substring>
                                                                                                        <xsl:value-of select="regex-group(1)" />
                                                                                                        <xsl:value-of select="regex-group(2)" />
                                                                                                        <xsl:value-of select="'&quot;'" />
                                                                                                        <xsl:value-of select="regex-group(3)" />
                                                                                                        <xsl:value-of select="'&quot;'" />
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
                                                                    </xsl:non-matching-substring>
                                                                </xsl:analyze-string>
                                                            </xsl:non-matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        
        

    </xsl:template>
    
    <xsl:function name="ast:tokenAttr">
        <xsl:param name="str" />
        <xsl:param name="char" />
        
        <xsl:variable name="deliver">
            <xsl:value-of select="tokenize($str, $char)[2]" />
        </xsl:variable>

        <xsl:variable name="strJoin">
            <xsl:apply-templates select="$deliver" mode="deliver" />
        </xsl:variable>
        
        <xsl:value-of select="concat(tokenize($str, $char)[1], $strJoin)" />
    </xsl:function>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str" />
        <xsl:param name="char" />
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
</xsl:stylesheet>
