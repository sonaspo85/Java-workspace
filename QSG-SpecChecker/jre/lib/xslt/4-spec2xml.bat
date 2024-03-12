@echo off
echo Just a moment, please!
echo I'm processing...

set SAXON_DIR=C:\Saxonica\
set _JAVA_OPTIONS=-Xmx2024m -Xms2024m

set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
set CLASSPATH=%SAXON_DIR%lib\saxon-he-10.3.jar;%CLASSPATH%

set transform=net.sf.saxon.Transform

set srcDirs="D:/WORK/_MA/QSG-Spec-Check/WORK/231120/sample_test/test8/CE-Only"
rem set specXMLF="%srcDirs%/temp/Validation.xml"
set specXMLF=%srcDirs%/temp/Validation.xml
set region=Ukr

rem rem rem rem  ************* IDML to XML  *********************
rem java %transform%  -s:dummy.xml  -o:%srcDirs%\temp\01-spec2xmlMerged.xml  -xsl:spec2xsls\01-spec2xmlMerged.xsl  srcDirs=%srcDirs%\temp\spec2xmlData
rem java %transform%  -s:%srcDirs%\temp\01-spec2xmlMerged.xml  -o:%srcDirs%\temp\02-groupingLangs.xml  -xsl:spec2xsls\02-groupingLangs.xsl
rem java %transform%  -s:%srcDirs%\temp\02-groupingLangs.xml  -o:%srcDirs%\temp\03-bandmode.xml  -xsl:spec2xsls\03-bandmode.xsl
rem java %transform%  -s:%srcDirs%\temp\03-bandmode.xml  -o:%srcDirs%\temp\04-etc.xml  -xsl:spec2xsls\04-etc.xsl
rem java %transform%  -s:%srcDirs%\temp\04-etc.xml  -o:%srcDirs%\temp\05-all-other-sheet.xml  -xsl:spec2xsls\05-all-other-sheet.xsl
rem java %transform%  -s:%srcDirs%\temp\05-all-other-sheet.xml  -o:%srcDirs%\temp\06-packages.xml  -xsl:spec2xsls\06-packages.xsl
rem java %transform%  -s:%srcDirs%\temp\06-packages.xml  -o:%srcDirs%\temp\07-sars.xml  -xsl:spec2xsls\07-sars.xsl
rem java %transform%  -s:%srcDirs%\temp\07-sars.xml  -o:%srcDirs%\temp\tmp-languages.xml  -xsl:spec2xsls\08-distance.xsl




java %transform%  -s:%srcDirs%\temp\tmp-languages.xml  -o:%srcDirs%\temp\languages.xml  -xsl:spec2xsls\09-languages.xsl  specXMLF=%specXMLF%  region=%region%






rem pause

