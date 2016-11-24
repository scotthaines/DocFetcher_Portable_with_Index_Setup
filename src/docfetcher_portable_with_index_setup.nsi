;===============================
; file: docfetcher_portable_with_index_setup.nsi
; created: 2016 09 04, Scott Haines
; edit: 11 Scott Haines
; date: 2016 11 24
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
    Var /GLOBAL getDefault

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
!define MUI_FINISHPAGE_RUN "$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"
!define MUI_FINISHPAGE_RUN_TEXT "&Run DocFetcher with Index"
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
    ; If the passed parameter indicates use of installDir
    ${If} "installDir" == "$getDefault"
        ; Do not display the directory page.
        ; Directory page display is off.
        Abort   ; This blocks the display of the directory page.
    ${EndIf}
FunctionEnd

Function ADirLv
    ; Use the selected directory.
    StrCpy $dirDraft $INSTDIR
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
; Install Search.
Section "Install search" SecInstallSearch
    ; The RO means the section is a Read Only section so it is required.
    SectionIn RO
    SectionIn 1

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

SectionEnd

;-------------------------------
; Installer section
; Create the desktop shortcut.
Section "desktop shortcut" SecDesktopShortcut
    ; The 2 means the section is the second listed in the components page.
    SectionIn 2

    ; Get the last folder name in the dirDraft path.
    ${GetFileName} "$dirDraft" $R0

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
        ; Get the last folder name in the dirDraft path.
        ${GetFileName} "$dirDraft" $R0
        CreateShortCut "$R0 Search.lnk" "$dirDraft\DocFetcher-1.1.18\DocFetcher.exe"
    ${EndIf}
SectionEnd

Function .onInstSuccess
    SectionGetFlags ${SecInstallSearch} $R3
    IntOp $R4 $R3 & ${SF_SELECTED}
FunctionEnd

;--------------------------------
; Descriptions

  ; Language strings
  LangString DESC_SecInstallSearch ${LANG_ENGLISH} "Install the DocFetcher search program with an index for searching the YOW Free Sample (YFS) pages."
  LangString DESC_SecDesktopShortcut ${LANG_ENGLISH} "Create desktop shortcut(s)."

  ; Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInstallSearch} $(DESC_SecInstallSearch)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktopShortcut} $(DESC_SecDesktopShortcut)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit

    Var /GLOBAL getParams
    Var /GLOBAL displayDirectoryPage
    StrCpy $displayDirectoryPage "true"

    ${GetParameters} $getParams
    ${GetOptions} $getParams "/default=" $getDefault
    ; If /default=all is a command line parameter.
    ${If} "all" == "$getDefault"
        ; Remove all of the installer's registry settings.
        ; These are setup UI language and install path.
        DeleteRegKey /ifempty HKCU "Software\YOW\DFPWithIndex"
    ${EndIf}
    ; If /default=installDir is a command line parameter.
    ${If} "installDir" == "$getDefault"
        ; Directory page display is off.
        StrCpy $displayDirectoryPage "false"
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
        WriteRegStr HKCU "Software\YOW\DFPWithIndex" "CreateDesktopShortcut" "true"
    ${Else}
        WriteRegStr HKCU "Software\YOW\DFPWithIndex" "CreateDesktopShortcut" "false"
    ${EndIf}
FunctionEnd

Function ReadShortcutChoice
    ; Read the desktop shortcut creation choice from the registry.
    ReadRegStr $0 HKCU "Software\YOW\DFPWithIndex" "CreateDesktopShortcut"
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

Function ReadComponentChoices
    Call ReadShortcutChoice
FunctionEnd
;===============================
