#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "context_obj.h"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); },
      Qt::QueuedConnection);

  std::string filename = "";
  if (argc >= 2) {
    filename = std::string(argv[1]);
  }

  ContextObj ctx(filename);
  engine.rootContext()->setContextProperty(u"ctx"_qs, &ctx);

  engine.load(QUrl(u"qrc:/qtcrop_qml/Main.qml"_qs));

  return app.exec();
}
