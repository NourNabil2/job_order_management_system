import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:image_picker/image_picker.dart';

const String baseURL = '';

class Http {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      headers: {
        'Content-Type': 'application/json',

      },
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      followRedirects: true, // السماح بإعادة التوجيه
      validateStatus: (status) => status! < 500, // عدم اعتبار 301 كخطأ
    ),
  )..httpClientAdapter = HttpClientAdapter() // Add this
    ..httpClientAdapter = IOHttpClientAdapter();

  // POST request using Dio
  static Future<dynamic> postdata({required String path, required Map data}) async {
    try {
      Response response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', // Add this line

          },
        )
      );
      log('POST request to $path successful: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('DioError during POST to $path: $e');
      log('POST request body: ${jsonEncode(data)}');
      log('POST request body before encoding: $data');
      log('POST request body after encoding: ${jsonEncode(data)}');
      log('POST request URL: ${dio.options.baseUrl}$path');
      if (e.response != null) {
        log('Response: ${e.response!.statusCode}, ${e.response!.data}');
      }
      throw Exception('Failed POST request: ${e.message}');
    } catch (e) {
      log('Unexpected error during POST: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // DELETE request using Dio
  static Future<dynamic> deletedata({required String path, required Map<String, dynamic> data}) async {
    try {
      Response response = await dio.delete(
        path,
        data: jsonEncode(data),
      );
      log('DELETE request to $path successful: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('DioError during DELETE to $path: ${e.message}');
      if (e.response != null) {
        log('Response: ${e.response!.statusCode}, ${e.response!.data}');
      }
      throw Exception('Failed DELETE request: ${e.message}');
    } catch (e) {
      log('Unexpected error during DELETE: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // GET request using Dio
  static Future<dynamic> getdata({required String path, Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(
        path,
        queryParameters: queryParameters,
      );
      log('GET request to $path successful: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('DioError during GET to $path: ${e.message}');
      if (e.response != null) {
        log('Response: ${e.response!.statusCode}, ${e.response!.data}');
      }
      throw Exception('Failed GET request: ${e.message}');
    } catch (e) {
      log('Unexpected error during GET: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // POST request with file upload using Dio
  static Future<dynamic> postFile({
    required String path,
    required Map<String, dynamic> data,
    XFile? imageFile,
  }) async {
    try {
      FormData formData = FormData.fromMap(data);

      if (imageFile != null) {
        if (await imageFile.length() == 0) {
          throw Exception('File is empty, cannot upload.');
        }
        String fileName = imageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(imageFile.path, filename: fileName),
        ));
      }

      Response response = await dio.post(path, data: formData,options: Options(headers: {
        "User-Agent": "PostmanRuntime/7.43.0",
        "Connection": "keep-alive",
      }));
      log('File upload to $path successful: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('DioError during file upload to $path: ${e.message}');
      if (e.response != null) {
        log('Response: ${e.response!.statusCode}, ${e.response!.data}');
      }
      throw Exception('Failed file upload: ${e.message}');
    } catch (e) {
      log('Unexpected error during file upload: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
