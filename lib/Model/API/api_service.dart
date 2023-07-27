import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ApiService {
  Future getResponse(String url) async {
    try {
      dynamic responseJson;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + url + ApiConstants.entityFilter));
      if (response.statusCode == 200) {
        responseJson = jsonDecode(response.body);
      } else {
        responseJson = returnResponse(response);
        debugPrint("debug1 " + responseJson.toString());
      }
      return responseJson;
    } catch (e) {
      log("catch e in api service" + e.toString());
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        log("case 200");
        // log(response.body.toString());
        dynamic responseJson = jsonDecode(response.body);
        // log("AAAAAAAAAAAAAAAAAAAAA");
        return responseJson;
      case 400:
        log("case 400");
        throw Exception(response.body);
      case 401:
      case 403:
        log("case 401");
        throw Exception(response.body);
      case 500:
      default:
        throw Exception(response.body);
    }
  }
}
