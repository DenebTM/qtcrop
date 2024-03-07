#ifndef CONTEXT_OBJ_H
#define CONTEXT_OBJ_H

#include <QObject>
#include <QProcess>

class ContextObj : public QObject {
    Q_OBJECT
public:
    ContextObj(std::string filename)
        : _filename(QString::fromStdString(filename)){};

    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged FINAL)

    Q_INVOKABLE void chooseFile();
    Q_INVOKABLE void saveCrop(int x, int y, int width, int height, QString &outFilename);
    Q_INVOKABLE void saveCropAs(int x, int y, int width, int height);

    QString filename() const { return _filename; }

    void setFilename(const QString &filename) { this->_filename = filename; }

signals:
    void filenameChanged();
    void saveCancelled();
    void ffmpegDone();

private:
    QString _filename;
    QProcess *ffmpegProcess = nullptr;
};

#endif // CONTEXT_OBJ_H
