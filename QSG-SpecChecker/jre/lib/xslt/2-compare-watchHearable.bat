@echo off
chcp 65001
echo Just a moment, please!
echo I'm processing...

set SAXON_DIR=C:\Saxonica\
set _JAVA_OPTIONS=-Xmx2024m -Xms2024m

set CLASSPATH=%SAXON_DIR%lib;%CLASSPATH%
set CLASSPATH=%SAXON_DIR%lib\saxon-he-10.3.jar;%CLASSPATH%

set transform=net.sf.saxon.Transform
set srcDirs="D:/WORK/_MA/QSG-Spec-Check/WORK/240325/A사전달자료_240325"
set specXMLF="%srcDirs%/temp/Validation.xml"
set langXMLF="%srcDirs%/temp/languages.xml"
set inputDir=%srcDirs%/temp/compare

rem rem rem ************************
rem java %transform%  -s:%srcDirs%\temp\idmlMergedXML.xml  -o:%srcDirs%\temp\compare\01-filterDoc.xml  -xsl:compare\common\filterDoc.xsl  specXML=%specXML%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\02-model-name.xml  -xsl:compare\common\model-name.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\03-packages-compare.xml  -xsl:compare\common\packages-compare.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\04-green-compare.xml  -xsl:compare\common\green-compare.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\05-sar.xml  -xsl:compare\common\sar.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\06-buds-sars1.xml  -xsl:compare\watchNHearable-xsls\07-buds-sars1.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\07-buds-sars2.xml  -xsl:compare\watchNHearable-xsls\08-buds-sars2.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\08-face-of-sar.xml  -xsl:compare\watchNHearable-xsls\09-face-of-sar.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\09-w-distance.xml  -xsl:compare\watchNHearable-xsls\10-w-distance.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%

rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\10-bandmode.xml  -xsl:compare\common\bandmode.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\10-bandmode.xml  -o:%srcDirs%\temp\compare\10-bandmode2.xml  -xsl:compare\common\bandmode2.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\10-bandmode3.xml  -xsl:compare\common\bandmode3.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\10-bandmode2.xml  -o:%srcDirs%\temp\compare\10-bandmode4.xml  -xsl:compare\common\bandmode4.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%  srcDirs=%srcDirs%
rem java %transform%  -s:%srcDirs%\temp\compare\10-bandmode4.xml  -o:%srcDirs%\temp\compare\11-bandmode-bool.xml  -xsl:compare\common\bandmode-bool.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\11-bandmode-bool.xml  -o:%srcDirs%\temp\compare\11-bandmode-bool2.xml  -xsl:compare\common\bandmode-bool2.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\13-edoc.xml  -xsl:compare\common\edoc.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\14-turgaranty.xml  -xsl:compare\common\turgaranty.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\15-indiabis.xml  -xsl:compare\common\indiabis.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\16-modelname-coverid.xml  -xsl:compare\common\modelname-coverid.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\17-Looseleaf.xml  -xsl:compare\common\Looseleaf.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%

rem rem rem rem 추가 기능 시작 ****************
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\18-usbcablesupport.xml  -xsl:compare\common\usbcablesupport.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\19-powerclass.xml  -xsl:compare\common\powerclass.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\20-pobox.xml  -xsl:compare\common\pobox.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\21-maxichargesupport.xml  -xsl:compare\common\maxichargesupport.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem rem rem 추가 기능 끝 ****************


rem rem rem ************************
rem java %transform%  -s:dummy.xml  -o:%srcDirs%\temp\final-merged01.xml  -xsl:compare\common\final-merged01.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%  srcDirs=%srcDirs%
rem java %transform%  -s:%srcDirs%\temp\final-merged01.xml  -o:%srcDirs%\temp\resultDoc.xml  -xsl:compare\common\final-merged02.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%



rem rem rem java %transform%  -s:%srcDirs%\temp\compare\01-filterDoc.xml  -o:%srcDirs%\temp\compare\12-productspec.xml  -xsl:compare\common\productspec.xsl  specXMLF=%specXMLF%  langXMLF=%langXMLF%
rem pause

