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
	
	<xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>
	
	
	<xsl:template match="/">
		<xsl:call-template name="varExtract" />
			
		<xsl:variable name="str0">
			<xsl:element name="docs">
				<xsl:attribute name="version" select="$version" />
				<xsl:attribute name="data-language" select="docs/@data-language" />
				<xsl:attribute name="inch" select="docs/@inch" />
				<xsl:apply-templates select="//HyperlinkURLDestination" />
				<xsl:apply-templates select="//Hyperlink" />
				
				<xsl:for-each select="docs/doc1">
					<xsl:if test="not(ends-with(@doc-name, '(Cover|TOC|Index)'))">
						<xsl:element name="doc">
							<xsl:attribute name="idml" select="concat(@doc-name, '.idml')"/>
							
							<xsl:for-each select="node()">
								<xsl:if test="self::*[name()='idPkg:Story']">
									<xsl:apply-templates select="Story" />
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>
			
		<xsl:apply-templates select="$str0/docs" mode="chapter_sort" />
	</xsl:template>


    <xsl:template match="HyperlinkURLDestination">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="parentNode" select="concat(parent::doc1/@doc-name, '.idml')" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Hyperlink">
        <xsl:copy copy-namespaces="no">
        	<xsl:attribute name="parentNode" select="concat(parent::doc1/@doc-name, '.idml')" />
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
	<xsl:template match="docs" mode="chapter_sort">
		<xsl:variable name="cur" select="." />
		
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<!-- Hyperlink, HyperlinkURLDestination related tags -->
			<xsl:copy-of select="doc[1]/preceding-sibling::node()" />
			
			<xsl:for-each select="$idml_import/root/chapter">
				<xsl:variable name="same">
					<xsl:choose>
						<xsl:when test="current()[@type = $region]">
							<xsl:for-each select="topic[parent::*/@type = $region]">
								<xsl:variable name="idml" select="@idml" />
								
								<xsl:call-template name="doc.recall">
									<xsl:with-param name="cur" select="$cur" />
									<xsl:with-param name="idml" select="$idml" />
								</xsl:call-template>
	                        </xsl:for-each>
	                    </xsl:when>
	                </xsl:choose>
				</xsl:variable>

				<xsl:variable name="differ">
					<xsl:choose>
						<xsl:when test="not(parent::*/chapter[@type = $region]) and 
										current()[@type != $region]">
							<xsl:for-each select="topic[parent::chapter/@type = 'common']">
								<xsl:variable name="idml" select="@idml" />
								
								<xsl:call-template name="doc.recall">
									<xsl:with-param name="cur" select="$cur" />
									<xsl:with-param name="idml" select="$idml" />
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="$same/node()">
						<xsl:copy-of select="$same" />
					</xsl:when>

					<xsl:when test="not($same/node()) and $differ">
						<xsl:copy-of select="$differ" />
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="doc.recall">
		<xsl:param name="cur" />
		<xsl:param name="idml" />

		<xsl:for-each select="$cur/doc">
			<xsl:variable name="docName" select="replace(@idml, '.idml', '')"/>
			
			<xsl:choose>
				<xsl:when test="self::*[starts-with(@idml, $idml)][matches(@idml, '01\d\-\d')]">
					<xsl:apply-templates select="self::*[$docName = $idml]" mode="chapter_sort" />
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:copy-of select="self::*[$docName = $idml]" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
    </xsl:template>

	<xsl:template match="doc[matches(@idml, '01\d\-\d')]" mode="chapter_sort">
		<xsl:variable name="idml" select="substring-after(@idml, '_')" />
		<xsl:variable name="pred-num" select="replace(substring-before(@idml, '_'), '(01)(\d\-)(\d)', '$1$3')" />

		<xsl:copy>
			<xsl:apply-templates select="@* except @idml" />
			<xsl:attribute name="idml" select="concat($pred-num, '_', $idml)" />

			<xsl:apply-templates select="node()" mode="chapter_sort" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@* | node()" mode="chapter_sort">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="chapter_sort" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="Story">
        <xsl:choose>
            <xsl:when test="count(descendant::Content) eq 0"/>
            <xsl:when test="count(descendant::Content) eq 1 and 
            				empty(descendant::Content[1]/text())"/>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="Self" select="@Self"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="ParagraphStyleRange">
		<xsl:choose>
			<xsl:when test="matches(@AppliedParagraphStyle, '도안번호')">
			</xsl:when>
			<xsl:when test="CharacterStyleRange/@AppliedCharacterStyle[ends-with(., 'C_SW_Version')]">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy copy-namespaces="no">
					<xsl:attribute name="pStyle" select="tokenize(@AppliedParagraphStyle,'/')[last()]"/>
					<xsl:apply-templates />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <xsl:template match="Group">
       	<xsl:apply-templates select="Rectangle[.//Link][1]"/>
    </xsl:template>

    <xsl:template match="CharacterStyleRange">
        <xsl:choose>
           <xsl:when test="count(descendant::Content) eq 1 and 
           				empty(descendant::Content[1]/text())"/>
			
			<xsl:when test="preceding-sibling::*[1][name()='XMLElement'] and 
							following-sibling::*[1][name()='XMLElement'] and
					  	  count(node()) = 1 and 
					  	  child::Br">
			</xsl:when>

			<xsl:when test="not(node())">
			</xsl:when>
            
            <!--<xsl:when test="count(node()) = 1 and 
                            child::Br">
                <aaa/>
            </xsl:when>-->
            
            <xsl:when test="contains(@AppliedCharacterStyle,'[No character style]')">
		        <xsl:apply-templates />
            </xsl:when>
        	
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="cStyle" select="tokenize(@AppliedCharacterStyle,'/')[last()]"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[matches(@AppliedCharacterStyle, 'C_NoHTML')]">
    </xsl:template>
    
    <xsl:template match="*[matches(@AppliedParagraphStyle, 'Chapter-Title')]">
    </xsl:template>

    <xsl:template match="Br">
        <xsl:choose>
			<xsl:when test="./following-sibling::* or ../following-sibling::*">
            	<Br/>
            </xsl:when>

			<xsl:when test="not(following-sibling::node()[1])">
				<Br/>
			</xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Rectangle | Polygon">
    	<xsl:choose>
            <xsl:when test="EPS">
                <xsl:apply-templates select="EPS/Link"/>
            </xsl:when>
    		
            <xsl:when test="PDF">
                <xsl:apply-templates select="PDF/Link"/>
            </xsl:when>
    		
            <xsl:when test="Image">
                <xsl:apply-templates select="Image/Link"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Link">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="ImageTypeName" select="tokenize(../@ImageTypeName,'/')[last()]"/>
            <xsl:attribute name="LinkResourceURI" select="@LinkResourceURI"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="StoryPreference | InCopyExportOption | MetadataPacketPreference | TextVariableInstance | 
    					 PageReference | TextWrapPreference | ObjectExportOption | TextFrame | Properties"/>

    <xsl:template match="@TextTopInset | @TextLeftInset | @TextBottomInset | @TextRightInset | @TableDirection |
    					 @ClipContentToTextCell | @AppliedCellStylePriority | @CellType | @SingleRowHeight | @MinimumHeight |
    					 @AppliedCharacterStyle | @Hidden | @ClipContentToCell | @LeftEdgeStrokeColor | @RightEdgeStrokeColor |
    					 @BottomEdgeStrokeType | @BottomEdgeStrokeTint | @LeftEdgeStrokePriority | @RightEdgeStrokePriority | @TopEdgeStrokePriority | @BottomEdgeStrokePriority |
    					 @GraphicLeftInset | @GraphicTopInset | @GraphicRightInset | @GraphicBottomInset | @ClipContentToGraphicCell |
    					 @LeftInset | @RightInset">
    </xsl:template>

    <xsl:template match="@Self[local-name(..) eq 'Table' or local-name(..) eq 'Row' or local-name(..) eq 'Column' or 
                               local-name(..) eq 'Link' or  local-name(..) eq 'Rectangle']"/>
    
    <xsl:template match="@AppliedTableStyle">
        <xsl:attribute name="{local-name()}" select="tokenize(.,'/')[last()]"/>
    </xsl:template>

    <xsl:template match="@AppliedCellStyle">
        <xsl:attribute name="{local-name()}" select="tokenize(.,'/')[last()]"/>
    </xsl:template>

	<xsl:template match="XMLElement|XMLAttribute">
    	<xsl:apply-templates />
    </xsl:template>

	<xsl:template match="HiddenText | Content[matches(., '^&#xFEFF;$')]">
	</xsl:template>
	
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

	<xsl:template match="text()" priority="15">
		<xsl:value-of select="replace(., '&#8232;', '%#%')" />
	</xsl:template>

</xsl:stylesheet>