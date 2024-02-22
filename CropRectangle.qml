import QtQuick

Item {
    id: root

    property int cropMinWidth: 10
    property int cropMinHeight: 10

    property alias cropX: cropArea.x
    property alias cropY: cropArea.y
    property alias cropWidth: cropArea.width
    property alias cropHeight: cropArea.height

    property int dragHandleVisibleWidth: 9
    property int dragHandleClickableWidth: 17
    property color dragHandleColor: "pink"

    property color overlayColor: "black"
    property real overlayOpacity: 0.75

    property real prevWidth: width
    property real prevHeight: width
    function updateCrop(newSize, prevSize, cropStart, cropSize, cropMin) {
        if (cropSize === prevSize) {
            cropSize = newSize
        } else if (newSize === -1) {
            cropStart = -1
            cropSize = -1
        } else {
            if (cropStart > newSize) {
                cropStart = newSize - cropSize
            }
            if (cropStart < 0) {
                cropStart = 0
            }
            if (cropStart + cropSize > newSize) {
                cropSize = newSize - cropStart
            }
            if (cropSize < cropMin && newSize >= cropMin) {
                cropSize = cropMin
            }
        }

        return [cropStart, cropSize, newSize]
    }
    onWidthChanged: {
        [cropX, cropWidth, prevWidth] = updateCrop(width, prevWidth, cropX,
                                                   cropWidth, cropMinWidth)
    }
    onHeightChanged: {
        [cropY, cropHeight, prevHeight] = updateCrop(height, prevHeight, cropY,
                                                     cropHeight, cropMinHeight)
    }

    Rectangle {
        id: cropArea

        color: "transparent"
        border.color: dragHandleColor
        border.width: 1

        width: root.width
        height: root.height

        MouseArea {
            anchors.fill: parent
            drag.target: cropArea
            drag.threshold: 0
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: root.width - cropArea.width
            drag.maximumY: root.height - cropArea.height
        }
    }

    component OverlayRect: Rectangle {
        color: overlayColor
        opacity: overlayOpacity
    }
    OverlayRect {
        id: overlayTop
        anchors.top: root.top
        anchors.right: cropArea.right
        anchors.bottom: cropArea.top
        anchors.left: cropArea.left
    }
    OverlayRect {
        id: overlayRight
        anchors.top: root.top
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.left: cropArea.right
    }
    OverlayRect {
        id: overlayBottom
        anchors.top: cropArea.bottom
        anchors.right: cropArea.right
        anchors.bottom: root.bottom
        anchors.left: cropArea.left
    }
    OverlayRect {
        id: overlayLeft
        anchors.top: root.top
        anchors.right: cropArea.left
        anchors.bottom: root.bottom
        anchors.left: root.left
    }

    component DragHandle: Item {
        id: handle

        property bool isLeft: false
        property bool isTop: false
        property alias axis: area.drag.axis
        property alias cursor: area.cursorShape

        // the visible handle
        Rectangle {
            anchors.centerIn: parent
            color: dragHandleColor
            width: dragHandleVisibleWidth
            height: dragHandleVisibleWidth
        }

        MouseArea {
            id: area

            anchors.centerIn: parent
            width: parent.width + dragHandleClickableWidth
            height: parent.height + dragHandleClickableWidth
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            drag.target: parent
            drag.threshold: 0
            drag.minimumX: isLeft ? 0 : initialCropXmin + cropMinWidth
            drag.maximumX: isLeft ? initialCropXmax - cropMinWidth : root.width
            drag.minimumY: isTop ? 0 : initialCropYmin + cropMinHeight
            drag.maximumY: isTop ? initialCropYmax - cropMinHeight : root.height

            property real initialCropXmin: cropArea.x
            property real initialCropXmax: cropArea.x
            property real initialCropYmin: cropArea.y
            property real initialCropYmax: cropArea.height
            onPressed: {
                initialCropXmin = cropArea.x
                initialCropXmax = cropArea.x + cropArea.width
                initialCropYmin = cropArea.y
                initialCropYmax = cropArea.y + cropArea.height
            }

            property real prevX
            property real prevY
            onPositionChanged: {
                if (pressed) {
                    const dX = parent.x - prevX
                    const dY = parent.y - prevY

                    if (isLeft) {
                        cropArea.x += dX
                        cropArea.width -= dX
                    } else {
                        cropArea.width += dX
                    }

                    if (isTop) {
                        cropArea.y += dY
                        cropArea.height -= dY
                    } else {
                        cropArea.height += dY
                    }
                }

                prevX = parent.x
                prevY = parent.y
            }
        }

        states: State {
            name: "dragged"
            when: area.pressed
            AnchorChanges {
                target: handle
                anchors.top: undefined
                anchors.right: undefined
                anchors.bottom: undefined
                anchors.left: undefined
            }
        }
    }
    DragHandle {
        id: tHandle

        anchors.left: cropArea.left
        anchors.bottom: cropArea.top
        width: cropArea.width

        axis: Drag.YAxis
        isTop: true
        cursor: Qt.SizeVerCursor
    }
    DragHandle {
        id: rHandle

        anchors.left: cropArea.right
        anchors.top: cropArea.top
        height: cropArea.height

        axis: Drag.XAxis
        cursor: Qt.SizeHorCursor
    }
    DragHandle {
        id: bHandle

        anchors.left: cropArea.left
        anchors.top: cropArea.bottom
        width: cropArea.width

        axis: Drag.YAxis
        cursor: Qt.SizeVerCursor
    }
    DragHandle {
        id: lHandle

        anchors.right: cropArea.left
        anchors.top: cropArea.top
        height: cropArea.height

        axis: Drag.XAxis
        isLeft: true
        cursor: Qt.SizeHorCursor
    }
    DragHandle {
        id: trHandle

        anchors.left: cropArea.right
        anchors.bottom: cropArea.top

        axis: Drag.XAndYAxis
        isTop: true
        cursor: Qt.SizeBDiagCursor
    }
    DragHandle {
        id: brHandle

        anchors.left: cropArea.right
        anchors.top: cropArea.bottom

        axis: Drag.XAndYAxis
        cursor: Qt.SizeFDiagCursor
    }
    DragHandle {
        id: blHandle

        anchors.right: cropArea.left
        anchors.top: cropArea.bottom

        axis: Drag.XAndYAxis
        isLeft: true
        cursor: Qt.SizeBDiagCursor
    }
    DragHandle {
        id: tlHandle

        anchors.right: cropArea.left
        anchors.bottom: cropArea.top

        axis: Drag.XAndYAxis
        isTop: true
        isLeft: true
        cursor: Qt.SizeFDiagCursor
    }
}
