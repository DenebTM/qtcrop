import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

ColumnLayout {
    id: root

    // context object
    property var ctx

    Text {
        Layout.alignment: Qt.AlignCenter
        text: "Select a video to start"
        color: palette.text
    }

    Button {
        Layout.alignment: Qt.AlignCenter
        text: "Open..."
        onClicked: videoSelect.open()

        FileDialog {
            id: videoSelect
            currentFolder: StandardPaths.standardLocations(
                               StandardPaths.MoviesLocation)[0]
            nameFilters: ["Video files (*.mp4 *.mov *.mkv *.webm *.avi *.wmv *.mpg *.mpeg *.3gp *.3gpp)"]

            onAccepted: {
                const url = new URL(selectedFile)
                root.ctx.filename = url.pathname
                videoLoader.active = true
            }
        }
    }
}
