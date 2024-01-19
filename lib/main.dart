import 'package:flutter/material.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/config/themes.dart';
import 'package:news_app/features/main/data/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDataBase = await $FloorAppDataBase.databaseBuilder("news_app").build();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      navigatorKey: navKey,
      theme: appTheme,
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}
