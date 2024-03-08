import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ColumnLayout {
    id: root

    // context object
    property var ctx

    spacing: 5

    Connections {
        target: ctx
        onFfmpegDone: saveButton.enabled = true
        onSaveCancelled: saveButton.enabled = true
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Video {
            id: video

            source: "file://" + root.ctx.filename

            function getScale() {
                const resolution = metaData.value(MediaMetaData.Resolution)
                if (typeof resolution === 'undefined')
                    return 1

                return resolution.width / getSize().width
            }

            function getSize() {
                const resolution = metaData.value(MediaMetaData.Resolution)
                if (typeof resolution === 'undefined')
                    return [0, 0]

                const aspect = resolution.height / resolution.width

                let outWidth = parent.width
                let outHeight = outWidth * aspect

                if (outHeight > parent.height) {
                    outHeight = parent.height
                    outWidth = outHeight / aspect
                }

                return {
                    "width": outWidth,
                    "height": outHeight
                }
            }

            anchors.centerIn: parent
            width: getSize().width
            height: getSize().height

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
            text: video.playbackState === MediaPlayer.PlayingState ? "\u2016" : "\u25B6"
            onClicked: video.playPause()

            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
        }

        TrimProgressBar {
            id: videoProgress

            Layout.fillWidth: true

            from: 0
            to: video.duration
            value: video.position

            onPlayHandleMoved: {
                video.position = value
            }

            property var prevPlaybackState
            onPlayHandlePressed: {
                prevPlaybackState = video.playbackState
                video.pause()
            }
            onPlayHandleReleased: {
                if (prevPlaybackState == MediaPlayer.PlayingState) {
                    video.play()
                }
            }

            trimStart: video.duration * 0.2
            trimEnd: video.duration * 0.8
        }

        Button {
            id: saveButton

            text: qsTr("Save")
            onClicked: {
                enabled = false

                const scale = video.getScale()
                const outRect = {
                    "x": Math.round(cropRect.cropX * scale),
                    "y": Math.round(cropRect.cropY * scale),
                    "width": Math.round(cropRect.cropWidth * scale),
                    "height": Math.round(cropRect.cropHeight * scale)
                }

                root.ctx.saveCropAs(outRect.x, outRect.y, outRect.width,
                                    outRect.height)
            }

            Layout.preferredHeight: 30
        }
    }
}
