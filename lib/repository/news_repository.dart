import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/categories_news_model.dart';
import 'package:newsapp/models/news_channel_headlines_model.dart';

class NewsRepository{
  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName)async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=daedc280602d48c58d7056f5b1c7e057' ;
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=daedc280602d48c58d7056f5b1c7e057' ;
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}