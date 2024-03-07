cmake_minimum_required(VERSION 3.16)

project(qtcrop VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup()

qt_add_executable(qtcrop
    main.cpp
)

qt_add_qml_module(qtcrop
    URI qtcrop_qml
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES CropRectangle.qml
    QML_FILES
    QML_FILES Welcome.qml
    QML_FILES CropInterface.qml
    SOURCES context_obj.h
    QML_FILES TrimProgressBar.qml
    SOURCES context_obj.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(qtcrop PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.qtcrop
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(qtcrop
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS qtcrop
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
