import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

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

    onClosing: video.stop()

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Video {
                id: video
                source: "file://" + eee.filename
                focus: true

                anchors.centerIn: parent

                function playPause() {
                    if (playbackState == MediaPlayer.PlayingState)
                        video.pause()
                    else
                        video.play()
                }

                Keys.onSpacePressed: playPause()

                CropRectangle {
                    id: cropRect

                    anchors.fill: parent

                    dragHandleColor: palette.highlight
                }
            }
        }

        RowLayout {
            Layout.margins: parent.spacing

            Button {
                // TODO: use State
                text: video.playbackState == MediaPlayer.PlayingState ? "\u2016" : "\u25B6"
                onClicked: video.playPause()

                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
            }

            Slider {
                id: videoProgress

                from: 0
                to: video.duration
                value: video.position
                Layout.fillWidth: true

                onMoved: video.position = value
            }

            Button {
                text: qsTr("Crop")
                onClicked: eee.crop(cropRect.cropX, cropRect.cropY,
                                    cropRect.cropWidth, cropRect.cropHeight)
                Layout.preferredHeight: 30
            }
        }
    }
}
