#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <iostream>

class ColonThree : public QObject {
  Q_OBJECT
public:
  Q_INVOKABLE void crop(int x, int y, int width, int height) const {
    std::cout << "x: " << x << ", y: " << y << ", w: " << width << ", h: " << height << std::endl;
  }
};

#include "main.moc"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); },
      Qt::QueuedConnection);

  ColonThree eee;
  engine.rootContext()->setContextProperty(u"eee"_qs, &eee);

  engine.load(QUrl(u"qrc:/vcrop/Main.qml"_qs));

  return app.exec();
}
