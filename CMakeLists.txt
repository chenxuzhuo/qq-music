cmake_minimum_required(VERSION 3.28.2)

project(QQMusic VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appQQMusic
    main.cpp
)

qt_add_qml_module(appQQMusic
    URI "se.lrcfilereader"
    VERSION 1.0
    QML_FILES Main.qml
    RESOURCES
    QML_FILES Player.qml
    QML_FILES MoveSlider.qml
    QML_FILES Qbottom.qml
    QML_FILES Volume.qml
    QML_FILES

    QML_FILES
    QML_FILES
    QML_FILES
    QML_FILES Qleft.qml
    QML_FILES Qright.qml

    QML_FILES Functions.qml
    SOURCES lrcfilereader.h lrcfilereader.cpp
    QML_FILES
    QML_FILES
    QML_FILES
    RESOURCES source.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQQMusic PROPERTIES
    AUTORCC TRUE
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQQMusic
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQQMusic
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appQQMusic
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
