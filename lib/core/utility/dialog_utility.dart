import 'package:flutter/material.dart';
import 'package:news_app/config/routes.dart';

class DialogUtility{
  static bool loading = false;

  static void showLoading(){
    if(!loading){
      showDialog(context: navKey.currentContext!, builder: (context){
        loading = true;
        return WillPopScope(
          onWillPop: () {
            loading = false;
            return Future.value(true);
          },
          child: const Center(
            child: SizedBox(
              height: 70,
              width: 70,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  static void hideLoading(){
    if(loading){
      loading = false;
      Navigator.pop(navKey.currentContext!);
    }
  }
}