import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    // 歌词相关属性
    property var lyrics: []
    property int currentLyricIndex: -1
    property string lrcFile: "qrc:/海阔天空.lrc"  // 修改点2（使用资源路径）

    // 加载歌词
    function loadLyrics() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", lrcFile, false)  // 修改点3（直接使用资源路径）
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var lines = xhr.responseText.split('\n')
                lyrics = []
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.match(/^$$\d{2}:\d{2}\.\d{2}$$.+/)) {
                        var timeStr = line.substring(1, line.indexOf(']'))
                        var text = line.substring(line.indexOf(']') + 1).trim()
                        var timeParts = timeStr.split(':')
                        var minutes = parseInt(timeParts[0])
                        var seconds = parseFloat(timeParts[1])
                        var ms = minutes * 60000 + seconds * 1000
                        lyrics.push({time: ms, text: text})
                    }
                }
                lyrics.sort((a, b) => a.time - b.time)
            }
        }
        xhr.send()
    }

    // 更新歌词显示
    function updateLyrics(position) {  // 参数名保持一致
        if (lyrics.length === 0) return

        var newIndex = -1
        for (var i = 0; i < lyrics.length - 1; i++) {
            if (position >= lyrics[i].time && position < lyrics[i+1].time) {
                newIndex = i
                break
            }
        }
        if (newIndex === -1 && position >= lyrics[lyrics.length-1].time) {
            newIndex = lyrics.length - 1
        }

        if (newIndex !== currentLyricIndex) {
            currentLyricIndex = newIndex
            lyricList.currentIndex = currentLyricIndex
            lyricList.positionViewAtIndex(currentLyricIndex, ListView.Center)
        }
    }

    // 格式化时间显示
       function formatTime(ms) {
           if(isNaN(ms))return "00:00"
           var seconds=Math.floor(ms/1000)
           var minutes=Math.floor(seconds/60)
           seconds=seconds % 60
           return (minutes <10 ? "0":"")+minutes+":"+(seconds<10 ? "0":"")+seconds
       }


       Component.onCompleted: {
           loadLyrics()
       }
}
