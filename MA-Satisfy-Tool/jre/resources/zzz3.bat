@echo off
echo Just a moment, please!


set SAXON_DIR=C:\Saxonica\
set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
set CLASSPATH=%SAXON_DIR%\lib\saxon-he-10.3.jar;%CLASSPATH%
set _JAVA_OPTIONS=-Xmx2024m -Xms2024m -XX:+HeapDumpOnOutOfMemoryError

rem rem ----------------------------------------------------------
set projectDir=H:\JAVA\java-workspace\MA-Satisfy-Tool\jre\
set tempDir=%projectDir%\resources\temp
set templsDir=%projectDir%\resources\template

set dbDirs=%tempDir%\db
set scoreF=%templsDir%\scoreSection.xml

set excelDirs=%tempDir%\excel\satisfy



@echo off

rem java net.sf.saxon.Transform  -s:xsls\dummy.xml  -o:temp\01-sati-merged.xml  -xsl:xsls\satisfy\01-sati-merged.xsl  excelDirs=%excelDirs%  scoreF=%scoreF%
rem java net.sf.saxon.Transform  -s:temp\01-sati-merged.xml  -o:temp\02-sati-chTagName.xml  -xsl:xsls\satisfy\02-sati-chTagName.xsl
rem java net.sf.saxon.Transform  -s:temp\02-sati-chTagName.xml  -o:temp\03-sati-grouping-filename.xml  -xsl:xsls\satisfy\03-sati-grouping-filename.xsl
rem java net.sf.saxon.Transform  -s:temp\03-sati-grouping-filename.xml  -o:temp\04-sati-cleanTag.xml  -xsl:xsls\satisfy\04-sati-cleanTag.xsl
rem java net.sf.saxon.Transform  -s:temp\04-sati-cleanTag.xml  -o:temp\05-sati-grouping-itemValue.xml  -xsl:xsls\satisfy\05-sati-grouping-itemValue.xsl
rem java net.sf.saxon.Transform  -s:temp\05-sati-grouping-itemValue.xml  -o:temp\06-sati-calculate.xml  -xsl:xsls\satisfy\06-sati-calculate.xsl
rem java net.sf.saxon.Transform  -s:temp\06-sati-calculate.xml  -o:temp\07-sati-total-avg.xml  -xsl:xsls\satisfy\07-sati-total-avg.xsl
java net.sf.saxon.Transform  -s:temp\07-sati-total-avg.xml  -o:temp\final-satisfy.xml  -xsl:xsls\satisfy\08-sati-delete-duplicate.xsl







echo complete!!
rem pause
