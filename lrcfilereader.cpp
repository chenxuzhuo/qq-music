#include "lrcfilereader.h"
#include <QRegularExpression>

LrcFileReader::LrcFileReader(QObject *parent) : QObject(parent) {}

bool LrcFileReader::readFile(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        m_fileContent = "无法打开文件: " + filePath;
        emit fileContentChanged();

        return false;
    }

    QTextStream in(&file);
    m_fileContent = in.readAll();
    file.close();

    parseLrcContent();
    emit fileContentChanged();
    return true;
}

QString LrcFileReader::fileContent() const
{
    return m_fileContent;
}

QVariantList LrcFileReader::parsedLyrics() const
{
    return m_parsedLyrics;
}

void LrcFileReader::parseLrcContent()
{
    m_parsedLyrics.clear();

    QStringList lines = m_fileContent.split('\n');

    QRegularExpression regex("\\[(\\d+):(\\d+)\\.(\\d+)\\](.*)");

    for (const QString &line : lines) {
        QRegularExpressionMatch match = regex.match(line);
        if (match.hasMatch()) {
            int min = match.captured(1).toInt();
            int sec = match.captured(2).toInt();
            int msec = match.captured(3).leftJustified(3, '0').toInt();
            QString text = match.captured(4).trimmed();

            if (!text.isEmpty()) {
                QVariantMap item;
                item["time"] = (min * 60 + sec) * 1000 + msec;
                item["text"] = text;
                m_parsedLyrics.append(item);
            }
        }
    }

    emit parsedLyricsChanged();
}
