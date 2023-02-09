import 'package:flutter/material.dart';

import 'package:lumi_technical_test/Utilities/gsheets_integration.dart';

//                          _______ _
//      /\                 |__   __| |
//     /  \   _ __  _ __      | |  | |__   ___ _ __ ___   ___
//    / /\ \ | '_ \| '_ \     | |  | '_ \ / _ \ '_ ` _ \ / _ \
//   / ____ \| |_) | |_) |    | |  | | | |  __/ | | | | |  __/
//  /_/    \_\ .__/| .__/     |_|  |_| |_|\___|_| |_| |_|\___|
//           | |   | |
//           |_|   |_|

const primaryColor = Color(0xFF364CE1);
const primaryColorText = Colors.white;
const secondaryColor = Color(0xFFDDE6FF);
const secondaryColorText = Color(0xFF9CAAFE);

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Montserrat',
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w900,
    ),
    titleMedium: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey),
    titleSmall: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.grey),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey),
  ),
  colorScheme: const ColorScheme.light().copyWith(
    primary: primaryColor,
  ),
);

//    _____ _       _           _
//   / ____| |     | |         | |
//  | |  __| | ___ | |__   __ _| |___
//  | | |_ | |/ _ \| '_ \ / _` | / __|
//  | |__| | | (_) | |_) | (_| | \__ \
//   \_____|_|\___/|_.__/ \__,_|_|___/

class NewsChips {
  static bool showLatest = true;
  static bool showTrending = true;
  static bool showNews = true;
}

class Statistics {
  static Map lastRead = {};
  static List publisherList = [];
  static Map categories = {'Latest': 0, 'Trending': 0, 'News': 0};
  static Duration appUseDuration = const Duration();

  Map compilePublishers() {
    final Map publisherCount = {};

    for (var i = 0; i < Statistics.publisherList.length; i++) {
      if (publisherCount.containsKey(Statistics.publisherList[i])) {
        publisherCount[Statistics.publisherList[i]]++;
      } else {
        publisherCount[Statistics.publisherList[i]] = 1;
      }
    }

    var sortedByValueMap = Map.fromEntries(publisherCount.entries.toList()
      ..sort((e2, e1) => e1.value.compareTo(e2.value)));

    return sortedByValueMap;
  }

  Map topCategory() {
    var value = 0;
    var key = '';

    Statistics.categories.forEach((k, v) {
      if (v > value) {
        value = v;
        key = k;
      }
    });
    return {key: value};
  }
}

class Milestones {
  static int numOfArticlesRead = 0;

  updateNumOfArticles(context) {
    Milestones.numOfArticlesRead += 1;
    print(Milestones.numOfArticlesRead);

    switch (Milestones.numOfArticlesRead) {
      case 5:
        {
          return viewedFiveAritcles(context);
        }
      case 10:
        {
          return viewedTenArticles(context);
        }
    }
  }

// ************************************************
// Not sure if SnackBar is the best way to implement this.
// As the newspage also have a SnackBar popup for publisher ads,
// feel like this could clash with that.
// An alternative is to use Dialog, but that also feels like it
// interferes with the viewing experience.
// ************************************************

  viewedFiveAritcles(context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(
        child: Text(
          "Congratulations, you have viewed 5 articles!",
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0xFF303030),
      elevation: 8,
    ));
  }

  viewedTenArticles(context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(
        child: Text(
          "Wow, you are an avid news reader!",
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0xFF303030),
      elevation: 8,
    ));
  }
}
