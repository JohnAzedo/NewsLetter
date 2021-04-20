import 'package:dio/dio.dart';
import 'package:news/models/news.dart';
import 'package:news/models/token.dart';
import 'package:news/repositories/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsRepository extends Repository {
  final String baseUrl = 'news';
  Token token;

  Future<void> _getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this.token = Token(
      access: preferences.getString('token_access'),
      refresh: preferences.getString('token_refresh'),
    );
  }

  Future<List<News>> fetchAll() async {
    await _getToken();
    final options =
        Options(headers: {'Authorization': 'Bearer ${this.token.access}'});

    Response response = await dio.get("$ipAddress/$baseUrl", options: options);
    final List<News> news = [];
    for (dynamic json in response.data) {
      news.add(News.fromJson(json));
    }
    return news;
  }

  Future<News> getNews(int id) async {
    await _getToken();
    final options =
        Options(headers: {'Authorization': 'Bearer ${this.token.access}'});

    Response response =
        await dio.get("$ipAddress/$baseUrl/$id", options: options);
    return News.fromJson(response.data);
  }
}
