//This is a front-end famework about QQ music
//by quzhiyao 2023051604020

import QtQuick
import QtQuick.Controls
import "./MusicUi/Right"
import "./MusicUi/Left"
import "./MusicUi/Bottom"


Window {
    id: window
    width: 1317
    height: 933
    visible: true
    title: qsTr("QQMusic")
    flags: Qt.FramelessWindowHint | Qt.window | Qt.WindowSystemmenuHint |
           Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint

    //三个主要窗口
    LeftPage {
        id: leftRect
    }


    RightPage {
        id: rightRect
    }

    BottomPage {
        id: bottomRect
    }

    //调用初始化
    Actions{
        id:actions
    }

    Content {
        id:content
        anchors.fill: parent
    }

    //移动窗口
    MouseArea {
        anchors.fill: parent
        property point clickPos: Qt.point(0, 0)

        onPressed: function(mouse) {
            clickPos = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: function(mouse) {
            let detal = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            window.x += detal.x
            window.y += detal.y
        }
    }
}


