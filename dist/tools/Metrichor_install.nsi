!define /date MyTIMESTAMP "%Y%m%d_%H%M"
OutFile "..\win\MetrichorInstall_${MyTIMESTAMP}.exe"

# predefined variables
var MetDir 

# uninstall section
#
Section "Uninstall"
  strcpy $MetDir $PROGRAMFILES64\ONT\Metrichor
  Delete $MetDir\uninstall_MDC.exe 
  IfFileExists $MetDir\icudt.dll 0 +2
    Delete $MetDir\icudt.dll
  IfFileExists $MetDir\nw.pak 0 +2
    Delete $MetDir\nw.pak
  IfFileExists $MetDir\metrichor.exe 0 +2
    Delete $MetDir\metrichor.exe
  RMDir  $MetDir
  IfFileExists $SMPROGRAMS\mdc.lnk 0 +2
    Delete "$SMPROGRAMS\mdc.lnk"
  IfFileExists $desktop\mdc.lnk 0 +2
    Delete "$desktop\mdc.lnk"
  #finished uninstaller
SectionEnd

# install section
section
  strcpy $MetDir $PROGRAMFILES64\ONT\Metrichor
  IfFileExists $MetDir\uninstall_MDC.exe 0 +2
    ExecWait $MetDir\uninstall_MDC.exe
  messageBox MB_OK "Installing Metrichor"
  setOutPath $MetDir

  file ..\win\icudt.dll
  file ..\win\metrichor.exe
  file ..\win\nw.pak

  MessageBox MB_YESNO "Install shortcut on desktop?" IDYES true IDNO false
  true:
    CreateShortcut "$desktop\mdc.lnk" "$MetDir\metrichor.exe"
      goto next
  false:
    goto next

  next:
  createShortCut "$SMPROGRAMS\mdc.lnk" "$MetDir\metrichor.exe"
  messageBox MB_OK "Metrichor Installed"
  WriteUninstaller $MetDir\uninstall_MDC.exe
sectionEnd

