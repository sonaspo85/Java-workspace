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

    <xsl:variable name="engCollection">
        <xsl:for-each select="root/*">
            <xsl:variable name="name" select="name()" />
            <xsl:copy>
                <xsl:apply-templates select="@*" />
                
                <xsl:for-each select="items[@lang='Eng']">
                    <xsl:copy>
                        <xsl:apply-templates select="@*, node()" />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

	<xsl:template match="etc">
		<xsl:for-each select="items">
			<xsl:variable name="fileName" select="@fileName" />
			<xsl:variable name="lang" select="@lang" />
			
			<xsl:choose>
				<xsl:when test="self::items[@lang = 'Tur']">
					<productSpec>
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="apply" select="'true'" />
							<xsl:attribute name="exc" select="''" />
							
							<xsl:for-each select="item">
								<xsl:variable name="rowNum" select="number(tokenize(@class, ':')[1])" />
								<xsl:variable name="colNum" select="number(tokenize(@class, ':')[2])" />
								
								<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
								
								<xsl:variable name="sID">
									<xsl:variable name="str" select="$engCollection/etc/items/item[number(tokenize(@class, ':')[1]) = $rowNum]" />
									<xsl:variable name="str0" select="lower-case(replace($str, '\s+', ''))" />
									
									<xsl:value-of select="$str0" />
								</xsl:variable>
								
								<xsl:if test="$rowNum &gt; 1 and $rowNum &lt; 20">
									<xsl:copy>
										<xsl:apply-templates select="@*" />
										<xsl:attribute name="id" select="$sID" />
										
										<xsl:apply-templates select="node()" />
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</productSpec>

					<turgaranty>
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="lang" select="$lang" />
							<xsl:attribute name="apply" select="'true'" />
							<xsl:attribute name="exc" select="''" />
							
							<xsl:for-each select="item">
								<xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
								<xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
								
								<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
								
								<xsl:if test="matches($rowNum, '^20$')">
									<xsl:copy>
										<xsl:apply-templates select="@*" />
										<xsl:attribute name="id" select="'garanty'" />
										<xsl:apply-templates select="node()" />
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</turgaranty>

					<turwifi5>
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="lang" select="$lang" />
							<xsl:attribute name="apply" select="'true'" />
							<xsl:attribute name="exc" select="''" />
							
							<xsl:for-each select="item">
								<xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
								<xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
								
								<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
								
								<xsl:if test="matches($rowNum, '^21$')">
									<xsl:copy>
										<xsl:apply-templates select="@*" />
										<xsl:attribute name="id" select="'turwifi5'" />
										<xsl:apply-templates select="node()" />
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</turwifi5>
				</xsl:when>
				
				<xsl:when test="self::items[@lang = 'Spa(LTN)']">
					<electronic>
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="lang" select="$lang" />
							<xsl:attribute name="apply" select="'true'" />
							<xsl:attribute name="exc" select="''" />
							
							<xsl:for-each select="item">
								<xsl:variable name="curItem" select="." />
								<xsl:variable name="rowNum" select="number(tokenize(@class, ':')[1])"  />
								<xsl:variable name="colNum" select="number(tokenize(@class, ':')[2])" />
								
								<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
								
								<xsl:if test="$rowNum >= 13 and $rowNum &lt; 19">
									<xsl:choose>
										<xsl:when test="$rowNum eq 13">
											<xsl:copy>
												<xsl:attribute name="id" select="'electronicspec'" />
												<xsl:apply-templates select="@*, node()" />
											</xsl:copy>
										</xsl:when>
										
										<xsl:when test="$rowNum eq 14">
											<xsl:copy>
												<xsl:attribute name="id" select="'adapter'" />
												<xsl:attribute name="name" select="$curItem" />
												
												<xsl:for-each select="$curItem/following-sibling::*[number(tokenize(@class, ':')[1]) eq 15]">
													<entries id="entry">
														<xsl:attribute name="name" select="." />
														
														<entry id="entry1" unit="Vca"/>
														<entry id="entry2" unit="Hz"/>
														<entry id="entry3" unit="A"/>
													</entries>
												</xsl:for-each>
												
												<xsl:for-each select="$curItem/following-sibling::*[number(tokenize(@class, ':')[1]) eq 16]">
													<entries id="departure">
														<xsl:attribute name="name" select="." />
														
														<entry id="departure1" unit="Vcc;A;o"/>
														<entry id="departure2" unit="Vcc;A"/>
													</entries>
												</xsl:for-each>
											</xsl:copy>
										</xsl:when>
										
										<xsl:when test="$rowNum eq 17">
											<xsl:copy>
												<xsl:attribute name="id" select="'device'" />
												<xsl:attribute name="name" select="." />
												
												<xsl:for-each select="$curItem/following-sibling::*[number(tokenize(@class, ':')[1]) eq 18]">
													<entries id="entry">
														<xsl:attribute name="name" select="." />
														
														<entry id="entry1" unit="Vcc;A"/>
													</entries>
												</xsl:for-each>
											</xsl:copy>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</electronic>
				</xsl:when>
				
				<xsl:when test="self::items[@lang = 'Ind']">
					<registration>
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="lang" select="$lang" />
							<xsl:attribute name="apply" select="'true'" />
							<xsl:attribute name="exc" select="''" />
							
							<xsl:for-each select="item">
								<xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
								<xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
								
								<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
								
								<xsl:if test="matches($rowNum, '^19$')">
									<xsl:copy>
										<xsl:apply-templates select="@*" />
										<xsl:attribute name="id" select="'regNum'" />
										
										<xsl:apply-templates select="node()" />
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
							
							
						</xsl:copy>
					</registration>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
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