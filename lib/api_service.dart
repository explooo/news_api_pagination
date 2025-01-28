import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'api_key.dart';

class ApiService {
  final String apiKey = ApiKey.apiKey;
  final String baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<Article>> fetchArticles(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?q=Google&sortBy=popularity&page=$page&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}