import QtQuick
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }

    color: palette.window

    Loader {
        id: placeholderLoader
        source: "Welcome.qml"
        active: !videoLoader.active
        onLoaded: item.ctx = ctx

        anchors.centerIn: parent
    }

    Loader {
        id: videoLoader
        source: "CropInterface.qml"
        active: false
        onLoaded: item.ctx = ctx

        anchors.fill: parent
    }
}
