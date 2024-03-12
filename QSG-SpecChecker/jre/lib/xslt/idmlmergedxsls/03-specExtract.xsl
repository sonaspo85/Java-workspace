<?xml  version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:x="adobe:ns:meta/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:xmpGImg="http://ns.adobe.com/xap/1.0/g/img/"
    xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:stRef="http://ns.adobe.com/xap/1.0/sType/ResourceRef#"
    xmlns:stEvt="http://ns.adobe.com/xap/1.0/sType/ResourceEvent#"
    xmlns:illustrator="http://ns.adobe.com/illustrator/1.0/"
    xmlns:xmpTPg="http://ns.adobe.com/xap/1.0/t/pg/"
    xmlns:stDim="http://ns.adobe.com/xap/1.0/sType/Dimensions#"
    xmlns:xmpG="http://ns.adobe.com/xap/1.0/g/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs ast xsi idPkg functx x dc xmp xmpGImg xmpMM stRef stEvt illustrator xmpTPg stDim xmpG pdf rdf" 
    version="2.0">
    <xsl:strip-space elements="*"/>
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" method="xml" indent="no" />
    
    <xsl:param name="midName" />
    
    <xsl:variable name="srcDirs01" select="replace(replace(replace($midName, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="concat('file:////', $srcDirs01)"  />
    <xsl:variable name="srcDirs03" select="iri-to-uri(concat($srcDirs02, '/temp/mergeSrc/?select=', '*.xml?;recurse=yes'))"  />
    <xsl:variable name="directory" select="collection($srcDirs03)" />    
        
        
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="/">
        <xsl:for-each select="$directory/*">
            <xsl:variable name="fileName" select="ast:last(base-uri(.), '/')"/>
            <xsl:result-document href="{concat($srcDirs02, '/temp/cleanSource/', $fileName)}">
                <xsl:copy copy-namespaces="no" inherit-namespaces="no">
                    <xsl:apply-templates select="node()" />
                </xsl:copy>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="ParagraphStyleRange">
        <xsl:choose>
            <xsl:when test="*[1][name()='Table']">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:when test="CharacterStyleRange/*[1][name()='Table']">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <p>
                   <xsl:apply-templates select="@*, node()" />
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="CharacterStyleRange">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="Table">
        <xsl:choose>
            <xsl:when test="ancestor::*[name()='ParagraphStyleRange']">
                <xsl:copy copy-namespaces="no" inherit-namespaces="no">
                    <xsl:attribute name="classPar" select="ast:last(ancestor::*[name()='ParagraphStyleRange']/@AppliedParagraphStyle, '/')" />
                    <xsl:apply-templates select="@*" />
                    <xsl:call-template name="tableSort">
                        <xsl:with-param name="cur" select="Cell" />
                    </xsl:call-template>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no" inherit-namespaces="no">
                    <xsl:apply-templates select="@*" />
                    <xsl:call-template name="tableSort">
                        <xsl:with-param name="cur" select="Cell" />
                    </xsl:call-template>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tableSort">
        <xsl:param name="cur" />
        
        <xsl:for-each-group select="$cur" group-by="tokenize(@Name, ':')[last()]">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <tr>
                        <xsl:apply-templates select="current-group()" />
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="current-group()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="Cell">
        <td>
            <xsl:apply-templates select="@*, node()" />
        </td>
    </xsl:template>
    
    <xsl:template match="@AppliedParagraphStyle | @AppliedCharacterStyle | @AppliedTableStyle">
        <xsl:attribute name="class" select="ast:last(., '/')" />
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="replace(., '&#x2028;', '')"/>
    </xsl:template>
    
    <xsl:template match="Story">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="Content">
        <xsl:choose>
            <xsl:when test="not(node())">
                <xsl:text> </xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
     
    <xsl:template match="Rectangle">
        <xsl:apply-templates select="descendant::Link" />
    </xsl:template>
    
    <xsl:template match="Link">
        <image>
            <xsl:choose>
                <xsl:when test="ancestor::PDF">
                    <xsl:variable name="ancesPDF" select="ancestor::PDF" />
                    <xsl:variable name="graphicBound" select="$ancesPDF/Properties[1]/GraphicBounds" />
                    
                    <xsl:variable name="gbAttr">
                        <xsl:variable name="box">
                            <xsl:for-each select="$ancesPDF/Properties[1]/GraphicBounds/@*[matches(name(), '(Left|Top|Right|Bottom)')]">
                                <xsl:variable name="cur" select="name(.)" />
                                <xsl:variable name="value" select="." />
                                
                                    <box>
                                        <xsl:element name="{$cur}">
                                            <xsl:value-of select="$value"/>
                                        </xsl:element>
                                    </box>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="width" select="(number($box/box/Right) - number($box/box/Left))" />
                        <xsl:variable name="height" select="number($box/box/Bottom) - number($box/box/Top)" />
                        <box width="{$width}" height="{$height}" />
                    </xsl:variable>
                    
                    <xsl:variable name="itemTransForm" select="tokenize($ancesPDF/@ItemTransform, ' ')[1]" />
                    
                    <xsl:variable name="finalWidth" select="($gbAttr/box/@width div 2.834645669) * number($itemTransForm)" />
                    <xsl:variable name="finalHeight" select="($gbAttr/box/@height div 2.834645669) * number($itemTransForm)" />
                    <xsl:attribute name="LinkResourceURI" select="ast:last(@LinkResourceURI, '/')" />
                    <xsl:attribute name="ItemTransform" select="$itemTransForm" />
                    <xsl:attribute name="width" select="$finalWidth" />
                    <xsl:attribute name="height" select="$finalWidth" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="LinkResourceURI" select="ast:last(@LinkResourceURI, '/')" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()" />
        </image>
    </xsl:template>
    
    <xsl:template match="text()" priority="5">
        <xsl:analyze-string select="." regex="(.*)(&#x2028;)(\s?\d+[.]?\d+\s?)(W/kg)">
            <xsl:matching-substring>
                <xsl:value-of select="replace(regex-group(0), '&#x2028;', '')"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(.*)(&#x2028;)(([-\s]+|.)*)(kHz)">
                    <xsl:matching-substring>
                        <xsl:value-of select="replace(regex-group(0), '&#x2028;', '')"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(Cihazın)(.*)([&#x2028;\s]+)?(2 yıldır.)">
                            <xsl:matching-substring>
                                <xsl:value-of select="replace(replace(regex-group(0), '([&#x2028;\s]+)', ' '), '\s+', ' ')"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="([^/])(&#x2028;)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                        <br/>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="replace(replace(., '&#x2028;', ''), '&#xA0;', ' ')"/>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="Br">
        <xsl:choose>
            <xsl:when test="parent::*[matches(name(),'CharacterStyleRange')]
                            /parent::*[matches(name(),'ParagraphStyleRange')]
                            /@AppliedParagraphStyle[matches(., '(UnorderList|Description-Cell)')]">
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="following-sibling::node()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*[not(matches(name(), 'AppliedParagraphStyle|AppliedCharacterStyle|Name|ColumnSpan|RowSpan|LinkResourceURI|DestinationUniqueKey|Source|AppliedTableStyle'))]" />
    
    <xsl:template match="InCopyExportOption | StoryPreference | Properties | MetadataPacketPreference" />
    
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