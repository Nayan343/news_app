import 'package:flutter/material.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/core/resources/network/dio_client.dart';
import 'package:news_app/features/main/data/app_database.dart';
import 'package:news_app/features/main/data/news_api_services.dart';
import 'package:news_app/features/main/view_models/article_view_model.dart';
import 'package:news_app/features/main/views/pages/article_detail.dart';
import 'package:news_app/features/main/views/pages/saved_article_page.dart';
import 'package:news_app/features/main/views/widgets/article_tile.dart';

class DailyNewsPage extends StatelessWidget {
  static const route = "/";

  const DailyNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final articleViewModel = ArticleViewModel(NewsApiServices(DioClient(), appDataBase!));
    Future.delayed(Duration.zero, () async {
      await articleViewModel.getArticles();
      await articleViewModel.getSavedArticles();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, SavedArticlePage.route,
                arguments: articleViewModel),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.bookmark, color: Colors.black),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: articleViewModel.articles,
          builder: (context, child) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ArticleWidget(
                  article: articleViewModel.articles.value[index],
                  onArticlePressed: (article) {
                    Navigator.pushNamed(context, ArticleDetailsView.route,
                        arguments: ArticleDetailsViewArguments(
                          article: article,
                          isForSave: true,
                          viewModel: articleViewModel
                        ));
                  },
                );
              },
              itemCount: articleViewModel.articles.value.length,
            );
          },
        ),
      ),
    );
  }
}
