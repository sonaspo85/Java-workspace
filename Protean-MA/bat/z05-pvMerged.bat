@echo off
echo Just a moment, please!
rem C:\Users\KSY\AppData\Roaming\Microsoft\Windows\SendTo

set JAVA_HOME=H:\JAVA\java-workspace\Protean-MA\lib\openjdk-18.0.1
set Path=%JAVA_HOME%\bin;%Path%
echo Java 18 activated.
java -version

echo ----------------------------------------------------------------------------------

set SAXON_DIR=H:\JAVA\java-workspace\Protean-MA\lib\saxon\
set CLASSPATH=%SAXON_DIR%lib\saxon-ee-10.0.jar;%CLASSPATH%
set xsltPath=Z:\lib\

rem set pvPath=H:\DITA\Mobile\Bat\mobile-source\out\newDB
set pvPath=C:\Users\SMC\Desktop\IMAGE\testdita\
set manualPath=C:\Users\SMC\Desktop\IMAGE\testdita\



rem rem rem ---------------------------------------------------------------------------
java net.sf.saxon.Transform  -s:%xsltPath%\xsls\dummy.xml  -o:%manualPath%\dummy.xml  -xsl:%xsltPath%\xsls\pvMerged\01-mergedFiles.xsl  pvPath=%pvPath%  manualPath=%manualPath%
java net.sf.saxon.Transform  -s:%manualPath%\out\mergedPV\01-mergedFiles.xml  -o:%manualPath%\out\mergedPV\02-collectionsItems.xml  -xsl:xsls\pvMerged\02-collectionsItems.xsl
rem java net.sf.saxon.Transform  -s:%manualPath%\out\mergedPV\02-collectionsItems.xml  -o:%manualPath%\out\mergedPV\03-groupingEng.xml  -xsl:xsls\pvMerged\03-groupingEng.xsl
rem java net.sf.saxon.Transform  -s:%manualPath%\out\mergedPV\03-groupingEng.xml  -o:%manualPath%\out\mergedPV\pv2.xml  -xsl:xsls\pvMerged\04-indent.xsl


pause
