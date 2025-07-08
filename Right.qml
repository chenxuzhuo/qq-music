import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform   // 文件对话框需要
import Qt.labs.settings
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

    // 添加设置对象用于存储历史记录
    Settings {
        id: searchSettings
        category: "searchHistory"
    }
    signal playMusic(string filePath)

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
        var savedHistory = searchSettings.value("history", "[]");
        if (savedHistory) {
            searchHistory = JSON.parse(savedHistory);
        }
    }
    function saveSearchHistory() {
        searchSettings.setValue("history", JSON.stringify(searchHistory));
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
                Column {
                    id: searchColumn

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

                        onAccepted: {
                            // 按下回车键时添加到历史记录
                            addSearchHistory(text);
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
                        width: seachTextField.width
                        height: Math.min(searchHistory.length * 30, 150)
                        color: "white"
                        radius: 5
                        border.color: "#d0d0d0"
                        anchors {
                            top: seachTextField.bottom
                            left: seachTextField.left
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

                                Label {
                                    text: modelData
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    color: "#333333"
                                    font.pixelSize: 14
                                }

                                HoverHandler {
                                    id: hoverHandler
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        seachTextField.text = modelData;
                                        searchHistoryPopup.visible = false;
                                        // 添加到历史记录（置顶）
                                        addSearchHistory(modelData);
                                    }
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

    // 页面加载时加载搜索历史
    Component.onCompleted: {
        loadSearchHistory();
    }
}
