<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version="2.0">

    <xsl:template name="fontSize">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="locale" />
        <xsl:param name="localeStrAfter" />
        <xsl:param name="cnt" required="no" />


        <xsl:if test="matches($cur, 'Frontmatter-')">
            <xsl:if test="matches($cur, 'Frontmatter-Url')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-info')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Frontmatter', ' Info',  ' Size')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-model')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-title')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-petName')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'TR')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <!-- <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise> -->
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($cur, 'TOC-')">
            <xsl:if test="matches($cur, 'TOC-header')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' header',  ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' header',  ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'TOC-depth')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC depth Size ', $cnt)" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC depth Size ', $cnt)" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC depth Size ', $cnt)" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC depth Size ', $cnt)" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/p ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'Heading3')]">
                    <xsl:choose>
                        <xsl:when test="parent::*[matches(@outputclass, 'roundbox')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=Heading3)', ' topic/p', ' roundbox', ' Size')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:when test="ancestor::*[contains(@class, 'topic/table ')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=Heading3)', ' topic/p-table', ' Size')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=Heading3)', ' topic/p', ' Size')" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'footnote')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=footnote)', ' topic/p', ' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/ph ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'small')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=intuitive)', ' topic/ph', ' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/title ')">
            <xsl:variable name="Number" select="$cnt - 1" />

            <xsl:if test="$cnt = 1">
                <xsl:choose>
                    <xsl:when test="matches($OSname, '-OS_upgrade')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Chapter Upgrade Size ', $cnt)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Chapter Normal Size ', $cnt)" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$cnt = 2">
                <xsl:choose>
                    <xsl:when test="$cur[matches(@outputclass, 'Heading1\-H3')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, '-H3', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, ' Size')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$cnt = 3">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3\-TroubleShooting')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $cnt, '-TroubleShooting', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading2')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading3-APPLINK')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $cnt, '-APPLINK', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $cnt, ' Size')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>inherit</xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$cnt = 4">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3-APPLINK')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, '-APPLINK', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $cnt, '-TroubleShooting', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading4')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $cnt, ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>inherit</xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$cnt = 5">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3-APPLINK')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', '3', '-APPLINK', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', '3', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading4\-TroubleShooting')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, '-TroubleShooting', ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading4')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', $Number, ' Size')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>inherit</xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/tm ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@tmtype, 'tm')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=tm)', ' topic/tm',' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@tmtype, 'reg')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=reg)', ' topic/tm',' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'task/step ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(., 'step-Number')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('step-Number)', ' task/step', ' Size')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="fontFamily">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="locale" />
        <xsl:param name="localeStrAfter" />
        <xsl:param name="cnt" required="no" />

        <xsl:if test="matches($cur, 'Frontmatter-')">
            <xsl:if test="matches($cur, 'Frontmatter-Url')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-info')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Frontmatter', ' Info',  ' FontFamily')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-model')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-title')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-petName')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'TR')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($cur, 'TOC-')">
            <xsl:if test="matches($cur, 'TOC-header')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'TOC-depth')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/title ')">
            <xsl:variable name="Number" select="$cnt - 1" />

            <xsl:if test="$cnt = 1">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Chapter FontFamily ', $cnt)" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$cnt = 2">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading1')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading1', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="matches(@outputclass, 'Heading2')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading2', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', ' Common', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$cnt = 3">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading2')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading2', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:choose>
                            <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading3-TroubleShooting', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading3', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', ' Common', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$cnt = 4">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading3', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="matches(@outputclass, 'Heading4')">
                        <xsl:choose>
                            <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading4-TroubleShooting', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading4', ' FontFamily')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', ' Common', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$cnt = 5">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading3', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches(@outputclass, 'Heading4')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading4', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading', ' Common', ' FontFamily')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/p ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'Heading3')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Heading3', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                $cur/ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('OS_Upgrade)', ' topic/p', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'hi-d/b ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, '^semi$')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=semi)', ' hi-d/b', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, '^preserve$')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=preserve)', ' hi-d/b', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('default)', ' hi-d/b', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/ph ') and
                      not(matches($class, 'hi-d/b '))">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, '^small$')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, '^preserve$')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=preserve)', ' topic/ph', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'arial')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=arial)', ' topic/ph', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=intuitive)', ' topic/ph', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[parent::*[matches(@class, 'topic/title ')]]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:when test="$cur[parent::*[matches(@outputclass, 'Heading3')]]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="$base-font-family" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'task/step ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(., 'step-Number')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('step-Number)', ' task/step', ' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/li ') and
                      not(matches($class, 'task/step '))">
            <xsl:choose>
                <xsl:when test="matches($cur, 'li-Bullet')">
                    <xsl:choose>
                        <xsl:when test="matches($localeStrAfter, 'CN')">
                            <xsl:value-of select="'FZZhongDengXian-Z07S'" />
                        </xsl:when>

                        <xsl:when test="matches($localeStrAfter, 'TR')">
                            <xsl:value-of select="'SamsungOne-400'" />
                            <!-- <xsl:choose>
                                <xsl:when test="$parTag[matches(@outputclass, 'star')]">
                                    <xsl:value-of select="'Segoe UI'" />

                                </xsl:when>

                                <xsl:otherwise>SamsungOne-400</xsl:otherwise>
                            </xsl:choose> -->
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('li-Bullet)', ' topic/li', ' FontFamily')" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'sw-d/cmdname ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('default)', ' cmdname', ' FontFamily')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/tm ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@tmtype, 'tm')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=tm)', ' topic/tm',' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@tmtype, 'reg')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=reg)', ' topic/tm',' FontFamily')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="fontColor">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="template" />
        <xsl:param name="cnt" required="no" />
        <xsl:param name="localeStrAfter" required="no" />


        <xsl:if test="matches($cur, 'Frontmatter-')">
            <xsl:if test="matches($cur, 'Frontmatter-Url')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-model')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,70%)'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(0%,0%,0%,70%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-title')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,0%)'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(0%,0%,0%,0%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-petName')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'TR')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,0%)'" />
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($cur, 'TOC-')">
            <xsl:if test="matches($cur, 'TOC-header')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'TOC-depth')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="'inherit'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="'inherit'" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/p ')">
            <xsl:choose>
                <xsl:when test="matches($OSname, '-OS_upgrade') and
                                $cur/ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                </xsl:when>
                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/title ')">
            <xsl:if test="$cnt = 2">
                <xsl:choose>
                    <xsl:when test="matches($template, '-OS_upgrade') and
                                    $cur/ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                        <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />

                    </xsl:when>
                    <xsl:when test="$cur[matches(@outputclass, 'Heading1\-H3')]">
                        <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'cmyk(65%,30%,0%,0%)'" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'sw-d/cmdname ')">
            <xsl:choose>
                <xsl:when test="matches($template, '-OS_upgrade') and
                                $cur/ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                </xsl:when>
                <xsl:when test="parent::*[contains(@class, 'topic/title ')]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'task/step ')">
            <xsl:choose>
                <xsl:when test="matches($template, '-OS_upgrade') and
                                $cur/ancestor::*[matches(@class, ' topic/topic ')][1][@oid = 'introduction'][@otherprops='introduction']">
                    <xsl:value-of select="'cmyk(0%,0%,0%,80%)'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/xref ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'C_URL-Copyright')]">
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'cmyk(90%,60%,0%,0%)'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/ph ') and
                      not(matches($class, 'hi-d/b '))">
             <xsl:choose>
                 <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                    <xsl:value-of select="'cmyk(0%,0%,0%,100%)'" />
                </xsl:when>

                 <xsl:otherwise>
                     <xsl:value-of select="'inherit'" />
                 </xsl:otherwise>
             </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="lineHeight">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="locale" />
        <xsl:param name="localeStrAfter" />
        <xsl:param name="cnt" required="no" />
        <xsl:param name="nodeCnt" required="no" />


        <xsl:if test="matches($cur, 'Frontmatter-')">
            <xsl:if test="matches($cur, 'Frontmatter-title')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-model')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-Url')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-petName')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'TR')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($cur, 'TOC-')">
            <xsl:if test="matches($cur, 'TOC-header')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'TOC-depth')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' LineHeight')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' LineHeight')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$cnt = 1">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' LineHeight')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' LineHeight')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/title ')">
            <xsl:if test="matches(@outputclass, '^Chapter')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Chapter', ' LineHeight')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading1')">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading1-H3', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading1', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading2')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Heading2', ' LineHeight')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading3')">

                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading3-TroubleShooting', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading3', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading4')">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading4-TroubleShooting', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading4', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/p ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'Heading3')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Heading3', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'footnote')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=footnote)', ' topic/p', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur/parent::*[name()='li']">
                    <xsl:value-of select="'16pt'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'hi-d/b ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'sw-d/cmdname ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('sw-d/cmdname', ' LineHeight')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/li ') and
                      not(matches($class, 'task/step '))">
            <xsl:variable name="parUl" select="$cur/parent::*[contains(@class, ' topic/ul ')]" />
            <xsl:variable name="parUl.parNote" select="$parUl/parent::*[contains(@class, ' topic/note ')]" />
            <xsl:variable name="ancesTable" select="$cur/ancestor::*[contains(@class, ' topic/table ')]" />
            <xsl:variable name="depth" select="count($cur/ancestor-or-self::*[contains(@class, ' topic/ul ')]) +
                                               count($cur/ancestor-or-self::*[contains(@class, ' task/steps ')][count(*) &gt; 1])"/>

            <xsl:choose>
                <xsl:when test="$cur/*[matches(@class, '(hi-d/b |sw-d/cmdname )')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur/*[contains(@class, 'topic/tm ')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur/*[@placement='inline']">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$ancesTable[matches(@outputclass, 'table_appendix-standard')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('parTag=table_appendix-standard)', ' topic/li', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'task/step ')">
            <xsl:if test="$nodeCnt = 'multi'">
                <xsl:choose>
                    <xsl:when test="$cur/*[1]/*[matches(@class, 'topic/xref ')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$cur/*[1][not(*)]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$cur/*[1]/*[matches(@class, '(hi-d/b |sw-d/cmdname )')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$nodeCnt = 'onestep'">
                <xsl:choose>
                    <xsl:when test="$cur/*[1]/*[matches(@class, 'topic/xref ')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$cur/*[1][not(*)]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$cur/*[1]/*[matches(@class, 'topic/image ')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$cur/*[1]/*[matches(@class, '(hi-d/b |sw-d/cmdname )')]">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/ph ') and
                      not(matches($class, 'hi-d/b '))">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'small')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=intuitive)', ' topic/ph', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[parent::*[matches(@class, 'topic/title ')]]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/tm ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@tmtype, 'tm')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=tm)', ' topic/tm', ' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@tmtype, 'reg')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=reg)', ' topic/tm',' LineHeight')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="fontStretch">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="locale" />
        <xsl:param name="localeStrAfter" />
        <xsl:param name="nodeCnt" required="no" />

        <xsl:if test="matches($cur, 'Frontmatter-')">
            <xsl:if test="matches($cur, 'Frontmatter-Url')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-info')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Frontmatter', ' Info',  ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-model')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-title')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'Frontmatter-petName')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'TR')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($cur, 'TOC-')">
            <xsl:if test="matches($cur, 'TOC-header')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches($cur, 'TOC-depth')">
                <xsl:choose>
                    <xsl:when test="matches($localeStrAfter, 'GB')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Default', ' Common', ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/title ')">
            <xsl:if test="matches(@outputclass, '^Chapter')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Chapter', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading1')">
                <xsl:choose>
                    <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading1', ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading1', ' FontStretch')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading2')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Heading2', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading3')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Heading3', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="matches(@outputclass, 'Heading4')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('Heading4', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/p ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('Default', ' Common', ' FontStretch')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'hi-d/b ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('Default', ' Common', ' FontStretch')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'sw-d/cmdname ')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('sw-d/cmdname', ' FontStretch')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/li ') and
                      not(matches($class, 'task/step '))">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat('topic/li', ' FontStretch')" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="matches($class, 'task/step ')">
            <xsl:if test="$nodeCnt = 'multi'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('task/step', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$nodeCnt = 'onestep'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat('task/step', ' FontStretch')" />
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/ph ') and
                      not(matches($class, 'hi-d/b '))">
            <xsl:choose>
                <xsl:when test="$cur[matches(@outputclass, 'small')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' FontStretch')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('outputclass=intuitive)', ' topic/ph', ' FontStretch')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[parent::*[matches(@class, 'topic/title ')]]">
                    <xsl:value-of select="'inherit'" />
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Default', ' Common', ' FontStretch')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="matches($class, 'topic/tm ')">
            <xsl:choose>
                <xsl:when test="$cur[matches(@tmtype, 'tm')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=tm)', ' topic/tm', ' FontStretch')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="$cur[matches(@tmtype, 'reg')]">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('tmtype=reg)', ' topic/tm',' FontStretch')" />
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'inherit'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="letterSpacing">
        <xsl:param name="cur" />
        <xsl:param name="class" />
        <xsl:param name="locale" />
        <xsl:param name="localeStrAfter" />
        <xsl:param name="cnt" required="no" />
        <xsl:param name="nodeCnt" required="no" />

        <xsl:choose>
            <xsl:when test="matches(@outputclass, 'compact-')">
                <xsl:variable name="compactNumber" select="replace(substring-after(@outputclass, 'compact-'), '(\d+)([\s\w+]+)?', '$1')" />
                <xsl:variable name="decimalConvert" select="number($compactNumber) * 0.01" />

                <xsl:choose>
                    <xsl:when test="matches($class, 'topic/li ') and
                                    not(matches($class, 'task/step '))">
                        <xsl:value-of select="concat('-', $decimalConvert, 'pt')" />
                    </xsl:when>

                    <xsl:when test="matches($class, 'topic/ph ') and
                                    not(matches($class, 'hi-d/b '))">
                        <xsl:value-of select="concat('-', $decimalConvert, 'pt')" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:variable name="compactNumber" select="replace(substring-after(@outputclass, 'compact-'), '(\d+)([\s\w+]+)?', '$1')" />
                        <xsl:variable name="decimalConvert" select="number($compactNumber) * 0.01" />
                        <xsl:value-of select="concat('-', $decimalConvert, 'pt')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:otherwise>
                <xsl:if test="matches($cur, 'Frontmatter-')">
                    <xsl:if test="matches($cur, 'Frontmatter-Url')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Url',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'Frontmatter-LangDateVer')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' LangDateVer',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'Frontmatter-info')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Frontmatter', ' Info',  ' LetterSpacing')" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'Frontmatter-model')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Model',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'Frontmatter-title')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' Title',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'Frontmatter-petName')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'TR')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Frontmatter', ' petName',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="matches($cur, 'TOC-')">
                    <xsl:if test="matches($cur, 'TOC-header')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('TOC', ' PageTitle',  ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches($cur, 'TOC-depth')">
                        <xsl:choose>
                            <xsl:when test="matches($localeStrAfter, 'GB')">
                                <xsl:choose>
                                    <xsl:when test="$cnt = 1">
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' LetterSpacing')" />
                                        </xsl:call-template>
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' LetterSpacing')" />
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$cnt = 1">
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="concat('TOC', ' Heading1', ' LetterSpacing')" />
                                        </xsl:call-template>
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="concat('TOC', ' SubHeading', ' LetterSpacing')" />
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="matches($class, 'topic/title ')">
                    <xsl:if test="matches(@outputclass, '^Chapter')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Chapter', ' LetterSpacing')" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="matches(@outputclass, 'Heading1')">
                        <xsl:choose>
                            <xsl:when test="matches(@outputclass, 'Heading1-H3')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading1-H3', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading1', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches(@outputclass, 'Heading2')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('Heading2', ' LetterSpacing')" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="matches(@outputclass, 'Heading3')">
                        <xsl:choose>
                            <xsl:when test="matches(@outputclass, 'Heading3-TroubleShooting')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading3-TroubleShooting', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading3', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if test="matches(@outputclass, 'Heading4')">
                        <xsl:choose>
                            <xsl:when test="matches(@outputclass, 'Heading4-TroubleShooting')">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading4-TroubleShooting', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="concat('Heading4', ' LetterSpacing')" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="matches($class, 'topic/p ')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'Heading3')">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('Heading3', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('Default', ' Common', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <xsl:if test="matches($class, 'hi-d/b ')">
                    <xsl:choose>
                        <xsl:when test="matches(@outputclass, 'semi')">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('Default', ' Common', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <xsl:if test="matches($class, 'sw-d/cmdname ')">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('sw-d/cmdname', ' LetterSpacing')" />
                    </xsl:call-template>
                </xsl:if>

                <xsl:if test="matches($class, 'topic/li ') and
                              not(matches($class, 'task/step '))">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('topic/li', ' LetterSpacing')" />
                    </xsl:call-template>
                </xsl:if>

                <xsl:if test="matches($class, 'task/step ')">
                    <xsl:if test="$nodeCnt = 'multi'">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('task/step', ' LetterSpacing')" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="$nodeCnt = 'onestep'">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="concat('task/step', ' LetterSpacing')" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="matches($class, 'topic/ph ') and
                              not(matches($class, 'hi-d/b '))">
                    <xsl:choose>
                        <xsl:when test="$cur[matches(@outputclass, 'small')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=small)', ' topic/ph', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:when test="$cur[matches(@outputclass, 'intuitive')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('outputclass=intuitive)', ' topic/ph', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:when test="$cur[parent::*[matches(@class, 'topic/title ')]]">
                            <xsl:value-of select="'inherit'" />
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('Default', ' Common', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <xsl:if test="matches($class, 'topic/tm ')">
                    <xsl:choose>
                        <xsl:when test="$cur[matches(@tmtype, 'tm')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('tmtype=tm)', ' topic/tm', ' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:when test="$cur[matches(@tmtype, 'reg')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="concat('tmtype=reg)', ' topic/tm',' LetterSpacing')" />
                            </xsl:call-template>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="'inherit'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
