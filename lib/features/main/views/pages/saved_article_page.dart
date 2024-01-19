import 'package:flutter/material.dart';
import 'package:news_app/features/main/view_models/article_view_model.dart';
import 'package:news_app/features/main/views/pages/article_detail.dart';
import 'package:news_app/features/main/views/widgets/article_tile.dart';

class SavedArticlePage extends StatelessWidget {
  static const route = "/SavedArticlePage";

  const SavedArticlePage({super.key, required this.articleViewModel});

  final ArticleViewModel articleViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Articles"),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: articleViewModel.savedArticles,
          builder: (context, child) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ArticleWidget(
                  article: articleViewModel.savedArticles.value[index],
                  isRemovable: true,
                  onRemove: (value) async{
                    await articleViewModel.removeArticle(articleModel: value);
                  },
                  onArticlePressed: (article) {
                    Navigator.pushNamed(context, ArticleDetailsView.route,
                        arguments: ArticleDetailsViewArguments(article: article));
                  },
                );
              },
              itemCount: articleViewModel.savedArticles.value.length,
            );
          }
        ),
      ),
    );
  }
}
