import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item{
    // 静音按钮（底层
    Button {
        id: muteButton

        icon.name: audiooutput.muted ? "audio-volume-muted" : "audio-volume-high"
        icon.width: 20
        icon.height: 20
        checkable: true
        checked: audiooutput.muted
        onClicked: {
            audiooutput.muted = !audiooutput.muted
            if (!audiooutput.muted) {
                audiooutput.volume = lastVolume
                volumeSlider.value = lastVolume
            }
        }

        // 按钮样式
        background: Rectangle {
            color: muteButton.hovered ? "#eeeeee" : "transparent"
            radius: 4
            border.color: "#cccccc"
            border.width: 1
        }

        // 鼠标区域控制
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            // 鼠标进入时显示滑块
            onEntered: {
                volumeText.visible=true
                volumeSlider.visible = true
                volumeSlider.forceActiveFocus()
            }

            // 鼠标离开时延迟隐藏
            onExited: {
                hideTimer.restart()
            }

            // 防止点击按钮时触发离开事件
            onPressed: {
                mouse.accepted = false
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

    // 延迟隐藏定时器
    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: {
            volumeSlider.visible = false
            volumeText.visible = false
        }
    }
    property real lastVolume: 0.5
}

