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

set tmxPath=C:\Users\SMC\Desktop\IMAGE\tmxtest\
echo ****** %~n0 ******
rem rem rem ---------------------------------------------------------------------------

setlocal EnableDelayedExpansion
for /f "delims=" %%i in (tmxLangList.xml) do (
    set filePath=%%i
    java net.sf.saxon.Transform  -s:!filePath!  -o:out\MigrateTMX\01-tm-migrated.tmx  -xsl:xsls\MigrateTMX\01-tm-migrate.xsl
    java net.sf.saxon.Transform  -s:out\MigrateTMX\01-tm-migrated.tmx  -o:out\MigrateTMX\02-tm-cleaned-i-type.tmx  -xsl:xsls\MigrateTMX\02-tm-clean-i-type.xsl
    java net.sf.saxon.Transform  -s:out\MigrateTMX\02-tm-cleaned-i-type.tmx  -o:out\MigrateTMX\03-tm-fix-ept-i.tmx  -xsl:xsls\MigrateTMX\03-tm-fix-ept-i.xsl
	java net.sf.saxon.Transform  -s:out\MigrateTMX\03-tm-fix-ept-i.tmx  -o:out\MigrateTMX\dummy.xml  -xsl:xsls\MigrateTMX\04-tm-clean-bpt-ept.xsl
)


pause