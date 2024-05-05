import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../models/collections.dart';
import '../models/collections_photos.dart';
import '../models/photos.dart';
import '../models/search_photos.dart';
import 'http_helper.dart';

class Network {


  static String BASE = "api.unsplash.com";
 // static String CLIENT_ID = "jkUJGTq0dFc4N0egBT1zHq36MT2wuF95jdO2MZXvRB4";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String API_PHOTOS = "/photos";
  static String API_SEARCH_PHOTOS = "/search/photos";
  static String API_COLLECTIONS = "/collections";
  static String API_COLLECTIONS_PHOTOS = "/collections/:id/photos";

  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  static get currentPage => null;

  // /* Http Requests */
  // static Future<String?> GET(String api, Map<String, String> params) async {
  //   var uri = Uri.https(BASE, api, params);
  //   var response = await get(uri, headers: headers);
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   }
  //   return null;
  // }
  static Future<String?> GET(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(BASE, api, params);

      var response = await client.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  /* Http Params */
  static Map<String, String> paramsPhotos(int currentPage) {
    Map<String, String> params = {};
    params.addAll({
      'page': currentPage.toString(),
      'per_page': '20',
      'order_by': 'popular',
      'client_id': HttpInterceptor.CLIENT_ID
    });
    return params;
  }

  static Map<String, String> paramsSearchPhotos(String query ,int currentPage) {
    Map<String, String> params = {};
    params.addAll({
  'query': query,
      'page': currentPage.toString(),
      'per_page': '20',
      'client_id': HttpInterceptor.CLIENT_ID
    });
    return params;
  }

  static Map<String, String> paramsCollections(int currentPage) {
    Map<String, String> params = {};
    params.addAll({'page': currentPage.toString(), 'per_page': '10', 'client_id':HttpInterceptor. CLIENT_ID});
    return params;
  }

  static Map<String, String> paramsCollectionsPhotos(int  currentPage) {
    Map<String, String> params = {};
    params.addAll({'page':currentPage.toString(), 'per_page': '20', 'client_id':HttpInterceptor.CLIENT_ID});
    return params;
  }

  /* Http Parsing */
  static List<Photo> parsePhotosList(String response) {
    dynamic json = jsonDecode(response);
    return List<Photo>.from(json.map((x) => Photo.fromJson(x)));
  }

  static SearchPhotosRes parseSearchPhotos(String response) {
    dynamic json = jsonDecode(response);
    return SearchPhotosRes.fromJson(json);
  }

  static List<Collections> parseCollections(String response) {
    dynamic json = jsonDecode(response);
    return List<Collections>.from(json.map((x) => Collections.fromJson(x)));
  }

  static List<CollectionsPhotos> parseCollectionsPhotos(String response) {
    dynamic json = jsonDecode(response);
    return List<CollectionsPhotos>.from(
        json.map((x) => CollectionsPhotos.fromJson(x)));
  }
}
