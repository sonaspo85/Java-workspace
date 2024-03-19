@echo off
chcp 65001
echo Just a moment, please!

rem set JAVA_HOME=H:\JAVA\java-workspace\SimpleCMS\jre\
rem set Path=%JAVA_HOME%\bin;%Path%
rem java -version

rem rem rem ----------------------------------------------------------------------------------

set SAXON_DIR=C:\Saxonica\
set CLASSPATH=%SAXON_DIR%lib\saxon-he-10.3.jar;%CLASSPATH%;
set _JAVA_OPTIONS=-Xmx4048m -Xms4048m

rem ***  variable  ***
set transform=net.sf.saxon.Transform

rem rem rem ----------------------------------------------------------------------------------
set langcode=EN

set docinfoF="H:/Workspace/Java-workspace/Martian/jre/lib/resource/docInfo.xml"
set resourcdDir="H:/Workspace/Java-workspace/Martian/jre/lib/resource"
set xslDir="H:/Workspace/Java-workspace/Martian/jre/lib/xsls"
set tempDir="H:/Workspace/Java-workspace/Martian/srcDir/temp"
rem set srcDirs="G:/MS-Drive/OneDrive - UOU/WORK/Workspace/WORK/JAVA/java-workspace/Martian/resource/output/EN"
rem set excelTemplsDir="G:/MS-Drive/OneDrive - UOU/WORK/Workspace/WORK/JAVA/java-workspace/Martian/srcDir/temp/excelTempls"



rem rem rem rem rem rem *************************************************************
rem java %transform%  -s:"H:/Workspace/Java-workspace/Martian/srcDir/temp/eachSrc/aaa.xml"  -o:%tempDir%\00-messageF-groupLang.xml  -xsl:%xslDir%\01-messageF-groupLang.xsl docinfoF=%docinfoF%
rem java %transform%  -s:%xslDir%\dummy.xml  -o:%tempDir%\00-videolinkF-group.xml  -xsl:%xslDir%\01-videolinkF-group.xsl
java %transform%  -s:"H:/Workspace/Java-workspace/Martian/srcDir/temp/eachSrc/aaa.xml"  -o:%tempDir%\01-simplify.xml  -xsl:%xslDir%\01-simplify.xsl
rem java %transform%  -s:%tempDir%\01-simplify.xml  -o:%tempDir%\02-simplify.xml  -xsl:%xslDir%\02-simplify.xsl
rem java %transform%  -s:%tempDir%\02-simplify.xml  -o:%tempDir%\03-define-BrType.xml  -xsl:%xslDir%\03-define-BrType.xsl
rem java %transform%  -s:%tempDir%\03-define-BrType.xml  -o:%tempDir%\04-cleanAttrs.xml  -xsl:%xslDir%\04-cleanAttrs.xsl
rem java %transform%  -s:%tempDir%\04-cleanAttrs.xml  -o:%tempDir%\05-grouping-br.xml  -xsl:%xslDir%\05-grouping-br.xsl
rem java %transform%  -s:%tempDir%\05-grouping-br.xml  -o:%tempDir%\06-groupingTR.xml  -xsl:%xslDir%\06-groupingTR.xsl
rem java %transform%  -s:%tempDir%\06-groupingTR.xml  -o:%tempDir%\07-split-BR.xml  -xsl:%xslDir%\07-split-BR.xsl
rem java %transform%  -s:%tempDir%\07-split-BR.xml  -o:%tempDir%\08-grouping-indent.xml  -xsl:%xslDir%\08-grouping-indent.xsl
rem java %transform%  -s:%tempDir%\08-grouping-indent.xml  -o:%tempDir%\09-nested-indent.xml  -xsl:%xslDir%\09-nested-indent.xsl
rem java %transform%  -s:%tempDir%\09-nested-indent.xml  -o:%tempDir%\10-grouping-list.xml  -xsl:%xslDir%\10-grouping-list.xsl
rem java %transform%  -s:%tempDir%\10-grouping-list.xml  -o:%tempDir%\11-grouping-note.xml  -xsl:%xslDir%\11-grouping-note.xsl
rem java %transform%  -s:%tempDir%\11-grouping-note.xml  -o:%tempDir%\12-nested-tags.xml  -xsl:%xslDir%\12-nested-tags.xsl
rem java %transform%  -s:%tempDir%\12-nested-tags.xml  -o:%tempDir%\13-simplify.xml  -xsl:%xslDir%\13-simplify.xsl
rem java %transform%  -s:%tempDir%\13-simplify.xml  -o:%tempDir%\14-connect-link.xml  -xsl:%xslDir%\14-connect-link.xsl
rem java %transform%  -s:%tempDir%\14-connect-link.xml  -o:%tempDir%\15-simplify.xml  -xsl:%xslDir%\15-simplify.xsl
rem java %transform%  -s:%tempDir%\15-simplify.xml  -o:%tempDir%\16-grouping-heading.xml  -xsl:%xslDir%\16-grouping-heading.xsl
rem java %transform%  -s:%tempDir%\16-grouping-heading.xml  -o:%tempDir%\17-1-insert-videolink.xml  -xsl:%xslDir%\17-1-insert-videolink.xsl
rem java %transform%  -s:%tempDir%\17-1-insert-videolink.xml  -o:%tempDir%\17-2-data-preORnext.xml  -xsl:%xslDir%\17-2-data-preORnext.xsl

rem java %transform%  -s:%tempDir%\17-2-data-preORnext.xml  -o:%tempDir%\17-3-connect-href.xml  -xsl:%xslDir%\17-3-connect-href.xsl
rem java %transform%  -s:%tempDir%\17-3-connect-href.xml  -o:%tempDir%\17-4-strip-img.xml  -xsl:%xslDir%\17-4-strip-img.xsl

rem java %transform%  -s:%tempDir%\17-4-strip-img.xml  -o:%tempDir%\18-simplify.xml  -xsl:%xslDir%\18-simplify.xsl
rem java %transform%  -s:%tempDir%\18-simplify.xml  -o:%tempDir%\19-create-body-header.xml  -xsl:%xslDir%\19-create-body-header.xsl

rem **************************************************************************************
rem java %transform%  -s:%tempDir%\18-simplify.xml  -o:%tempDir%\dummy.xml  -xsl:%xslDir%\20-split-html.xsl
rem java %transform%  -s:%tempDir%\18-simplify.xml  -o:%tempDir%\dummy.xml  -xsl:%xslDir%\21-search-db.xsl
rem java %transform%  -s:%tempDir%\00-messageF-groupLang.xml  -o:%tempDir%\dummy.xml  -xsl:%xslDir%\22-ui_text.xsl
rem java %transform%  -s:%tempDir%\18-simplify.xml  -o:%tempDir%\dummy.xml  -xsl:%xslDir%\23-search-html.xsl
rem java %transform%  -s:%tempDir%\18-simplify.xml  -o:%tempDir%\dummy.xml  -xsl:%xslDir%\24-start-here.xsl
rem java %transform%  -s:%resourcdDir%\docInfo.xml  -o:%resourcdDir%\docInfo.xml  -xsl:%xslDir%\25-set-docinfo.xsl






rem java %transform%  -s:%xslDir%\dummy.xml  -o:%tempDir%\00-messageF-groupLang.xml  -xsl:%xslDir%\01-messageF-groupLang.xsl
echo complete!!
rem pause

