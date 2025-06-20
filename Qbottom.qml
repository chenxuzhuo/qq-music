import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform   // 文件对话框需要

Rectangle {

    id: bottomRect
    color: "#F5F5F5"

    property MediaPlayer player
    property AudioOutput audioOutput
    property string currentPlayingPath
    property int playMode
    property var playModeIcons

    signal playNext()
    signal playPrevious()
    signal togglePlayPause()
    signal changePlayMode()

    /*property bool isPlaying: false  // 组件级属性声明
    property var mp3Files: []
    property string currentPlayingPath: ""
    property int playMode: 0
    property bool listExpanded: true
    // 播放模式图标路径
    property var playModeIcons: [
        "file:///root/musicfunction/list/image/order.png",
        "file:///root/musicfunction/list/image/random.png",
        "file:///root/musicfunction/list/image/circal.png"
    ]*/

    // 媒体播放器声明提升到Window作用域
    /*MediaPlayer {
        id: player
        audioOutput: AudioOutput {
            id: audioOutput
            volume: 0.5
        }
        onPlaybackStateChanged: {
            isPlaying = (playbackState === MediaPlayer.PlayingState)
            playButton.icon.name = isPlaying ? "media-playback-pause" : "media-playback-start"
        }
    }*/


    // 媒体播放器
    /*MediaPlayer {

        id: player
        audioOutput: AudioOutput {
            id: audioOutput
            volume: 0.5
        }

        onPlaybackStateChanged: {
            isPlaying = (playbackState === MediaPlayer.PlayingState)
            playButton.icon.name = isPlaying ? "media-playback-pause" : "media-playback-start"
        }
        onErrorOccurred: console.error("播放错误:", errorString)
    }*/


    // Player{
    //     id:play
    // }

    RowLayout{
        anchors.fill:parent
        anchors.leftMargin:0.02*window.width

        Image{
            width:44
            height:44
            source:"file:///root/qq-music/image/15.jpg"

            sourceSize: Qt.size(74,74)  // 优化加载尺寸
        }
        ColumnLayout{
            Text{
                id:textItem
                text:qsTr("QQ音乐 听我想听")
            }

            RowLayout{
                Layout.preferredWidth: textItem.width  // 关键修改：宽度与文本对齐
                    Image{
                        source: "file:///root/qq-music/image/love.png"  // 确保路径与.qrc文件一致
                        sourceSize: Qt.size(20,20)
                    }
                    Image{
                        source: "file:///root/qq-music/image/order.png"
                        sourceSize: Qt.size(20,20)
                    }
                    Image{
                        source: "file:///root/qq-music/image/more1.png"
                        sourceSize: Qt.size(20,20)
                    }
            }
        }
        Item{
            width: 44
            height:44
        }

        function formatFilePath(path) {
            return path.toString().replace("file://", "").replace(/^.*\//, "")
        }

        function formatTime(ms) {
            const sec = Math.floor(ms / 1000)
            return `${Math.floor(sec / 60)}:${String(sec % 60).padStart(2, '0')}`
        }

        ColumnLayout{
            RowLayout{
                spacing:30
                Layout.preferredWidth:row.width

                // 播放模式切换按钮
                // 播放模式按钮
                Button {
                    id: modeButton
                    icon.source: playModeIcons[playMode]
                    icon.width: 24
                    icon.height: 24
                    flat: true
                    onClicked: changePlayMode()
                    ToolTip.text: ["顺序播放", "随机播放", "单曲循环"][playMode]
                    ToolTip.visible: hovered
                }

                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-backward"
                    icon.width:20
                    icon.height:20
                    onClicked: playPrevious()
                }
                Button{

                    id: playButton
                    icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                    onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
                }
                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-forward"
                    icon.width:20
                    icon.height:20
                    onClicked: playNext()
                }

                Volume{
                    width:30
                    height:30
                }
            }


            MoveSlider{
                id:row
                Layout.fillWidth: true
            }
        }

        Item{
            Layout.preferredWidth:parent.width/10
            Layout.fillWidth:true
            Layout.fillHeight:true
        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"file:///root/qq-music/image/standard.png"
            sourceSize: Qt.size(44,44)

        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"file:///root/qq-music/image/device off.png"
            sourceSize: Qt.size(44,44)
        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"file:///root/qq-music/image/word.png"
            sourceSize: Qt.size(44,44)

        }

        Image{
            anchors.bottomMargin: 10
            Layout.preferredWidth:50
            source:"file:///root/qq-music/image/more.png"
            sourceSize: Qt.size(44,44)

        }

        Item{
            Layout.preferredWidth:parent.width/10
            Layout.fillWidth:true
            Layout.fillHeight:true
        }
    }
}
