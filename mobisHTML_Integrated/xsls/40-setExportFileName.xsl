<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ast="http://www.astkorea.net/"
    exclude-result-prefixes="xs ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl"/>
    <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="h0 h1 h2 h3 h4 li p" />

    <xsl:key name="htmls" match="topic[@file]" use="@file"/>
    

    <xsl:variable name="filenames" as="xs:string*">
        <xsl:for-each select="root()/topic/topic[@idml]//topic[@file]/@file">
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:variable name="str0">
            <xsl:apply-templates mode="abc" />
        </xsl:variable>
        
        <xsl:apply-templates select="$str0/*" />
    </xsl:template>
    
    <xsl:template match="@*[matches(name(), '^(idml|file|href|data-prev|data-next)$')]">
        <xsl:choose>
            <xsl:when test="$commonRef/version/@value = '6th'">
                <xsl:variable name="str0">
                    <xsl:choose>
                        <xsl:when test="name()='href' and 
                                        matches(., '^(https?)')">
                            <xsl:value-of select="." />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--<xsl:value-of select="lower-case(replace(., '(0\d+_)(.*)', '$2'))" />-->
                            <!--<xsl:value-of select="replace(., '(0\d+_)(.*)', '$2')" />-->
                            
                            <xsl:choose>
                                <xsl:when test="matches(., '(0\d+\.\d+_)(.*)')">
                                    <xsl:value-of select="replace(., '(0\d+\.\d+_)(.*)', '$2')" />
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:value-of select="replace(., '(0\d+_)(.*)', '$2')" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <!--<xsl:attribute name="{name()}" select="replace(., '(0\d+_)(.*)', '$2')" />-->
                <xsl:attribute name="{name()}" select="$str0" />
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:attribute name="{name()}" select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="abc">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topic[@idml][not(@file)]" mode="abc">
        <xsl:copy>
            <xsl:attribute name="idx" select="tokenize(@idml, '_')[1]" />
            <xsl:apply-templates select="@*, node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topic[@file]" mode="abc">
        <xsl:variable name="getPreFileVal">
            <xsl:call-template name="setPreFileVal">
                <xsl:with-param name="cur" select="." />
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="getNextFileVal">
            <xsl:call-template name="setNextFileVal">
                <xsl:with-param name="cur" select="." />
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:if test="$getPreFileVal != '#'">
                <xsl:attribute name="data-prev">
                    <xsl:value-of select="$getPreFileVal"/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:if test="$getNextFileVal != '#'">
                <xsl:attribute name="data-next">
                    <xsl:value-of select="$getNextFileVal"/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:attribute name="file" select="@file" />
            
            <xsl:apply-templates select="node()" mode="abc" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="setNextFileVal">
        <xsl:param name="cur" />
        
        <xsl:variable name="filename" select="@file"/>
        <xsl:variable name="next" select="key('htmls', $filenames[index-of($filenames, $filename) + 1])"/>
        <xsl:variable name="nextFname" select="$next/@file"/>
        <xsl:variable name="nextLastSCID" select="tokenize(replace($nextFname, '.html', ''), '_')[last()]" />
        <xsl:variable name="nextHeadingNode" select="$next/div[1]/*[matches(name(), 'h(1|2)')]"/>
        <xsl:variable name="nextHeadingNodeID" select="$nextHeadingNode[1]/@id"/>
        
        <xsl:variable name="getNextFileVal">
            <xsl:value-of select="if ($nextLastSCID = $nextHeadingNodeID) then 
                                  $nextFname else 
                                  concat($nextFname, '#', $nextHeadingNodeID)"/>
        </xsl:variable>
        
        <xsl:variable name="finalNextVal">
            <xsl:choose>
                <xsl:when test="not(following-sibling::topic) and 
                                ancestor::topic[@idml]
                                /following-sibling::topic[@idml][1]
                                /descendant::*[matches(@class, '-sublink')]">
                    <xsl:variable name="flw" select="ancestor::topic[@idml]/following-sibling::topic[@idml][1]/topic[1]/topic[1]/@idml" />
                    
                    <xsl:value-of select="concat($flw, '.html')" />
                </xsl:when>
                
                <xsl:when test="$commonRef/version/@value = '6th' and 
                                not(following-sibling::topic) and 
                                ancestor::topic[@idml]/following-sibling::*[@idml][1][matches(@idml, '(Systemoverview)')]">
                    <xsl:value-of select="$getNextFileVal" />
                </xsl:when>
                
                <xsl:when test="not(following-sibling::topic) and 
                                count(ancestor::topic[@idml]
                                /following-sibling::topic[@idml][1]
                                /topic[1]/topic) &gt; 1">
                    <xsl:value-of select="concat(ancestor::topic[@idml]/following-sibling::topic[@idml][1]/@idml, '.html')"/>
                </xsl:when>
                
                <xsl:when test="not(following-sibling::topic) and 
                                not(ancestor::topic[@idml]/following-sibling::topic[@idml])">
                    <xsl:value-of select="'#'" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="$getNextFileVal" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--<xsl:value-of select="replace($finalNextVal, '(0\d+_)(.*)', '$2')" />-->
        <xsl:value-of select="$finalNextVal" />
    </xsl:template>
    
    <xsl:template name="setPreFileVal">
        <xsl:param name="cur" />
        
        <xsl:variable name="filename" select="@file"/>
        <xsl:variable name="pre" select="key('htmls', $filenames[index-of($filenames, $filename) - 1])"/>
        <xsl:variable name="preFName" select="$pre/@file"/>
        <xsl:variable name="preLastSCID" select="tokenize(replace($preFName, '.html', ''), '_')[last()]" />
        <xsl:variable name="preHeadingNode" select="$pre/div[last()]/*[matches(name(), 'h(1|2)')]"/>
        <xsl:variable name="preHeadingNodeID" select="if ($pre/div[last()][h1][h2]) then 
                                                      $preHeadingNode[1]/@id else 
                                                      $preHeadingNode[last()]/@id"/>
        
        <xsl:variable name="getPreFileVal">
            <xsl:choose>
                <xsl:when test="$commonRef/version/@value = '6th'">
                    <xsl:value-of select="if ($preLastSCID = $preHeadingNodeID) then 
                                          $preFName else 
                                          concat($preFName, '#', $preHeadingNodeID)"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="if ($preLastSCID = $preHeadingNodeID) then 
                                          $preFName else 
                                          concat($preFName, '#', $preHeadingNodeID)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="finalPreVal">
            <xsl:choose>
                <!-- 첫번째 챕터의 첫번째 topic일 경우 -->
                <xsl:when test="(index-of($filenames, $filename) - 1) = 0">
                    <xsl:choose>
                        <xsl:when test="matches(ancestor::topic[@idml]/@idml, '(Video|Content)')">
                            <xsl:value-of select="'#'" />
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="concat(ancestor::topic[@idml]/@idml, '.html')" />
                        </xsl:otherwise>
                    </xsl:choose> 
                </xsl:when>

                <!-- 자신이 topic 의 첫번째 위치이고, 자손들 중에 -sublink 있는 경우 minitoc인 목차 html 페이지로 연결 시키기 -->
                <!-- 무저건 concat(ancestor::topic[@idml]/@idml, '.html') 로 변경 하면 안됨 -->
                <!-- 46번 minitoc 생성될 챕터(Systemoverview|Appendix) 만 해야됨 -->
                <xsl:when test="$commonRef/version/@value = '6th' and 
                                not(preceding-sibling::topic) and 
                                following-sibling::topic/descendant::*[matches(@class, '-sublink')]">
                    <xsl:choose>
                        <xsl:when test="matches(ancestor::topic[@idml]/@idml, '(Systemoverview|Appendix)')">
                            <xsl:value-of select="concat(ancestor::topic[@idml]/@idml, '.html')"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="$getPreFileVal" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:when test="$commonRef/version/@value = '6th' and 
                                not(preceding-sibling::topic) and 
                                ancestor::topic[@idml]/preceding-sibling::*[@idml][1][matches(@idml, '(Video|Content)')]">
                    <xsl:value-of select="$getPreFileVal" />
                </xsl:when>
                
                <xsl:when test="not(preceding-sibling::topic) and
                                following-sibling::topic/descendant::*[matches(@class, '-sublink')]">
                    <xsl:value-of select="$getPreFileVal" />
                </xsl:when>
                
                <xsl:when test="not(preceding-sibling::topic) and 
                                count(parent::*/topic) &gt; 1">
                    <xsl:value-of select="concat(ancestor::topic[@idml]/@idml, '.html')"/>
                </xsl:when>
                
                <!--<xsl:when test="not(ancestor::topic[@idml]/preceding-sibling::topic) and 
                                not(preceding-sibling::topic)">
                    <xsl:value-of select="concat(ancestor::topic[@idml], '.html')" />
                </xsl:when>-->
                
                <xsl:otherwise>
                    <xsl:value-of select="$getPreFileVal" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--<xsl:value-of select="replace($finalPreVal, '(0\d+_)(.*)', '$2')" />-->
        <xsl:value-of select="$finalPreVal" />
    </xsl:template>

</xsl:stylesheet>