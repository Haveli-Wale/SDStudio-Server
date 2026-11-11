# NSIS Packaging
# see options at: https://cmake.org/cmake/help/latest/cpack_gen/nsis.html
set(CPACK_NSIS_PACKAGE_NAME "Shiv Digital Studio Desktop Server")
set(CPACK_NSIS_DISPLAY_NAME "Shiv Digital Studio Desktop Server")
set(CPACK_NSIS_BRANDING_TEXT "Shiv Digital Studio")
set(CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}/sunshine.ico")
set(CPACK_NSIS_MUI_UNIICON "${CMAKE_SOURCE_DIR}/sunshine.ico")

set(CPACK_NSIS_INSTALLED_ICON_NAME "${PROJECT__DIR}\\\\${PROJECT_EXE}")

# Enable detailed logging only on AMD64
if(CMAKE_SYSTEM_PROCESSOR MATCHES "AMD64")
    set(NSIS_LOGSET_COMMAND "LogSet on")
else()
    set(NSIS_LOGSET_COMMAND "")
endif()

# Extra install commands
# Runs the main setup script which handles all installation tasks
SET(CPACK_NSIS_EXTRA_INSTALL_COMMANDS
        "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
        ${NSIS_LOGSET_COMMAND}
        IfSilent +3 0
        nsExec::ExecToLog \
          'powershell -ExecutionPolicy Bypass \
          -File \\\"$INSTDIR\\\\scripts\\\\sunshine-setup.ps1\\\" -Action install'
        Goto +2
        nsExec::ExecToLog \
          'powershell -ExecutionPolicy Bypass \
          -File \\\"$INSTDIR\\\\scripts\\\\sunshine-setup.ps1\\\" -Action install -Silent'
        install_done:
        ")

# Extra uninstall commands
# Runs the main setup script which handles all uninstallation tasks
set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS
        "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
        ${NSIS_LOGSET_COMMAND}
        nsExec::ExecToLog \
          'powershell -ExecutionPolicy Bypass \
          -File \\\"$INSTDIR\\\\scripts\\\\sunshine-setup.ps1\\\" -Action uninstall'
        MessageBox MB_YESNO|MB_ICONQUESTION \
          'Do you want to remove $INSTDIR (this includes the configuration, cover images, and settings)?' \
          /SD IDNO IDNO no_delete
          RMDir /r \\\"$INSTDIR\\\"; skipped if no
        no_delete:
        ")

# Adding an option for the start menu
set(CPACK_NSIS_MODIFY_PATH OFF)
set(CPACK_NSIS_EXECUTABLES_DIRECTORY ".")
# This will be shown on the installed apps Windows settings
set(CPACK_NSIS_INSTALLED_ICON_NAME "SDStudio Server.exe")
set(CPACK_NSIS_CREATE_ICONS_EXTRA
        "${CPACK_NSIS_CREATE_ICONS_EXTRA}
        SetOutPath '\$INSTDIR'
        CreateShortCut '\$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\SDStudio Server.lnk' \
            '\$INSTDIR\\\\SDStudio Server.exe' '--shortcut'
        ")
set(CPACK_NSIS_DELETE_ICONS_EXTRA
        "${CPACK_NSIS_DELETE_ICONS_EXTRA}
        Delete '\$SMPROGRAMS\\\\$MUI_TEMP\\\\SDStudio Server.lnk'
        ")

# Checking for previous installed versions
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL "ON")

set(CPACK_NSIS_HELP_LINK "https://github.com/Haveli-Wale/SDStudio-Server/issues")
set(CPACK_NSIS_URL_INFO_ABOUT "${CMAKE_PROJECT_HOMEPAGE_URL}")
set(CPACK_NSIS_CONTACT "https://github.com/Haveli-Wale/SDStudio-Server/issues")

set(CPACK_NSIS_MENU_LINKS
        "https://github.com/Haveli-Wale/SDStudio-Server" "SDStudio Server GitHub"
        "https://github.com/Haveli-Wale/SDStudio-Server/issues" "Support and Issues")
set(CPACK_NSIS_MANIFEST_DPI_AWARE true)
