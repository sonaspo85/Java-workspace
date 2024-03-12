<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" version="2.0">

   
    <xsl:param name="specXMLF" />
    <xsl:param name="langXMLF" />
    
    <xsl:variable name="specXMLF00" select="replace(replace(replace($specXMLF, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="specXMLF01" select="concat('file:////', $specXMLF00)"  />
    <xsl:variable name="specXMLF02" select="iri-to-uri($specXMLF01)"  />
    
    <xsl:variable name="langXMLF00" select="replace(replace(replace($langXMLF, '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string"  />
    <xsl:variable name="langXMLF01" select="concat('file:////', $langXMLF00)"  />
    <xsl:variable name="langXMLF02" select="iri-to-uri($langXMLF01)"  />
    
    <!--spec2xml-data.xlsm-->
    <xsl:variable name="langXML" select="document($langXMLF02)/*[local-name()='root']" />
    <!--SPEC_Sample-->
    <xsl:variable name="specXML" select="document($specXMLF02)/*[local-name()='root']" />
    <xsl:variable name="allLangF" select="document(concat(ast:getPath(base-uri(document('')), '/'), '/allLangs.xml'))/*[local-name()='root']" />
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
    
    <xsl:function name="ast:Last">
        <xsl:param name="str" />
        <xsl:param name="char" />
        
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
</xsl:stylesheet>