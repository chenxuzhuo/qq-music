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
        }

        onErrorOccurred: console.error("播放错误:", errorString)
    }

    AudioOutput {
        id: audiooutput
        volume: 0.5
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // 主内容区域
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            Left {
                id: leftPanel
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                // 双向绑定展开状态
                listExpanded: window.listExpanded
                onToggleList: window.listExpanded = !window.listExpanded
            }


            Right {
                id: rightPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
                folderModel: folderModel
                currentPlayingPath: window.currentPlayingPath
                isPlaying: window.isPlaying
                listExpanded: window.listExpanded
                onPlayMusic: (filePath) => window.playMusic(filePath)

                Layout.preferredHeight: listExpanded ? implicitHeight : 0
            }
        }

        Qbottom {
            Layout.fillWidth: true
            height:150
            player: player
            //audioOutput: audioOutput
            currentPlayingPath: window.currentPlayingPath
            playMode: window.playMode
            playModeIcons: window.playModeIcons
            onPlayNext: window.playNext()
            onPlayPrevious: window.playPrevious()
            onTogglePlayPause: window.togglePlayPause()
            onChangePlayMode: window.playMode = (window.playMode + 1) % 3
        }
    }

    FolderListModel {
        id: folderModel
        folder: "file:///root/tmp"
        nameFilters: ["*.mp3"]
        showDirs: false
    }



    Component.onCompleted: {
        folderModel.update()
        playDefaultMusic()
    }

    // 工具函数
    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }

    function playMusic(filePath, keepPlaying = false) {
        const localPath = filePath.toString().replace("file://", "")
        const wasPlaying = isPlaying

        if (currentPlayingPath === localPath) {
            togglePlayPause()
            return
        }

        player.stop()
        player.source = "file://" + localPath
        currentPlayingPath = localPath

        if (wasPlaying || keepPlaying) {
            player.play()
        }
    }

    function togglePlayPause() {
        player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
    }

    function playNext() {
        if (folderModel.count === 0) return

        let currentIndex = folderModel.indexOf(currentPlayingPath)
        if (currentIndex === -1) currentIndex = 0

        switch(playMode) {
        case 0: currentIndex = (currentIndex + 1) % folderModel.count; break;
        case 1: currentIndex = Math.floor(Math.random() * folderModel.count); break;
        case 2: return;
        }

        playMusic(folderModel.get(currentIndex, "filePath"), true)
    }

    function playPrevious() {
        if (folderModel.count === 0) return

        let currentIndex = folderModel.indexOf(currentPlayingPath)
        if (currentIndex === -1) currentIndex = 0

        switch(playMode) {
        case 0: currentIndex = (currentIndex - 1 + folderModel.count) % folderModel.count; break;
        case 1: currentIndex = Math.floor(Math.random() * folderModel.count); break;
        case 2: return;
        }

        playMusic(folderModel.get(currentIndex, "filePath"), true)
    }

    function formatTime(ms) {
        const sec = Math.floor(ms / 1000)
        return `${Math.floor(sec / 60)}:${String(sec % 60).padStart(2, '0')}`
    }

    function playDefaultMusic() {
        const defaultPath = "file:///root/tmp/海阔天空.mp3"
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
}
