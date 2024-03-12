<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">
	
	<xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="Content"/>
	
    
	
	<xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*, node()"/>
        </xsl:element>
    </xsl:template>

	<xsl:template match="@*">
        <xsl:choose>
            <xsl:when test="matches(name(), '(Name|AppliedCharacterStyle|AppliedFormat)') and 
                            parent::*[matches(local-name(), '(CrossReferenceSource|HyperlinkTextDestination)')]">    
            </xsl:when>

            <xsl:when test="matches(name(), 'Self') and 
                            parent::CrossReferenceSource">
                <xsl:attribute name="crosskey" select="."/>
            </xsl:when>

            <xsl:when test="matches(name(), '(AppliedCharacterStyle|AppliedParagraphStyle|AppliedTableStyle)')">
                <xsl:attribute name="class" select="replace(replace(ast:getLast(., '/'), 'HTML%3a', ''), 'Cover%3a', '')"/>
            </xsl:when>

            <xsl:when test="matches(name(), 'StoryDirection')">
                <xsl:attribute name="dir" select="."/>
            </xsl:when>

            <xsl:when test="matches(name(), 'VerticalJustification')">
                <xsl:attribute name="align" select="."/>
            </xsl:when>

            <xsl:when test="matches(name(), 'ParagraphBreakType')">
                <xsl:attribute name="breakType" select="."/>
            </xsl:when>

            <xsl:when test="matches(name(), '(Alpha|Auto|EdgeStroke|DOMVersion|AppliedTOCStyle|IsEndnoteStory|StoryTitle|TrackChanges|UserText|Inset|ClipContent|Type|TopEdgeStrokeTint|MinimumHeight|FooterRowCount|StoryOrientation|OpticalMarginSize|OpticalMarginAlignment|AppliedNamedGrid|Priority|FillColor|SpaceAfter|FirstBaselineOffset|AppliedLanguage|TocEntryPageNumberString|HorizontalScale|Tracking|Hidden|Self|TreatIdeographicSpaceAsSpace|StartRow|TableDirection|SingleRowHeight|SingleColumnWidth|BaselineShift|SpaceBefore)')"> 
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="{name()}" select="replace(replace(replace(replace(., 'HTML%3a', ''), 'Cover%3a', ''), 'CellStyle/', ''), 'TableStyle/', '')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="/">
        <xsl:variable name="linkF" select="'linkCollection.xml'"/>

        <xsl:result-document href="{$linkF}">
            <xsl:element name="root" inherit-namespaces="no">
                <xsl:for-each select="root">
                    <xsl:variable name="filename" select="@filename"/>

                    <xsl:for-each select="linkcollect">
                        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
                            <xsl:attribute name="filename" select="$filename"/>
                            <xsl:apply-templates select="@*, node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>


    <xsl:template match="Rectangle">
        <xsl:apply-templates select="descendant::*[matches(name(), '(Image|PDF)')]"/>
    </xsl:template>

    <xsl:template match="Image[parent::Rectangle]">
        <xsl:variable name="href" select="ast:getLast(child::Link/@LinkResourceURI, '/')"/>
        
        
        <xsl:variable name="class">
            <xsl:choose>
                <xsl:when test="ancestor::Rectangle[1]/parent::CharacterStyleRange">
                    <xsl:value-of select="ast:getLast(ancestor::CharacterStyleRange[1]/@AppliedCharacterStyle, '/')" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="ast:getLast(ancestor::ParagraphStyleRange[1]/@AppliedParagraphStyle, '/')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:attribute name="href" select="$href"/>
            <xsl:attribute name="class" select="replace(replace($class, 'HTML%3a', ''), 'Cover%3a', '')"/>
        </xsl:copy>
    </xsl:template>

	<xsl:template match="PDF[parent::Rectangle]">
        <xsl:variable name="href" select="ast:getLast(child::Link/@LinkResourceURI, '/')"/>
        
        <xsl:variable name="class">
            <xsl:choose>
                <xsl:when test="ancestor::Rectangle[1]/parent::CharacterStyleRange">
                    <xsl:value-of select="ast:getLast(ancestor::CharacterStyleRange[1]/@AppliedCharacterStyle, '/')" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="ast:getLast(ancestor::ParagraphStyleRange[1]/@AppliedParagraphStyle, '/')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="Image" inherit-namespaces="no">
            <xsl:attribute name="href" select="$href"/>
            <xsl:attribute name="class" select="replace(replace($class, 'HTML%3a', ''), 'Cover%3a', '')"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="Mojikumi | KinsokuSet | dMap | StoryPreference | InCopyExportOption | TextVariableInstance | PDFAttribute 
						| ImageIOPreference | TextFrame | Properties | TextWrapPreference | ObjectExportOption | GraphicLine| 
						linkcollect | Note"/>

	<xsl:template match="CharacterStyleRange">
        <xsl:choose>
            <xsl:when test="count(node()) = 1 and
                            child::*[matches(local-name(), '(HyperlinkTextDestination|CrossReferenceSource)')]">
                <xsl:apply-templates select="node()"/>
            </xsl:when>

            <xsl:when test="count(node()) = 1 and 
                            matches(parent::*/@AppliedParagraphStyle, 'OrderList') and 
							child::Br">
                <xsl:apply-templates select="node()"/>
            </xsl:when>

			<xsl:when test="count(node()) = 1 and 
							matches(@ParagraphBreakType, 'NextColumn') and 
							child::Br">
			</xsl:when>

            <xsl:otherwise>
                <xsl:copy inherit-namespaces="no" copy-namespaces="no">
                    <xsl:apply-templates select="@*, node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="processing-instruction()[name() = 'ACE']"/>

	<xsl:template match="text()">
        <xsl:value-of select="replace(replace(replace(., '&#xa0;', ' '), '&#x2028;', ' '), '\s+', ' ')" />
    </xsl:template>

</xsl:stylesheet>