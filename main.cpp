#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
//#include "lrcfilereader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QQMusic", "Main");

    return app.exec();
}
