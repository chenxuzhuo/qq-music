import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.folderlistmodel
import QtQuick.Shapes

//三个主要窗口
Rectangle {
    id: leftRect
    width: parent.width
    height: parent.height
    color: "#FFFFFF"

    // 接收外部传递的展开状态
    property bool listExpanded: true
    signal toggleList()  // 声明切换信号

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
                TapHandler {
                    onTapped: console.log("头像点击")
                }
            }
            Button{
                text:qsTr("点击登陆")
                width:100
                height:44
            }
        }

        // 导航按钮行
        RowLayout {
            id: row
            spacing: 10
            Layout.fillWidth: true

            // 首页按钮
            Rectangle {
                id: homeRect
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: homeHover.hovered ? "#e0e0e0" : "#f0f0f0"

                Image {
                    source: "file:///root/qq-music/image/first.png"
                    width: 44
                    height: 44
                    anchors.centerIn: parent
                }

                HoverHandler {
                    id: homeHover
                }

                TapHandler {
                    onTapped: console.log("首页点击")
                }
            }

            // 乐馆按钮
            Rectangle {
                id: musicRect
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: musicHover.hovered ? "#e0e0e0" : "#f0f0f0"

                Image {
                    source: "file:///root/qq-music/image/music.png"
                    width: 44
                    height: 44
                    anchors.centerIn: parent
                }

                HoverHandler {
                    id: musicHover
                }

                TapHandler {
                    onTapped: console.log("乐馆点击")
                }
            }
        }

        Shape {
            width: 220
            height: 50

            ShapePath {
                strokeColor: "gray"
                strokeWidth: 2
                strokeStyle: ShapePath.DashLine
                dashPattern: [4, 2]
                fillColor: "transparent"

                // 修正后的路径坐标（适应200x50尺寸）
                startX: 10; startY: 5  // 顶部留出2px边距（strokeWidth/2）
                PathLine { x: 200; y: 5 }  // 200宽度 - 10边距 = 190
                PathLine { x: 200; y: 40 }  // 50高度 - 5边距 = 45
                PathLine { x: 10; y: 40 }
                PathLine { x: 10; y: 5 }
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "file:///root/qq-music/image/plus.png"
                width: 22
                height: 22
            }

            TapHandler {
                onTapped: console.log("分隔线点击")
            }
        }


        Button {
            // 绑定到外部传递的展开状态
            text: listExpanded ? "▼ 隐藏列表" : "▶ 显示列表"
            onClicked: toggleList()  // 触发切换信号
            Layout.fillWidth: true
        }
    }
}
