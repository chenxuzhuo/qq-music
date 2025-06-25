import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform

Rectangle {
    id: bottomRect
    color: "#F5F5F5"

    property MediaPlayer player
    property AudioOutput audioOutput
    property string currentPlayingPath
    property int playMode
    property var playModeIcons
    signal toggleList()

    property bool listExpanded: false
    // 当前歌曲是否被收藏（由外部绑定）
    property bool isFavorite: false

    // 新增信号
    signal addFavorite(string filePath)   // 添加收藏信号
    signal removeFavorite(string filePath) // 移除收藏信号

    signal playNext()
    signal playPrevious()
    signal togglePlayPause()
    signal changePlayMode()

    RowLayout{
        anchors.fill:parent
        anchors.leftMargin:0.02*window.width

        Image{
            width:44
            height:44
            source:"qrc:/image/15.jpg"
            sourceSize: Qt.size(74,74)
        }
        ColumnLayout{
            Text{
                id:textItem
                text:qsTr("QQ音乐 听我想听")
            }

            RowLayout{
                Layout.preferredWidth: textItem.width

                // ===== 修复爱心按钮区域 =====
                Rectangle {
                    id: favoriteButton
                    width: 30
                    height: 30
                    color: "transparent"

                    // 爱心图标 - 直接绑定到外部状态
                    Image {
                        id: loveIcon
                        anchors.centerIn: parent
                        source: bottomRect.isFavorite ?
                            "qrc:/image/full-love.png" :
                            "qrc:/image/love.png"
                        sourceSize: Qt.size(20,20)
                    }

                    // 鼠标交互
                    HoverHandler {
                        id: hoverHandler
                        cursorShape: Qt.PointingHandCursor
                    }

                    // 点击处理
                    TapHandler {
                        onTapped: {
                            if (currentPlayingPath) {
                                // 根据当前状态发送不同信号
                                if (bottomRect.isFavorite) {
                                    removeFavorite(currentPlayingPath);
                                } else {
                                    addFavorite(currentPlayingPath);
                                }
                            }
                        }
                    }

                    // 提示文本
                    ToolTip.text: bottomRect.isFavorite ?
                        qsTr("取消喜欢") : qsTr("喜欢这首歌")
                    ToolTip.visible: hoverHandler.hovered
                }
                // ===== 爱心按钮区域结束 =====

                Image{
                    source: "qrc:/image/order.png"
                    sourceSize: Qt.size(20,20)
                }
                Image{
                    source: "qrc:/image/more1.png"
                    sourceSize: Qt.size(20,20)
                }
            }
        }
        Item{
            width: 30
            height:44
        }

        ColumnLayout{
            RowLayout{
                spacing:30
                Layout.preferredWidth:row.width

                // 播放模式切换按钮
                Button {
                    id: modeButton
                    icon.source: playModeIcons[playMode]
                    icon.width: 24
                    icon.height: 24
                    flat: true
                    onClicked: changePlayMode()
                    ToolTip.text: ["顺序播放", "随机播放", "单曲循环"][playMode]
                    ToolTip.visible: hovered
                }

                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-backward"
                    icon.width:20
                    icon.height:20
                    onClicked: playPrevious()
                }
                Button{
                    id: playButton
                    icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                    onClicked: togglePlayPause()
                }
                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-forward"
                    icon.width:20
                    icon.height:20
                    onClicked: playNext()
                }

                Volume{
                    width:30
                    height:30
                }
            }


            MoveSlider{
                id:row
                Layout.fillWidth: true
            }
        }

        Item{
            Layout.preferredWidth:parent.width/20
            Layout.fillWidth:true
            Layout.fillHeight:true
        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"qrc:/image/standard.png"
            sourceSize: Qt.size(44,44)

        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"qrc:/image/device off.png"
            sourceSize: Qt.size(44,44)
        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"qrc:/image/word.png"
            sourceSize: Qt.size(44,44)

        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"qrc:/image/more.png"
            sourceSize: Qt.size(44,44)
            TapHandler{
                onTapped:toggleList()
            }
        }

        Item{
            Layout.preferredWidth:20
            Layout.fillWidth:true
            Layout.fillHeight:true
        }
    }
}
