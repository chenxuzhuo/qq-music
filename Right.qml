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
        height: 60
        color: "#2C2C2C"  // 保持与父容器一致的颜色
        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 0.02 * window.width
            }
            spacing: 15

            Button {
                id: exitButton
                icon.name: "dialog-error"
                width: 32
                height: 32
                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }
                onClicked: Qt.quit()
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
