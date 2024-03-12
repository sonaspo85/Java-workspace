@echo off
echo Just a moment, please!
rem C:\Users\KSY\AppData\Roaming\Microsoft\Windows\SendTo

set JAVA_HOME=C:\Program Files\Java\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
echo Java 18 activated.
java -version

echo ----------------------------------------------------------------------------------

set SAXON_DIR=C:\Saxonica\
set CLASSPATH=%SAXON_DIR%lib\saxon9he.jar;%CLASSPATH%;%CLASSPATH1%

echo ****** %~n0 ******

rem set sMapDir=H:\DITA\Mobile\Bat\mobile-source\out\
set tempP=C:\Users\SMC\Desktop\IMAGE\testdita\excel\temp-html
set xslDir=Z:\lib\xsls
rem set idmlTemplsDir="H:/JAVA/java-workspace/Protean-MA/lib/idml-template/template"
rem set idmlTemplsDir="C:/Protean-MA/idmlModule/template"


java net.sf.saxon.Transform  -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%xslDir%\dummy.xml  -o:%tempP%\temp\01-merged.xml  -xsl:%xslDir%\temp-html\01-merged.xsl  sMapDir=%tempP%
java net.sf.saxon.Transform  -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%tempP%\temp\01-merged.xml  -o:%tempP%\temp\02-getMatchesLangs.xml  -xsl:%xslDir%\temp-html\02-getMatchesLangs.xsl
java net.sf.saxon.Transform  -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%tempP%\temp\02-getMatchesLangs.xml  -o:%tempP%\temp\dummy.xml  -xsl:%xslDir%\temp-html\03-exportHtml.xsl






rem rem rem ---------------------------------------------------------------------------



rem java net.sf.saxon.Transform   -s:idmlModule\xsls\dummy.xml -o:idmlModule\dummy.xml  -xsl:idmlModule\xsls\08-dummy.xsl

rem java net.sf.saxon.Transform   -s:out2\dfinedInline.xml -o:out2\xrefed.xml  -xsl:idmlModule\xsls\xrefs.xsl
rem -> package.xsl 실행시  idmlModule/temp 폴더내에 있는 *.idml을 하나씩 호출하여 소스로 사용

pause
