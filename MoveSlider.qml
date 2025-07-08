//writed by Chengyan Yao
//Synchronization of the progress bar and music playback

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
            text: currentPlayingPath ? funct.formatFilePath(currentPlayingPath) : ""
            elide: Text.ElideMiddle
            Layout.preferredWidth: 150
            font.bold: true
            color: "blue"
        }

        Text {
            id: timeText
            text: funct.formatTime(player.position)
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
        }

        Label {
            id: text
            text: funct.formatTime(player.duration)
            font.pixelSize: 12
            Layout.preferredWidth: 30
        }

        // 播放速度选择器
        ComboBox {
            id: speedSelector
            model: [0.5, 0.8, 1.0, 1.2, 1.5, 2.0]
            currentIndex: 2  // 默认1倍速
            onActivated: {
                player.playbackRate = currentText
                progressSlider.value = currentText
            }
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
}

