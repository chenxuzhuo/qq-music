//chenxuzhuo about history and 顶部控制栏
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform   // 文件对话框需要
import QtQuick.LocalStorage
import QtQuick.Window

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
    property var searchHistory: [] // 存储搜索历史
    property int maxHistoryItems: 5 // 最大历史记录数量
    property bool showFavoritesOnly: false;
    property bool controlPanelVisible: false
    property var player
    property var lrcReader
    property var searchSettings: LocalStorage.openDatabaseSync("MusicPlayer", "1.0", "Search history", 100000)

    property ListModel lyricModel: ListModel {}
    property int currentLine: -1
    property alias parsedLyricView: parsedLyricView

    property var window: Qt.application.activeWindow
    signal playMusic(string filePath)
    signal loadInitialFile(string filename)

    // 初始化数据库表
    function initDatabase() {
        searchSettings.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS search_history (id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT)');
            }
        );
    }
    // 搜索历史相关函数
    function addSearchHistory(text) {
        if (text && text.trim() !== "") {
            // 移除已存在的相同搜索内容
            searchHistory = searchHistory.filter(function(item) {
                return item.toLowerCase() !== text.toLowerCase();
            });

            // 添加到历史记录开头
            searchHistory.unshift(text.trim());

            // 限制历史记录数量
            if (searchHistory.length > maxHistoryItems) {
                searchHistory = searchHistory.slice(0, maxHistoryItems);
            }

            // 保存到本地存储
            saveSearchHistory();
        }
    }

    function loadSearchHistory() {
        searchHistory = [];
        searchSettings.transaction(
            function(tx) {
                var result = tx.executeSql('SELECT query FROM search_history ORDER BY id DESC LIMIT ?', [maxHistoryItems]);
                for (var i = 0; i < result.rows.length; i++) {
                    searchHistory.push(result.rows.item(i).query);
                }
            }
        );
    }

    function saveSearchHistory() {
        searchSettings.transaction(
            function(tx) {
                // 清空现有记录
                tx.executeSql('DELETE FROM search_history');

                // 插入新记录
                for (var i = 0; i < searchHistory.length; i++) {
                    tx.executeSql('INSERT INTO search_history (query) VALUES (?)', [searchHistory[i]]);
                }
            }
        );
    }


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
                    source: "qrc:/image/let.png"
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
                    source: "qrc:/image/right.png"
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
                    source: "qrc:/image/order.png"
                }
            }
            //搜索框
            Column {
                id: searchColumn

                TextField{
                    id:searchTextField
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
                                source: "qrc:/image/search.png"
                            }
                        }
                    }

                    onAccepted: {
                        // 按下回车键时添加到历史记录
                        addSearchHistory(text);
                        saveSearchHistory();

                        // 这里可以添加实际搜索逻辑
                        //console.log("搜索:", text);
                    }

                    onFocusChanged: {
                        if (focus) {
                            // 获得焦点时显示历史记录
                            searchHistoryPopup.visible = searchHistory.length > 0;
                        } else {
                            // 失去焦点时延迟隐藏，以便点击历史记录
                            searchHistoryPopup.visible = false;
                        }
                    }
                }

                // 搜索历史下拉框
                Rectangle {
                    id: searchHistoryPopup
                    visible: false
                    width: searchTextField.width
                    height: Math.min(searchHistory.length * 30, 150)
                    color: "white"
                    radius: 5
                    border.color: "#d0d0d0"
                    anchors {
                        top: searchTextField.bottom
                        left: searchTextField.left
                        margins: 2
                    }
                    z: 100  // 确保显示在最上层

                    ListView {
                        id: historyListView
                        anchors.fill: parent
                        model: searchHistory
                        delegate: Rectangle {
                            id: historyItem
                            width: parent.width
                            height: 30
                            color: hovered ? "#f0f0f0" : "white"
                            radius: 3

                            property bool hovered: hoverHandler.hovered  // 绑定 HoverHandler 的状态

                            Label {
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                color: "#333333"
                                font.pixelSize: 14
                            }

                            Image {
                                id: deleteButton
                                source: "qrc:/image/close.png"
                                width: 16
                                height: 16
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                                visible: hovered
                                opacity: hovered ? 1.0 : 0.0
                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                TapHandler {
                                    onTapped: {
                                        // 从数组中删除
                                        searchHistory = searchHistory.filter(function(item) {
                                            return item !== modelData;
                                        });
                                        // 更新数据库
                                        saveSearchHistory();
                                        // 如果没有历史记录了，隐藏弹出框
                                        if (searchHistory.length === 0) {
                                            searchHistoryPopup.visible = false;
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: hoverHandler
                            }
                            TapHandler {

                                onTapped: {
                                    searchTextField.text = modelData;
                                    searchHistoryPopup.visible = false;
                                    addSearchHistory(modelData);  // 置顶历史记录
                                }
                            }
                        }
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
                source: "qrc:/image/toupin.png"

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
                width:30
                height:10
                anchors.verticalCenter:parent.verticalCenter
                color:"#75777f"

                HoverHandler {
                    id:minniHover
                }

                TapHandler {
                    onTapped: {
                        if (rightRect.window) {
                rightRect.window.visibility = Window.Minimized;
                        } else {
                            console.error("无法找到窗口对象")
                        }
                    }
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
                        if (window) {
                            if (window.maximized) {
                                window.showNormal();  // 恢复
                            } else {
                                window.showMaximized();  // 最大化
                            }
                        } else {
                            console.error("无法找到窗口对象");
                        }
                    }
                }

            }

            // 关闭按钮
            Image {
                id: closeImg
                source: "qrc:/image/close.png"
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

    //歌词在主界面的显示，该部分的可见性暴露给了Qbottom空白区域
    ColumnLayout {
        id: controlPanel
        anchors.top: rec.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: controlPanelVisible
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
            visible: !window.showFavoritesOnly || leftRect.isFavorite(filePath)
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
                id: love
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

    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }

    // 页面加载时加载搜索历史
    Component.onCompleted: {
        initDatabase();
        loadSearchHistory();
    }
}
