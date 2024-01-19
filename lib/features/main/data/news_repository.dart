import 'package:news_app/features/main/models/article_model.dart';

abstract class NewsRepository {
  Future<List<ArticleModel>> getArticles();
  Future<List<ArticleModel>> getSaveArticles();
  Future<int> savedArticles({ArticleModel? articleModel});
  Future<int> updateArticle({ArticleModel? articleModel});
  Future<int> removeArticles({ArticleModel? articleModel});
}