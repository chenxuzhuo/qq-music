import QtQuick

Rectangle {
    id: bottomRect
    anchors.top: rightRect.bottom
    anchors.right: parent.right
    anchors.left: leftRect.right
    anchors.bottom: parent.bottom
    color: "#F5F5F5"
}
