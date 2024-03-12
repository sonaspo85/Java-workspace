@echo off
echo Just a moment, please!
rem C:\Users\KSY\AppData\Roaming\Microsoft\Windows\SendTo

set JAVA_HOME=H:\JAVA\java-workspace\Protean-MA\lib\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
rem echo Java 18 activated.
rem java -version

echo ----------------------------------------------------------------------------------

set CLASSPATH=
set dita=H:\JAVA\java-workspace\Protean-MA\lib\DITA-OT-MA\bin\
rem net use z: \\10.10.10.222\AHFormatterV63 >NUL
set ANT_OPTS=-Xmx2048M
set AXF_OPT=H:/JAVA/java-workspace/Protean-MA/lib/DITA-OT-MA/pdf-settings/pdf-settings.xml

set srcDir=H:\DITA\Mobile\Bat\mobile-source\

set lgs=
setlocal EnableDelayedExpansion
for /f "tokens=1,2 delims=^=" %%a in ('type _setLanguage.xml^|find "setLanguage="') do (
    set lang=%%b
)


echo ****** %~n0 ******
rem rem rem ---------------------------------------------------------------------------


call %dita%dita.bat  --input=%srcDir%\out\master-final.dita  -output=%srcDir%\out  --transtype=protean_ma_um_en_2020pdf  -Dlgs=%lgs%  -Denv.AXF_OPT=%AXF_OPT%


pause
