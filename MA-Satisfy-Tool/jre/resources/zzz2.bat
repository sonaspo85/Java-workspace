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
set satisF=%tempDir%\final-satisfy.xml
set tarF=%tempDir%\17-totalsum.xml

@echo off

rem java net.sf.saxon.Transform  -s:xsls\dummy.xml  -o:temp\08-DBmerged.xml  -xsl:xsls\compare\08-DBmerged.xsl  tempDir=%tempDir%  scoreF=%scoreF%  satisF=%satisF%
rem java net.sf.saxon.Transform  -s:temp\08-DBmerged.xml  -o:temp\09-score-count.xml  -xsl:xsls\compare\09-score-count.xsl
rem java net.sf.saxon.Transform  -s:temp\09-score-count.xml  -o:temp\10-satis-count.xml  -xsl:xsls\compare\10-satis-count.xsl
rem java net.sf.saxon.Transform  -s:temp\10-satis-count.xml  -o:temp\12-grouping.xml  -xsl:xsls\compare\12-grouping.xsl
rem java net.sf.saxon.Transform  -s:temp\12-grouping.xml  -o:temp\13-cleanTag.xml  -xsl:xsls\compare\13-cleanTag.xsl
rem java net.sf.saxon.Transform  -s:temp\13-cleanTag.xml  -o:temp\14-grouping.xml  -xsl:xsls\compare\14-grouping.xsl
rem java net.sf.saxon.Transform  -s:temp\14-grouping.xml  -o:temp\15-calculate.xml  -xsl:xsls\compare\15-calculate.xsl
rem java net.sf.saxon.Transform  -s:temp\15-calculate.xml  -o:temp\16-percent.xml  -xsl:xsls\compare\16-percent.xsl
java net.sf.saxon.Transform  -s:temp\16-percent.xml  -o:temp\17-totalsum.xml  -xsl:xsls\compare\17-totalsum.xsl
rem java net.sf.saxon.Transform  -s:temp\08-DBmerged.xml  -o:temp\18-meged-tarF.xml  -xsl:xsls\compare\18-meged-tarF.xsl  tarF=%tarF%
rem java net.sf.saxon.Transform  -s:temp\18-meged-tarF.xml  -o:temp\19-same-keys.xml  -xsl:xsls\compare\19-same-keys.xsl
rem java net.sf.saxon.Transform  -s:temp\19-same-keys.xml  -o:temp\dummy.xml  -xsl:xsls\compare\20-split-doc.xsl  tempDir=%tempDir%
rem java net.sf.saxon.Transform  -s:temp\17-totalsum.xml  -o:temp\21-safety-define.xml  -xsl:xsls\compare\21-safety-define.xsl
rem java net.sf.saxon.Transform  -s:temp\21-safety-define.xml  -o:temp\22-safety-grouping.xml  -xsl:xsls\compare\22-safety-grouping.xsl

rem java net.sf.saxon.Transform  -s:temp\17-totalsum.xml  -o:temp\23-convert-html01.xml  -xsl:xsls\compare\23-convert-html01.xsl
rem java net.sf.saxon.Transform  -s:temp\23-convert-html01.xml  -o:temp\24-convert-html02.xml  -xsl:xsls\compare\24-convert-html02.xsl
rem java net.sf.saxon.Transform  -s:temp\24-convert-html02.xml  -o:temp\finally.html  -xsl:xsls\compare\25-convert-html03.xsl




echo complete!!
rem pause
