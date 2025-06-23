import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia
import Qt.labs.platform   // 文件对话框需要

Rectangle {

    id: bottomRect

    property bool isPlaying: false  // 组件级属性声明

    // 媒体播放器
    MediaPlayer {
        id: player
        source: "file:///root/tmp/海阔天空.mp3"

        audioOutput: audiooutput

        onPlaybackStateChanged: {
            isPlaying = (playbackState === MediaPlayer.PlayingState)
            playButton.icon.name = isPlaying ? "media-playback-pause" : "media-playback-start"
        }

        onErrorOccurred: {
            console.error("播放错误:", errorString)
            errorDialog.open()
        }
    }

    AudioOutput{
            id:audiooutput
            volume:0.5
        }

    color: "#F5F5F5"

    Player{
        id:play
    }

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

        ColumnLayout{
            RowLayout{
                spacing:30
                Layout.preferredWidth:row.width
                Button{
                    Layout.preferredWidth:50
                    icon.name:"system-reboot"
                    icon.width:20
                    icon.height:20
                }
                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-backward"
                    icon.width:20
                    icon.height:20
                }
                Button{
                    id: playButton
                    Layout.preferredWidth:50
                    icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-stop" : "media-playback-start"
                    icon.width:20
                    icon.height:20
                    onClicked: {
                        player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
                    }
                }
                Button{
                    Layout.preferredWidth:50
                    icon.name:"media-seek-forward"
                    icon.width:20
                    icon.height:20
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
