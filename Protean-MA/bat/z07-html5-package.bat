@echo off
echo Just a moment, please!
rem C:\Users\KSY\AppData\Roaming\Microsoft\Windows\SendTo

set JAVA_HOME=C:\Program Files\Java\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
echo Java 18 activated.
java -version

echo ----------------------------------------------------------------------------------

set SAXON_DIR=C:\Saxonica\
set CLASSPATH=%SAXON_DIR%lib\saxon-ee-10.0.jar;%SAXON_DIR%lib\xml-resolver-1.2.jar;%CLASSPATH%

setlocal EnableDelayedExpansion
for /f "tokens=1,2 delims=^=" %%a in ('type _setLanguage.xml^|find "setLanguage="') do (
    set lang=%%b
)

set pvPath=H:\DITA\Mobile\Bat\mobile-source\xsls\pv.xml
set manualPath=H:\DITA\Mobile\Bat\mobile-source\
set htmlDirS="H:/DITA/Mobile/Bat/mobile-source/out/3_"

set lang=!lang!
echo ****** %~n0 ******
echo %lang%


rem rem rem rem rem rem ****** 1. ExcelDB 생성하기 *********************************
rem java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:out\master-final.dita  -o:out\ExcelDB.xml  -xsl:xsls\htmlExcelDB\01-ExcelDB.xsl  pvPath=%pvPath%

rem rem rem rem rem rem ****** 2. xmlTexcel 생성하기 *******************************
rem call java18-xmlTexcel.bat

rem rem rem rem rem rem ****** 3. excelTxml 생성하기 *******************************
rem call java18-excelTxml.bat


rem rem rem rem rem **************************************************************
rem java net.sf.saxon.Transform  -s:out\preview.html  -o:out\html-temp\01-heading-grouping.html  -xsl:xsls\html-convert\01-heading-grouping.xsl  htmlDirS=%htmlDirS%
rem java net.sf.saxon.Transform  -s:out\html-temp\01-heading-grouping.html  -o:out\html-temp\02-insert-subArti-into-h1.html  -xsl:xsls\html-convert\02-insert-subArti-into-h1.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\02-insert-subArti-into-h1.html  -o:out\html-temp\03-attr-clean.html  -xsl:xsls\html-convert\03-attr-clean.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\03-attr-clean.html  -o:out\html-temp\04-id-modified.html  -xsl:xsls\html-convert\04-id-modify.xsl

rem rem rem rem rem rem rem rem ****** html 파일 추출 하기 ********************************
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\05-make-toc1.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\06-package.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\07-start-here.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\08-make-jsons.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\09-make-search.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\10-make-bookmark.xsl
rem java net.sf.saxon.Transform  -s:out\html-temp\04-id-modified.html  -o:out\html-temp\dummy.xml  -xsl:xsls\html-convert\11-make-app.xsl


rem rem rem rem rem rem rem ****** tags.xml 생성하기 *********************************
java net.sf.saxon.Transform  -s:out\recommend.xml  -o:out\tagsXml\01-groupingHeading1.xml  -xsl:xsls\tagsXml\01-groupingHeading1.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\01-groupingHeading1.xml  -o:out\tagsXml\02-pickupRecommend.xml  -xsl:xsls\tagsXml\02-pickupRecommend.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\02-pickupRecommend.xml  -o:out\tagsXml\03-splitNewListitem.xml  -xsl:xsls\tagsXml\03-splitNewListitem.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\03-splitNewListitem.xml  -o:out\tagsXml\04-groupRecommend.xml  -xsl:xsls\tagsXml\04-groupRecommend.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\04-groupRecommend.xml  -o:out\tagsXml\05-removeHeadingCheck.xml  -xsl:xsls\tagsXml\05-removeHeadingCheck.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\05-removeHeadingCheck.xml  -o:out\tagsXml\06-createTagsF.xml  -xsl:xsls\tagsXml\06-createTagsF.xsl  manualPath=%manualPath%
rem java net.sf.saxon.Transform  -s:out\tagsXml\06-createTagsF.xml  -o:out\tagsXml\dummy.xml  -xsl:xsls\tagsXml\07-sortTags.xsl

rem rem rem rem rem ****** ui-text 생성하기 **********************************
rem java net.sf.saxon.Transform  -s:out\Message.xml  -o:out\tagsXml\08-messageF-escape.xml  -xsl:xsls\tagsXml\08-messageF-escape.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\08-messageF-escape.xml  -o:out\tagsXml\09-lgsGrouping.xml  -xsl:xsls\tagsXml\09-lgsGrouping.xsl
rem java net.sf.saxon.Transform  -s:out\tagsXml\09-lgsGrouping.xml  -o:out\tagsXml\dummy.xml  -xsl:xsls\tagsXml\10-createUiTxt.xsl

rem rem rem rem rem ---------------------------------------------------------------------------





rem rem rem rem rem ---------------------------------------------------------------------------

pause
