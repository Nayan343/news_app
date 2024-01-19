import 'package:flutter/material.dart';
import 'package:news_app/features/main/data/app_database.dart';
import 'package:news_app/features/main/view_models/article_view_model.dart';
import 'package:news_app/features/main/views/pages/article_detail.dart';
import 'package:news_app/features/main/views/pages/daily_news_page.dart';
import 'package:news_app/features/main/views/pages/saved_article_page.dart';

final navKey = GlobalKey<NavigatorState>();
AppDataBase? appDataBase;

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint("${settings.name}");
    switch (settings.name) {
      case DailyNewsPage.route:
        return _materialRoute(const DailyNewsPage());
      case ArticleDetailsView.route:
        return _materialRoute(
          ArticleDetailsView(
            arguments: settings.arguments as ArticleDetailsViewArguments,
          ),
        );
      case SavedArticlePage.route:
        return _materialRoute(SavedArticlePage(articleViewModel: settings.arguments as ArticleViewModel,));
      default:
        return _materialRoute(const SizedBox.shrink());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
