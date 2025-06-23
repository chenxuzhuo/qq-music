//A front-end about QQ music
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

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
            width: 250  // 固定宽度
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                margins: 20
            }
            color: "#FFFFFF"


        ColumnLayout{
            spacing:30
            RowLayout{
                Layout.fillWidth: true
                Rectangle {
                    width: 44
                    height: 44
                    radius: width / 2  // 设置为圆形
                    color: "transparent"  // 透明背景
                    clip: true  // 裁剪超出部分
                    Image{
                        // width:44
                        // height:44
                        anchors.fill: parent
                        source:"file:///root/qq-music/image/04.jpg"
                        sourceSize: Qt.size(44,44)
                    }
                }
                Button{
                    text:qsTr("点击登陆")
                    width:100
                    height:44
                }
            }


            RowLayout {
                id:row
                spacing: 10

                // 左侧项目
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: mouseArea1.containsMouse ? "#e0e0e0" : "#f0f0f0"

                    Image {
                        source: "file:///root/qq-music/image/first.png"
                        width: 44
                        height: 44
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: mouseArea1
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("首页点击")
                    }
                }

                // 右侧项目
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: mouseArea2.containsMouse ? "#e0e0e0" : "#f0f0f0"

                    Image {
                        source: "file:///root/qq-music/image/music.png"
                        width: 44
                        height: 44
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: mouseArea2
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("乐馆点击")
                    }
                }
            }

            Shape {
                width: 240
                height: 50

                ShapePath {
                    strokeColor: "gray"
                    strokeWidth: 2
                    strokeStyle: ShapePath.DashLine
                    dashPattern: [4, 2]
                    fillColor: "transparent"

                    // 修正后的路径坐标（适应200x50尺寸）
                    startX: 10; startY: 5  // 顶部留出2px边距（strokeWidth/2）
                    PathLine { x: 220; y: 5 }  // 200宽度 - 10边距 = 190
                    PathLine { x: 220; y: 40 }  // 50高度 - 5边距 = 45
                    PathLine { x: 10; y: 40 }
                    PathLine { x: 10; y: 5 }
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: "file:///root/qq-music/image/plus.png"
                    width: 22
                    height: 22
                    // 添加点击穿透属性（防止拦截事件）
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        onClicked:console.log("aaa")
                    }
                }
            }
        }
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
            Row{
                id:miniRow
                spacing:15
                anchors.verticalCenter:parent.verticalCenter
                anchors.right:parent.right
                anchors.rightMargin:0.02*window.width
                //投屏
                Image {
                    id: miniImg
                    anchors.verticalCenter:parent.verticalCenter
                    source: "file:///root/qqMusic/Resources/title/toupin.png"
                    height:30
                    width:30
                    MouseArea{
                        anchors.fill:parent
                        hoverEnabled:true
                        onEntered:{
                            miniImg.layer.enabled = true
                        }
                        onExited:{
                            miniImg.layer.enabled = false
                        }
                        onClicked:{
                            //waiting
                        }
                    }
                }

                //small
                Rectangle{
                    id:miniRect
                    width:20
                    height:2
                    anchors.verticalCenter:parent.verticalCenter
                    color:"#75777f"
                    MouseArea{
                        anchors.fill:parent
                        hoverEnabled:true
                        onEntered:{
                            miniRect.color = "#2C2C2C"
                        }
                        onExited:{
                            miniRect.color = "#75777f"
                        }
                        onClicked:{
                            window.showMinimized()
                        }
                    }
                }
                //big
                Rectangle{
                    id:maxRect
                    width:20
                    height:width
                    border.width:1
                    border.color:"#75777f"
                    color:"transparent"
                    anchors.verticalCenter:parent.verticalCenter
                    MouseArea{
                        anchors.fill:parent
                        hoverEnabled:true
                        onEntered:{
                            maxRect.border.color = "#969696"
                        }
                        onExited:{
                            maxRect.border.color = "#75777f"
                        }
                        onClicked:{
                            window.showFullScreen()
                        }
                    }
                }
                //close
                Image {
                    id: closeImg
                    source: "file:///root/qqMusic/Resources/title/close.png"
                    height:30
                    width:30
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Qt.quit()
                        }
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


