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
	
	<xsl:template match="bandmode">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="lang" select="$lang" />
					
					<xsl:attribute name="apply">
						<xsl:choose>
						    <xsl:when test="matches($lang, '^(Kaz|Mon|Uzb|Heb|Ara|Urd|Spa\(LTN\)|Aze|Geo|Ben|Ind|Khm|Lao|Mya|Chi\(Singapore\)|Tha|Eng\(India\)|Rus|Rum|Ukr|Fre|Vie|HongKong|Arm)$')">
								<xsl:value-of select="'false'" />
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:value-of select="'true'" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:attribute name="exc">
						<xsl:choose>
							<xsl:when test="matches($lang, '^Fre$')">
								<xsl:value-of select="'MEA'" />
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:value-of select="''" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:for-each select="item">
						<xsl:variable name="curItem" select="." />
						<xsl:variable name="fileName" select="@fileName" />
						
						
						<xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
						<xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
						
						<xsl:variable name="flwUnit" select="following-sibling::*[1]" />
						
						<xsl:variable name="sID">
							<xsl:choose>
								<xsl:when test="$rowNum = '8'">
									<xsl:value-of select="'wcdma900/wcdma2100'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '10'">
									<xsl:value-of select="'lte'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '16'">
									<xsl:value-of select="'wifi5_1_5_7ghz'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '20'">
									<xsl:value-of select="'wifi5_9_6_4ghz'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '22'">
									<xsl:value-of select="'nfc1'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '24'">
								    <xsl:variable name="str" select="$engCollection/bandmode/items/item[tokenize(@class, ':')[1] = '24']" />
									<xsl:value-of select="lower-case(replace($str, '\s+', ''))" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '26'">
									<xsl:value-of select="'uwb6-8_5ghz'" />
								</xsl:when>
								
								<xsl:when test="$rowNum = '32'">
									<xsl:value-of select="'mst3_6khz'" />
								</xsl:when>
								
								<xsl:otherwise>
								    <xsl:variable name="str" select="$engCollection/bandmode/items/item[tokenize(@class, ':')[1] = $rowNum]" />
								    <xsl:variable name="str0" select="lower-case(replace(replace(replace(replace(replace($str, '\s+', ''), '/', ''),
																		'\.', '_'),
																		'-', ''),
																		',', '_'))" />
									<xsl:value-of select="$str0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="sUnit">
							<xsl:choose>
								<xsl:when test="$flwUnit = ''">
									<xsl:value-of select="''" />
								</xsl:when>
							    
							    <xsl:when test="matches($rowNum, '^(4|6|8|10|12|14|16|18|20|26|30|32)$')">
							        <xsl:variable name="sunit" select="tokenize($flwUnit, ' ')[2]" />
							        <xsl:value-of select="$sunit" />
							    </xsl:when>
							    
								<xsl:when test="matches($rowNum, '^(22|24)$')">
									<xsl:value-of select="'dBμA/m'" />
								</xsl:when>
								
								<!--<xsl:otherwise>
									<xsl:variable name="sunit" select="tokenize($flwUnit, ' ')[2]" />
									<xsl:value-of select="$sunit" />
								</xsl:otherwise>-->
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="sMulti">
							<xsl:choose>
								<xsl:when test="matches($rowNum, '^(8|10)$')">
									<xsl:choose>
										<xsl:when test="matches($lang, '^Ukr$')">
											<xsl:value-of select="'false'" />
										</xsl:when>
										
										<xsl:otherwise>
											<xsl:value-of select="'true'" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								
								<xsl:when test="matches($rowNum, '^(16|20|22|24|26|32)$')">
									<xsl:value-of select="'false'" />
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:value-of select="'false'" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:choose>
							<xsl:when test="$lang = 'Ukr' and 
							                $curItem = 'WCDMA Band VIII/Band I'">
							    <xsl:if test="not(matches($rowNum, '^(5|7|9|11|13|15|17|19|21|23|25|27|28|29|31|33)$'))">
    								<xsl:copy>
    								    <xsl:apply-templates select="@* except (@value, @lgn)" />
    									<xsl:attribute name="id" select="'wcdma900'" />
    									
    								    <xsl:if test="matches($rowNum, '^(4|6|8|10|12|14|16|18|20|22|24)$')">
    								        <xsl:attribute name="unit" select="$sUnit" />
    								    </xsl:if>
    									<xsl:attribute name="multi" select="$sMulti" />
    									
    								    <xsl:value-of select="'WCDMA Band VIII'" />
    								</xsl:copy>
    								
    								<xsl:copy>
    								    <xsl:apply-templates select="@* except (@value, @lgn)" />
    									<xsl:attribute name="id" select="'wcdma2100'" />
    									
    								    <xsl:if test="matches($rowNum, '^(4|6|8|10|12|14|16|18|20|22|24)$')">
    								        <xsl:attribute name="unit" select="$sUnit" />
    								    </xsl:if>
    									<xsl:attribute name="multi" select="$sMulti" />
    									
    								    <xsl:value-of select="'WCDMA Band I'" />
    								</xsl:copy>
							    </xsl:if>
							</xsl:when>
							
							<xsl:otherwise>
							    <xsl:if test="not(matches($rowNum, '^(5|7|9|11|13|15|17|19|21|23|25|27|28|29|31|33)$'))">
     							    <xsl:copy>
     								    <xsl:apply-templates select="@* except (@value, @lgn)" />
     									<xsl:attribute name="id" select="$sID" />
     								    
     								    <xsl:if test="matches($rowNum, '^(4|6|8|10|12|14|16|18|20|22|24|26|30|32)$')">
     								        <xsl:attribute name="unit" select="$sUnit" />
     								    </xsl:if>
     									<xsl:attribute name="multi" select="$sMulti" />
     									
     									<xsl:apply-templates select="node()" />
     								</xsl:copy>
							    </xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
    
    <xsl:template match="@lgn|*[not(ancestor::*[matches(local-name(), '^(chargingsupport|safetyinfo|pobox|wlan|eDoc)$')])]/@value">
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