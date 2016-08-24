#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QString::fromLatin1(argv[0]) + ".qml"));

    return app.exec();
}
