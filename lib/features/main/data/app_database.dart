import 'dart:async';

import 'package:floor/floor.dart';
import 'package:news_app/features/main/data/dao/article_dao.dart';
import 'package:news_app/features/main/models/article_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ArticleModel])
abstract class AppDataBase extends FloorDatabase{
  ArticleDao get articleDao;
}