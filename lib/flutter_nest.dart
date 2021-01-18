library flutter_nest;
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
    if (auth != null) {
      headers["Authorization"] = auth;
    }

    return headers;
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

  static Future<http.Response> get(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("GETting data from $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.get(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, getCodes, sendError, onError);
    });
  }

  static Future<http.Response> postNew(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("POSTing empty data to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, postCodes, sendError, onError);
    });
  }

  static Future<http.Response> post(String url,Map<String, dynamic> data, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    
    final encodedData = jsonEncode(data);

    NestInfo.log("POSTing $data to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(url, body:encodedData, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, postCodes, sendError, onError);
    });
  }

  static Future<http.Response> put(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("PUTting data at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, putCodes, sendError, onError);
    });
  }

  static Future<http.Response> delete(String url, {String auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'},bool sendError = false, VoidCallback onError}) {
    NestInfo.log("DELETting data at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.delete(url, headers: _addAuth(auth, headers)).then((response) {
      return _handleResponse(response, deleteCodes, sendError, onError);
    });
  }


}
