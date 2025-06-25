import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    // 静音按钮（底层）
    Button {
        id: muteButton
        icon.name: audiooutput.muted ? "audio-volume-muted" : "audio-volume-high"
        icon.width: 20
        icon.height: 20
        checkable: true
        checked: audiooutput.muted
        hoverEnabled: true  // 启用按钮的hover状态

        // 按钮样式（添加hover状态指示）
        background: Rectangle {
            color: muteButton.hovered ? "#eeeeee" : "transparent"
            radius: 4
            border.color: "#cccccc"
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        // 按钮点击处理
        onClicked: {
            audiooutput.muted = !audiooutput.muted
            if (!audiooutput.muted) {
                audiooutput.volume = lastVolume
                volumeSlider.value = lastVolume
            }
            // 点击时重置隐藏定时器
            hideTimer.restart()
        }

        // 绑定hover状态到音量控件
        onHoveredChanged: {
            if (hovered) {
                volumeText.visible = true
                volumeSlider.visible = true
                volumeSlider.forceActiveFocus()
                hideTimer.restart()
            }
        }
    }

    // 音量滑块（悬浮层）
    Slider {
        id: volumeSlider
        from: 0.0
        to: 1.0
        value: audiooutput.volume
        stepSize: 0.1
        width: 80
        height: 30
        visible: false
        anchors {
            left: muteButton.right
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }

        // 实时更新音量
        onValueChanged: {
            audiooutput.volume = value
            volumeText.text = (value * 100).toFixed(0) + "%"
            lastVolume = value
        }

        // 添加hover状态控制
        onHoveredChanged: {
            if (hovered) {
                hideTimer.restart()
            } else {
                hideTimer.start()
            }
        }
    }

    // 音量显示
    Text {
        id: volumeText
        visible: false
        text: (volumeSlider.value * 100).toFixed(0) + "%"
        font.pixelSize: 12
        anchors {
            left: volumeSlider.right
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }

    // 延迟隐藏定时器（添加对滑块hover的响应）
    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: {
            if (!volumeSlider.hovered && !muteButton.hovered) {
                volumeSlider.visible = false
                volumeText.visible = false
            }
        }
    }

    // 保持原有属性
    property real lastVolume: 0.5
}
