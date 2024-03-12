<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
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
    exclude-result-prefixes="xs son xsi idPkg functx x dc xmp xmpGImg xmpMM stRef stEvt illustrator xmpTPg stDim xmpG pdf rdf"
    version="3.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
	<xsl:strip-space elements="*"/>
	
    <xsl:param name="srcDirs" />
    <xsl:param name="folderName" />
    

    <xsl:variable name="regionF" select="document(concat(son:getpath(base-uri(document('')), '/'), '/region.xml'))/*[local-name()='root']" />
    <xsl:variable name="srcDirs01" select="replace(replace(replace($srcDirs, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="srcDirs02" select="concat('file:////', $srcDirs01)"  />
    <xsl:variable name="srcDirs03" select="iri-to-uri(concat($srcDirs02, '/temp/cleanSource/', '?select=*.xml;recurse=yes'))"  />
    <xsl:variable name="directory" select="collection($srcDirs03)" />
    
    <xsl:variable name="tokenRegion">
        <xsl:for-each select="$regionF/region">
            <xsl:variable name="curRegion" select="." />
            <xsl:variable name="regionAttr" select="@region" />
            <xsl:variable name="outRegion" select="@outRegion" />
            
            <xsl:choose>
                <xsl:when test="count(tokenize($regionAttr, ',')) &gt; 1">
                    <xsl:for-each select="tokenize($regionAttr, ',')">
                        <xsl:variable name="cur" select="." />
                        
                        <xsl:choose>
                            <xsl:when test="$curRegion/type">
                                <region region="{$cur}">
                                    <xsl:copy-of select="$curRegion/type" />
                                </region>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <region region="{$cur}" outRegion="{$outRegion}" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <region region="{$regionAttr}" outRegion="{$outRegion}" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="getRegion">
        <xsl:variable name="var0">
            <xsl:iterate select="$tokenRegion/region">
                <xsl:variable name="curRegion" select="." />
                <xsl:variable name="region" select="@region" />
                <xsl:variable name="outRegion" select="@outRegion" />
                
                <xsl:if test="matches($folderName, $region, 'i')">
                    <xsl:choose>
                        <xsl:when test="child::type">
                            <xsl:iterate select="type">
                                <xsl:variable name="curType" select="." />
                                <xsl:variable name="typeVal" select="@value" />
                                <xsl:variable name="typeOutRegion" select="@outRegion" />
                                
                                <xsl:choose>
                                    <xsl:when test="matches($folderName, $typeVal)">
                                        <xsl:value-of select="$typeOutRegion" />
                                        <xsl:break />
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="$curType[matches(@value, 'COMMON')]/@outRegion" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:iterate>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="$curRegion[matches(@region, $region)]/@outRegion" />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:break />
                </xsl:if>
            </xsl:iterate>
        </xsl:variable>
        
        <xsl:value-of select="$var0" />
    </xsl:variable>


	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

	<xsl:template match="/">
	    <xsl:variable name="filename" select="concat($srcDirs02, '/temp/04-resource_merged.xml')" />
	    
		<xsl:result-document href="{$filename}" method="xml">
			<root>
			    <xsl:attribute name="region" select="$getRegion" />
			    <xsl:attribute name="folderName" select="$folderName" />
			    <!--<xsl:copy-of select="$tokenRegion" />-->
			    
			    <xsl:for-each select="$directory/*">
				    <doc ori-filename="{son:last(base-uri(.), '/')}">
						<xsl:attribute name="lang">
						    <xsl:variable name="fileName" select="tokenize(replace(son:last(base-uri(.), '/'), '.xml', ''), '_')[last()]"/>
							<xsl:value-of select="$fileName"/>
						</xsl:attribute>
						
						<xsl:apply-templates select="@*, node()" />
					</doc>
				</xsl:for-each>
			</root>
		</xsl:result-document>
	    <dummy/>
	</xsl:template>

	<xsl:function name="son:getpath">
		<xsl:param name="arg1" />
		<xsl:param name="arg2" />
		<xsl:value-of select="string-join(tokenize($arg1, $arg2)[position() ne last()], $arg2)" />
	</xsl:function>

	<xsl:function name="son:last">
		<xsl:param name="arg1" />
		<xsl:param name="arg2" />
		<xsl:copy-of select="tokenize($arg1, $arg2)[last()]" />
	</xsl:function>

</xsl:stylesheet>