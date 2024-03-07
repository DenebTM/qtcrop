import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: root

    // context object
    property var ctx

    Connections {
        target: root.ctx
        onFilenameChanged: videoLoader.active = true
    }

    SystemPalette {
        id: palette
    }

    ColumnLayout {
        anchors.centerIn: parent

        Text {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Select or drop a video here to start")
            color: palette.text
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Open...")
            onClicked: root.ctx.chooseFile()
        }
    }

    DropArea {
        anchors.fill: parent

        onDropped: event => {
                       if (event.urls.length > 0) {
                           const url = new URL(event.urls[0])
                           root.ctx.filename = url.pathname
                       }
                   }
    }
}
