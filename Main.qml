//A front-end about QQ music

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Qt.labs.folderlistmodel
import QtMultimedia

Window {
    //id: root
    id: window
    width: 1317
    height: 933
    visible: true
    title: qsTr("QQMusic")
    flags: Qt.FramelessWindowHint | Qt.window | Qt.WindowSystemmenuHint |
           Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint

    // 窗口拖动区域
    Item {
        id: dragArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40  // 顶部拖拽区域高度

        HoverHandler {
            cursorShape: Qt.SizeAllCursor
        }

        DragHandler {
            target: null
            onActiveChanged: if (active) window.startSystemMove()
        }
    }

    property var mp3Files: []
    property string currentPlayingPath: ""
    property bool isPlaying: false
    property int playMode: 0
    property bool listExpanded: false

    // 播放模式图标路径
    property var playModeIcons: [
        "file:///root/musicfunction/list/image/order.png",
        "file:///root/musicfunction/list/image/random.png",
        "file:///root/musicfunction/list/image/circal.png"
    ]

    MediaPlayer {
        id: player
        audioOutput: audiooutput

        onPlaybackStateChanged: {
                isPlaying = (playbackState === MediaPlayer.PlayingState)

            // 检测播放结束
                    if (playbackState === MediaPlayer.StoppedState &&
                        player.duration > 0 &&
                        Math.abs(player.position - player.duration) < 100) {
                        funct.autoPlayNext()
                    }
            }

        onErrorOccurred: console.error("播放错误:", errorString)
    }

    AudioOutput {
        id: audiooutput
        volume: 0.5
    }

    //三个主要窗口
    Qleft {
        id:leftRect
        width: 250  // 固定宽度

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
    }

    Qright {
        id: rightRect

        height: 800

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: bottomRect.top

        color: "#2C2C2C"

        folderModel: folderModel
        currentPlayingPath: window.currentPlayingPath
        isPlaying: window.isPlaying
        listExpanded: window.listExpanded
        onPlayMusic: (filePath) => funct.playMusic(filePath)

        Layout.preferredHeight: listExpanded ? implicitHeight : 0
    }

    Qbottom {
        id: bottomRect

        anchors.top: rightRect.bottom
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: parent.bottom

        // 绑定当前歌曲的收藏状态
            isFavorite: {
                if (!currentPlayingPath) return false;
                const normalizedPath = currentPlayingPath.replace("file://", "");
                return leftRect.favoriteSongs.includes(normalizedPath);
            }

            // 连接信号到Qleft的处理函数
            onAddFavorite: leftRect.addFavorite(filePath)
            onRemoveFavorite: leftRect.removeFavorite(filePath)

        player: player
        currentPlayingPath: window.currentPlayingPath
        playMode: window.playMode
        playModeIcons: window.playModeIcons
        onPlayNext: funct.playNext()
        onPlayPrevious: funct.playPrevious()
        onTogglePlayPause: funct.togglePlayPause()
        onChangePlayMode: window.playMode = (window.playMode + 1) % 3
        // 双向绑定展开状态
        listExpanded: window.listExpanded
        onToggleList: window.listExpanded = !window.listExpanded
    }


    FolderListModel {
        id: folderModel
        folder: "file:///root/tmp"
        nameFilters: ["*.mp3"]
        showDirs: false
    }

    Functions{
        id:funct
    }

    Component.onCompleted: {
        //确保有一首歌在程序启动时播放
        folderModel.statusChanged.connect(function() {
            if (folderModel.status === FolderListModel.Ready && folderModel.count > 0) {
                // 查找默认歌曲
                const defaultSong = "Go_Beyond_Andy.mp3";
                let foundIndex = -1;

                for (let i = 0; i < folderModel.count; i++) {
                    const fileName = folderModel.get(i, "fileName");
                    if (fileName === defaultSong) {
                        foundIndex = i;
                        break;
                    }
                }

                // 播放找到的歌曲或第一首
                const playIndex = foundIndex >= 0 ? foundIndex : 0;
                funct.playMusic(folderModel.get(playIndex, "filePath"), true);
                player.stop();
            }
        });
    }
}
