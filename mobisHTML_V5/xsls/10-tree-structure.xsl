<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">

    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="title li p" />

    <xsl:variable name="company" select="tokenize(/topic/@data-language, '_')[1]" />
    <xsl:variable name="type" select="substring-before(substring-after(/topic/@data-language, '('), ')')" />
    <xsl:variable name="topic_hierarchy" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'topic_hierarchy.xml'))/root" />
    <xsl:variable name="spec" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ui_text.xml'))/root/listitem[1]/language" />
    <xsl:variable name="spec1" select="substring-before(substring-after($spec, '('), ')')" />

    <xsl:template match="/topic">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@class[parent::p/parent::topic][.='Description_1-Center']">
        <xsl:attribute name="class" select="concat('nested ', .)" />
    </xsl:template>

    <xsl:variable name="topic_idml">
        <xsl:for-each select="$topic_hierarchy/chapter[matches(@company, $company)]">
            <xsl:variable name="same" select="current()[@type = $spec1]" />

            <xsl:variable name="same_topic">
                <xsl:if test="$same">
                    <xsl:sequence select="$same/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="differ_topic">
                <xsl:if test="not(parent::*/chapter[@type = $spec1]) and 
                              current()[@type != $spec1]">
                    <xsl:sequence select="current()[@type = 'common']/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$same_topic/node()">
                    <xsl:copy-of select="$same_topic" />
                </xsl:when>

                <xsl:when test="not($same_topic/node()) and 
                                $differ_topic">
                    <xsl:copy-of select="$differ_topic" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="curr" select="root()/topic/topic[@idml]" />
        <xsl:variable name="str0">
            <topic>
                <xsl:apply-templates select="root()/topic/@*" />
                <xsl:for-each select="$topic_idml/topic">
                    <xsl:call-template name="nested">
                        <xsl:with-param name="current" select="." />
                        <xsl:with-param name="curr" select="$curr" />
                    </xsl:call-template>
                </xsl:for-each>
            </topic>
        </xsl:variable>

        <xsl:apply-templates select="$str0/*" />
    </xsl:template>

    <xsl:template name="nested">
        <xsl:param name="current" />
        <xsl:param name="curr" />

        <xsl:choose>
            <xsl:when test="current()[not(topic)]">
                <xsl:variable name="idml" select="@idml" />
                <xsl:copy-of select="$curr[@idml = $idml]" />
            </xsl:when>

            <xsl:when test="current()[topic]">
                <xsl:variable name="idml" select="@idml" />
                
                <xsl:for-each select="$curr[@idml = $idml]">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" />
                        <xsl:for-each select="node()">
                            <xsl:copy>
                                <xsl:apply-templates select="@*, node()" />

	                            <xsl:for-each select="$current/topic">
	                                <xsl:call-template name="nested2">
	                                    <xsl:with-param name="current" select="." />
	                                    <xsl:with-param name="curr" select="$curr" />
	                                </xsl:call-template>
	                            </xsl:for-each>
                            </xsl:copy>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nested2">
        <xsl:param name="current" />
        <xsl:param name="curr" />

        <xsl:choose>
            <xsl:when test="current()[not(topic)]">
                <xsl:variable name="idml" select="@idml" />
                <xsl:copy-of select="$curr[@idml = $idml]/node()" />
            </xsl:when>

            <xsl:when test="current()[topic]">
                <xsl:variable name="idml" select="@idml" />

                <xsl:for-each select="$curr[@idml = $idml]">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />

                        <xsl:for-each select="$current/topic">
                            <xsl:call-template name="nested2">
                                <xsl:with-param name="current" select="." />
                                <xsl:with-param name="curr" select="$curr" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>

    <xsl:function name="ast:getLast">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="if (count(tokenize($str, $char)) = 2) then tokenize($str, $char)[position() eq last()] else string-join(tokenize($str, $char)[position() ne 1], $char)" />
    </xsl:function>
</xsl:stylesheet>