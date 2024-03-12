<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs idPkg ast"
    version="2.0">

    
    
    <!-- <xsl:variable name="docinfo" select="document(concat(ast:getPath(base-uri(document('')), '/'), '/../', 'docInfo.xml'))" /> -->
    <xsl:variable name="docinfo" select="document(resolve-uri(concat(ast:getPath(base-uri(document('')), '/'), '/../resource/', 'docInfo.xml')))" />

    <!-- <xsl:variable name="docinfo0" select="replace(replace(replace(replace($docinfoF, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string" />
    <xsl:variable name="docinfo" select="document(iri-to-uri($docinfo0))" /> -->

    <xsl:variable name="srcDirs0" select="$docinfo/root/item[@id = 'srcDir']/@path" />
    <xsl:variable name="srcDir" select="replace(replace(replace(replace($srcDirs0, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string" />

    <xsl:variable name="tempDir0" select="$docinfo/root/item[@id = 'tempDir']/@path" />
    <xsl:variable name="tempDir" select="replace(replace(replace(replace($tempDir0, ' ', '%20'), '\\', '/'), '\[', '%5B'), '\]', '%5D')" as="xs:string" />
    <xsl:variable name="type" select="$docinfo/root/@type" />
    <xsl:variable name="modelcode" select="$docinfo/root/@modelNumber" />
    <xsl:variable name="langmapCnt" select="count(tokenize($docinfo/root/item[@id = 'langsMap']/@sequence, ','))" />
    <xsl:variable name="videoswitch" select="$docinfo/root/@videoSwitch" />
    
    <!-- <xsl:variable name="navF" select="document(concat($tempDir, '/19-create-body-header.xml'))/root" /> -->
    <xsl:variable name="navF" select="document(iri-to-uri(concat($tempDir, '/19-create-body-header.xml')))/root" />

    <xsl:variable name="msgDirs02" select="iri-to-uri(concat('file:////', $tempDir, '/excelTempls/message.xml'))" />
    <xsl:variable name="msgPath" select="document($msgDirs02)/root" />

    <xsl:variable name="videolinkDirs02" select="iri-to-uri(concat('file:////', $tempDir, '/excelTempls/video_link.xml'))" />
    <xsl:variable name="videolinkPath" select="document($videolinkDirs02)" />

    <xsl:variable name="videokeyDirs02" select="iri-to-uri(concat('file:////', $tempDir, '/excelTempls/video_key.xml'))" />
    <xsl:variable name="videokeyPath" select="document($videokeyDirs02)/root" />

    <xsl:variable name="videolinkDirs03" select="iri-to-uri(concat('file:////', $tempDir, '/00-videolinkF-group.xml'))" />
    <xsl:variable name="videolinkPath03" select="document($videolinkDirs03)/root" />

    <xsl:variable name="linkDirs02" select="iri-to-uri(concat('file:////', $tempDir, '/linkCollection.xml'))" />
    <xsl:variable name="linkPath" select="document($linkDirs02)/root" />



    <xsl:variable name="body-header" select="document(concat(ast:getPath(base-uri(document('')), '/'), '/html-templs/', 'body-header.xml'))" />
    <xsl:variable name="body-footer" select="document(concat(ast:getPath(base-uri(document('')), '/'), '/html-templs/', 'body-footer.xml'))" />

    <!-- ************************************************ -->
	<!-- ************************************************ -->
    <xsl:function name="ast:getLast">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="tokenize($str, $char)[last()]" />
    </xsl:function>
    
    <xsl:function name="ast:getPath">
        <xsl:param name="str"/>
        <xsl:param name="char"/>
        <xsl:value-of select="string-join(tokenize($str, $char)[position() ne last()], $char)" />
    </xsl:function>
    
</xsl:stylesheet>