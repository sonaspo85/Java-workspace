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

set excelF=%tempDir%\excel\aaa1.xml
set scoreF=%templsDir%\scoreSection.xml


@echo off

rem java net.sf.saxon.Transform  -s:template\db.xml  -o:temp\01-merged.xml  -xsl:xsls\01-merged.xsl  excelF=%excelF%  scoreF=%scoreF%
rem java net.sf.saxon.Transform  -s:temp\01-merged.xml  -o:temp\02-changeTagName.xml  -xsl:xsls\02-changeTagName.xsl
rem java net.sf.saxon.Transform  -s:temp\02-changeTagName.xml  -o:temp\03-cleanTag.xml  -xsl:xsls\03-cleanTag.xsl
rem java net.sf.saxon.Transform  -s:temp\03-cleanTag.xml  -o:temp\04-grouping.xml  -xsl:xsls\04-grouping.xsl
rem java net.sf.saxon.Transform  -s:temp\04-grouping.xml  -o:temp\05-fillAttr.xml  -xsl:xsls\05-fillAttr.xsl
rem java net.sf.saxon.Transform  -s:temp\05-fillAttr.xml  -o:temp\06-grouping.xml  -xsl:xsls\06-grouping.xsl
rem java net.sf.saxon.Transform  -s:temp\06-grouping.xml  -o:temp\07-score-count.xml  -xsl:xsls\07-score-count.xsl
rem java net.sf.saxon.Transform  -s:temp\07-score-count.xml  -o:temp\db\final-database.xml  -xsl:xsls\08-final-database.xsl



echo complete!!
rem pause
