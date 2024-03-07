#include "context_obj.h"

#include <iostream>
#include <sstream>

#include <QFileDialog>
#include <QMimeDatabase>
#include <QStandardPaths>

void ContextObj::chooseFile() {
    QFileDialog dialog;

    dialog.setAcceptMode(QFileDialog::AcceptOpen);
    dialog.setFileMode(QFileDialog::ExistingFile);
    dialog.setDirectory(QStandardPaths::standardLocations(QStandardPaths::MoviesLocation).last());
    dialog.setMimeTypeFilters({"video/mp4",
                               "video/quicktime",
                               "video/x-matroska",
                               "video/webm",
                               "video/avi",
                               "video/mpeg",
                               "video/x-ms-wmv",
                               "video/3gpp",
                               "video/3gpp2"});

    const bool accepted = dialog.exec() == QDialog::Accepted;
    if (accepted && !dialog.selectedFiles().isEmpty()) {
        setFilename(dialog.selectedFiles().constFirst());
        emit filenameChanged();
    }
}

void ContextObj::saveCropAs(int x, int y, int width, int height) {
    QFileDialog dialog;

    dialog.setAcceptMode(QFileDialog::AcceptSave);
    dialog.setFileMode(QFileDialog::AnyFile);
    dialog.setDirectoryUrl(QUrl(filename()).adjusted(QUrl::RemoveFilename));
    dialog.setMimeTypeFilters({"video/mp4",
                               "video/quicktime",
                               "video/x-matroska",
                               "video/webm",
                               "video/avi",
                               "video/mpeg",
                               "video/x-ms-wmv",
                               "video/3gpp",
                               "video/3gpp2"});
    dialog.selectMimeTypeFilter(QMimeDatabase().mimeTypeForFile(filename()).name());
    dialog.selectFile(filename());

    const bool accepted = dialog.exec() == QDialog::Accepted;
    if (accepted && !dialog.selectedFiles().isEmpty()) {
        saveCrop(x, y, width, height, dialog.selectedFiles().first());
    }
}

void ContextObj::saveCrop(int x, int y, int width, int height, QString &outFilename)
{
    // TODO: handle overwriting input file
    QString inFilename = filename();

    std::cout << "x: " << x << ", y: " << y << ", w: " << width << ", h: " << height << std::endl;

    std::ostringstream cropParams;
    cropParams << "crop=x=" << x << ":y=" << y << ":w=" << width << ":h=" << height;

    const QString program = "ffmpeg";
    const QStringList args = QStringList() << "-n"
                                           << "-i" << inFilename << "-filter:v"
                                           << QString(cropParams.str().c_str()) << outFilename;

    ffmpegProcess = new QProcess;

    ffmpegProcess->setProgram(program);
    ffmpegProcess->setArguments(args);

    QObject::connect(ffmpegProcess, &QProcess::finished, this, [this] {
        std::cout << ffmpegProcess->readAllStandardOutput().toStdString();
        std::cout << ffmpegProcess->readAllStandardError().toStdString();
        std::cout << std::endl;

        emit ffmpegDone();

        delete ffmpegProcess;
    });

    ffmpegProcess->start();
    ffmpegProcess->waitForStarted(-1);
}
