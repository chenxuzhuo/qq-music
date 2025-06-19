//A front-end about QQ music
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 1317
    height: 933
    visible: true
    title: qsTr("QQMusic")
    flags: Qt.FramelessWindowHint | Qt.window | Qt.WindowSystemmenuHint |
           Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint

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

        Rectangle{
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.top:parent.top
            height:60
            RowLayout{
                anchors.right:parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 0.02*window.width
                spacing:15
                Button {
                    id: exitButton
                    icon.name: "dialog-error"
                    width: 32
                    height: 32
                    onClicked: {
                        console.log("Exiting...")  // 调试输出
                        Qt.quit()
                    }
                }
            }
        }
    }

    Qbottom {
        id: bottomRect

        anchors.top: rightRect.bottom
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: parent.bottom
    }
}


