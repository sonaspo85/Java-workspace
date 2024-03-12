<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:MadCap="http://www.madcapsoftware.com/Schemas/MadCap.xsd"
	xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="MadCap ast ">

	<xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" />
	<xsl:strip-space elements="*" />


	
	<xsl:template match="/">
		
			<xsl:for-each select="descendant::*[@id]">
				<ddd>
					<xsl:value-of select="@id" />
                </ddd>
            </xsl:for-each>
			
	
	</xsl:template>

	
	
</xsl:stylesheet>
