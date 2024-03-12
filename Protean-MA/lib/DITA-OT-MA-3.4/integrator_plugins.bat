set DITA_DIR=%cd%\
set ANT_HOME=
set CLASSPATH=%DITA_DIR%/lib/xml-resolver-1.2.jar

call %DITA_DIR%bin\ant -f integrator.xml
pause