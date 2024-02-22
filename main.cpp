#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <cstdlib>
#include <sys/wait.h>
#include <unistd.h>

#include <filesystem>
#include <iostream>
#include <sstream>

class ColonThree : public QObject {
  Q_OBJECT
public:
  ColonThree(std::string filename) : _filename(QString::fromStdString(filename)){};

  Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged FINAL)

  Q_INVOKABLE void crop(int x, int y, int width, int height) const {
    pid_t pid = fork();

    switch (pid) {
      case -1: {
        perror("fork");
        break;
      }

      default: {
        break;
      }

      case 0: {
        std::cout << "x: " << x << ", y: " << y << ", w: " << width << ", h: " << height << std::endl;

        std::filesystem::path inPath(filename().toStdString());
        std::filesystem::path outPath(inPath);
        auto ext = inPath.extension();
        outPath.replace_extension();
        auto outFilename = outPath.filename().string() + "_cropped";
        outPath.replace_filename(outFilename);
        outPath.replace_extension(ext);

        std::ostringstream cropParams;
        cropParams << "crop=x=" << x << ":y=" << y << ":w=" << width << ":h=" << height;

        execlp("ffmpeg", "ffmpeg", "-i", inPath.c_str(), "-filter:v", cropParams.str().c_str(), outPath.c_str(), NULL);
      }
    }
  }

  QString filename() const { return _filename; }

  void setFilename(const QString &filename) { this->_filename = filename; }

signals:
  void filenameChanged();

private:
  QString _filename;
};

#include "main.moc"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); },
      Qt::QueuedConnection);

  // TODO: do this via UI
  std::string filename;
  if (argc >= 2) {
    filename = std::string(argv[1]);
  } else {
    std::cout << "Video filename: ";
    fflush(stdout);
    getline(std::cin, filename);
    filename = filename.substr(0, filename.find_last_of('\n'));
  }
  std::cout << filename << std::endl;

  ColonThree eee(filename);
  engine.rootContext()->setContextProperty(u"eee"_qs, &eee);

  engine.load(QUrl(u"qrc:/vcrop/Main.qml"_qs));

  return app.exec();
}
