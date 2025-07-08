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
    property bool showFavoritesOnly: false;
    implicitHeight: listExpanded ? Math.min(fileListView.contentHeight + 20, 300) : 0
    clip: true

    property FolderListModel folderModel
    property string currentPlayingPath
    property bool isPlaying
    property bool listExpanded: false
    property bool controlPanelVisible: false
    property var player
    property var lrcReader

    property ListModel lyricModel: ListModel {}
    property int currentLine: -1
    property alias parsedLyricView: parsedLyricView

    property bool showRecentSongs: false

    signal playMusic(string filePath)
    signal loadInitialFile(string filename)

    // 解析歌词文件内容
    function parseLyrics(fileContent) {
        const lines = fileContent.split('\n');
        const pattern = /\[(\d{2}):(\d{2})\.(\d{2})\](.*)/;

        lyricModel.clear();
        currentLine = -1;

        for (const line of lines) {
            const match = line.match(pattern);
            if (match) {
                const minutes = parseInt(match[1]);
                const seconds = parseInt(match[2]);
                const ms = parseInt(match[3]);
                const time = minutes * 60000 + seconds * 1000 + ms * 10;

                lyricModel.append({
                    time: time,
                    text: match[4].trim()
                });
            }
        }
    }

    //根据播放位置更新当前歌词行
    function updateCurrentLine(position) {
        if (lyricModel.count === 0) return;

        let newLine = -1;
        for (let i = lyricModel.count - 1; i >= 0; i--) {
            if (position >= lyricModel.get(i).time) {
                newLine = i;
                break;
            }
        }

        if (newLine !== currentLine) {
            currentLine = newLine;
            if (currentLine >= 0) {
                parsedLyricView.positionViewAtIndex(currentLine, ListView.Center);
                karaokeView.positionViewAtIndex(currentLine, ListView.Center);
            }
        }
    }

    function formatTime(ms) {
        const totalSec = ms / 1000;
        const min = Math.floor(totalSec / 60);
        const sec = Math.floor(totalSec % 60);
        const msec = Math.floor((ms % 1000) / 10);
        return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}.${String(msec).padStart(2, '0')}`;
    }

    Rectangle {
        id: rec
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: 60
        color: "#2C2C2C"

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

        Button {
            visible: window.showFavoritesOnly || showRecentSongs
            text: qsTr("返回全部歌曲")
            onClicked: {
                window.showFavoritesOnly = false;
                showRecentSongs = false;
            }
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 15
            }
        }
    }

    // 内容区域 - 使用StackLayout管理不同视图
    StackLayout {
        id: contentStack
        anchors {
            top: rec.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        currentIndex: {
            if (controlPanelVisible) return 0; // 控制面板
            if (listExpanded && showRecentSongs) return 1; // 最近播放列表
            if (listExpanded && window.showFavoritesOnly) return 2; // 收藏列表
            if (listExpanded) return 3; // 常规播放列表
            return 4; // 空状态
        }

        // 控制面板（歌词视图）
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            TabBar {
                id: tabBar
                Layout.fillWidth: true
                TabButton { text: "歌词视图" }
                TabButton { text: "滚动模式" }
            }

            StackLayout {
                id: stackLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: tabBar.currentIndex

                // 歌词视图
                Item {
                    // 歌词列表视图
                    ListView {
                        id: parsedLyricView
                        anchors.fill: parent
                        model: lyricModel
                        spacing: 5
                        clip: true
                        preferredHighlightBegin: height * 0.4
                        preferredHighlightEnd: height * 0.6
                        highlightRangeMode: ListView.StrictlyEnforceRange
                        highlightMoveDuration: 250
                        currentIndex: currentLine

                        delegate: Rectangle {
                            width: parsedLyricView.width
                            height: lyricText.implicitHeight + 20
                            color: index === currentLine ? "#ffe485" : (index % 2 === 0 ? "#f8f8f8" : "#ffffff")
                            radius: 3

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15

                                Label {
                                    text: formatTime(model.time)
                                    font.bold: true
                                    color: "#555555"
                                    Layout.preferredWidth: 80
                                }

                                Label {
                                    id: lyricText
                                    text: model.text
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                    font.pixelSize: index === currentLine ? 18 : 14
                                    font.bold: index === currentLine
                                    color: index === currentLine ? "#bd6f1a" : "#333333"
                                }
                            }
                        }
                        ScrollBar.vertical: ScrollBar {}
                    }

                    // 无歌词提示（居中显示）
                    Label {
                        id: noLyricLabel
                        anchors.centerIn: parent
                        text: "该音乐为纯音乐，无歌词内容"
                        font.pixelSize: 24
                        color: "#AAAAAA"
                        visible: lyricModel.count === 0  // 没有歌词时显示
                    }
                }

                // 滚动模式视图
                Item {
                    Rectangle {
                        color: "#222222"
                        anchors.fill: parent

                        Image {
                            id: name
                            source: "qrc:/image/background2.jpg"
                            sourceSize: Qt.size(200,200)
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 20
                            }

                            RotationAnimation on rotation {
                                from: 0
                                to: 360
                                duration: 20000
                                loops: Animation.Infinite
                                running: true
                            }
                        }

                        // 卡拉OK歌词视图
                        ListView {
                            id: karaokeView
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 15
                            clip: true
                            model: lyricModel
                            preferredHighlightBegin: height * 0.4
                            preferredHighlightEnd: height * 0.6
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            currentIndex: currentLine

                            delegate: Label {
                                width: karaokeView.width
                                horizontalAlignment: Text.AlignHCenter
                                text: model.text
                                color: index === currentLine ? "#00BFFF" : "#AAAAAA"
                                font.pixelSize: index === currentLine ? 28 : 18
                                font.bold: index === currentLine
                                opacity: index === currentLine ? 1.0 : (Math.abs(index - currentLine) < 3 ? 0.8 : 0.5)
                                Behavior on color { ColorAnimation { duration: 200 } }
                                Behavior on font.pixelSize { NumberAnimation { duration: 200 } }
                                Behavior on opacity { NumberAnimation { duration: 200 } }
                            }

                            ScrollBar.vertical: ScrollBar {
                                policy: ScrollBar.AlwaysOn
                            }
                        }

                        // 无歌词提示（居中显示）
                        Label {
                            anchors.centerIn: parent
                            text: "该音乐为纯音乐，无歌词内容"
                            font.pixelSize: 28
                            color: "#666666"
                            visible: lyricModel.count === 0  // 没有歌词时显示
                        }
                    }
                }
            }
        }

        // 最近播放列表
        ListView {
            id: recentSongsView
            clip: true
            spacing: 5
            model: leftRect.recentSongs

            delegate: Rectangle {
                id: recentDelegate
                width: recentSongsView.width
                height: 50
                color: recentSongsView.currentIndex === index ? "#e0e0e0" :
                      (currentPlayingPath === ("file://" + modelData) ? "#d4e6f1" : "white")
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
                            text: {
                                // 从文件路径中提取文件名
                                const path = modelData;
                                const lastSlash = path.lastIndexOf('/');
                                return lastSlash >= 0 ? path.substring(lastSlash + 1) : path;
                            }
                            font.bold: true
                            elide: Text.ElideRight
                            color: currentPlayingPath === ("file://" + modelData) ? "blue" : "black"
                        }

                        Label {
                            text: modelData
                            font.pixelSize: 12
                            elide: Text.ElideLeft
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // 收藏图标
                    Image {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 10
                        }
                        width: 20
                        height: 20
                        source: leftRect.isFavorite("file://" + modelData) ?
                                "qrc:/image/full-love.png" :
                                "qrc:/image/love.png"
                    }
                }

                HoverHandler {
                    id: recentHoverHandler
                    onHoveredChanged: recentDelegate.isHovered = hovered
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        recentSongsView.currentIndex = index
                        playMusic("file://" + modelData)
                        window.currentPlayingPath = "file://" + modelData
                        const lrcPath = modelData.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
                    }
                    onDoubleTapped: {
                        playMusic("file://" + modelData)
                        window.currentPlayingPath = "file://" + modelData
                        const lrcPath = modelData.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
                    }
                }

                states: State {
                    when: recentDelegate.isHovered
                    PropertyChanges {
                        target: recentDelegate
                        color: recentSongsView.currentIndex === index ? "#e0e0e0" : "#f5f5f5"
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        // 收藏列表
        ListView {
            id: favoriteListView
            clip: true
            spacing: 5
            model: folderModel

            delegate: Rectangle {
                id: fileDelegate
                width: favoriteListView.width
                height: 50
                color: favoriteListView.currentIndex === index ? "#e0e0e0" :
                      (currentPlayingPath === filePath ? "#d4e6f1" : "white")
                border.color: "#d0d0d0"
                radius: 5
                // 只显示收藏的歌曲
                visible: window.showFavoritesOnly && leftRect.isFavorite(filePath)
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
                            text: funct.formatFilePath(filePath)
                            font.pixelSize: 12
                            elide: Text.ElideLeft
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // 收藏图标
                    Image {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 10
                        }
                        width: 20
                        height: 20
                        source: leftRect.isFavorite(filePath) ?
                                "qrc:/image/full-love.png" :
                                "qrc:/image/love.png"
                    }
                }

                HoverHandler {
                    id: hoverHandler
                    onHoveredChanged: fileDelegate.isHovered = hovered
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        favoriteListView.currentIndex = index
                        playMusic(filePath)
                        window.currentPlayingPath = filePath
                        const lrcPath = filePath.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
                    }
                    onDoubleTapped: {
                        playMusic(filePath)
                        window.currentPlayingPath = filePath
                        const lrcPath = filePath.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
                    }
                }

                states: State {
                    when: fileDelegate.isHovered
                    PropertyChanges {
                        target: fileDelegate
                        color: favoriteListView.currentIndex === index ? "#e0e0e0" : "#f5f5f5"
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        // 常规播放列表
        ListView {
            id: fileListView
            clip: true
            spacing: 5
            model: folderModel

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
                            text: funct.formatFilePath(filePath)
                            font.pixelSize: 12
                            elide: Text.ElideLeft
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // 收藏图标
                    Image {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 10
                        }
                        width: 20
                        height: 20
                        source: leftRect.isFavorite(filePath) ?
                                "qrc:/image/full-love.png" :
                                "qrc:/image/love.png"
                    }
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
                        window.currentPlayingPath = filePath
                        const lrcPath = filePath.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
                    }
                    onDoubleTapped: {
                        playMusic(filePath)
                        window.currentPlayingPath = filePath
                        const lrcPath = filePath.replace(/\.mp3$/, ".lrc")
                        lrcReader.readFile(lrcPath)
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

        // 空状态（当列表和控制面板都不可见时）
        Item {}
    }
}
