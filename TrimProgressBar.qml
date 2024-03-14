import QtQuick

Item {
    id: root

    function middleOf(item) {
        return Math.round(item.x + (item.width / 2))
    }

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
        }

        Rectangle {
            id: handlePlayback

            width: 5
            height: 10

            anchors.horizontalCenter: backdropProgress.right
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: handleTrimStart

            width: 5
            height: 10

            anchors.horizontalCenter: backdropTrim.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: handleTrimEnd

            width: 5
            height: 10

            anchors.horizontalCenter: backdropTrim.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: area

        anchors.fill: backdropFull

        drag.threshold: 0
        drag.target: undefined
        drag.axis: Drag.XAxis
        drag.minimumX: root.trimStart * root.barScale - (handlePlayback.width / 2)
        drag.maximumX: root.trimEnd * root.barScale - (handlePlayback.width / 2)

        onPositionChanged: root.playHandleMoved()

        onPressed: {
            drag.target = getDragTarget()
            root.playHandlePressed()
        }

        onReleased: {
            drag.target = undefined
            root.playHandleReleased()
        }

        readonly property real dragThreshold: 10
        function getDragTarget() {
            for (const handle of [handleTrimEnd, handleTrimStart]) {
                if (Math.abs(mouseX - middleOf(handle)) <= dragThreshold)
                    return handle
            }

            return handlePlayback
        }
    }

    // root.value is set by handle while dragged; restored
    // to previous value/binding afterwards
    Binding {
        when: area.drag.active
        root.value: root.middleOf(handlePlayback) / root.barScale
        restoreMode: Binding.RestoreBindingOrValue
    }

    states: State {
        name: "dragged"
        when: area.pressed
        AnchorChanges {
            target: handlePlayback
            anchors.horizontalCenter: undefined
        }
        AnchorChanges {
            target: handleTrimStart
            anchors.horizontalCenter: undefined
        }
        AnchorChanges {
            target: handleTrimEnd
            anchors.horizontalCenter: undefined
        }
    }
}
