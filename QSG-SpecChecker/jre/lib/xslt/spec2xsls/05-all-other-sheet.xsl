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

	<xsl:template match="fingerprint">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="apply" select="'true'" />
					<xsl:attribute name="exc" select="''" />
					
					
					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:variable name="sID">
					       <xsl:choose>
					           <xsl:when test="$rowNum = '2'">
					               <xsl:value-of select="'optical'" />
					           </xsl:when>
					           
					           <xsl:when test="$rowNum = '3'">
					               <xsl:value-of select="'ultrawave'" />
					           </xsl:when>
					       </xsl:choose>
					    </xsl:variable>
					    
					    <xsl:if test="matches($rowNum, '^(2|3)$')">
					        <xsl:copy>
					            <xsl:apply-templates select="@*" />
					            <xsl:attribute name="id" select="$sID" />
					            <xsl:apply-templates select="node()" />
					        </xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="eDoc">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="lang" select="$lang" />
					<xsl:attribute name="apply" select="'true'" />
					<xsl:attribute name="exc" select="''" />
					
					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:variable name="sID">
					       <xsl:value-of select="lower-case(replace(@value, '&#x20;', ''))" />
					    </xsl:variable>
					    
					    <xsl:if test="matches($rowNum, '^(2|3|4|5)$')">
					        <xsl:copy>
					            <xsl:apply-templates select="@*" />
					            <xsl:attribute name="id" select="$sID" />
					            <xsl:apply-templates select="node()" />
					        </xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="indiabis">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="lang" select="$lang" />
					<xsl:attribute name="apply" select="'true'" />
					<xsl:attribute name="exc" select="''" />
					
					<xsl:for-each select="item">
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="id" select="'bis'" />
						    
						    <xsl:apply-templates select="node()" />
						</xsl:copy>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="opensources">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />

				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="lang" select="$lang" />
					<xsl:attribute name="apply" select="'true'" />
					<xsl:attribute name="exc" select="''" />
					
					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:if test="matches($rowNum, '^(2)$')">
							<xsl:copy>
								<xsl:apply-templates select="@*" />
								<xsl:attribute name="id" select="'opensource'" />
								
								<xsl:apply-templates select="node()" />
							</xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="greenissue">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:attribute name="apply" select="'true'" />
					<xsl:attribute name="exc" select="''" />
					
					<xsl:for-each select="item">
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<xsl:attribute name="id" select="'greenissue'" />
						    
						    <xsl:apply-templates select="node()" />
						</xsl:copy>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="chargingsupport">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />

					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:variable name="sID">
						   <xsl:value-of select="lower-case(replace(@value, '&#x20;', ''))" />
					    </xsl:variable>
					    
					    <xsl:if test="matches($rowNum, '^(2|3|4|5)$')">
					        <xsl:copy>
					            <xsl:apply-templates select="@* except @value" />
					            <xsl:attribute name="id" select="$sID" />
					            <xsl:apply-templates select="node()" />
					        </xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="pobox">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					
					<xsl:for-each select="item">
						<xsl:copy>
							<xsl:apply-templates select="@*" />
							<!--<xsl:attribute name="id" select="'pobox'" />-->
						    <xsl:attribute name="id" select="lower-case(@value)" />
						    
						    <xsl:apply-templates select="node()" />
						</xsl:copy>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="safetyinfo">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />

					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:variable name="sID">
					       <xsl:value-of select="lower-case(replace(@value, '&#x20;', ''))" />
					    </xsl:variable>
					    
					    <xsl:if test="matches($rowNum, '^(2|3)$')">
					        <xsl:copy>
					            <xsl:apply-templates select="@*" />
					            <xsl:attribute name="id" select="$sID" />
					            <xsl:apply-templates select="node()" />
					        </xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="wlan">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each select="items">
				<xsl:variable name="cur" select="." />
				<xsl:variable name="fileName" select="@fileName" />
				<xsl:variable name="lang" select="@lang" />
				
				<xsl:copy>
					<xsl:apply-templates select="@*" />

					<xsl:for-each select="item">
					    <xsl:variable name="rowNum" select="tokenize(@class, ':')[1]" />
					    <xsl:variable name="colNum" select="tokenize(@class, ':')[2]" />
					    
					    <xsl:variable name="sID">
					       <xsl:value-of select="lower-case(replace(@value, '&#x20;', ''))" />
					    </xsl:variable>
					    
					    <xsl:if test="matches($rowNum, '^(2|3|4)$')">
					        <xsl:copy>
					            <xsl:apply-templates select="@*" />
					            <xsl:attribute name="id" select="$sID" />
					            <xsl:apply-templates select="node()" />
					        </xsl:copy>
					    </xsl:if>
					</xsl:for-each>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@value">
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