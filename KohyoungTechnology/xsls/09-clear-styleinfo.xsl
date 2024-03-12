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

    <xsl:template match="@* | node()" mode="replaceText">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="replaceText" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates select="node()" mode="replaceText" />
        </xsl:variable>

        <xsl:apply-templates select="$str0/node()" />
    </xsl:template>

    <xsl:template match="stylelist">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="Svalue">
    </xsl:template>
    
    <xsl:template match="Sname">
        <xsl:variable name="Svalue" select="parent::*/Svalue" />
        
        <xsl:choose>
            <xsl:when test="matches(., ',')">
                <xsl:for-each select="tokenize(., ',')[1]">
                    <xsl:variable name="m_name" select="if (matches(., '\.')) then tokenize(., '\.')[1] else ." />
                    <xsl:variable name="m_class" select="if (matches(., '\.')) then tokenize(., '\.')[2] else $Svalue" />
                    <xsl:element name="{$m_name}">
                        <xsl:attribute name="class" select="$m_class" />
                        <xsl:attribute name="changeclass">
                            <xsl:call-template name="valuesText">
                                <xsl:with-param name="Svalues" select="$Svalue" />
                                <xsl:with-param name="Sclass" select="$m_class" />
                            </xsl:call-template>
                        </xsl:attribute>

                        <xsl:attribute name="styleName">
                            <xsl:value-of select="$Svalue" />
                        </xsl:attribute>
                   </xsl:element>
                </xsl:for-each>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="name" select="if (matches(., '\.')) then tokenize(., '\.')[1] else ." />
                <xsl:variable name="class" select="if (matches(., '\.')) then tokenize(., '\.')[2] else $Svalue" />
                
                <xsl:element name="{$name}">
                    <xsl:attribute name="class" select="$class" />
                    <xsl:attribute name="changeclass">
                        <xsl:call-template name="valuesText">
                            <xsl:with-param name="Svalues" select="$Svalue" />
                            <xsl:with-param name="Sclass" select="$class" />
                        </xsl:call-template>
                    </xsl:attribute>
                    
                    <xsl:attribute name="styleName">
                        <xsl:value-of select="$Svalue" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="valuesText">
        <xsl:param name="Svalues" />
        <xsl:param name="Sclass" />
        <xsl:variable name="lowCaseVal" select="lower-case(replace($Svalues, '&#x20;', ''))" />
        <xsl:variable name="lowCaseClass" select="lower-case(replace($Sclass, '&#x20;', ''))" />
        
        <xsl:choose>
            <xsl:when test="matches($lowCaseVal, '순서1-indent')">
                <xsl:value-of select="'OL_plainNum_indent'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호2-indent')">
                <xsl:value-of select="'UL2_hyphen_indent'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '순서2-indent')">
                <xsl:value-of select="'OL_circleNum_indent'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호1-indent')">
                <xsl:value-of select="'UL1_bullet_indent'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호2-indent')">
                <xsl:value-of select="'UL2_hyphen_indent'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호3-indentcxsp')">
                <xsl:value-of select="'UL3_square_indent'" />
            </xsl:when>
            
            <xsl:when test="matches($lowCaseVal, '순서1')">
                <xsl:value-of select="'OL_plainNum'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '순서2')">
                <xsl:value-of select="'OL_circleNum'" />
            </xsl:when>
            
            <xsl:when test="matches($lowCaseVal, '글머리기호1')">
                <xsl:value-of select="'UL1_bullet'" />
                <!--<xsl:value-of select="'disc'" />-->
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호2')">
                <xsl:value-of select="'UL2_hyphen'" />
                <!--<xsl:value-of select="'hyphen'" />-->
            </xsl:when>

            <xsl:when test="matches($lowCaseClass, 'msolistbullet2cxsp')">
                <xsl:value-of select="'UL2_hyphen'" />
                <!--<xsl:value-of select="'hyphen'" />-->
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '글머리기호3')">
                <xsl:value-of select="'UL3_square'" />
            </xsl:when>
            
            <xsl:when test="matches($lowCaseClass, 'msolistbullet3cxsp')">
                <xsl:value-of select="'UL3_square'" />
            </xsl:when>

            <!--<xsl:when test="$lowCaseClass = 'a0'">
                <xsl:value-of select="'heading2_midtitle'" />
            </xsl:when>-->
            
            <xsl:when test="matches($lowCaseVal, '설명')">
                <xsl:value-of select="'description'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '중간제목')">
                <xsl:value-of select="'heading2_midtitle'" />
            </xsl:when>
            
            <xsl:when test="matches($lowCaseVal, '(제목)(\d+)')">
                <xsl:variable name="idx" select="replace($lowCaseVal, '(제목)(\d+)(.*)', '$2')" />
                <xsl:value-of select="concat('title', $idx)" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '제목')">
                <xsl:variable name="idx" select="replace($Svalues, '(제목)(\d+)(.*)', '$2')" />
                <xsl:value-of select="'title'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '메모')">
                <xsl:value-of select="'note'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '머리글')">
                <xsl:value-of select="'header'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '부제')">
                <xsl:value-of select="'subtitle'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '바닥글')">
                <xsl:value-of select="'footer'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '도움말텍스트')">
                <xsl:value-of select="'helpText'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, 'copyright')">
                <xsl:value-of select="'Copyright'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '참고')">
                <xsl:value-of select="'note_hyphen'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '표지_타이틀1')">
                <xsl:value-of select="'coverTitle1'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '표지_타이틀2')">
                <xsl:value-of select="'coverTitle2'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '표지_버전정보')">
                <xsl:value-of select="'coverVersion'" />
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, '목록단락')">
                <xsl:value-of select="'UL1_bullet'" />
                <!--<xsl:value-of select="'disc'" />-->
            </xsl:when>

            <xsl:when test="matches($lowCaseVal, 'bullet2')">
                <xsl:value-of select="'UL2_bullet'" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$Svalues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" priority="10" mode="replaceText">
        <xsl:value-of select="replace(replace(replace(replace(., '&quot;', ''), ';', ''), '\s+$', ''), '^\s+', '')" />
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