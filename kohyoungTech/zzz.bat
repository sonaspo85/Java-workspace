@echo off
echo Just a moment, please!
echo I'm processing...

set SAXON_DIR=C:\Saxonica\

set JAVA_HOME=H:\GitProject\Java\java-workspace\kohyoungTech\jre\
@REM set JAVA_HOME=%ScriptDir%\functions\openjdk18
set Path=%JAVA_HOME%\bin;%Path%
echo Java 1.8 activated.
java -version

java -jar "C:/Users/sonas/Desktop/Image/230603/ko/odlexe/Kohyoung-Word2HTML-Setup/Kohyoung-Word2HTML-Korean.jar"


pause