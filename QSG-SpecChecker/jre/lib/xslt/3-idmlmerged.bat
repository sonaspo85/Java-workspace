@echo off
echo Just a moment, please!
echo I'm processing...

set SAXON_DIR=C:\Saxonica\
set _JAVA_OPTIONS=-Xmx2024m -Xms2024m

set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
set CLASSPATH=%SAXON_DIR%lib\saxon-he-10.3.jar;%CLASSPATH%

set transform=net.sf.saxon.Transform
set srcDirs="D:/WORK/_MA/QSG-Spec-Check/WORK/240125/test1"

set folderName=SM-A5460_QSG_Open_China_Chi_Rev.2.5_230908_INDD
set fullPath="C:/Users/SMC/Desktop/IMAGE/qsg/test/[SM-A546B]/SM-A546B_DS_QSG_Open_TSS_4th_EUB_Rev.1.0_230201_INDD/zipDir/001_A546B_DS_QSG_Open_Eng"


rem rem rem rem  ************* IDML to XML  *********************
rem java %transform%  -s:idmlmergedxsls\dummy.xml  -xsl:idmlmergedxsls\01-designmap_name.xsl  midName=%fullPath%
rem java %transform%  -s:idmlmergedxsls\dummy.xml  -xsl:idmlmergedxsls\02-story_merged.xsl  midName=%fullPath%
rem java %transform%  -s:idmlmergedxsls\dummy.xml -xsl:idmlmergedxsls\03-specExtract.xsl  midName=%srcDirs%
rem java %transform% -s:idmlmergedxsls\dummy.xml  -o:%srcDirs%\temp\dummy.xml  -xsl:idmlmergedxsls\04-resource_merged.xsl  srcDirs=%srcDirs%  folderName=%folderName%
java %transform%  -s:%srcDirs%\temp\04-resource_merged.xml  -o:%srcDirs%\temp\05-table-structure.xml  -xsl:idmlmergedxsls\05-table-structure.xsl  srcPath=%srcDirs%
rem java %transform%  -s:%srcDirs%\temp\05-table-structure.xml  -o:%srcDirs%\temp\idmlMergedXML.xml  -xsl:idmlmergedxsls\06-grouping-doc.xsl  midName=%srcDirs%



rem pause

