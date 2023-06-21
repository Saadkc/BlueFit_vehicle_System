import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/data/repositories/subjectRepository.dart';
import 'package:eschool/utils/errorMessageKeysAndCodes.dart';

import 'package:external_path/external_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class DownloadFileState {}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileInProgress extends DownloadFileState {
  final double uploadedPercentage;

  DownloadFileInProgress(this.uploadedPercentage);
}

class DownloadFileSuccess extends DownloadFileState {
  final String downloadedFileUrl;
  DownloadFileSuccess(this.downloadedFileUrl);
}

class DownloadFileProcessCanceled extends DownloadFileState {}

class DownloadFileFailure extends DownloadFileState {
  final String errorMessage;

  DownloadFileFailure(this.errorMessage);
}

class DownloadFileCubit extends Cubit<DownloadFileState> {
  final SubjectRepository _subjectRepository;
  DownloadFileCubit(this._subjectRepository) : super(DownloadFileInitial());

  final CancelToken _cancelToken = CancelToken();

  void _downloadedFilePercentage(double percentage) {
    emit(DownloadFileInProgress(percentage));
  }

  Future<bool> _hasGivenManageDownloadFilePermissions() async {
    // if (Platform.isAndroid) {
    //   Permission storagePermission = await Permission.storage;
    //   final androidInfo = await DeviceInfoPlugin().androidInfo;
    //   final sdkVersion = await androidInfo.version.sdkInt;

    //   if (sdkVersion! >= 30) {
    //     //if sdk version is >= 30 then check for manage external storage
    //     Permission manageExternalStoragePermission =
    //         await Permission.manageExternalStorage;
    //     bool permissionsGiven = (await storagePermission.status).isGranted &&
    //         (await manageExternalStoragePermission.status).isGranted;

    //     if (permissionsGiven) {
    //       return true;
    //     }

    //     permissionsGiven = (await Permission.storage.request()).isGranted &&
    //         (await Permission.manageExternalStorage.request()).isGranted;
    //     return permissionsGiven;
    //   }
    // }

    //If platfomr is ios or android with < 30 sdk version
    Permission storagePermission = await Permission.storage;
    bool permissionsGiven = (await storagePermission.status).isGranted;
    if (permissionsGiven) {
      return permissionsGiven;
    }
    permissionsGiven = (await storagePermission.request()).isGranted;
    return permissionsGiven;
  }

  Future<void> writeFileFromTempStorage(
      {required String sourcePath, required String destinationPath}) async {
    final tempFile = File(sourcePath);
    final byteData = await tempFile.readAsBytes();
    final downloadedFile = File(destinationPath);
    //write into downloaded file
    await downloadedFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  void downloadFile(
      {required StudyMaterial studyMaterial,
      required bool storeInExternalStorage}) async {
    emit(DownloadFileInProgress(0.0));
    try {
      //if wants to download the file then
      if (storeInExternalStorage) {
        //if user has given permission to download and view file
        if (await _hasGivenManageDownloadFilePermissions()) {
          //storing the fie temp
          final Directory tempDir = await getTemporaryDirectory();
          final tempFileSavePath =
              "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await _subjectRepository.downloadStudyMaterialFile(
              cancelToken: _cancelToken,
              savePath: tempFileSavePath,
              updateDownloadedPercentage: _downloadedFilePercentage,
              url: studyMaterial.fileUrl);

          //download file
          String downloadFilePath = Platform.isAndroid
              ? (await ExternalPath.getExternalStoragePublicDirectory(
                  ExternalPath.DIRECTORY_DOWNLOADS))
              : (await getApplicationDocumentsDirectory()).path;

          downloadFilePath =
              "${downloadFilePath}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await writeFileFromTempStorage(
              sourcePath: tempFileSavePath, destinationPath: downloadFilePath);

          emit(DownloadFileSuccess(downloadFilePath));
        } else {
          //if user does not give permission to store files in download directory
          emit(DownloadFileFailure(
              ErrorMessageKeysAndCode.permissionNotGivenCode));
        }
      } else {
        //download file for just to see
        final Directory tempDir = await getTemporaryDirectory();
        final savePath =
            "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

        await _subjectRepository.downloadStudyMaterialFile(
            cancelToken: _cancelToken,
            savePath: savePath,
            updateDownloadedPercentage: _downloadedFilePercentage,
            url: studyMaterial.fileUrl);

        emit(DownloadFileSuccess(savePath));
      }
    } catch (e) {
      if (_cancelToken.isCancelled) {
        emit(DownloadFileProcessCanceled());
      } else {
        emit(DownloadFileFailure(e.toString()));
      }
    }
  }

  void cancelDownloadProcess() {
    _cancelToken.cancel();
  }
}
