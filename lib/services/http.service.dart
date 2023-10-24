import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
// import 'package:fuodz/services/app.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.service.dart';
import 'local_storage.service.dart';

class HttpService {
  String host = Api.baseUrl;
  BaseOptions baseOptions;
  Dio dio;
  SharedPreferences prefs;

  Future<Map<String, String>> getHeaders() async {
    final userToken = await AuthServices.getAuthBearerToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      "lang": translator.activeLocale.languageCode,
    };
  }

  HttpService() {
    LocalStorageService.getPrefs();

    baseOptions = new BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = new Dio(baseOptions);
    dio.interceptors.add(getCacheManager().interceptor);
  }

  DioCacheManager getCacheManager() {
    return DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: Duration(hours: 1),
      ),
    );
  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic> queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio.get(
        uri,
        options: mOptions,
        queryParameters: queryParameters,
      );
    } catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio.post(
        uri,
        data: body,
        options: mOptions,
      );
    } catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    print("Uri: $uri");
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    print("Headers: ${await getHeaders()}");
    print("FormData: $body");

    Response response;
    try {
      response = await dio.post(
        uri,
        data: FormData.fromMap(body),
        options: mOptions,
      );
    } catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    Response response;

    try {
      response = await dio.patch(
        uri,
        data: body,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";

    Response response;
    try {
      response = await dio.delete(
        uri,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } catch (error) {
      response = formatDioExecption(error);
    }
    return response;
  }

  Response formatDioExecption(DioError ex) {
    var response = Response(requestOptions: ex.requestOptions);
    print("type ==> ${ex.type}");
    response.statusCode = 400;
    String msg = response.statusMessage;

    try {
      if (ex.type == DioErrorType.connectTimeout) {
        msg =
            "Connection timeout. Please check your internet connection and try again"
                .tr();
      } else if (ex.type == DioErrorType.sendTimeout) {
        msg =
            "Timeout. Please check your internet connection and try again"
                .tr();
      } else if (ex.type == DioErrorType.receiveTimeout) {
        msg =
            "Timeout. Please check your internet connection and try again"
                .tr();
      } else if (ex.type == DioErrorType.response) {
        msg =
            "Connection timeout. Please check your internet connection and try again"
                .tr();
      } else {
        msg = "Please check your internet connection and try again".tr();
      }
      response.data = {"message": msg};
    } catch (error) {
      response.statusCode = 400;
      msg = error.message ??
          "Please check your internet connection and try again".tr();
      response.data = {"message": msg};
    }

    throw msg;
  }

  //NEUTRALS
  Future<Response> getExternal(
    String url, {
    Map<String, dynamic> queryParameters,
  }) async {
    return dio.get(
      url,
      queryParameters: queryParameters,
    );
  }
}
