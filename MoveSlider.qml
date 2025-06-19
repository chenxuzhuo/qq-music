import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    property alias row:_row

    RowLayout{
        id:_row
        spacing: 15
        Layout.fillWidth: true  // 关键修改：允许行填充宽度
        Layout.alignment: Qt.AlignVCenter

        Text{
            id:timeText
            text: play.formatTime(player.position)
            font.pixelSize: 12
            Layout.preferredWidth: 30  // 添加固定宽度
        }

        Slider{
            id:sliders

            height:25
            from: 0
            to: player.duration
            value: player.position

            MouseArea {
                anchors.fill: parent
                drag.target: sliders
                drag.axis: Drag.XAxis
                drag.threshold: 0
                propagateComposedEvents: true

                // 修改点1：移除暂停逻辑
                onPressed: (mouse) => {
                    updateTimer.stop()  // 仅停止自动更新
                    mouse.accepted = false
                }

                onReleased: (mouse) => {
                    player.position = slider.value
                    updateTimer.start()
                    mouse.accepted = false
                }
            }

            // 实时更新处理
            onValueChanged: {
                if (pressed) {
                    player.position = value
                }
            }
        }
        Label{
            id:text
            text:play.formatTime(player.duration)
            font.pixelSize: 12
            Layout.preferredWidth: 30   // 添加固定宽度
        }

        Timer {
            id: updateTimer
            interval: 500
            repeat: true
            running: true
            onTriggered: {
                if (!sliders.pressed) {
                    sliders.value = player.position
                }
            }
        }
        function formatTime(millis) {
            const seconds = Math.floor(millis / 1000)
            const minutes = Math.floor(seconds / 60)
            const secs = seconds % 60
            return `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
        }
    }
}
