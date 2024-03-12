<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    xmlns:ast="http://www.astkorea.net/" 
    exclude-result-prefixes="xs idPkg ast" 
    version="2.0">
    
    <xsl:import href="00-commonVar.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="no" />
    <xsl:strip-space elements="*"/>


    <xsl:variable name="isocode" select="root()/root/@isocode" />

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*, node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="section[parent::root]">
        <xsl:choose>
            <xsl:when test="not(following-sibling::section)">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>

                <xsl:if test="matches($videoswitch, '^on$')">
                    <xsl:call-template name="videoLink" />
                </xsl:if>
            </xsl:when>
        
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*, node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="videoLink">
        <xsl:variable name="vcTxt" select="$videolinkPath03/videoKey/listitem[@key = 'Video_C']/*[local-name() = upper-case($isocode)]" />
        <xsl:variable name="vhTxt" select="$videolinkPath03/videoKey/listitem[@key = 'Video_H1']/*[local-name() = upper-case($isocode)]" />
        
        <xsl:variable name="getLinkNode">
            <xsl:for-each select="$videolinkPath03/listitem[@type=$type]/div">
                <xsl:variable name="video_key" select="@key" />
                <xsl:variable name="video_href" select="@href" />
                
                <xsl:for-each select="*[local-name()=upper-case($isocode)]">
                    <p id="{$video_key}">
                        <span class="see-page">
                            <a href="{$video_href}" target="_blank">
                                <xsl:value-of select="concat('• ', .)" />
                            </a>
                        </span>
                    </p>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="fileNum" select="xs:integer(replace(@file, '(content)(\d)(.html)', '$2'))" />

        <section file="{concat('content', $fileNum + 1, '.html')}">
            <h1 class="chapter" id="Video_C">
                <img src="./img/title_icon.png" alt="" />
                <xsl:value-of select="$vcTxt" />
            </h1>

            <div class="Heading1">
                <h2 class="heading1 shap-target remove-space" ast-id="video_H1">
                    <xsl:value-of select="$vhTxt" />
                </h2>

                <div class="unorderList_1" id="video_list">
                    <p id="video_list-1">
                        <xsl:copy-of select="$getLinkNode" />
                    </p>
                </div>
            </div>
        </section>
    </xsl:template>

</xsl:stylesheet>
