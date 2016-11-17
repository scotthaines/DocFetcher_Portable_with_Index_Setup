;===============================
; file: docfetcher_portable_with_index_setup.nsi
; created: 2016 09 04, Scott Haines
; edit: 08 Scott Haines
; date: 2016 11 17
; description:  This places DocFetcher Portable in a folder and
;               also places an index with DFP.
; 
;               I do not call this an install because it 
;               does not list DocFetcher in the computer's
;               list of installed programs. Remove the 
;               program by deleting its folder and associated
;               shortcut. Check the desktop for a search 
;               shortcut.
;-------------------------------
; Modern User Interface 2 (MUI2)
    !include "mui2.nsh"

; x64 bit OS detection
    !include "x64.nsh"                  ; Note that mui2.nsh or x64.nsh
                                        ; must include LogicLib.nsh to
                                        ; allow the {If} below to work.
    !include "FileFunc.nsh"

;-------------------------------
    !define MUI_ICON "..\data\docfetcher_portable_blue.ico"

;--------------------------------
; Version Information

    !define DFP_Version 1.0.0.0
    !define DFP_LongName "DFP with Index"
    !define DFP_ShortName "DFP"
    !define DFP_InstallerName "DocFetcherPortableWithIndexSetup_1_0_0.exe"

    ; Blank the branding text which by default appears as
    ; 'Nullsoft Install System v2.46.5-Unicode'.
    BrandingText /TRIMRIGHT " "

    Name "${DFP_LongName}"
    OutFile "..\exe\${DFP_InstallerName}"

    VIProductVersion ${DFP_Version}
    VIAddVersionKey ProductName "${DFP_LongName}"
    VIAddVersionKey Comments "DocFetcher Portable with Index (DFP) provides indexed search for YOW Free Sample browser pages. Visit https://sites.google.com/site/friedbook/ for more information."
    VIAddVersionKey LegalCopyright "Public Domain"
    VIAddVersionKey FileDescription "${DFP_LongName} installer"
    VIAddVersionKey FileVersion ${DFP_Version}
    VIAddVersionKey ProductVersion ${DFP_Version}
    VIAddVersionKey LegalTrademarks "Friedbook, $\"Your Own Web$\" and YOW are Trademarks of Scott Haines."
    VIAddVersionKey OriginalFilename "${DFP_InstallerName}"

    ; Initialize the INSTDIR.
    InstallDir ""
                                        ; An empty string here makes the
                                        ; Browser button work reasonably
                                        ; with the MUI_PAGE_CUSTOMFUNCTION_PRE
                                        ; function writing to INSTDIR.

    RequestExecutionLevel user
    AllowRootDirInstall false

;--------------------------------
; MUI Interface Configuration

    !define MUI_ABORTWARNING

;--------------------------------
; Language Selection Dialog Settings

    ;Remember the installer language
    !define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
    !define MUI_LANGDLL_REGISTRY_KEY  "Software\YOW\Free Sample"
    !define MUI_LANGDLL_REGISTRY_VALUENAME "InstallerUILanguage"
    !define MUI_LANGDLL_ALWAYSSHOW

;-------------------------------
; MUI pages

    Var /GLOBAL dirDraft

; The following define makes the show details displayed before the
; finish page.
!define MUI_FINISHPAGE_NOAUTOCLOSE

!define MUI_WELCOMEPAGE_TEXT "Setup will guide you through the installation of $(^NameDA).$\r$\n$\r$\nSearch YOW Free Sample with DFP and the installed index.$\r$\n$\r$\n$_CLICK"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\data\DocFetcher_Portable_Setup_blue.bmp"
!insertmacro MUI_PAGE_WELCOME
; !define MUI_PAGE_HEADER_TEXT "Public Domain Dedication"
; !define MUI_PAGE_HEADER_SUBTEXT "Please review the dedication Deed and Legal Code before installing $(^NameDA)."
; !define MUI_LICENSEPAGE_TEXT_TOP "Press Page Down to see the rest of the dedication."
; !define MUI_LICENSEPAGE_TEXT_BOTTOM "$_CLICK"
; !define MUI_LICENSEPAGE_BUTTON "&Next >"
    !insertmacro MUI_PAGE_LICENSE "..\data\DocFetcher-1.1.18\license\epl-v10.rtf"
!define MUI_PAGE_CUSTOMFUNCTION_PRE "ReadComponentChoices"
    !insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_PRE "ADirPre"
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "ADirLv"
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
;;; !define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN "$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"
;;; !define MUI_FINISHPAGE_RUN_TEXT "&Open Home page (index.html) folder."
!define MUI_FINISHPAGE_RUN_TEXT "&Run DocFetcher with Index"
;;; !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
;;; !define MUI_FINISHPAGE_RUN_NOTCHECKED
;;; !define MUI_FINISHPAGE_SHOWREADME "$dirDraft\repository\index.html"
;;; !define MUI_FINISHPAGE_SHOWREADME_TEXT "&Display Home page."
    !insertmacro MUI_PAGE_FINISH

Function LaunchLink
    Exec '"$WINDIR\explorer.exe" /e,$dirDraft\repository'
FunctionEnd

    Var /GLOBAL homeDir

Function ADirPre
    ${If} "" == "$dirDraft"
        ; This is the default install location.
        StrCpy $INSTDIR "$DOCUMENTS\drafts\${DFP_ShortName}"
    ${Else}
        StrCpy $INSTDIR "$dirDraft"
    ${EndIf}
FunctionEnd

Function ADirLv
;;; A directory with the YOW Free Sample installed is desired and
;;; also necessary for the indexed search to be able to open and 
;;; view actual files.
;;; 2016 11 16
;;;     ; If the directory is empty or not found
;;;     ${DirState} $INSTDIR $R0
;;;     ${If} 1 != $R0
        ; Use the selected directory.
        StrCpy $dirDraft $INSTDIR
;;;     ${Else}
;;;         ; Make the user try again.
;;;         MessageBox MB_OK "The destination folder must be empty or not exist. Enter another destination folder." /SD IDOK
;;;         Abort
;;;     ${EndIf}

FunctionEnd

;-------------------------------
; MUI installer languages

    ; Offer many languages.
    !insertmacro MUI_LANGUAGE "English"
    !insertmacro MUI_LANGUAGE "Arabic"
    !insertmacro MUI_LANGUAGE "German"
    !insertmacro MUI_LANGUAGE "French"
    !insertmacro MUI_LANGUAGE "Italian"
    !insertmacro MUI_LANGUAGE "Russian"
    !insertmacro MUI_LANGUAGE "Spanish"
    !insertmacro MUI_LANGUAGE "SimpChinese"
    !insertmacro MUI_LANGUAGE "TradChinese"
    !insertmacro MUI_LANGUAGE "Japanese"
    !insertmacro MUI_LANGUAGE "Korean"
    !insertmacro MUI_LANGUAGE "Vietnamese"

;--------------------------------
    !insertmacro MUI_RESERVEFILE_LANGDLL ; Language selection dialog

;-------------------------------
; Installer section
; Install working copy (draft) of the YOW Free Sample repository.
Section "draft (required)" SecDraft
                                        ; Now there is a components page so the
                                        ; name is important.
    ; The RO means the section is a Read Only section so it is required.
    SectionIn RO
    SectionIn 1

    ; Initialize the temporary folder path.
    ; "This folder is automatically deleted when the installer exits."
    ; It variable is $PLUGINSDIR.
    InitPluginsDir

    ; Set output path to the installation directory.
    SetOutPath $dirDraft

;;; Do not install Git or the YOW Free Sample repository.
;;; These are not part of the DocFetcherPortableWithIndexSetup_1_0_0.exe.
;;; 2016 11 16
;;;     ;--------
;;;     ; Install Git if it is not already installed.
;;; 
;;;     ; Determine the Git install location if it is installed.
;;;     Var /Global GitInstallLocation
;;;     Var /Global GitInstallCheckAB
;;;     StrCpy $GitInstallCheckAB "CheckA"  ; This indicates first check.
;;; 
;;; TRY_AGAIN:
;;;     StrCpy $GitInstallLocation "placeholder value"
;;; 
;;;     ; This RunningX64 macro stuff is dependent on x64.nsh.
;;;     ${If} ${RunningX64}
;;;         # 64 bit code
;;;         SetRegView 64
;;;     ${Else}
;;;         # 32 bit code
;;;         SetRegView 32
;;;     ${EndIf}
;;; 
;;;     ; First look for Git installed for all users.
;;;     ReadRegStr $GitInstallLocation HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\ "InstallLocation"
;;;     IfErrors REG_READ_FAILURE_A REG_READ_SUCCESS
;;; REG_READ_FAILURE_A:
;;; 
;;;     ; Second look for Git installed just for the current user.
;;;     ReadRegStr $GitInstallLocation HKCU Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\ "InstallLocation"
;;;     IfErrors REG_READ_FAILURE_B REG_READ_SUCCESS
;;; REG_READ_FAILURE_B:
;;; 
;;;     ; Third look for a Git 32 bit install on a 64 bit OS and installed for all.
;;;     ${If} ${RunningX64}
;;;         # There is a chance that they installed the 32 bit Git.
;;;         # Check for it as well.
;;;         SetRegView 32
;;;         ReadRegStr $GitInstallLocation HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\ "InstallLocation"
;;;         IfErrors REG_READ_FAILURE_C REG_READ_SUCCESS
;;; REG_READ_FAILURE_C:
;;; 
;;;             # Fourth look for a Git 32 bit install on a 64 bit OS and installed
;;;             # just for the current user.
;;;             ReadRegStr $GitInstallLocation HKCU Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\ "InstallLocation"
;;;             IfErrors REG_READ_FAILURE_D REG_READ_SUCCESS
;;;                 Goto REG_READ_SUCCESS
;;;     ${Else}
;;;         StrCmpS $GitInstallCheckAB "CheckB" GIT_INSTALL_FAILED32 INSTALL_GIT32
;;; GIT_INSTALL_FAILED32:
;;;             MessageBox MB_OK "Git was not installed. ${DFP_LongName} install will halt now." /SD IDOK
;;;             Abort "Git must be installed to install ${DFP_LongName}."
;;; 
;;; INSTALL_GIT32:
;;;         # Assume by this that Git is not installed.
;;;         MessageBox MB_OK "Git is not installed. When you press OK the Git installer will start. It is best to use the default Git installer settings presented to you unless you have clear reasons to use other settings."
;;; ;       MessageBox MB_OK "Install 32 bit Git."
;;;         SetOutPath $PLUGINSDIR
;;;         SetRegView 32
;;;         File ..\data\Git-2.9.3-32-bit.exe
;;;         File ..\data\GitInf.txt
;;;         ExecWait '"Git-2.9.3-32-bit.exe" /LOADINF=GitInf.txt' $0
;;;         SetOutPath $dirDraft
;;; ;       Goto REG_READ_SUCCESS
;;;         StrCpy $GitInstallCheckAB "CheckB"  ; This indicates second check.
;;;         Goto TRY_AGAIN
;;;     ${EndIf}
;;; 
;;; REG_READ_FAILURE_D:
;;;     StrCmpS $GitInstallCheckAB "CheckB" GIT_INSTALL_FAILED64 INSTALL_GIT64
;;; GIT_INSTALL_FAILED64:
;;;     MessageBox MB_OK "Git was not installed. ${DFP_LongName} install will halt now." /SD IDOK
;;;     Abort "Git must be installed to install ${DFP_LongName}."
;;; 
;;; INSTALL_GIT64:
;;;     # Assume by this that Git is not installed.
;;;     MessageBox MB_OK "Git is not installed. When you press OK the Git installer will start. It is best to use the default Git installer settings presented to you unless you have clear reasons to use other settings."
;;; ;   MessageBox MB_OK "Install 64 bit Git."
;;;     SetOutPath $PLUGINSDIR
;;;     SetRegView 64
;;;     File ..\data\Git-2.9.3-64-bit.exe
;;;     File ..\data\GitInf.txt
;;;     ExecWait '"Git-2.9.3-64-bit.exe" /LOADINF=GitInf.txt' $0
;;;     SetOutPath $dirDraft
;;; ;   Goto REG_READ_SUCCESS
;;;     StrCpy $GitInstallCheckAB "CheckB"  ; This indicates second check.
;;;     Goto TRY_AGAIN
;;; 
;;; REG_READ_SUCCESS:
;;; ; The following message box is for debugging.
;;; ;   MessageBox MB_OK "Git is already installed. This is the Git install location: $GitInstallLocation"
;;; 
;;;     ;--------
;;;     ; Clone YOW Free Sample into the install directory.
;;;     ; Add files and folders to install here.
;;; 
;;;     ; This installs the YOW Free Sample Git repository.
;;;     SetOutPath $PLUGINSDIR
;;;     File install_repository.cmd
;;;     File install_repository.sh
;;; 
;;;     ; Install the repository.
;;;     ExecWait '"install_repository.cmd" $\"$GitInstallLocation$\" $\"$dirDraft$\"' $0
;;;     ; If the return value is 0
;;;     StrCmp "0" $0 0 INSTALLREPO_FAILURE
;;;         ; Print success on cloning text.
;;;         DetailPrint "Success: The repository is cloned."
;;;         Goto INSTALL_CONTINUE
;;; INSTALLREPO_FAILURE:
;;;         ; Print an error message to the detail list.
;;;         DetailPrint "Error: The repository is not cloned. Check that the clone source is"
;;;         DetailPrint "available and the destination directory is empty. Try again."
;;;         MessageBox MB_OK "Error: The repository is not cloned. Check that the clone source is available and the destination directory is empty. Try again." /SD IDOK
;;;         Abort
;;; 
;;; INSTALL_CONTINUE:
;;;     SetOutPath $dirDraft
;;;     File "..\data\Public_Domain_Dedication.txt"
;;; 
;;;     ; Get the last folder name in the dirDraft path.
;;;     ${GetFileName} "$dirDraft" $R0
;;; 
;;;     ; Create a shortcut to display the home page.
;;;     ; Name the shortcut with the last folder's name.
;;;     CreateShortCut "$R0.lnk" "$dirDraft\repository\index.html"
;;; 
;;;     ; Remember the installation folder.
;;;     WriteRegStr HKCU "Software\YOW\Free Sample" "InstallLocation" "$dirDraft"
;;; 
;;;     Call WriteInstallSearchChoice
;;; 
;;;     Call WriteShortcutChoice

SectionEnd

;-------------------------------
; Installer section
; Install Search.
Section "Install search" SecInstallSearch
    ; The 2 means the section is the second listed in the components page.
    SectionIn 2

;;; The license is displayed and asked about at the beginning of the 
;;; install. This message box is redundant.
;;;     MessageBox MB_YESNO "Do you accept the license for DocFetcher?" IDNO SkipDocFetcherInstall

    ; Install DocFetcher and related files.
    SetOutPath $PLUGINSDIR
    File ..\data\docfetcher-1.1.18-portable.zip
    SetOutPath $dirDraft

    ; Install DocFetcher Portable with an index for YFS.
    ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
    nsisunz::UnzipToLog "$PLUGINSDIR\docfetcher-1.1.18-portable.zip" "$INSTDIR"

    ; Always check the result on the stack.
    Pop $0
    StrCmp $0 "success" ok
        DetailPrint "$0" ; Print error message to log.
ok:

    ; Install the pregenerated indexed search for the YFS repository directory.
    SetOutPath $dirDraft\DocFetcher-1.1.18

    ; SetOverwrite on ; This is already the default state.
	File /a /r "..\data\DocFetcher-1.1.18\indexes"

SkipDocFetcherInstall:

SectionEnd

;-------------------------------
; Installer section
; Create the desktop shortcut.
Section "desktop shortcut" SecDesktopShortcut
    ; The 3 means the section is the third listed in the components page.
    SectionIn 3

    ; Get the last folder name in the dirDraft path.
    ${GetFileName} "$dirDraft" $R0
;;; This setup does not create anything directly to the repository.
;;; This includes shortcuts to pages in the repository.
;;;     ; Create a shortcut on the desktop to display the home page.
;;;     CreateShortCut "$DESKTOP\$R0.lnk" "$dirDraft\repository\index.html"

    SectionGetFlags ${SecInstallSearch} $R1
    IntOp $R2 $R1 & ${SF_SELECTED}
    ; If install search is selected
	${If} $R2 != 0
        ; Create a desktop shortcut to DocFetcher.
        ; Base the shortcut name on the last folder's name.
        CreateShortCut "$DESKTOP\$R0 Search.lnk" "$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"
    ${EndIf}

SectionEnd

;-------------------------------
; Installer section
; This is run after other installer sections because of its 
; placement lower in this file.
Section
    SectionGetFlags ${SecInstallSearch} $R3
    IntOp $R4 $R3 & ${SF_SELECTED}
    ; If install search is selected
	${If} $R4 != 0
        ; Create a shortcut to DocFetcher in the draft root folder.
        ; Base the shortcut name on the last folder's name.
        SetOutPath $dirDraft
        CreateShortCut "$R0 Search.lnk" "$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"
    ${EndIf}
SectionEnd

Function .onInstSuccess
    SectionGetFlags ${SecInstallSearch} $R3
    IntOp $R4 $R3 & ${SF_SELECTED}
;;; This is done per checkbox state now.
;;;     ; If install search is selected
;;; 	${If} $R4 != 0
;;;         ; Run the search so the user sees it.
;;;         Exec '"$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"'
;;;     ${EndIf}
FunctionEnd

;--------------------------------
; Descriptions

  ; Language strings
  LangString DESC_SecDraft ${LANG_ENGLISH} "Install YOW Free Sample pages and their Git repository. It is a clone of their repository on GitHub.$\r$\n$\r$\nEdit and commit these pages to create Your Own Web of pages."
  LangString DESC_SecInstallSearch ${LANG_ENGLISH} "Install the DocFetcher search program with an index for searching the YOW Free Sample (YFS) pages."
  LangString DESC_SecDesktopShortcut ${LANG_ENGLISH} "Create desktop shortcut(s)."

  ; Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDraft} $(DESC_SecDraft)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInstallSearch} $(DESC_SecInstallSearch)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktopShortcut} $(DESC_SecDesktopShortcut)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit

    Var /GLOBAL getParams
    Var /GLOBAL getDefault
    ${GetParameters} $getParams
    ${GetOptions} $getParams "/default=" $getDefault
    ; If /default=all is a command line parameter.
    ${If} "all" == "$getDefault"
        ; Remove all of the installer's registry settings.
        ; These are setup UI language and install path.
        DeleteRegKey /ifempty HKCU "Software\YOW\Free Sample"
    ${EndIf}
    ReadRegStr $0 HKCU "Software\YOW\Free Sample" "InstallLocation"
    StrCpy $dirDraft "$0"

    ReadEnvStr $homeDir HOMEDRIVE

    !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

Function WriteShortcutChoice
    ; Write the desktop shortcut creation choice to the registry.
    ; This is used to set the initial choice during the next install.
    SectionGetFlags ${SecDesktopShortcut} $0
    IntOp $0 $0 & ${SF_SELECTED}
    ${If} $0 == ${SF_SELECTED}
        WriteRegStr HKCU "Software\YOW\Free Sample" "CreateDesktopShortcut" "true"
    ${Else}
        WriteRegStr HKCU "Software\YOW\Free Sample" "CreateDesktopShortcut" "false"
    ${EndIf}
FunctionEnd

Function ReadShortcutChoice
    ; Read the desktop shortcut creation choice from the registry.
    ReadRegStr $0 HKCU "Software\YOW\Free Sample" "CreateDesktopShortcut"
    ; "" is returned if no entry exists. This makes 'else' checked default.
    ${If} $0 == "false"
        ; Lower the selected flag.
        SectionGetFlags ${SecDesktopShortcut} $0
        IntOp $0 $0 & ${SECTION_OFF}
        SectionSetFlags ${SecDesktopShortcut} $0
    ${Else}
        ; Raise the selected flag.
        SectionGetFlags ${SecDesktopShortcut} $0
        IntOp $0 $0 | ${SF_SELECTED}
        SectionSetFlags ${SecDesktopShortcut} $0
    ${EndIf}
FunctionEnd

Function WriteInstallSearchChoice
    ; Write the install search choice to the registry.
    ; This is used to set the initial choice during the next install.
    SectionGetFlags ${SecInstallSearch} $0
    IntOp $0 $0 & ${SF_SELECTED}
    ${If} $0 == ${SF_SELECTED}
        WriteRegStr HKCU "Software\YOW\Free Sample" "InstallSearch" "true"
    ${Else}
        WriteRegStr HKCU "Software\YOW\Free Sample" "InstallSearch" "false"
    ${EndIf}
FunctionEnd

Function ReadInstallSearchChoice
    ; Read the install search choice from the registry.
    ReadRegStr $0 HKCU "Software\YOW\Free Sample" "InstallSearch"
    ; "" is returned if no entry exists. This makes 'else' checked default.
    ${If} $0 == "false"
        ; Lower the selected flag.
        SectionGetFlags ${SecInstallSearch} $0
        IntOp $0 $0 & ${SECTION_OFF}
        SectionSetFlags ${SecInstallSearch} $0
    ${Else}
        ; Raise the selected flag.
        SectionGetFlags ${SecInstallSearch} $0
        IntOp $0 $0 | ${SF_SELECTED}
        SectionSetFlags ${SecInstallSearch} $0
    ${EndIf}
FunctionEnd

Function ReadComponentChoices
    Call ReadShortcutChoice

    Call ReadInstallSearchChoice

FunctionEnd
;===============================
