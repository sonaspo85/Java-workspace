@echo off
echo Just a moment, please!
echo I'm processing...

set SAXON_DIR=C:\Saxonica\


set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
set CLASSPATH=%SAXON_DIR%lib\saxon-he-10.3.jar;%CLASSPATH%

rem set _JAVA_OPTIONS=-Xmx2024m -Xms2024m
set transform=net.sf.saxon.Transform

rem set folderName=005_R900_QSG_ASIA_TYPE_A_Lao

set srcDirs="D:/WORK/_MA/QSG-Spec-Check/WORK/231120/sample_test/test8/CE-Only"
set packageDir="G:/MS-Drive/OneDrive - UOU/WORK/Workspace/WORK/JAVA/java-workspace/QSG-SpecChecker"
set specSampleDirs=%srcDirs%\temp\specSample\
set region=Ukr

rem rem rem rem  ************* IDML to XML  *********************
rem java %transform%  -s:%packageDir%/jre/lib/xslt/dummy.xml  -o:%/srcDirs%/temp/dummy.xml  -xsl:specSample\01-specSampleMerged.xsl  specSampleDirs=%specSampleDirs%
java %transform%  -s:%srcDirs%/temp/01-specSampleMerged.xml  -o:%srcDirs%/temp/Validation.xml  -xsl:specSample/02-validation.xsl  specSampleDirs=%specSampleDirs%  region=%region%




rem pause

