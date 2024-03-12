@echo off
echo Just a moment, please!

set JAVA_HOME=H:\JAVA\java-workspace\Protean-MA\lib\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
rem echo Java 18 activated.
rem java -version

echo ----------------------------------------------------------------------------------

set SAXON_DIR=H:\JAVA\java-workspace\Protean-MA\lib\saxon\
set CLASSPATH1=%CLASSPATH%
set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
rem set CLASSPATH=%SAXON_DIR%lib\saxon-ee-10.0.jar;%CLASSPATH%

REM for /r %%a in (*.ai) do ren "%%~a" "%%~na.pdf" 2>nul
rem rename BASIC/images/*.ai *.pdf 2>nul

rem rem rem ---------------------------------------------------------------------------
rem +----------------------------------------------------------------------------
rem | DITA-OT merged 플러그인을 이용하여 out 폴더에 PROJECT.xml 파일을 만든다.
rem +----------------------------------------------------------------------------


set CLASSPATH=
set ditavalDIR=H:\JAVA\java-workspace\Protean-MA\lib\DITA-OT-MA\_filter\
set dita=H:\JAVA\java-workspace\Protean-MA\lib\DITA-OT-MA\bin\
rem set ANT_OPTS=-Xmx2048m %ANT_OPTS%
set ANT_OPTS=-Xmx2048M
setlocal EnableDelayedExpansion
for /f "tokens=1,2 delims=^=" %%a in ('type _setLanguage.xml^|find "setLanguage="') do (
    set lang=%%b
)

set srcDir=H:\DITA\Mobile\Bat\mobile-source\

set ditaval=!lang!.ditaval
echo ****** %~n0 ******
echo %ditaval%

rem +----------------------------------------------------------------------------
rem TEST Source: E:\WORK\WORK\Protean\WORK\220103\source\1_EU
rem +----------------------------------------------------------------------------


call %dita%dita.bat  --input="H:/DITA/Mobile/Bat/mobile-source/PROJECT.ditamap"  --output=%srcDir%\out  --transtype=merged  --args.filter=%ditavalDIR%%ditaval%



pause



