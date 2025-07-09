//By quzhiyao 2023051604020
//A rectangle about left side component

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Qt.labs.platform
import QtMultimedia

Rectangle {
    id: leftRect
    color: "#FFFFFF"
    width: isNarrow ? 60 : 250
    state: "wide"

    states: [
        State {
            name: "wide"
            PropertyChanges { target: leftRect; width: 250 }
            PropertyChanges { target: loginButton; visible: true }
            PropertyChanges { target: mainFuncRow; visible: true }
            PropertyChanges { target: menuColumn; visible: true }
            PropertyChanges { target: settingButton; visible: true }
            PropertyChanges { target: skinButton; visible: true }
            PropertyChanges { target: zoomButton; visible: true }
        },
        State {
            name: "narrow"
            PropertyChanges { target: leftRect; width: 60 }
            PropertyChanges { target: loginButton; visible: false }
            PropertyChanges { target: mainFuncRow; visible: false }
            PropertyChanges { target: settingButton; visible: false }
            PropertyChanges { target: skinButton; visible: false }
            PropertyChanges { target: zoomButton; visible: true }
        }
    ]

    transitions: Transition {
        NumberAnimation { property: "width"; duration: 300; easing.type: Easing.InOutQuad }
    }

    property bool isNarrow: false
    property bool isLoggedIn: false
    property string userName: "未登录用户"
    property var favoriteSongs: []
    property var recentSongs: [] // 最近播放列表
    property var localSongs: []  // 本地音乐列表

    // 信号
    signal showFavoriteSongs()
    signal showRecentSongs()
    signal showLocalSongs()
    signal showSettings()

    function toggleZoom() {
        isNarrow = !isNarrow;
        state = isNarrow ? "narrow" : "wide";
    }

    // 模拟登录
    function login() {
        isLoggedIn = true;
        userName = "音乐爱好者";
        loginButton.text = userName;
        // 加载用户数据
        loadUserData();
    }

    // 加载用户数据
    function loadUserData() {
        try {
            const savedFavorites = Qt.application.settings.value("favorites");
            if (savedFavorites) {
                favoriteSongs = JSON.parse(savedFavorites);
            }

            const savedRecent = Qt.application.settings.value("recentSongs");
            if (savedRecent) {
                recentSongs = JSON.parse(savedRecent);
            }

            const savedLocal = Qt.application.settings.value("localSongs");
            if (savedLocal) {
                localSongs = JSON.parse(savedLocal);
            }
        } catch (e) {
            console.error("加载用户数据失败:", e);
        }
    }

    // 保存用户数据
    function saveUserData() {
        try {
            Qt.application.settings.setValue("favorites", JSON.stringify(favoriteSongs));
            Qt.application.settings.setValue("recentSongs", JSON.stringify(recentSongs));
            Qt.application.settings.setValue("localSongs", JSON.stringify(localSongs));
        } catch (e) {
            console.error("保存用户数据失败:", e);
        }
    }

    // 添加收藏
    function addFavorite(filePath) {
        const normalizedPath = filePath.replace("file://", "");
        if (!favoriteSongs.includes(normalizedPath)) {
            favoriteSongs.push(normalizedPath);
            saveUserData();
            console.log("已添加到收藏:", normalizedPath);
        }
        favoriteSongsChanged()
    }

    // 移除收藏
    function removeFavorite(filePath) {
        const normalizedPath = filePath.replace("file://", "");
        const index = favoriteSongs.indexOf(normalizedPath);
        if (index >= 0) {
            favoriteSongs.splice(index, 1);
            saveUserData();
            console.log("已从收藏移除:", normalizedPath);
        }
        favoriteSongsChanged()
    }

    // 添加最近播放
    function addRecentSong(filePath) {
        const normalizedPath = filePath.replace("file://", "");

        // 移除已存在的相同歌曲
        const index = recentSongs.indexOf(normalizedPath);
        if (index >= 0) {
            recentSongs.splice(index, 1);
        }

        // 添加到开头
        recentSongs.unshift(normalizedPath);

        // 限制最多保存20首
        if (recentSongs.length > 20) {
            recentSongs = recentSongs.slice(0, 20);
        }

        saveUserData();
    }

    // 添加本地音乐
    function addLocalSong(filePath) {
        const normalizedPath = filePath.replace("file://", "");

        // 检查是否已存在
        if (!localSongs.includes(normalizedPath)) {
            localSongs.push(normalizedPath);
            saveUserData();
            console.log("已添加到本地音乐:", normalizedPath);
        }
    }

    // 浏览添加本地音乐
    function browseLocalMusic() {
        fileDialog.open();
    }

    // 文件对话框
    FileDialog {
        id: fileDialog
        title: "选择音乐文件"
        nameFilters: ["MP3文件 (*.mp3)"]
        onAccepted: {
            for (var i = 0; i < fileDialog.files.length; i++) {
                const filePath = fileDialog.files[i].toString();
                addLocalSong(filePath);
            }
            showLocalSongs();
        }
    }

    Component.onCompleted: {
        try {
            const savedFavorites = Qt.application.settings.value("favorites");
            if (savedFavorites) {
                favoriteSongs = JSON.parse(savedFavorites);
            }
        } catch (e) {
            console.error("加载收藏列表失败:", e);
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: isNarrow ? 15 : 30

        // 顶部登录区域
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Rectangle {
                width: isNarrow ? 30 : 44
                height: isNarrow ? 30 : 44
                radius: width / 2
                color: "transparent"
                clip: true
                Image {
                    anchors.fill: parent
                    source: "qrc:/image/04.jpg"
                    sourceSize: Qt.size(isNarrow ? 30 : 44, isNarrow ? 30 : 44)
                }
            }

            Button {
                id: loginButton
                text: isLoggedIn ? userName : qsTr("点击登录")
                width: 100
                height: 44
                visible: true
                onClicked: {
                    if (!isLoggedIn) {
                        login();
                    }
                }
            }
        }

        // 主要功能按钮
        RowLayout {
            id: mainFuncRow
            spacing: 10
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            visible: true

            Rectangle {
                id: homeButton
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 0 : 100
                color: homeTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/first.png"
                    width: isNarrow ? 30 : 44
                    height: isNarrow ? 30 : 44
                    anchors.centerIn: parent
                }

                TapHandler {
                    id: homeTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: console.log("首页点击")
                }
            }

            Rectangle {
                id: musicButton
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 0 : 100
                color: musicTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/music.png"
                    width: isNarrow ? 30 : 44
                    height: isNarrow ? 30 : 44
                    anchors.centerIn: parent
                }

                TapHandler {
                    id: musicTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: console.log("乐馆点击")
                }
            }
        }

        // 紧凑模式下的垂直功能按钮
        ColumnLayout {
            id: narrowFuncColumn
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            spacing: 10
            visible: isNarrow

            Rectangle {
                id: narrowHomeButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: narrowHomeTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/first.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                }

                TapHandler {
                    id: narrowHomeTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: console.log("首页点击 (紧凑模式)")
                }
            }

            Rectangle {
                id: narrowMusicButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: narrowMusicTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/music.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                }

                TapHandler {
                    id: narrowMusicTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: console.log("乐馆点击 (紧凑模式)")
                }
            }
        }

        // 菜单按钮区域
        ColumnLayout {
            id: menuColumn
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Rectangle {
                id: favoriteButton
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: favoriteTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 15
                    visible: !isNarrow

                    Image {
                        source: "qrc:/image/love.png"
                        width: 24
                        height: 24
                        sourceSize: Qt.size(24, 24)
                    }

                    Text {
                        text: qsTr("喜欢")
                        font.pixelSize: 16
                        color: "#333333"
                    }
                }

                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/love.png"
                    width: 24
                    height: 24
                }

                TapHandler {
                    id: favoriteTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        console.log("我的喜欢");
                        showFavoriteSongs();
                    }
                }
            }

            Rectangle {
                id: recentButton
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: recentTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 15
                    visible: !isNarrow

                    Image {
                        source: "qrc:/image/repl.png"
                        width: 24
                        height: 24
                        sourceSize: Qt.size(24, 24)
                    }

                    Text {
                        text: qsTr("最近播放")
                        font.pixelSize: 16
                        color: "#333333"
                    }
                }

                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/repl.png"
                    width: 24
                    height: 24
                }

                TapHandler {
                    id: recentTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        console.log("我的最近播放");
                        showRecentSongs();
                    }
                }
            }

            Rectangle {
                id: downloadButton
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: downloadTap.hovered ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 15
                    visible: !isNarrow

                    Image {
                        source: "qrc:/image/export-down.png"
                        width: 24
                        height: 24
                        sourceSize: Qt.size(24, 24)
                    }

                    Text {
                        text: qsTr("本地和下载")
                        font.pixelSize: 16
                        color: "#333333"
                    }
                }

                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/export-down.png"
                    width: 24
                    height: 24
                }

                TapHandler {
                    id: downloadTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        console.log("我的本地下载");
                        browseLocalMusic();
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        // 底部按钮区域
        RowLayout {
            Layout.preferredHeight: 10
            spacing: 10

            Rectangle {
                id: zoomButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: zoomTap.hovered ? "#e0e0e0" : "transparent"
                property string text: "缩放"

                Image {
                    visible: !isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/next.png"
                    width: 24
                    height: 24
                }

                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/next.png"
                    width: 20
                    height: 20
                }

                TapHandler {
                    id: zoomTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: toggleZoom()
                }
            }

            Rectangle {
                id: settingButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: settingTap.hovered ? "#e0e0e0" : "transparent"
                visible: !isNarrow

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/image/setting.png"
                    width: 24
                    height: 24
                }

                TapHandler {
                    id: settingTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: {
                        console.log("设置按钮点击");
                        showSettings();
                    }
                }
            }

            Rectangle {
                id: skinButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: skinTap.hovered ? "#e0e0e0" : "transparent"
                visible: !isNarrow

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/image/skin.png"
                    width: 24
                    height: 24
                }

                TapHandler {
                    id: skinTap
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: console.log("换肤按钮点击")
                }
            }
        }
    }
}
