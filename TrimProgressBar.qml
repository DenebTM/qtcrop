import QtQuick

Item {
    id: root

    required property real from
    required property real to
    required property real value

    required property real trimStart
    required property real trimEnd

    readonly property real barScale: root.width / (to - from)

    readonly property alias playHandleDragActive: area.drag.active
    signal playHandleMoved

    signal playHandlePressed
    signal playHandleReleased

    SystemPalette {
        id: palette
    }

    Rectangle {
        id: backdropFull

        anchors.left: root.left
        anchors.right: root.right
        anchors.verticalCenter: root.verticalCenter
        height: 5

        color: palette.base

        Rectangle {
            id: backdropTrim

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            x: root.trimStart * root.barScale
            width: (root.trimEnd - root.trimStart) * root.barScale
            height: 20

            color: palette.midlight
        }

        Rectangle {
            id: backdropProgress

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            x: 0
            width: (root.value - root.from) * root.barScale

            color: palette.highlight

            Rectangle {
                id: playbackHandle

                width: 5
                height: 10

                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter
                states: State {
                    name: "dragged"
                    when: area.pressed
                    AnchorChanges {
                        target: playbackHandle
                        anchors.horizontalCenter: undefined
                    }
                }

                MouseArea {
                    id: area

                    anchors.fill: parent

                    drag.threshold: 0
                    drag.target: parent
                    drag.axis: Drag.XAxis
                    drag.minimumX: root.trimStart * root.barScale
                    drag.maximumX: root.trimEnd * root.barScale

                    // root.value is set by handle while dragged; restored
                    // to previous value/binding afterwards
                    Binding {
                        when: area.drag.active
                        root.value: playbackHandle.x / root.barScale
                        restoreMode: Binding.RestoreBindingOrValue
                    }

                    onPositionChanged: root.playHandleMoved()

                    onPressed: root.playHandlePressed()
                    onReleased: root.playHandleReleased()
                }
            }
        }
    }

    component TrimHandle: Rectangle {
        MouseArea {
            drag.target: parent
            drag.axis: Qt.XAxis

            cursorShape: Qt.SizeHorCursor
        }
    }

    TrimHandle {
        id: handleTrimStart
    }

    TrimHandle {
        id: handleTrimEnd
    }
}
