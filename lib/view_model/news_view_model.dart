

import 'package:newsapp/models/categories_news_model.dart';
import 'package:newsapp/repository/news_repository.dart';

import '../models/news_channel_headlines_model.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async{
    final response = await _rep.fetchNewChannelHeadlinesApi(channelName);
    return response ;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response ;
  }
}