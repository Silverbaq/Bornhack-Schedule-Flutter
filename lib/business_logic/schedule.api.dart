import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ScheduleApi {
  final _dio = Dio();
  final _url = "https://bornhackredirect.vps.w4.dk";

  Future<String> fetchXml() async {
    final results = await _dio.get(_url);
    return results.data.toString();
  }

  @disposeMethod
  void dispose() {
    // logic to dispose instance
  }
}
