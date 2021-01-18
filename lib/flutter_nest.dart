library flutter_nest;
import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' as found;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///An enum storing each platform the application might be running on
enum Platform {
  android,
  ios,
  web,
  unknown
}

/// This class contains methods for getting information about the application, such as platform, and whether or not it is running in debug mode
class NestInfo {

  static Platform getPlatform() {
    
    Platform platform;

    try {
      if (io.Platform.isAndroid) {
        platform = Platform.android;
      } else if (io.Platform.isIOS) {
        platform = Platform.ios;
      } else {
        platform = Platform.unknown;
      }
    } catch (e) {
      platform = Platform.web;
    }

    return platform;
  }

  static bool debugMode = found.kDebugMode;

  static void log(Object object) {
    if (debugMode) print(object);
  }

}

/// This class contains methods for making API calls to a RESTful API
class NestRest {

  static List<int> getCodes = [200];
  static List<int> postCodes = [200,201];
  static List<int> deleteCodes = [200,202,204];
  static List<int> putCodes = [200,204];

  static Map<String,String> _addAuth(String auth, Map<String,String> headers) {

    Map<String, String> newHeaders = HashMap<String, String>();

    for (String key in headers.keys) {
      newHeaders[key] = headers[key];
    }

    if (auth != null) {
      newHeaders["Authorization"] = "Bearer $auth";
    }

    return newHeaders;
  }

  static String _responseOutput(http.Response r) => "Request: ${r.request} returned Status Code: ${r.statusCode}.\nHeaders: ${r.headers}\nBody: ${r.body}";

  static http.Response _handleResponse(http.Response response,List<int> codes, bool sendError,VoidCallback onError) {
    NestInfo.log(_responseOutput(response));
    if (!codes.contains(response.statusCode)) {
      if (onError != null) {
        onError();
      }
      if (sendError) {
        return response;
      } else {
        return null;
      }
      
    } else {
      return response;
    }
  }

  /// Makes a GET request to `url`. If the request does not result in a success, it will only return the response object if `sendError` is true.
  /// If an error occurs, this will call `onError`.
  static Future<http.Response> get(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("GETting data from $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.get(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, getCodes, sendError, onError);
    });
  }

  /// Makes a POST request to `url`, with no data. Use [post] if you want to post data. If the request does not result in a success, it will only return the response object if `sendError` is true.
  /// If an error occurs, this will call `onError`.
  static Future<http.Response> postNew(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("POSTing empty data to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, postCodes, sendError, onError);
    });
  }

  /// Makes a POST request to `url`, with the body set as `data`. Use [postNew] if you do not want to post data. If the request does not result in a success, it will only return the response object if `sendError` is true.
  /// If an error occurs, this will call `onError`.
  static Future<http.Response> post(String url,Map<String, dynamic> data, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    
    final encodedData = jsonEncode(data);

    NestInfo.log("POSTing $data to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(url, body:encodedData, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, postCodes, sendError, onError);
    });
  }

  /// Makes a PUT request to `url`. If the request does not result in a success, it will only return the response object if `sendError` is true.
  /// If an error occurs, this will call `onError`.
  static Future<http.Response> put(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("PUTting data at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.put(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, putCodes, sendError, onError);
    });
  }

  /// Makes a DELETE request to `url`. If the request does not result in a success, it will only return the response object if `sendError` is true.
  /// If an error occurs, this will call `onError`.
  static Future<http.Response> delete(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("DELETting data at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.delete(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, deleteCodes, sendError, onError);
    });
  }


}
