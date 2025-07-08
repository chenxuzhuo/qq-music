import QtQuick

Rectangle {
    id: rightRect
    height: 800
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: leftRect.right
    anchors.bottom: bottomRect.top
    color: "#2C2C2C"
}
