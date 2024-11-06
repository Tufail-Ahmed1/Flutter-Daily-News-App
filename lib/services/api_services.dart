import 'dart:convert';


import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/latest_news_model.dart';
import 'package:http/http.dart' as http;

import '../common/utilis.dart';

const baseUrl='https://newsapi.org/v2/';
const key= 'apikey=$apikey';
late String endPoint;

class ApiServices{

  Future<LatestNewsModel> getLatestNewsModel(String channelName) async {
    endPoint= 'top-headlines?sources=$channelName&';
    final url='$baseUrl$endPoint$key';

    http.Response response= await http.get(Uri.parse(url));

    if(response.statusCode==200)
      {
        return LatestNewsModel.fromJson(json.decode(response.body));
      }
    else
      {
        throw Exception('failed to load latest news');
      }

  }

  Future<CategoriesNewsModel> getCatogoriesModel(String category) async{
    endPoint='top-headlines?q=$category&';
    final url='$baseUrl$endPoint$key';
    http.Response response= await http.get(Uri.parse(url));
    if(response.statusCode==200)
      {
        return CategoriesNewsModel.fromJson(json.decode(response.body));
      }
    else
      {
        throw Exception('Failed to Load Catories Model');
      }


  }

}