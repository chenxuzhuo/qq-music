import QtQuick
import QtMultimedia

Item {
    // 工具函数
    function formatFilePath(path) {
        return path.toString().replace("file://", "").replace(/^.*\//, "")
    }

    function playMusic(filePath, keepPlaying = false) {
        let normalizedPath = filePath.toString();
        // 确保路径以file://开头
        if (!normalizedPath.startsWith("file://")) {
            normalizedPath = "file://" + normalizedPath;
        }

        if (currentPlayingPath === normalizedPath) {
            togglePlayPause();
            return;
        }

        player.stop();
        player.source = normalizedPath;
        currentPlayingPath = normalizedPath;

        if (keepPlaying || isPlaying) {
            player.play();
        }
    }

    function togglePlayPause() {
        player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
    }


    function autoPlayNext() {
        if (folderModel.count === 0) return

        switch(playMode) {
        case 0: // 顺序播放
            playNext()
            break
        case 1: // 随机播放
            playRandom()
            break
        case 2: // 单曲循环
            replayCurrent()
            break
        }
    }

    function playRandom() {
        if (folderModel.count === 0) return

        let newIndex
        let currentIndex = getCurrentIndex()

        // 确保不重复播放同一首歌（除非只有一首）
        do {
            newIndex = Math.floor(Math.random() * folderModel.count)
        } while (newIndex === currentIndex && folderModel.count > 1)

        playMusic(folderModel.get(newIndex, "filePath"), true)
        const lrcPath = folderModel.get(newIndex, "filePath").replace(/\.mp3$/, ".lrc");
        lrcReader.readFile(lrcPath);
    }

    function replayCurrent() {
        if (currentPlayingPath) {
            player.position = 0
            player.play()
        }
    }

    function getCurrentIndex() {
        if (folderModel.count === 0) return -1

        const currentNormalized = currentPlayingPath.replace("file://", "")
        for (let i = 0; i < folderModel.count; i++) {
            if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                return i
            }
        }
        return -1
    }

    function playNext() {
        if (folderModel.count === 0) return;
            let currentIndex = -1;
            const currentNormalized = currentPlayingPath.replace("file://", "");
            for (let i = 0; i < folderModel.count; i++) {
                if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex === -1) currentIndex = 0;

            switch(playMode) {
            case 0: // 顺序播放
                currentIndex = (currentIndex + 1) % folderModel.count;
                break;
            case 1: // 随机播放
                // 确保不重复播放同一首歌
                let newIndex;
                do {
                    newIndex = Math.floor(Math.random() * folderModel.count);
                } while (newIndex === currentIndex && folderModel.count > 1);
                currentIndex = newIndex;
                break;
            case 2: // 单曲循环
                currentIndex = currentIndex; // 保持不变
                break;
            }

            playMusic(folderModel.get(currentIndex, "filePath"), true);
            const lrcPath = folderModel.get(currentIndex, "filePath").replace(/\.mp3$/, ".lrc");
            lrcReader.readFile(lrcPath);
    }

    function playPrevious() {
        if (folderModel.count === 0) return;
            // 获取当前索引（使用标准化路径比较）
            let currentIndex = -1;
            const currentNormalized = currentPlayingPath.replace("file://", "");
            for (let i = 0; i < folderModel.count; i++) {
                if (folderModel.get(i, "filePath").replace("file://", "") === currentNormalized) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex === -1) currentIndex = folderModel.count - 1;

            switch(playMode) {
            case 0: // 顺序播放
                currentIndex = (currentIndex - 1 + folderModel.count) % folderModel.count;
                playMusic(folderModel.get(currentIndex, "filePath"), true);
                break;
            case 1: // 随机播放
                currentIndex = Math.floor(Math.random() * folderModel.count);
                playMusic(folderModel.get(currentIndex, "filePath"), true);
                break;
            case 2: // 单曲循环
                if (currentPlayingPath) {
                    playMusic(currentPlayingPath, true);
                }
                break;
            }
            const lrcPath = folderModel.get(currentIndex, "filePath").replace(/\.mp3$/, ".lrc");
            lrcReader.readFile(lrcPath);
    }

    function addToSelectedFiles(name, path) {
        if (!mp3Files.some(f => f.path === path)) {
            mp3Files.push({name, path})
            mp3FilesChanged()
        }
    }

    function formatTime(ms) {
        const sec = Math.floor(ms / 1000)
        return `${Math.floor(sec / 60)}:${String(sec % 60).padStart(2, '0')}`
    }

    function playDefaultMusic() {
        const defaultPath = "file:///root/tmp/Go_Beyond_Andy.mp3"
        for (let i = 0; i < folderModel.count; i++) {
            if (folderModel.get(i, "filePath") === defaultPath) {
                playMusic(defaultPath, true)
                return
            }
        }
        if (folderModel.count > 0) {
            playMusic(folderModel.get(0, "filePath"), true)
        }
    }
}
