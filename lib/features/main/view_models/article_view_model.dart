import 'package:flutter/material.dart';
import 'package:news_app/core/utility/dialog_utility.dart';
import 'package:news_app/core/utility/extensions.dart';
import 'package:news_app/features/main/data/news_repository.dart';
import 'package:news_app/features/main/models/article_model.dart';

class ArticleViewModel extends ChangeNotifier {
  final NewsRepository _newsRepository;

  ArticleViewModel(this._newsRepository);

  final articles = <ArticleModel>[].obs;
  final savedArticles = <ArticleModel>[].obs;

  Future<void> getArticles() async {
    try {
      DialogUtility.showLoading();
      final response = await _newsRepository.getArticles();
      articles.value = response;
      DialogUtility.hideLoading();
    } catch (e) {
      debugPrint(e.toString());
      DialogUtility.hideLoading();
    }
  }

  Future<void> getSavedArticles() async {
    try {
      final response = await _newsRepository.getSaveArticles();
      savedArticles.value = response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<int?> savedArticle({ArticleModel? articleModel}) async {
    try {
      final isPresent = savedArticles.value.any((element) => element.title == articleModel?.title);
      if(isPresent){
        final response = await _newsRepository.updateArticle(articleModel: articleModel);
        await getSavedArticles();
        return response;
      }
      final response = await _newsRepository.savedArticles(articleModel: articleModel);
      await getSavedArticles();
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<int?> removeArticle({ArticleModel? articleModel}) async {
    try {
      final response = await _newsRepository.removeArticles(articleModel: articleModel);
      await getSavedArticles();
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
