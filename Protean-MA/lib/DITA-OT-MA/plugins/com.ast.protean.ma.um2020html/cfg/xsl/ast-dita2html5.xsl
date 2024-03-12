<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  version="2.0">
  
  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

  <!-- root rule -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
