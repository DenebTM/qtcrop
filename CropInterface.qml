import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ColumnLayout {
    // context object
    property var ctx

    spacing: 5

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Video {
            id: video

            source: "file://" + ctx.filename

            anchors.centerIn: parent
            width: metaData.value(MediaMetaData.Resolution).width ?? 0
            height: metaData.value(MediaMetaData.Resolution).height ?? 0

            function playPause() {
                if (playbackState == MediaPlayer.PlayingState)
                    video.pause()
                else
                    video.play()
            }

            CropRectangle {
                id: cropRect

                anchors.fill: parent

                SystemPalette {
                    id: palette
                    colorGroup: SystemPalette.Active
                }
                dragHandleColor: palette.highlight
            }

            muted: true
            Component.onCompleted: play()

            // prevents a segfault
            Component.onDestruction: stop()
        }
    }

    RowLayout {
        Layout.margins: parent.spacing

        Button {
            // TODO: use State
            text: (video
                   && video.playbackState === MediaPlayer.PlayingState) ? "\u2016" : "\u25B6"
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
            onClicked: ctx.crop(cropRect.cropX, cropRect.cropY,
                                cropRect.cropWidth, cropRect.cropHeight)
            Layout.preferredHeight: 30
        }
    }
}
