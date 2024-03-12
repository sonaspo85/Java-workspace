@echo off
echo Just a moment, please!
rem C:\Users\KSY\AppData\Roaming\Microsoft\Windows\SendTo

rem set JAVA_HOME=C:\Program Files\Java\openjdk-18.0.1
set JAVA_HOME=H:\JAVA\java-workspace\Protean-MA\lib\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
rem echo Java 18 activated.
rem java -version

echo ----------------------------------------------------------------------------------

set SAXON_DIR=H:\JAVA\java-workspace\Protean-MA\lib\saxon\
set CLASSPATH=%SAXON_DIR%lib\saxon-ee-10.0.jar;%CLASSPATH%;%CLASSPATH1%


rem ***  variable  ***
rem set pvPath=H:\DITA\Mobile\Bat\mobile-source\xsls\pv.xml
set pvPath="H:/DITA/Mobile/Bat/mobile-source/xsls/pv.xml"
set manualPath=H:\DITA\Mobile\Bat\mobile-source\
set srcDir=H:\DITA\Mobile\Bat\mobile-source\
set xsltPath=Z:\lib\
set name="English-EU"
rem set name="Arabic"
set template=default
rem set template=T-OS_upgrade
set prodtype=smartphone
set htmlVer=eee

setlocal EnableDelayedExpansion
for /f "tokens=1,2 delims=^=" %%a in ('type _setLanguage.xml^|find "setLanguage="') do (
    set lang=%%b
)



set lang=!lang!
echo ****** %~n0 ******
echo lang: %lang%
echo template: %template%

rem rem rem rem rem rem *************************************************************
java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%srcDir%\out\PROJECT.xml  -o:%srcDir%\out\master.dita  -xsl:%xsltPath%\xsls\master.xsl  pvPath=%pvPath%  lang=%lang%  name=%name%  template=%template%  prodtype=%prodtype% htmlVer=%htmlVer%
java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%srcDir%\out\master.dita  -o:%srcDir%\out\master-final.dita  -xsl:%xsltPath%\xsls\insert-idx.xsl
java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%srcDir%\out\master-final.dita  -o:%srcDir%\out\%lang%.dita  -xsl:%xsltPath%\xsls\target.xsl  pvPath=%pvPath%
java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%srcDir%\out\master-final.dita  -o:%srcDir%\out\4_TR\TR2-%lang%.xml  -xsl:%xsltPath%\xsls\multi-export.xsl  pvPath=%pvPath%
java net.sf.saxon.Transform -catalog:C:\DITA-OT-MA\catalog-dita.xml  -s:%srcDir%\out\%lang%.dita  -o:%srcDir%\out\4_TR\TR1-%lang%.xml  -xsl:%xsltPath%\xsls\tr-export.xsl  lang=%lang%  pvPath=%pvPath%  manualPath=%manualPath%


pause