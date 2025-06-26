#pragma once

#ifndef LRCFILEREADER_H
#define LRCFILEREADER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

class LrcFileReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileContent READ fileContent NOTIFY fileContentChanged)
    Q_PROPERTY(QVariantList parsedLyrics READ parsedLyrics NOTIFY parsedLyricsChanged)
    QML_ELEMENT

public:
    explicit LrcFileReader(QObject *parent = nullptr);

    Q_INVOKABLE bool readFile(const QString &filePath);
    QString fileContent() const;
    QVariantList parsedLyrics() const;

signals:
    void fileContentChanged();
    void parsedLyricsChanged();

private:
    QString m_fileContent;
    QVariantList m_parsedLyrics;

    void parseLrcContent();
};

#endif // LRCFILEREADER_H
