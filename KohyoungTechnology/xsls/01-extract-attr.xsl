<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ast="http://www.astkorea.net/"
      xmlns:uuid="java.util.UUID"
	exclude-result-prefixes="xs ast uuid">


    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" />


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template name="id_created">
        <xsl:param name="str0" />

        <xsl:for-each select="$str0/*">
            <xsl:variable name="random" select="uuid:randomUUID()"/>
            
            <xsl:copy>
                <xsl:attribute name="ASTID" select="$random" />
                <xsl:value-of select="." />
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    
    <xsl:template match="/">
        <xsl:variable name="Files">
            <root>
                <xsl:call-template name="id_export">
                    <xsl:with-param name="cur" select="."/>
                </xsl:call-template>
            </root>
        </xsl:variable>

        <root><!--࿊: &#xFCA;-->
            <xsl:apply-templates select="root/@*" />
            
            <xsl:for-each select="$Files/root/node()">
                <xsl:choose>
                    <xsl:when test="self::*[@ASTID]">
                        <S>
                            <xsl:attribute name="ASTID" select="@ASTID" />
                        </S>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </root>
        <!-- ***************************************** -->
        <xsl:result-document href="01-extract-attr.xml" >
            <root>
                <xsl:for-each select="$Files/root//*">
                    <xsl:apply-templates select="." />
                </xsl:for-each>
            </root>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="id_export">
        <xsl:param name="cur" />

        <xsl:analyze-string select="." regex="(XXXX&lt;head&gt;)(.*)(&lt;/head&gt;)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(0)" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(&lt;)([\w+\s+\.\-&apos;&quot;;:#=%,_/\(\)&amp;gt;]+?)(&gt;)">
                    <xsl:matching-substring>
                        <xsl:variable name="str0">
                            <T>
                                <xsl:value-of select="regex-group(0)" />
                            </T>
                        </xsl:variable>

                        <xsl:call-template name="id_created">
                            <xsl:with-param name="str0" select="$str0" />
                        </xsl:call-template>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="." />
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
    
</xsl:stylesheet>