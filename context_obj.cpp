#include "context_obj.h"

#include <filesystem>
#include <iostream>
#include <sstream>

void ContextObj::crop(int x, int y, int width, int height)
{
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

    const QString program = "ffmpeg";
    const QStringList args = QStringList()
                             << "-n"
                             << "-i" << QString(inPath.c_str()) << "-filter:v"
                             << QString(cropParams.str().c_str()) << QString(outPath.c_str());

    ffmpegProcess = new QProcess;

    ffmpegProcess->setProgram(program);
    ffmpegProcess->setArguments(args);
    ffmpegProcess->start();

    ffmpegProcess->waitForStarted(-1);

    QObject::connect(ffmpegProcess, &QProcess::finished, this, [this] {
        std::cout << ffmpegProcess->readAllStandardOutput().toStdString();
        std::cout << ffmpegProcess->readAllStandardError().toStdString();
        std::cout << std::endl;

        emit ffmpegDone();

        delete ffmpegProcess;
        ffmpegProcess = nullptr;
    });
}
