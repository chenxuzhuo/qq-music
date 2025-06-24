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



    // 顶部控制栏
    Rectangle {
        id: rec
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: 50
        color: "#d0d0d0"
        Rectangle{

            Row{
                id:searchRow
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 36
                anchors.verticalCenter: othersRow.verticalCenter
                //返回
                Rectangle{
                    id:backForwardrect
                    width: 24
                    height: 35
                    radius: 4
                    color: "transparent"
                    border.color:"#2b2b31"
                    Image {
                        id: bake
                        height:30
                        width:30
                        anchors.centerIn: parent
                        source: "file:///root/qq-music/image/let.png"
                    }
                }
                //前进
                Rectangle{
                    id:forwardrect
                    width: 24
                    height: 35
                    radius: 4
                    color: "transparent"
                    border.color:"#2b2b31"
                    Image {
                        id: forward
                        height:30
                        width:30
                        anchors.centerIn: parent
                        source: "file:///root/qq-music/image/right.png"
                    }
                }
                //刷新
                Rectangle{
                    id:loopRect
                    width: 24
                    height: 35
                    radius: 4
                    color: "transparent"
                    border.color:"#2b2b31"
                    Image {
                        id: loop
                        height:30
                        width:30
                        anchors.centerIn: parent
                        source: "file:///root/qq-music/image/loop.png"
                    }
                }
                //搜索框
                TextField{
                    id:seachTextField
                    height:30
                    width: 240
                    leftPadding: 40
                    placeholderText:"搜索"
                    placeholderTextColor:"#2b2b31"
                    color: "#333333"  // 修改输入文字颜色
                    font.pixelSize:16
                    background:Rectangle {
                        anchors.fill:parent
                        Rectangle{
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 8
                            Image {
                                id: serchIcon
                                scale: 0.7
                                height:30
                                width:30
                                anchors.verticalCenter: parent
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                source: "file:///root/qq-music/image/search.png"
                            }
                        }
                    }
                }
                //听歌识曲
                Rectangle{
                    id:lisenRect
                    width: 24
                    height: 35
                    color: "transparent"
                    border.color:parent
                    Image {
                        id: lisen
                        height:30
                        width:30
                        anchors.centerIn: parent
                        source: "file:///root/qq-music/image/qqmusic.png"
                    }
                }

            }
        }

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
