<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast"
    version="2.0">
	
	
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>
    
    
	<xsl:variable name="exceldb">
	    <xsl:for-each select="root/excelDB/grouped">
	       <xsl:copy>
	           <xsl:apply-templates select="@*" />
	           
	           <xsl:for-each select="listitem">
	               <xsl:copy>
	                   <xsl:attribute name="id" select="count(preceding-sibling::listitem)" />
	                   <xsl:apply-templates select="@*, node()" />
	               </xsl:copy>
	           </xsl:for-each>
	       </xsl:copy>
	   </xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="competitive_price[parent::dbtempls]">
        <xsl:variable name="class1" select="@class" />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <items>
                <xsl:for-each select="items/*">
                    <xsl:variable name="ancesCls" select="parent::items/parent::*/@class" />
                    <xsl:variable name="id" select="@id" />
                    
                    <xsl:if test="$class1 = $exceldb/grouped/@class">
                        <xsl:variable name="var0" select="$exceldb/grouped[@class = $class1]/listitem" />

                        <xsl:choose>
                            <xsl:when test="$id = $var0/@id">
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell1')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell1')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@detail" />
                                    </xsl:if>
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell3')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell3')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@company" />
                                    </xsl:if>
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </items>
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="automation[parent::dbtempls]">
        <xsl:variable name="class1" select="@class" />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <items>
                <xsl:for-each select="items/*">
                    
                    <xsl:variable name="ancesCls" select="parent::items/parent::*/@class" />
                    <xsl:variable name="id" select="@id" />
                    
                    <xsl:if test="$class1 = $exceldb/grouped/@class">
                        <xsl:variable name="var0" select="$exceldb/grouped[@class = $class1]/listitem" />
                        
                        <xsl:choose>
                            <xsl:when test="$id = $var0/@id">
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell1')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell1')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@detail" />
                                    </xsl:if>
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell3')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell3')]" />
                                        
                                        <xsl:choose>
                                            <xsl:when test="matches($var0[@id = $id]/@company, '/')">
                                                <xsl:variable name="valsOne" select="tokenize($var0[@id = $id]/@company, '/')[1]" />
                                                <xsl:variable name="valsTwo" select="replace(tokenize($var0[@id = $id]/@company, '/')[2], '(\d+)(.*)?', '$1')" />
                                                
                                                <xsl:attribute name="{local-name($name)}" select="normalize-space($valsOne)" />
                                                
                                                <xsl:attribute name="{replace(local-name($name), '(t\dcell)(3)', '$14')}" select="normalize-space($valsTwo)" />
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:attribute name="{local-name($name)}" select="'0'" />
                                                <xsl:attribute name="{replace(local-name($name), '(t\dcell)(3)', '$14')}" select="replace($var0[@id = $id]/@company, '(\d+)(.*)?', '$1')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </items>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="safety[parent::dbtempls]">
        <xsl:variable name="class1" select="@class" />
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <items>
                <xsl:for-each select="items/*">
                    <xsl:variable name="ancesCls" select="parent::items/parent::*/@class" />
                    <xsl:variable name="id" select="@id" />
                    
                    <xsl:if test="$class1 = $exceldb/grouped/@class">
                        <xsl:variable name="var0" select="$exceldb/grouped[@class = $class1]/listitem" />
                        
                        <xsl:choose>
                            <xsl:when test="$id = $var0/@id">
                                <xsl:variable name="cur" select="." />
                                
                                <xsl:copy>
                                    <xsl:apply-templates select="@*" />
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell1')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell1')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@evaluateType" />
                                    </xsl:if>
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell2')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell2')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@detail" />
                                    </xsl:if>
                                    
                                    <xsl:if test="@*[matches(local-name(), 't\dcell4')]">
                                        <xsl:variable name="name" select="@*[matches(local-name(), 't\dcell4')]" />
                                        
                                        <xsl:attribute name="{local-name($name)}" select="$var0[@id = $id]/@company" />
                                    </xsl:if>
                                </xsl:copy>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*, node()" />
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </items>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="excelDB">
    </xsl:template>
    
</xsl:stylesheet>