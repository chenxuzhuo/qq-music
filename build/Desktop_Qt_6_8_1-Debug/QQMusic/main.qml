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
    property bool listExpanded: true

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
                //playButton.icon.name = isPlaying ? "media-playback-pause" : "media-playback-start"

                // // 检测播放结束
                // if (playbackState === MediaPlayer.StoppedState && player.position >= player.duration - 100) {
                //     autoPlayNext()
                // }

            // 检测播放结束
                    if (playbackState === MediaPlayer.StoppedState &&
                        player.duration > 0 &&
                        Math.abs(player.position - player.duration) < 100) {
                        autoPlayNext()
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

<<<<<<<< HEAD:build/Desktop_Qt_6_8_1-Debug/QQMusic/main.qml
         anchors.top: parent.top
         anchors.bottom: parent.bottom
         anchors.left: parent.left
         anchors.margins: 20
    }

    Right {
========
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
    }

    Qright {
>>>>>>>> 97c9c7737065b54d5c6b86f50392a4f0799bc551:main.qml
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
        onPlayMusic: (filePath) => window.playMusic(filePath)

        Layout.preferredHeight: listExpanded ? implicitHeight : 0
    }

    Qbottom {
        id: bottomRect

        anchors.top: rightRect.bottom
        anchors.right: parent.right
        anchors.left: leftRect.right
        anchors.bottom: parent.bottom

<<<<<<<< HEAD:build/Desktop_Qt_6_8_1-Debug/QQMusic/main.qml
========
        // 绑定当前歌曲的收藏状态
            isFavorite: {
                if (!currentPlayingPath) return false;
                const normalizedPath = currentPlayingPath.replace("file://", "");
                return leftRect.favoriteSongs.includes(normalizedPath);
            }

            // 连接信号到Qleft的处理函数
            onAddFavorite: leftRect.addFavorite(filePath)
            onRemoveFavorite: leftRect.removeFavorite(filePath)


>>>>>>>> 97c9c7737065b54d5c6b86f50392a4f0799bc551:main.qml
        player: player
        currentPlayingPath: window.currentPlayingPath
        playMode: window.playMode
        playModeIcons: window.playModeIcons
        onPlayNext: window.playNext()
        onPlayPrevious: window.playPrevious()
        onTogglePlayPause: window.togglePlayPause()
        onChangePlayMode: window.playMode = (window.playMode + 1) % 3
    }


    FolderListModel {
        id: folderModel
        folder: "file:///root/tmp"
        nameFilters: ["*.mp3"]
        showDirs: false
    }

    // 工具函数
    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }

    function playMusic(filePath, keepPlaying = false) {
        const normalizedPath = filePath.toString().replace("file://", "");
            const currentNormalized = currentPlayingPath.replace("file://", "");

            if (currentNormalized === normalizedPath) {
                togglePlayPause();
                return;
            }

            player.stop();
            player.source = "file://" + normalizedPath;
            currentPlayingPath = normalizedPath;

            if (keepPlaying || isPlaying) {
                player.play();
            }
    }

    function togglePlayPause() {
        player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
    }


    function autoPlayNext() {
        if (folderModel.count === 0) return

        switch(playMode) {
        case 0: // 顺序播放
            playNext()
            break
        case 1: // 随机播放
            playRandom()
            break
        case 2: // 单曲循环
            replayCurrent()
            break
        }
    }

    function playRandom() {
        if (folderModel.count === 0) return

        let newIndex
        let currentIndex = getCurrentIndex()

        // 确保不重复播放同一首歌（除非只有一首）
        do {
            newIndex = Math.floor(Math.random() * folderModel.count)
        } while (newIndex === currentIndex && folderModel.count > 1)

        playMusic(folderModel.get(newIndex, "filePath"), true)
    }

    function replayCurrent() {
        if (currentPlayingPath) {
            player.position = 0
            player.play()
        }
    }

    function getCurrentIndex() {
        if (folderModel.count === 0) return -1

        const currentNormalized = currentPlayingPath.replace("file://", "")
        for (let i = 0; i < folderModel.count; i++) {
            if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                return i
            }
        }
        return -1
    }

    function playNext() {
        if (folderModel.count === 0) return;

            let currentIndex = -1;
            const currentNormalized = currentPlayingPath.replace("file://", "");
            for (let i = 0; i < folderModel.count; i++) {
                if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex === -1) currentIndex = 0;

            switch(playMode) {
            case 0: // 顺序播放
                currentIndex = (currentIndex + 1) % folderModel.count;
                break;
            case 1: // 随机播放
                // 确保不重复播放同一首歌
                let newIndex;
                do {
                    newIndex = Math.floor(Math.random() * folderModel.count);
                } while (newIndex === currentIndex && folderModel.count > 1);
                currentIndex = newIndex;
                break;
            case 2: // 单曲循环
                currentIndex = currentIndex; // 保持不变
                break;
            }

            playMusic(folderModel.get(currentIndex, "filePath"), true);
    }

    function playPrevious() {
        if (folderModel.count === 0) return;

            // 获取当前索引（使用标准化路径比较）
            let currentIndex = -1;
            const currentNormalized = currentPlayingPath.replace("file://", "");
            for (let i = 0; i < folderModel.count; i++) {
                if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex === -1) currentIndex = folderModel.count - 1;

            switch(playMode) {
            case 0: // 顺序播放
                currentIndex = (currentIndex - 1 + folderModel.count) % folderModel.count;
                playMusic(folderModel.get(currentIndex, "filePath"), true);
                break;
            case 1: // 随机播放
                currentIndex = Math.floor(Math.random() * folderModel.count);
                playMusic(folderModel.get(currentIndex, "filePath"), true);
                break;
            case 2: // 单曲循环
                if (currentPlayingPath) {
                    playMusic(currentPlayingPath, true);
                }
                break;
            }
    }

    function addToSelectedFiles(name, path) {
        if (!mp3Files.some(f => f.path === path)) {
            mp3Files.push({name, path})
            mp3FilesChanged()
        }
    }

    function formatTime(ms) {
        const sec = Math.floor(ms / 1000)
        return `${Math.floor(sec / 60)}:${String(sec % 60).padStart(2, '0')}`
    }

    function playDefaultMusic() {
        const defaultPath = "file:///root/tmp/Go_Beyond_Andy.mp3"
        for (let i = 0; i < folderModel.count; i++) {
            if (folderModel.get(i, "filePath") === defaultPath) {
                playMusic(defaultPath, true)
                return
            }
        }
        if (folderModel.count > 0) {
            playMusic(folderModel.get(0, "filePath"), true)
        }
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
                playMusic(folderModel.get(playIndex, "filePath"), true);
                player.stop();
            }
        });
    }
}
