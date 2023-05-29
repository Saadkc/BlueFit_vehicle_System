import 'package:eschool_teacher/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//It will store the details like contact us and other
abstract class AppSettingsState {}

class AppSettingsInitial extends AppSettingsState {}

class AppSettingsFetchInProgress extends AppSettingsState {}

class AppSettingsFetchSuccess extends AppSettingsState {
  final String appSettingsResult;

  AppSettingsFetchSuccess({required this.appSettingsResult});
}

class AppSettingsFetchFailure extends AppSettingsState {
  final String errorMessage;

  AppSettingsFetchFailure(this.errorMessage);
}

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final SystemRepository _systemRepository;

  AppSettingsCubit(this._systemRepository) : super(AppSettingsInitial());

  void fetchAppSettings({required String type}) async {
    emit(AppSettingsFetchInProgress());

    try {
      final result = await _systemRepository.fetchSettings(type: type) ?? "";
      emit(AppSettingsFetchSuccess(appSettingsResult: result));
    } catch (e) {
      emit(AppSettingsFetchFailure(e.toString()));
    }
  }
}
