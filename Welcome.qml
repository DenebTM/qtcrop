import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

ColumnLayout {
    id: root

    // context object
    property var ctx

    Connections {
        target: root.ctx
        onFilenameChanged: videoLoader.active = true
    }

    Text {
        Layout.alignment: Qt.AlignCenter
        text: "Select a video to start"
        color: palette.text
    }

    Button {
        Layout.alignment: Qt.AlignCenter
        text: "Open..."
        onClicked: root.ctx.chooseFile()
    }
}
