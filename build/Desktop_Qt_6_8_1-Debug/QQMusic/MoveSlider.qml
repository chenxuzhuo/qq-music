import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    property alias row: _row

    RowLayout {
        id: _row
        spacing: 15
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter

        Label {
            text: currentPlayingPath ? formatFilePath(currentPlayingPath) : ""
            elide: Text.ElideMiddle
            Layout.preferredWidth: 150
            font.bold: true
            color: "blue"
        }

        Text {
            id: timeText
            text: formatTime(player.position)
            font.pixelSize: 12
            Layout.preferredWidth: 30
        }

        Slider {
            id: progressSlider
            from: 0
            to: player.duration
            value: player.position
            enabled: player.seekable
            onMoved: player.position = value
            Layout.fillWidth: true

            /*id: sliders
            height: 25
            from: 0
            to: player.duration
            value: player.position
            live: true  // 关键：启用实时更新

            // 处理按压状态
            onPressedChanged: {
                if (pressed) {
                    updateTimer.stop()
                } else {
                    player.position = value
                    updateTimer.start()
                }
            }

            // 处理点击跳转（Qt 5.15+）
            onMoved: {
                if (!pressed) {  // 处理点击事件
                    player.position = value
                }
            }

            // 实时更新处理
            Connections {
                target: player
                function onPositionChanged() {
                    if (!progressSlider.pressed) {
                        progressSlider.value = player.position
                    }
                }
            }*/
        }

        Label {
            id: text
            text: formatTime(player.duration)
            font.pixelSize: 12
            Layout.preferredWidth: 30
        }

        Timer {
            id: updateTimer
            interval: 500
            repeat: true
            running: true
            onTriggered: {
                if (!progressSlider.pressed) {
                    progressSlider.value = player.position
                }
            }
        }
    }

    function formatTime(millis) {
        const seconds = Math.floor(millis / 1000)
        const minutes = Math.floor(seconds / 60)
        const secs = seconds % 60
        return `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
    }

    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }
}

