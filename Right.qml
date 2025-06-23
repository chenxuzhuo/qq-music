import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform   // 文件对话框需要

Rectangle {
    id: rightRect
    height: 800
    color: "#2C2C2C"

    implicitHeight: listExpanded ? Math.min(fileListView.contentHeight + 20, 300) : 0
    clip: true

    property FolderListModel folderModel
    property string currentPlayingPath
    property bool isPlaying
    property bool listExpanded: true

    signal playMusic(string filePath)


    Rectangle {
        id: rec
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: 100
        color: "#2C2C2C"  // 保持与父容器一致的颜色
        Row{
            id:miniRow
            spacing:15
            anchors.verticalCenter:parent.verticalCenter
            anchors.right:parent.right
            anchors.rightMargin:0.02*window.width

            // 投屏按钮
            Image {
                id: miniImg
                anchors.verticalCenter:parent.verticalCenter
                source: "file:///root/qq-music/image/toupin.png"
                height:30
                width:30

                HoverHandler {
                    id: miniImgHover
                }

                TapHandler {
                    onTapped: {
                        //waiting
                    }
                }
            }

            // 最小化按钮
            Rectangle{
                id:miniRect
                width:20
                height:2
                anchors.verticalCenter:parent.verticalCenter
                color:"#75777f"

                HoverHandler {
                }

                TapHandler {
                    onTapped: window.showMinimized()
                }
            }

            // 最大化/恢复按钮
            Rectangle{
                id:maxRect
                width:20
                height:width
                border.width:1
                border.color:"#75777f"
                color:"transparent"
                anchors.verticalCenter:parent.verticalCenter

                HoverHandler {
                    id: maxHover
                }

                TapHandler {
                    onTapped: {
                        if (window.visibility === Window.Maximized)
                            window.showNormal()
                        else
                            window.showMaximized()
                    }
                }
            }

            // 关闭按钮
            Image {
                id: closeImg
                source: "file:///root/qq-music/image/close.png"
                height:30
                width:30

                HoverHandler {
                    id: closeHover
                    property color originalColor: closeImg.color
                }

                TapHandler {
                    onTapped: Qt.quit()
                }
            }
        }
    }

    ListView {
        id: fileListView
        anchors {
            top: rec.bottom  // 顶部对齐到rec的底部
            //left: parent.left
            right: parent.right
            bottom: parent.bottom  // 底部对齐到父容器底部
            margins: 10  // 添加适当边距
        }

        width:400
        clip: true
        model: folderModel
        spacing: 5
        visible: listExpanded



        delegate: Rectangle {
            id: fileDelegate
            width: fileListView.width
            height: 50
            color: fileListView.currentIndex === index ? "#e0e0e0" :
                  (currentPlayingPath === filePath ? "#d4e6f1" : "white")
            border.color: "#d0d0d0"
            radius: 5

            property bool isHovered: false

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15

                ColumnLayout {
                    spacing: 5

                    Label {
                        text: fileName
                        font.bold: true
                        elide: Text.ElideRight
                        color: currentPlayingPath === filePath ? "blue" : "black"
                    }

                    Label {
                        text: formatFilePath(filePath)
                        color: "gray"
                        font.pixelSize: 12
                        elide: Text.ElideLeft
                    }
                }

                Item { Layout.fillWidth: true }
            }

            HoverHandler {
                id: hoverHandler
                onHoveredChanged: fileDelegate.isHovered = hovered
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    fileListView.currentIndex = index
                    playMusic(filePath)
                }
                onDoubleTapped: {
                    playMusic(filePath)
                }
            }

            states: State {
                when: fileDelegate.isHovered
                PropertyChanges {
                    target: fileDelegate
                    color: fileListView.currentIndex === index ? "#e0e0e0" : "#f5f5f5"
                }
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }

    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }
}
