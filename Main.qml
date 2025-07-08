//A front-end about QQ music

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Qt.labs.folderlistmodel
import QtMultimedia


Window {
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
        height: 40

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
    property bool controlPanelVisible: false
    property bool showRecentSongs: false

    // 播放模式图标路径
    property var playModeIcons: [
        "qrc:/image/order.png",
        "qrc:/image/random.png",
        "qrc:/image/circal.png"
    ]

    MediaPlayer {
        id: player
        audioOutput: audiooutput
        onPlaybackStateChanged: {
            isPlaying = (playbackState === MediaPlayer.PlayingState)
            if (playbackState === MediaPlayer.StoppedState &&
                player.duration > 0 &&
                Math.abs(player.position - player.duration) < 100) {
                funct.autoPlayNext()
            }
        }
        onErrorOccurred: console.error("播放错误:", errorString)
        onPositionChanged: {
            rightRect.updateCurrentLine(player.position)
        }

        onSourceChanged: {
            if (source.toString() !== "") {
                const lrcPath =window.currentPlayingPath.replace(/\.mp3$/, ".lrc")
                lrcReader.readFile(lrcPath)
                rightRect.currentLine = -1 // 重置当前歌词行
            }
        }
    }

    AudioOutput {
        id: audiooutput
        volume: 0.5
    }

    // 歌词解析器
    LrcFileReader {
        id: lrcReader
        onFileContentChanged: {
            rightRect.parseLyrics(fileContent)
        }
    }

    //三个主要窗口
    Qleft {
        id:leftRect
        width: 250
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20

        onShowRecentSongs: {
                window.showRecentSongs = true;
        }
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
        controlPanelVisible: window.controlPanelVisible
        player: player
        onPlayMusic: (filePath) => {
            funct.playMusic(filePath)
            window.currentPlayingPath = filePath
        }
        lrcReader: lrcReader
        Layout.preferredHeight: listExpanded ? implicitHeight : 0

        showRecentSongs: window.showRecentSongs
            onShowRecentSongsChanged: {
                if (showRecentSongs) {
                    window.showFavoritesOnly = false;
                    window.listExpanded = true;
                }
            }
    }

    Qbottom {
        id: bottomRect
        anchors.top: rightRect.bottom
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: parent.bottom
        isFavorite: {
            if (!currentPlayingPath) return false;
            const normalizedPath = currentPlayingPath.replace("file://", "");
            return leftRect.favoriteSongs.includes(normalizedPath);
        }
        player: player
        currentPlayingPath: window.currentPlayingPath
        playMode: window.playMode
        playModeIcons: window.playModeIcons
        onPlayNext: funct.playNext()
        onPlayPrevious: funct.playPrevious()
        onTogglePlayPause: funct.togglePlayPause()
        onChangePlayMode: window.playMode = (window.playMode + 1) % 3
        listExpanded: window.listExpanded
        controlPanelVisible: window.controlPanelVisible
        onToggleVisible: window.controlPanelVisible = !window.controlPanelVisible
        onToggleList: window.listExpanded = !window.listExpanded
        onAddFavorite: (filePath) => leftRect.addFavorite(filePath)
        onRemoveFavorite: (filePath) => leftRect.removeFavorite(filePath)
    }

    FolderListModel {
        id: folderModel
        folder: "file:///root/tmp"
        nameFilters: ["*.mp3"]
        showDirs: false
    }

    Functions {
        id: funct
    }

    Component.onCompleted: {
        console.log("Window component completed")
        folderModel.statusChanged.connect(function() {
            if (folderModel.status === FolderListModel.Ready && folderModel.count > 0) {
                const defaultSong = "Go_Beyond_Andy.mp3";
                let foundIndex = -1;

                for (let i = 0; i < folderModel.count; i++) {
                    const fileName = folderModel.get(i, "fileName");
                    if (fileName === defaultSong) {
                        foundIndex = i;
                        break;
                    }
                }

                const playIndex = foundIndex >= 0 ? foundIndex : 0;
                const filePath = folderModel.get(playIndex, "filePath")
                funct.playMusic(filePath, true);
                window.currentPlayingPath = filePath
                player.stop();
                const lrcPath = filePath.replace(/\.mp3$/, ".lrc");
                lrcReader.readFile(lrcPath);
            }
        });
    }
}

