<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:x="adobe:ns:meta/"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
    exclude-result-prefixes="xs idPkg x rdf dc ast"
    version="2.0">

    <xsl:character-map name="a">
        <xsl:output-character character="&amp;" string="&amp;" />
        <xsl:output-character character="&lt;" string="&lt;" />
        <xsl:output-character character="&gt;" string="&gt;" />
        <xsl:output-character character="&quot;" string="&quot;" />
        <xsl:output-character character="&apos;" string="&apos;" />
    </xsl:character-map>
    
    <xsl:variable name="errorHTML" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'error.html'))" />
    <xsl:variable name="commonRef" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/varExract.xml'))/root"/>
    <xsl:variable name="data-language" select="/docs/@data-language" />
    <xsl:variable name="company" select="tokenize($data-language, '_')[1]" />
    <xsl:variable name="language" select="/docs/substring-after($data-language, '_')" />
    <xsl:variable name="inch" select="/docs/@inch" />
    
    <xsl:variable name="linkedIdFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'IDTxt.xml'))/root" />
    <xsl:variable name="linkedIdFileName" select="$linkedIdFile/@fileName" />
    <xsl:variable name="version" select="$linkedIdFile/@version" />
    <xsl:variable name="ccncVer" select="$linkedIdFile/@ccncVer" />


    <xsl:variable name="a1" select="replace($linkedIdFileName, '(.*)(_ID_)(.*)(_\d+th.*)', '$3')" />
    <xsl:variable name="carName" select="$a1" />
    
    <xsl:variable name="regexLgsRegion" select="replace($commonRef/lgsRegion/@value, '([()]+)', '\\$1')" />
    
    <!-- ************************************************ -->
    <xsl:variable name="uiTxtFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'UITxt.xml'))" />
    <xsl:variable name="uiTxtFileName" select="$uiTxtFile/root/@fileName" />
    <xsl:variable name="spec" select="$uiTxtFile/root/listitem[1]/language" />
    <xsl:variable name="region" select="substring-before(substring-after($spec, '('), ')')" />
    <xsl:variable name="uiTxtLang" select="$uiTxtFile/root/listitem[matches(child::language, $regexLgsRegion, 'i')]" />

    <!-- ************************************************ -->
    <xsl:variable name="verCheck">
        <xsl:choose>
            <xsl:when test="$version = '6th'">
                <xsl:choose>
                    <xsl:when test="$ccncVer = 'ccncLite'">
                        <xsl:value-of select="'ccncLite_V6'" />
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="'V6'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'V5'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="URLformFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/dataTemplate/', 'URL_form_', $verCheck, '.xml'))/root" />
    
    <xsl:variable name="URLformsCompany" select="$URLformFile/URLform[starts-with(Project, $commonRef/company/@value)]" />
    <xsl:variable name="URLformsLang" select="$URLformsCompany[matches(Language, $regexLgsRegion, 'i')]" />
    <xsl:variable name="getURL" select="$URLformsLang/URL" />
    <xsl:variable name="URLformsAnalCode" select="$URLformsLang/analCode" />
    
    <xsl:variable name="sameRegionURL" select="$URLformsCompany[matches(Language, concat('\(', $commonRef/region/@value, '\)'))]" />

    <!-- ************************************************ -->
    <xsl:variable name="idml_import">
        <xsl:choose>
            <xsl:when test="$version = '6th'">
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/version6/', 'idml_import.xml'))/root" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'idml_import.xml'))/root" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="topic_hierarchy">
        <xsl:choose>
            <xsl:when test="$version = '6th'">
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/version6/', 'topic_hierarchy.xml'))/root" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'topic_hierarchy.xml'))/root" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="chapter_sort">
        <xsl:choose>
            <xsl:when test="$version = '6th'">
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/version6/', 'index_sort.xml'))/root" />
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy-of select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/Customize/', 'index_sort.xml'))/root" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- ************************************************ -->
    <xsl:variable name="codesFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/dataTemplate/', 'codes.xml'))/codes/langs" />
    <xsl:variable name="ISOCode" select="$codesFile/code[@Fullname = $language]/@ISO" />
    <xsl:variable name="RTLlgs" select="matches($commonRef/ISOCode/@value, '(AR|IL|IW)')" />
    
    <xsl:variable name="indexSortTopic">
        <xsl:for-each select="$chapter_sort/root/chapter[matches(@company, $commonRef/company/@value)]">
            <xsl:variable name="same" select="current()[@type = $commonRef/region/@value]" />

            <xsl:variable name="same_topic">
                <xsl:if test="$same">
                    <xsl:sequence select="$same/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="differ_topic">
                <!--<xsl:if test="not($same_topic/*) and
                              current()[@type != $commonRef/region/@value]">
                    <xsl:sequence select="current()[@type = 'common']/topic" />
                </xsl:if>-->
                <xsl:if test="not(parent::*/chapter[@type = $commonRef/region/@value]) and
                              current()[@type != $commonRef/region/@value]">
                    <xsl:sequence select="current()[@type = 'common']/topic" />
                </xsl:if>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$same_topic/*">
                        <xsl:copy-of select="$same_topic" />
                </xsl:when>

                <xsl:when test="not($same_topic/*) and
                                $differ_topic">
                        <xsl:copy-of select="$differ_topic" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <!-- ************************************************ -->
	<xsl:template name="varExtract">
	    <xsl:variable name="filePath" select="'../resource/varExract.xml'" />
	    
	    <xsl:result-document href="{$filePath}" indent="yes">
	        <root>
                <dataLanguage value="{$data-language}" />
                <language value="{$language}" />
                <ISOCode value="{$ISOCode}" />
                <company value="{$company}" />
                <lgsRegion value="{concat($language, '(', $region, ')')}" />
                <linkedIdFileName value="{$linkedIdFileName}" />
                <carName value="{$carName}" />
                <uiTxtFileName value="{$uiTxtFileName}" />
                <version>
                    <xsl:choose>
                        <xsl:when test="$version">
                            <xsl:attribute name="value" select="$version" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:attribute name="value" select="'NONE'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </version>
	            <ccncVer>
	                <xsl:attribute name="value" select="$ccncVer" />
	            </ccncVer>
                
                <region value="{$region}" />
                <inch value="{$inch}" />
            </root>
        </xsl:result-document>
	</xsl:template>
    <!-- ************************************************ -->
    <!-- htmlbase, tocbase -->
    <xsl:variable name="body-footer" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'body-footer.xml'))/root/*" />
    <!--<xsl:variable name="body-header" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'body-header.xml'))/root/*" />-->
    
    <xsl:variable name="body-headerPath">
        <xsl:choose>
            <xsl:when test="matches($carName, '^(GZ|EU)$')">
                <xsl:value-of select="concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'body-header-cv.xml')" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy-of select="concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'body-header.xml')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="body-header" select="document($body-headerPath)/root/*" />
    
    <xsl:variable name="search-top" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'search-top.xml'))/root/*" />
    <xsl:variable name="search-footer" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/template/', 'search-footer.xml'))/root/*" />

    <xsl:variable name="metaImage">
        <xsl:choose>
            <xsl:when test="contains($commonRef/company/@value, 'hyun')">
                <xsl:value-of select="'M-hyundai_symbol.png'" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="'M-kia_symbol.png'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- ************************************************ -->
    <xsl:variable name="ch-images" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/', 'ch-images.xml'))" />
    <xsl:variable name="localizationFile" select="document(concat(ast:getName(base-uri(.), '/'), '/../resource/dataTemplate/', 'index_localization.xml'))/root" />


	<!-- ************************************************ -->
    <xsl:function name="ast:getName">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], '/')" />
    </xsl:function>
    
    <xsl:function name="ast:getNameLast">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>

    <xsl:function name="ast:group" as="element()*">
        <xsl:param name="elements" as="element()*" />
        <xsl:param name="level" as="xs:integer" />

        <xsl:for-each-group select="$elements" group-starting-with="*[local-name() eq concat('h', $level)]">
            <xsl:choose>
                <xsl:when test="$level &gt; 4">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>

                <xsl:when test="self::*[local-name() eq concat('h', $level)]">
                    <topic>
                        <xsl:attribute name="id" select="if (@id) then
                                                        @id else
                                                        concat('d', generate-id())" />

                        <xsl:apply-templates select="current-group()[1]" />

                        <!-- level을 +1 하여, ast:group 함수 재귀 호출  -->
                        <xsl:sequence select="ast:group(current-group() except ., $level + 1)" />
                    </topic>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:function>

    <xsl:function name="ast:count">
        <xsl:param name="str"/>
        <xsl:param name="char"/>

        <xsl:variable name="to" select="tokenize($str, $char)" />
        <xsl:choose>
            <xsl:when test="count($to) = 3">
                <xsl:value-of select="$to[2]" />
            </xsl:when>
            <xsl:when test="count($to) = 2">
                <xsl:value-of select="substring-after($to[2], '(')" />
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>