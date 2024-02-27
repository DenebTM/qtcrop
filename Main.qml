import QtQuick
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("vcrop: ") + (videoLoader.item ? videoLoader.item.ctx.filename : qsTr(
                                                     "No file"))

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
        active: ctx.filename.length > 0
        onLoaded: item.ctx = ctx

        anchors.fill: parent
    }
}
