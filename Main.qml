import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Video {
                id: video
                source: "file:///home/deneb/Videos/boxdance.mp4"
                focus: true

                anchors.centerIn: parent

                Keys.onSpacePressed: video.playbackState
                                     == MediaPlayer.PlayingState ? video.pause(
                                                                       ) : video.play()

                CropRectangle {
                    id: cropRect

                    anchors.fill: parent
                }
            }
        }

        RowLayout {
            Slider {
                id: videoProgress

                from: 0
                to: video.duration
                value: video.position
                Layout.fillWidth: true

                onMoved: {
                    video.position = value
                }
            }

            Button {
                text: "Crop"
                onClicked: eee.crop(cropRect.cropX, cropRect.cropY,
                                    cropRect.cropWidth, cropRect.cropHeight)
            }
        }
    }
}
