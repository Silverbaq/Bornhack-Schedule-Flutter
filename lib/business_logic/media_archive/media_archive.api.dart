import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'model/File.dart';
import 'model/album.dart';

@singleton
class MediaApi {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://mediastaging.bornhack.org/api/v1/json',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  MediaApi() {
    _createDio();
  }

  void _createDio() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      //var user = await userDBController.getUser();

      options.headers['Cookie'] =
          'bma_sessionid=0kr19jifvdvp0j6lsux34bvplv301x4j';
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if (error.response?.statusCode == 401 &&
          error.response?.statusMessage == 'Unauthorized') {
        //await refreshToken();
        //return handler.resolve(await _retry(error.requestOptions));
      }
      return handler.next(error);
    }));
  }

  Future<bool> login() async {
    //final results = await _dio.get(_url + '/login');
    //var data = results.data;

    _dio.options.headers['Cookie'] =
        'bma_sessionid=0kr19jifvdvp0j6lsux34bvplv301x4j';

    return false;
  }

  // Files
  Future<File?> uploadFile(String title, String description, String source,
      String filePath, String filename,
      [String license = "CC_ZERO_1_0", String attribution = "string"]) async {
    try {
      var formData = FormData.fromMap({
        'metadata': FormData.fromMap({
          "license": license,
          "attribution": attribution,
          "title": title,
          "description": description,
          "source": source,
        }),
        'f': await MultipartFile.fromFile(filePath, filename: filename,),
      });

      final results = await _dio.post('/files/upload/', data: formData);
      if (results.statusCode == 201) {
        var json = results.data;
        return File.fromJson(json);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<File>> getFiles() async {
    try {
      final results = await _dio.get('/files/?limit=100');

      if (results.statusCode == 200) {
        var json = results.data;
        return json.map<File>((file) => File.fromJson(file)).toList();
      }
    } catch (e) {
      return List.empty();
    }
    return List.empty();
  }

  Future<File?> getFile(String uuid) async {
    try {
      final results = await _dio.get('/files/$uuid/');
      if (results.statusCode == 200) {
        var json = results.data;
        return File.fromJson(json);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<File?> updateFile(String uuid, String title, String description,
      String source, String license, String attribution) async {
    var data = {
      "title": title,
      "description": description,
      "source": source,
      "license": license,
      "attribution": attribution
    };

    final results = await _dio.patch('/files/' + uuid, data: data);
    if (results.statusCode == 200) {
      var json = results.data;
      return File.fromJson(json);
    }
    return null;
  }

  Future<File?> replaceFile(String uuid, String title, String description,
      String source, String license, String attribution) async {
    var data = {
      "title": title,
      "description": description,
      "source": source,
      "license": license,
      "attribution": attribution
    };

    final results = await _dio.put('/files/' + uuid, data: data);
    if (results.statusCode == 200) {
      var json = results.data;
      return File.fromJson(json);
    }
    return null;
  }

  Future<File?> deleteFile(String uuid) async {
    final results = await _dio.delete('/files/' + uuid);
    if (results.statusCode == 200) {
      var json = results.data;
      return File.fromJson(json);
    }
    return null;
  }

  // Albums
  Future<List<Album>> getAlbums() async {
    final results = await _dio.get('/albums/?limit=100');

    if (results.statusCode == 200) {
      var data = results.data;
      return data.map<Album>((album) => Album.fromJson(album));
    }
    return List.empty();
  }

  Future<Album?> createAlbum(Album album) async {
    final results = await _dio.post('/albums/albums/', data: album.toJson());
    if (results.statusCode == 201) {
      var json = results.data;
      return json.map<Album>((album) => Album.fromJson(album));
    }
    return null;
  }

  Future<Album?> getAlbum(String uuid) async {
    final results = await _dio.get('/albums/albums/$uuid/');
    if (results.statusCode == 200) {
      var json = results.data;
      return Album.fromJson(json);
    }
    return null;
  }

  Future<Album?> updateAlbum(String uuid, Album album) async {
    var data = album.toJson();
    final results = await _dio.patch('/albums/albums/$uuid/', data: data);
    if (results.statusCode == 200) {
      var json = results.data;
      return Album.fromJson(json);
    }
    return null;
  }

  Future<Album?> replaceAlbum(String uuid, Album album) async {
    var data = album.toJson();
    final results = await _dio.put('/albums/albums/$uuid/', data: data);
    if (results.statusCode == 200) {
      var json = results.data;
      return Album.fromJson(json);
    }
    return null;
  }

  Future<bool> deleteAlbum(String uuid) async {
    final results = await _dio.delete('/albums/albums/$uuid/');
    if (results.statusCode == 204) {
      return true;
    }
    return false;
  }

  @disposeMethod
  void dispose() {
    // logic to dispose instance
  }
}
