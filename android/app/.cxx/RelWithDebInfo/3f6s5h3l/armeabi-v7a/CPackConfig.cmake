# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


set(CPACK_BUILD_SOURCE_DIRS "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android;/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android/app/.cxx/RelWithDebInfo/3f6s5h3l/armeabi-v7a")
set(CPACK_CMAKE_GENERATOR "Ninja")
set(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
set(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Taku Kudo")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_FILE "/Users/afridee/Library/Android/sdk/cmake/3.18.1/share/cmake-3.18/Templates/CPack.GenericDescription.txt")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_SUMMARY "MyChatbotProject built using CMake")
set(CPACK_GENERATOR "7Z")
set(CPACK_INSTALL_CMAKE_PROJECTS "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android/app/.cxx/RelWithDebInfo/3f6s5h3l/armeabi-v7a;MyChatbotProject;ALL;/")
set(CPACK_INSTALL_PREFIX "/usr/local")
set(CPACK_MODULE_PATH "")
set(CPACK_NSIS_DISPLAY_NAME "MyChatbotProject 0.2.1")
set(CPACK_NSIS_INSTALLER_ICON_CODE "")
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
set(CPACK_NSIS_PACKAGE_NAME "MyChatbotProject 0.2.1")
set(CPACK_NSIS_UNINSTALL_NAME "Uninstall")
set(CPACK_OUTPUT_CONFIG_FILE "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android/app/.cxx/RelWithDebInfo/3f6s5h3l/armeabi-v7a/CPackConfig.cmake")
set(CPACK_PACKAGE_CONTACT "taku@google.com")
set(CPACK_PACKAGE_DEFAULT_LOCATION "/")
set(CPACK_PACKAGE_DESCRIPTION_FILE "/Users/afridee/Library/Android/sdk/cmake/3.18.1/share/cmake-3.18/Templates/CPack.GenericDescription.txt")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "MyChatbotProject built using CMake")
set(CPACK_PACKAGE_FILE_NAME "MyChatbotProject-0.2.1-Android")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "MyChatbotProject 0.2.1")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "MyChatbotProject 0.2.1")
set(CPACK_PACKAGE_NAME "MyChatbotProject")
set(CPACK_PACKAGE_RELOCATABLE "true")
set(CPACK_PACKAGE_VENDOR "Humanity")
set(CPACK_PACKAGE_VERSION "0.2.1")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "2")
set(CPACK_PACKAGE_VERSION_PATCH "1")
set(CPACK_RESOURCE_FILE_LICENSE "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/external/sentencepiece/LICENSE")
set(CPACK_RESOURCE_FILE_README "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/external/sentencepiece/README.md")
set(CPACK_RESOURCE_FILE_WELCOME "/Users/afridee/Library/Android/sdk/cmake/3.18.1/share/cmake-3.18/Templates/CPack.GenericWelcome.txt")
set(CPACK_SET_DESTDIR "OFF")
set(CPACK_SOURCE_GENERATOR "TXZ")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/.git/;/dist/;/sdist/;~$;")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android/app/.cxx/RelWithDebInfo/3f6s5h3l/armeabi-v7a/CPackSourceConfig.cmake")
set(CPACK_STRIP_FILES "TRUE")
set(CPACK_SYSTEM_NAME "Android")
set(CPACK_TOPLEVEL_TAG "Android")
set(CPACK_WIX_SIZEOF_VOID_P "4")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "/Users/afridee/StudioProjects/biologyChatBotMigrated/biologychatbot/android/app/.cxx/RelWithDebInfo/3f6s5h3l/armeabi-v7a/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()
