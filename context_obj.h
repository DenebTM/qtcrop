#ifndef CONTEXT_OBJ_H
#define CONTEXT_OBJ_H

#include <QObject>
#include <QQmlContext>

#include <cstdlib>
#include <sys/wait.h>
#include <unistd.h>

#include <filesystem>
#include <iostream>
#include <sstream>

class ContextObj : public QObject {
  Q_OBJECT
public:
  ContextObj(std::string filename) : _filename(QString::fromStdString(filename)){};

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

#endif // CONTEXT_OBJ_H
