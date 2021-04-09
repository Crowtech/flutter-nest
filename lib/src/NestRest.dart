import 'package:flutter_nest/src/NestInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'dart:convert';

/// This class contains methods for making API calls to a RESTful API
class NestRest {

  static Map<String,String?> _addAuth(String? auth, Map<String,String> headers) {

    Map<String, String?> newHeaders = HashMap<String, String?>();

    for (String key in headers.keys) {
      newHeaders[key] = headers[key];
    }

    if (auth != null) {
      newHeaders["Authorization"] = "Bearer $auth";
    }

    return newHeaders;
  }

  static String _responseOutput(http.Response r) => "Request: ${r.request} returned Status Code: ${r.statusCode}.\nHeaders: ${r.headers}\nBody: ${r.body}";


  /// Makes a GET request to `url`. Returns a http Response object
  static Future<http.Response> get(String url, {String? auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'}}) {
    NestInfo.log("GETting data from $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.get(Uri.parse(Uri.encodeFull(url)), headers: _addAuth(auth, headers) as Map<String, String>?).then((response) {
      NestInfo.log(_responseOutput(response));
      return response;
    });
  }

  /// Makes a POST request to `url`, with no data. Use [post] if you want to post data.
  static Future<http.Response> postNew(String url, {String? auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'}}) {
    NestInfo.log("POSTing empty data to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(Uri.parse(Uri.encodeFull(url)), headers: _addAuth(auth, headers) as Map<String, String>?).then((response) {
      NestInfo.log(_responseOutput(response));
      return response;
    });
  }

  /// Makes a POST request to `url`, with the body set as `body`. Use [postNew] if you do not want to post data.
  static Future<http.Response> post(String url,dynamic body, {String? auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'}}) {
    
    if (headers["Content-Type"] == "application/json") {
      body = jsonEncode(body);
    }

    NestInfo.log("POSTing $body to $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.post(Uri.parse(Uri.encodeFull(url)), body:body, headers: _addAuth(auth, headers) as Map<String, String>?).then((response) {
      NestInfo.log(_responseOutput(response));
      return response;
    });
  }

  /// Makes a PUT request to `url`, with optional `body` data.
  static Future<http.Response> put(String url, {String? auth, dynamic body, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'}}) {
    
    if (headers["Content-Type"] == "application/json") {
      body = jsonEncode(body);
    }
    
    NestInfo.log("PUTting ${body ?? "data"} at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.put(Uri.parse(Uri.encodeFull(url)), body: body, headers: _addAuth(auth, headers) as Map<String, String>?).then((response) {
      NestInfo.log(_responseOutput(response));
      return response;
    });
  }

  /// Makes a DELETE request to `url`.
  static Future<http.Response> delete(String url, {String? auth, Map<String, String> headers = const {'Content-Type': 'application/json','Accept': 'application/json'}}) {
    NestInfo.log("DELETting data at $url using ${auth == null ? "no token" : "token: $auth"}");
    return http.delete(Uri.parse(Uri.encodeFull(url)), headers: _addAuth(auth, headers) as Map<String, String>?).then((response) {
      NestInfo.log(_responseOutput(response));
      return response;
    });
  }


}
