import 'package:news_app/core/resources/network/network_imports.dart';
import 'package:news_app/features/main/data/app_database.dart';
import 'package:news_app/features/main/data/news_repository.dart';
import 'package:news_app/features/main/models/article_model.dart';

class NewsApiServices implements NewsRepository {
  final DioClient _dioClient;
  final AppDataBase _database;

  const NewsApiServices(this._dioClient, this._database);

  @override
  Future<List<ArticleModel>> getArticles() async {
    final response =
        await _dioClient.get(Endpoints.topHeadlines, queryParameters: {
      "apiKey": Endpoints.apiKey,
      "country": Endpoints.country,
      "category": Endpoints.category,
    });
    if (response.statusCode == 200) {
      final articles = <ArticleModel>[];
      for (var item in response.data["articles"]) {
        articles.add(ArticleModel.fromJson(item));
      }
      return articles;
    } else {
      throw response;
    }
  }

  @override
  Future<List<ArticleModel>> getSaveArticles() async {
    return await _database.articleDao.getArticles();
  }

  @override
  Future<int> removeArticles({ArticleModel? articleModel}) async {
    return await _database.articleDao
        .deleteArticle(articleModel ?? ArticleModel());
  }

  @override
  Future<int> savedArticles({ArticleModel? articleModel}) async {
    return await _database.articleDao
        .insertArticle(articleModel ?? ArticleModel());
  }

  @override
  Future<int> updateArticle({ArticleModel? articleModel}) async {
    return await _database.articleDao
        .updateArticle(articleModel ?? ArticleModel());
  }
}
