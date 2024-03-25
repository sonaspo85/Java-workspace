<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

    <xsl:output method="html" indent="no" encoding="UTF-8" include-content-type="no" />
    <xsl:strip-space elements="*" />
    <xsl:variable name="data-language" select="/body/@data-language" />
    <xsl:variable name="model-name" select="/body/@model-name" />

    <xsl:variable name="cr1" select="'&#xA;'" />
    <xsl:variable name="sp1" select="'&#x20;'" />
    <xsl:variable name="crt1" select="'&#xA;&#x9;'" />
    <xsl:variable name="crt2" select="'&#xA;&#x9;&#x9;'" />
    <xsl:variable name="crt3" select="'&#xA;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt4" select="'&#xA;&#x9;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt5" select="'&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;'" />
    <xsl:variable name="crt6" select="'&#xA;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;'" />
    
    <xsl:variable name="sourcePath" select="body/@sourcePath" />
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates />
        <xsl:result-document href="dummy.xml">
            <dummy/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="body">
        <xsl:variable name="file" select="concat($sourcePath, '/output/', 'toc.html')" />
        
        <xsl:result-document href="{$file}">
            <div class="toc">
                <xsl:value-of select="$crt1" />
                <h1><xsl:value-of select="concat($model-name, '&#x20;', 'User Manual')" /></h1>
                <xsl:value-of select="$crt1" />
                <div class="m-home"><span class="side-close">&#xFEFF;</span></div>
                <xsl:value-of select="$crt1" />
                <ul class="toc-nav">
                    <xsl:value-of select="$crt2" />
                    <li>
                        <a href="start_here.html">Welcome</a>
                    </li>
                    <li>
                        <a>
                            <xsl:attribute name="href" select="concat(lower-case(chapter[1]/toc_link[1]/h1), '_', chapter[1]/toc_link[1]/h1/@id, '.html')" />
                            <xsl:value-of select="chapter[1]/toc_link[1]/h1" />
                        </a>
                    </li>
                    <xsl:for-each select="chapter[position() &gt; 1]">
                        <xsl:value-of select="$crt2" />
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:variable name="filename" select="topic[1]/@filename" />
                                    <xsl:variable name="fid" select="topic[1]/*[1]/@id" />
                                    <xsl:value-of select="concat($filename, '_', $fid, '.html')" />
                                </xsl:attribute>
                                <xsl:value-of select="topic[1]/*[1]" />
                            </a>

                            <xsl:choose>
                                <xsl:when test="topic/table//td[matches(@class, 'text-heading')]">
                                    <xsl:variable name="filename" select="topic[1]/@filename" />
                                    <xsl:variable name="fid" select="topic[1]/*[1]/@id" />
                                    <xsl:variable name="href" select="concat($filename, '_', $fid, '.html')" />

                                    <ul>
                                        <xsl:for-each select="topic/table//td[ends-with(@class, 'text-heading')]/*[matches(@class, 'tableheading')]">
                                            <li>
                                                <a href="{concat($href, '#', @id)}">
                                                    <xsl:value-of select="." />
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                        <xsl:value-of select="$crt5" />
                                    </ul>
                                </xsl:when>
                                
                                <xsl:when test="count(.//topic) &gt; 1">
                                    <ul>
                                        <xsl:for-each select="topic">   <!-- 1 topic -->
                                            <xsl:if test="*[matches(@class, '(heading)([23])')]">
                                                <xsl:for-each select="node()">
                                                    <xsl:variable name="filename" select="parent::*/@filename" />
                                                    <xsl:variable name="fid" select="parent::*/*[1]/@id" />
                                                    <xsl:variable name="href" select="concat($filename, '_', $fid, '.html')" />
                                                    <xsl:choose>
                                                        <xsl:when test="self::*[matches(@class, '(heading)([23])')]">
                                                            <li>
                                                                <a href="{concat($href, '#', @id)}">
                                                                    <xsl:value-of select="." />
                                                                </a>
                                                            </li>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:if>
                                            
                                            <xsl:choose>
                                                <xsl:when test="topic">
                                                    <xsl:for-each select="topic">
                                                        <xsl:variable name="filename" select="@filename" />
                                                        <xsl:variable name="fid" select="*[1]/@id" />
                                                        <xsl:variable name="href" select="concat($filename, '_', $fid, '.html')" />
                                                        <xsl:value-of select="$crt4" />
                                                        <xsl:variable name="cur" select="." />

                                                        <li>
                                                            <a href="{$href}">
                                                                <xsl:value-of select="*[1]" />
                                                            </a>
                                                            <xsl:if test="not(topic) and 
                                                                         (*[matches(@class, 'heading3')] or 
                                                                         table//td[ends-with(@class, 'text-body1')]/*[matches(@class, 'heading3')] or 
                                                                         self::*[matches(name(), 'h\d')])">
                                                                <ul>
                                                                    <xsl:for-each select="node()">
                                                                        <xsl:choose>
                                                                            <xsl:when test="self::*[matches(@class, 'heading3')]">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="self::*[matches(@class, 'heading3')]">
                                                                                        <xsl:variable name="cur_pos" select="." />
                                                                                        
                                                                                        <xsl:call-template name="recall">
                                                                                            <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                            <xsl:with-param name="href" select="$href" />
                                                                                            <xsl:with-param name="cur" select="$cur" />
                                                                                        </xsl:call-template>
                                                                                    </xsl:when>
                                                                                </xsl:choose>
                                                                            </xsl:when>

                                                                            <xsl:when test="self::table//td[ends-with(@class, 'text-body1')]/*[matches(@class, 'heading3')]">
                                                                                <xsl:for-each select=".//td[ends-with(@class, 'text-body1')]/*[matches(@class, 'heading3')]">
                                                                                    <li>
                                                                                        <a href="{concat($href, '#', @id)}">
                                                                                            <xsl:value-of select="." />
                                                                                        </a>
                                                                                    </li>
                                                                                </xsl:for-each>
                                                                            </xsl:when>
                                                                        </xsl:choose>
                                                                    </xsl:for-each>
                                                                </ul>
                                                            </xsl:if>

                                                            <xsl:if test="topic">
                                                                <xsl:value-of select="$crt5" />
                                                                <ul>
                                                                    <xsl:for-each select="$cur/node()">
                                                                        <xsl:choose>
                                                                            <xsl:when test="self::*[matches(@class, 'heading3')]">
                                                                                <xsl:variable name="cur_pos" select="." />

                                                                                <xsl:call-template name="recall">
                                                                                    <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                    <xsl:with-param name="href" select="$href" />
                                                                                    <xsl:with-param name="cur" select="$cur" />
                                                                                </xsl:call-template>
                                                                            </xsl:when>
                                                                            
                                                                            <xsl:when test="self::*[matches(name(), 'h\d')][not($cur/*[1])]">
                                                                                <xsl:variable name="cur_pos" select="." />
                                                                                
                                                                                <xsl:call-template name="recall">
                                                                                    <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                    <xsl:with-param name="href" select="$href" />
                                                                                    <xsl:with-param name="cur" select="$cur" />
                                                                                </xsl:call-template>
                                                                            </xsl:when>

                                                                            <xsl:when test="self::table//td[ends-with(@class, 'text-body1')]">
                                                                                <xsl:variable name="cur_pos" select="." />

                                                                                <xsl:call-template name="recall">
                                                                                    <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                    <xsl:with-param name="href" select="$href" />
                                                                                </xsl:call-template>
                                                                            </xsl:when>
                                                                        </xsl:choose>
                                                                    </xsl:for-each>
                                                                    
                                                                    <xsl:for-each select="topic">
                                                                        <xsl:variable name="filename" select="@filename" />
                                                                        <xsl:variable name="fid" select="*[1]/@id" />
                                                                        <xsl:variable name="href" select="concat($filename, '_', $fid, '.html')" />

                                                                        <xsl:for-each select="node()">
                                                                            <xsl:choose>
                                                                                <xsl:when test="self::*[matches(name(), 'h\d')]">
                                                                                    <xsl:variable name="cur_pos" select="." />
                                                                                    
                                                                                    <xsl:call-template name="recall">
                                                                                        <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                        <xsl:with-param name="href" select="$href" />
                                                                                        <xsl:with-param name="cur" select="$cur" />
                                                                                    </xsl:call-template>
                                                                                </xsl:when>

                                                                                <xsl:when test="self::*[matches(@class, 'heading3')]">
                                                                                    <xsl:variable name="cur_pos" select="." />
                                                                                    
                                                                                    <xsl:call-template name="recall">
                                                                                        <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                        <xsl:with-param name="href" select="$href" />
                                                                                        <xsl:with-param name="cur" select="$cur" />
                                                                                    </xsl:call-template>
                                                                                </xsl:when>

                                                                                <xsl:when test="self::table//td[ends-with(@class, 'text-body1')]">
                                                                                    <xsl:variable name="cur_pos" select="." />
                                                                                    
                                                                                    <xsl:call-template name="recall">
                                                                                        <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                        <xsl:with-param name="href" select="$href" />
                                                                                    </xsl:call-template>
                                                                                </xsl:when>

                                                                                <xsl:when test="self::topic//*[matches(@class, 'heading3')]">
                                                                                    <xsl:for-each select="node()">
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="self::*[matches(@class, 'heading3')]">
                                                                                                <xsl:variable name="cur_pos" select="." />

                                                                                                <xsl:call-template name="recall">
                                                                                                    <xsl:with-param name="cur_pos" select="$cur_pos" />
                                                                                                    <xsl:with-param name="href" select="$href" />
                                                                                                    <xsl:with-param name="cur" select="$cur" />
                                                                                                </xsl:call-template>
                                                                                            </xsl:when>
                                                                                        </xsl:choose>
                                                                                    </xsl:for-each>
                                                                                </xsl:when>
                                                                            </xsl:choose>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </ul>
                                                            </xsl:if>
                                                        </li>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:variable name="filename" select="@filename" />
                                                    <xsl:variable name="tid" select="@id" />
                                                    <xsl:value-of select="$crt4" />
                                                
                                                    <li>
                                                        <a href="{concat($filename, '_', $tid, '.html')}"></a>
                                                    </li>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:when>
                            </xsl:choose>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="recall">
        <xsl:param name="cur_pos" />
        <xsl:param name="href" />
        <xsl:param name="cur" />

        <xsl:choose>
            <xsl:when test="$cur_pos[matches(@class, 'heading3')]">
                <li>
                    <a href="{concat($href, '#', @id)}">
                        <xsl:value-of select="." />
                    </a>
                </li>
            </xsl:when>
            
            <xsl:when test="$cur_pos[self::*][matches(name(), 'h\d')]">
                <li>
                    <a href="{$href}">
                        <xsl:value-of select="." />
                    </a>
                </li>
            </xsl:when>
            
            <xsl:when test="$cur_pos[self::table]//td[ends-with(@class, 'text-body1')]">
                <xsl:for-each select="$cur_pos//td[ends-with(@class, 'text-body1')]/*[matches(@class, 'heading3')]">
                    <li>
                        <a href="{concat($href, '#', @id)}">
                            <xsl:value-of select="." />
                        </a>
                    </li>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
