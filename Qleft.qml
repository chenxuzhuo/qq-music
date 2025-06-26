//By quzhiyao 2023051604020
//A rectangle about left side component

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

/*Rectangle {
    id: leftRect
    color: "#FFFFFF"
    width: isNarrow ? 60 : 250  // 根据状态调整宽度
    state: "wide"

    // 定义两种状态
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

    // 状态切换动画
    transitions: Transition {
        NumberAnimation { property: "width"; duration: 300; easing.type: Easing.InOutQuad }
    }

    // 属性跟踪当前状态
    property bool isNarrow: false

    // 缩放按钮点击处理
    function toggleZoom() {
        isNarrow = !isNarrow;
        state = isNarrow ? "narrow" : "wide";
    }

    // 添加收藏列表
        property var favoriteSongs: []

        // 在Component.onCompleted中添加初始化
        Component.onCompleted: {
            // 尝试从本地存储加载收藏列表
            try {
                const savedFavorites = Qt.application.settings.value("favorites");
                if (savedFavorites) {
                    favoriteSongs = JSON.parse(savedFavorites);
                }
            } catch (e) {
                console.error("加载收藏列表失败:", e);
            }
        }

        // 保存收藏列表到本地
        function saveFavorites() {
            try {
                Qt.application.settings.setValue("favorites", JSON.stringify(favoriteSongs));
            } catch (e) {
                console.error("保存收藏列表失败:", e);
            }
        }

        // 添加歌曲到收藏
        function addFavorite(filePath) {
            const normalizedPath = filePath.replace("file://", "");

            // 检查是否已存在
            if (!favoriteSongs.includes(normalizedPath)) {
                favoriteSongs.push(normalizedPath);
                saveFavorites();
                console.log("已添加到收藏:", normalizedPath);
            }

            console.log("添加收藏:", normalizedPath)
            favoriteSongsChanged() // 确保触发信号
        }

        // 从收藏移除歌曲
        function removeFavorite(filePath) {
            const normalizedPath = filePath.replace("file://", "");
            const index = favoriteSongs.indexOf(normalizedPath);

            if (index >= 0) {
                favoriteSongs.splice(index, 1);
                saveFavorites();
                console.log("已从收藏移除:", normalizedPath);
            }

            console.log("移除收藏:", normalizedPath)
                favoriteSongsChanged() // 确保触发信号
        }

    ColumnLayout {
        anchors.fill: parent
        spacing: isNarrow ? 15 : 30  // 紧凑模式下减少间距

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
                text: qsTr("点击登陆")
                width: 100
                height: 44
                visible: true
            }
        }

        // 主要功能按钮 - 只在宽模式下显示
        RowLayout {
            id: mainFuncRow
            spacing: 10
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            visible: true

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 0 : 100
                color: mouseArea1.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/first.png"
                    width: isNarrow ? 30 : 44
                    height: isNarrow ? 30 : 44
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouseArea1
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("首页点击")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 0 : 100
                color: mouseArea2.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/music.png"
                    width: isNarrow ? 30 : 44
                    height: isNarrow ? 30 : 44
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouseArea2
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("乐馆点击")
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

            // 首页按钮 (紧凑模式)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: narrowMouseArea1.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/first.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: narrowMouseArea1
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("首页点击 (紧凑模式)")
                }
            }

            // 乐馆按钮 (紧凑模式)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: narrowMouseArea2.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                Image {
                    source: "qrc:/image/music.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: narrowMouseArea2
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("乐馆点击 (紧凑模式)")
                }
            }
        }

        // 菜单按钮区域 (宽模式)
        ColumnLayout {
            id: menuColumn
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: recentMouseArea.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                // 宽模式下的布局
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

                // 紧凑模式下的布局
                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/love.png"
                    width: 24
                    height: 24
                }

                MouseArea {
                    id: recentMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("我的喜欢")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: favoriteMouseArea.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                // 宽模式下的布局
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

                // 紧凑模式下的布局
                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/repl.png"
                    width: 24
                    height: 24
                }

                MouseArea {
                    id: favoriteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("我的最近播放")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: isNarrow ? 40 : 50
                color: downMouseArea.containsMouse ? "#e0e0e0" : "#f0f0f0"
                radius: 5

                // 宽模式下的布局
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

                // 紧凑模式下的布局
                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                     source: "qrc:/image/export-down.png"
                    width: 24
                    height: 24
                }

                MouseArea {
                    id: downMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("我的本地下载")
                }
            }

            // 弹性空间
            Item {
                Layout.fillHeight: true
            }
        }

        // 底部按钮区域
        RowLayout {
            Layout.preferredHeight: 10
            spacing: 10

            // 缩放按钮 (始终显示)
            Rectangle {
                id: zoomButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: zoomMouseArea.containsMouse ? "#e0e0e0" : "transparent"
                property string text: "缩放"

                // 宽模式图标
                Image {
                    visible: !isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/next.png"
                    width: 24
                    height: 24
                }

                // 紧凑模式图标
                Image {
                    visible: isNarrow
                    anchors.centerIn: parent
                    source: "qrc:/image/next.png"
                    width: 20
                    height: 20
                }

                MouseArea {
                    id: zoomMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: toggleZoom()
                }
            }

            // 设置按钮 (宽模式下显示)
            Rectangle {
                id: settingButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: settingMouseArea.containsMouse ? "#e0e0e0" : "transparent"
                visible: !isNarrow

                Image {
                    anchors.centerIn: parent

                    source: "qrc:/image/setting.png"
                    width: 24
                    height: 24
                }

                MouseArea {
                    id: settingMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("设置按钮点击")
                }
            }

            // 换肤按钮 (宽模式下显示)
            Rectangle {
                id: skinButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: skinMouseArea.containsMouse ? "#e0e0e0" : "transparent"
                visible: !isNarrow

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/image/skin.png"

                    width: 24
                    height: 24
                }

                MouseArea {
                    id: skinMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("换肤按钮点击")
                }
            }
        }
    }
}*/


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

    function toggleZoom() {
        isNarrow = !isNarrow;
        state = isNarrow ? "narrow" : "wide";
    }

    property var favoriteSongs: []

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

    function saveFavorites() {
        try {
            Qt.application.settings.setValue("favorites", JSON.stringify(favoriteSongs));
        } catch (e) {
            console.error("保存收藏列表失败:", e);
        }
    }

    function addFavorite(filePath) {
        const normalizedPath = filePath.replace("file://", "");
        if (!favoriteSongs.includes(normalizedPath)) {
            favoriteSongs.push(normalizedPath);
            saveFavorites();
            console.log("已添加到收藏:", normalizedPath);
        }
        console.log("添加收藏:", normalizedPath)
        favoriteSongsChanged()
    }

    function removeFavorite(filePath) {
        const normalizedPath = filePath.replace("file://", "");
        const index = favoriteSongs.indexOf(normalizedPath);
        if (index >= 0) {
            favoriteSongs.splice(index, 1);
            saveFavorites();
            console.log("已从收藏移除:", normalizedPath);
        }
        console.log("移除收藏:", normalizedPath)
        favoriteSongsChanged()
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
                text: qsTr("点击登陆")
                width: 100
                height: 44
                visible: true
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
                    onTapped: console.log("我的喜欢")
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
                    onTapped: console.log("我的最近播放")
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
                    onTapped: console.log("我的本地下载")
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
                    onTapped: console.log("设置按钮点击")
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
