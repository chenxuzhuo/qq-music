//A front-end about QQ music
import QtQuick

Window {
    id: window
    width: 1317
    height: 933
    visible: true
    title: qsTr("QQMusic")
    flags: Qt.FramelessWindowHint | Qt.window | Qt.WindowSystemmenuHint |
           Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint

    //三个主要窗口
    Rectangle {
        id: leftRect

        width: 250

        anchors.top: parent.top
        anchors.right: rightRect.left
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        color: "#FFFFFF"
    }

    Rectangle {
        id: rightRect

        height: 800

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: bottomRect.top

        color: "#2C2C2C"
    }

    Rectangle {
        id: bottomRect

        anchors.top: rightRect.bottom
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: parent.bottom

        color: "#F5F5F5"
    }

    // 窗口拖动
    MouseArea {
        anchors.fill: parent
        property point clickPos: Qt.point(0, 0)

        // 捕捉鼠标按下事件
        onPressed: function(mouse) {
            clickPos = Qt.point(mouse.x, mouse.y)
        }

        // 捕捉鼠标位置变化事件
        onPositionChanged: function(mouse) {
            let delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            window.x += delta.x
            window.y += delta.y
        }
    }
}


