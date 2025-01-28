import 'package:flutter/material.dart';
import 'models/article.dart';
import "api_service.dart";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<Article> _articles = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchArticles();
      }
    });
  }

  Future<void> _fetchArticles() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final articles = await apiService.fetchArticles(_page);
    setState(() {
      _articles.addAll(articles);
      _page++;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News API Pagination'),
      ),
      body: _articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + 1,
              itemBuilder: (context, index) {
                if (index == _articles.length) {
                  return _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
                }
                final article = _articles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  leading: (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                      ? Image.network(article.urlToImage!, width: 100, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                );
              },
            ),
    );
  }
}