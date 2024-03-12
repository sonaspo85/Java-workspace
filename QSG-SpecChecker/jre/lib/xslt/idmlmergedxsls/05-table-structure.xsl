<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:son="http://www.astkorea.net/"
    xmlns:functx="http://www.functx.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs son xsi functx"
    version="2.0">


	<xsl:output method="xml" encoding="UTF-8" indent="no" cdata-section-elements="Contents" />
	<xsl:strip-space elements="*"/>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>

	<xsl:template match="Table">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:for-each-group select="node()" group-starting-with="tr[td[1][@RowSpan &gt; 1]]">
				<xsl:choose>
					<xsl:when test="current-group()[1][td[1][@RowSpan &gt; 1]]">
						<xsl:apply-templates select="current-group()[1]" />
						
						<xsl:call-template name="grouping">
							<xsl:with-param name="group" select="current-group()[position() &gt; 1]" />
							<xsl:with-param name="idx" select="current-group()[1]/td[1]/@RowSpan - 1" />
							<xsl:with-param name="firstTD" select="current-group()[1]/td[1]" />
						</xsl:call-template>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:apply-templates select="current-group()" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:variable name="class" select="@class"/>

		<xsl:choose>
			<xsl:when test="child::br and 
							matches($class, 'Description')">
				<xsl:choose>
					<xsl:when test="count(parent::*/p) = 1">
						<xsl:for-each select="node()">
							<xsl:choose>
								<xsl:when test="self::text()">
									<p>
										<xsl:apply-templates select="$class" />
										<xsl:value-of select="."/>
									</p>
								</xsl:when>
								
								<xsl:otherwise>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
				
					<xsl:otherwise>
						<xsl:copy>
							<xsl:apply-templates select="@*"/>

							<xsl:for-each select="node()">
								<xsl:choose>
									<xsl:when test="self::br">
									</xsl:when>
								
									<xsl:otherwise>
										<xsl:copy>
											<xsl:apply-templates select="@* | node()"/>
										</xsl:copy>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="child::br">
				<xsl:for-each select="node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<p>
								<xsl:apply-templates select="$class" />
								<xsl:value-of select="."/>
							</p>
						</xsl:when>
						
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*, node()" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="grouping">
		<xsl:param name="group" />
		<xsl:param name="idx" />
		<xsl:param name="firstTD" />
		
		<xsl:choose>
			<xsl:when test="$idx &gt;= 1">
				<xsl:for-each select="$group[1]">
					<xsl:copy>
						<xsl:apply-templates select="@*" />
						<xsl:for-each select="$firstTD">
							<xsl:copy>
								<xsl:attribute name="remover" select="'yes'" />
								<xsl:apply-templates select="@*, node()" />
							</xsl:copy>
						</xsl:for-each>
						<xsl:apply-templates select="node()" />
					</xsl:copy>
				</xsl:for-each>
				
				<xsl:call-template name="grouping">
					<xsl:with-param name="group" select="$group[position() &gt; 1]" />
					<xsl:with-param name="idx" select="$idx - 1" />
					<xsl:with-param name="firstTD" select="$firstTD" />
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:apply-templates select="$group" />
			</xsl:otherwise>
		</xsl:choose>
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