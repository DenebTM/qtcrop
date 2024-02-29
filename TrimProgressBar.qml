import QtQuick

Item {
    id: root

    required property real from
    required property real to
    required property real value

    required property real trimStart
    required property real trimEnd

    readonly property real barScale: root.width / (to - from)

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

            x: trimStart * barScale
            width: (trimEnd - trimStart) * barScale
            height: 20

            color: palette.light
        }

        Rectangle {
            id: backdropProgress

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            x: 0
            width: (value - from) * barScale

            color: palette.highlight

            Rectangle {
                id: playbackHandle

                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter

                width: 5
                height: 10
            }
        }
    }

    component TrimHandle: Rectangle {}

    TrimHandle {
        id: handleTrimStart
    }

    TrimHandle {
        id: handleTrimEnd
    }
}
