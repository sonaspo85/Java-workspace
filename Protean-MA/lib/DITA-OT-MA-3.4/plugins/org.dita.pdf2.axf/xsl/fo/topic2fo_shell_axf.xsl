<?xml version="1.0" encoding="UTF-8"?><!--
This file is part of the DITA Open Toolkit project.

Copyright 2011 Jarno Elovirta

See the accompanying LICENSE file for applicable license.
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  
  <xsl:import href="plugin:org.dita.pdf2:xsl/fo/topic2fo.xsl"/>

  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/tables-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/toc-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/index-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/root-processing_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/index_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/topic_axf.xsl"/>
  
  <xsl:import xmlns:dita="http://dita-ot.sourceforge.net" href="plugin:com.ast.protean.ma.qsg2020pdf:cfg/fo/xsl/ast-pagebreak.xsl"/><xsl:import href="plugin:com.ast.protean.ma.um2020pdf:cfg/fo/xsl/ast-pagebreak.xsl"/><xsl:import href="plugin:com.ast.protean.ma.um_en_2020pdf:cfg/fo/xsl/ast-pagebreak.xsl"/>

  <xsl:import href="cfg:fo/attrs/custom.xsl"/>
  <xsl:import href="cfg:fo/xsl/custom.xsl"/>
  
</xsl:stylesheet>