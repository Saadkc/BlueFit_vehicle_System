import 'package:eschool_teacher/data/models/holiday.dart';
import 'package:eschool_teacher/utils/api.dart';

class SystemRepository {
  Future<dynamic> fetchSettings({required String type}) async {
    try {
      final result = await Api.get(
          queryParameters: {"type": type},
          url: Api.settings,
          useAuthToken: false);

      return result['data'];
    } catch (e) {
      print(e.toString());
      throw ApiException(e.toString());
    }
  }

  Future<List<Holiday>> fetchHolidays() async {
    try {
      final result = await Api.get(url: Api.holidays, useAuthToken: false);
      return ((result['data'] ?? []) as List)
          .map((holiday) => Holiday.fromJson(Map.from(holiday)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
