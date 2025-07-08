import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    // 歌词相关属性
    function parseLyrics(fileContent) {
        const lines = fileContent.split('\n');
        const pattern = /\[(\d{2}):(\d{2})\.(\d{2})\](.*)/;

        lyricModel.clear();
        currentLine = -1;

        for (const line of lines) {
            const match = line.match(pattern);
            if (match) {
                const minutes = parseInt(match[1]);
                const seconds = parseInt(match[2]);
                const ms = parseInt(match[3]);
                const time = minutes * 60000 + seconds * 1000 + ms * 10;

                lyricModel.append({
                    time: time,
                    text: match[4].trim()
                });
            }
        }
    }

    function updateCurrentLine(position) {
        if (lyricModel.count === 0) return;

        let newLine = -1;
        for (let i = lyricModel.count - 1; i >= 0; i--) {
            if (position >= lyricModel.get(i).time) {
                newLine = i;
                break;
            }
        }

        if (newLine !== currentLine) {
            currentLine = newLine;
            if (currentLine >= 0) {
                parsedLyricView.positionViewAtIndex(currentLine, ListView.Center);
                karaokeView.positionViewAtIndex(currentLine, ListView.Center);
            }
        }
    }

    function formatTime(ms) {
        const totalSec = ms / 1000;
        const min = Math.floor(totalSec / 60);
        const sec = Math.floor(totalSec % 60);
        const msec = Math.floor((ms % 1000) / 10);
        return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}.${String(msec).padStart(2, '0')}`;
    }
}
