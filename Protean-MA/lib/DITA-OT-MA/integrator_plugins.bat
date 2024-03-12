set DITA_DIR=%cd%\
set ANT_HOME=

call %DITA_DIR%bin\ant -f integrator.xml
pause