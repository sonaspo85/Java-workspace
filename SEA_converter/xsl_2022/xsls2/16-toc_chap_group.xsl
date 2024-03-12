<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ast="http://www.astkorea.net/"
	exclude-result-prefixes="xs ast">

	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:preserve-space elements="li p" />

	<xsl:key name="link_toc" match="p[matches(@class, 'toc')]/a" use="." />
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="chapter[@TOC_chapter]">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:for-each-group select="*" group-starting-with="*[matches(@class, 'toc')]">
				<xsl:choose>
					<xsl:when test="current-group()[1][matches(@class, 'toc')]">
						<toc_link>
							<xsl:apply-templates select="current-group()" />
                        </toc_link>
                    </xsl:when>
					<xsl:otherwise>
						<toc_link>
							<xsl:apply-templates select="current-group()" />
						</toc_link>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

	<xsl:template match="*[ancestor::*[matches(@TOC_chapter, 'TOC_chapter')]]">
		<xsl:choose>
			<xsl:when test="@class = 'toc'">
				<xsl:variable name="filename" select="ast:normalized(replace(replace(lower-case(a), '\s+', '_'), 'get_started', 'getting_started'))" />
				
				<h3 class="toc">
					<a class="h3" href="{concat($filename, '_', substring-after(a/@href, '#'), '.html')}">
						<xsl:value-of select="." />
					</a>
				</h3>
            </xsl:when>

			<xsl:when test="self::p and preceding-sibling::*[matches(@class, 'toc')]">
				<xsl:copy>
					<xsl:attribute name="class" select="'snippet'" />
					<xsl:apply-templates select="@*" />
					<xsl:for-each select="node()">
						<xsl:choose>
							<xsl:when test="self::b">
								<xsl:copy>
									<xsl:attribute name="class" select="'toc_subtitle'" />
									<xsl:apply-templates select="node()" />
                            	</xsl:copy>
                        	</xsl:when>

							<xsl:otherwise>
								<xsl:copy>
									<xsl:apply-templates select="@*, node()" />
								</xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
				</xsl:copy>
        	</xsl:when>

			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="*[matches(@class, 'heading')]" priority="10">
		<xsl:choose>
			<xsl:when test="parent::*[matches(@TOC_chapter, 'TOC_chapter')]">
				<h3>
					<xsl:attribute name="class" select="'toc'" />
					<a>
						<xsl:apply-templates select="@id" />
						<xsl:value-of select="." />
					</a>
                </h3>
            </xsl:when>

			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="text()" priority="10">
		<xsl:value-of select="replace(., '[&#xa0;]+', ' ')" />
    </xsl:template>


    <xsl:function name="ast:normalized">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(replace(normalize-unicode(replace(replace(lower-case(normalize-space(replace($value, '\+', '_plus'))), '[!@#$%&amp;();:.,’?]+', ''), '[ &#xA0;]', '_'), 'NFKD'), '\P{IsBasicLatin}', ''), '/' , '_')"/>
    </xsl:function>
</xsl:stylesheet>