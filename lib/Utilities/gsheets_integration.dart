import 'package:gsheets/gsheets.dart';

import 'package:lumi_technical_test/auth/apikeys.dart';

class NewsData {
  final String title;
  final String publisher;
  final String image;
  final String publisherImage;
  final String publisherRect;
  final String lastUpdated;
  final String link;

  const NewsData({
    required this.title,
    required this.publisher,
    required this.image,
    required this.publisherImage,
    required this.publisherRect,
    required this.lastUpdated,
    required this.link,
  });

  @override
  String toString() {
    return '{title: $title, publisher: $publisher, image: $image, publisherImage: $publisherImage, publisherRect: $publisherRect, lastUpdated: $lastUpdated, link: $link}';
  }

  factory NewsData.fromGsheets(Map<String, dynamic> json) {
    return NewsData(
        title: json['News Title'],
        publisher: json['Publisher name'],
        image: json['Image url'],
        publisherImage: json['Publisher image url'],
        publisherRect: json['Publisher rectangle url'],
        lastUpdated: json['Updated'],
        link: json['Link']);
  }
}

class NewsDataManager {
  final gsheets = GSheets(gsheetsKey);

  Spreadsheet? latestSpreadsheet;
  Worksheet? latestWorksheet;
  final latestSpreadsId = '1sZ6o7z1P2ALgX0T1dlb_b8yPk_NuvsEFkXrRwzXPP_Q';
  final latestWorksId = 649442165;

  Spreadsheet? trendingSpreadsheet;
  Worksheet? trendingWorksheet;
  final trendingSpreadsId = '1psJuyUGIKhM1OjcIGmIDrtuRLHuwJKisDbkkFhj1kAE';
  final trendingWorksId = 1586533608;

  Spreadsheet? newsSpreadsheet;
  Worksheet? newsWorksheet;
  final newsSpreadsId = '102fZI-kAtp3Z0Fc4_zeT26bw_xkKrmYA75xgPybfRZY';
  final newsWorksId = 144758681;

  Future<void> initLatest() async {
    latestSpreadsheet ??= await gsheets.spreadsheet(latestSpreadsId);
    latestWorksheet = latestSpreadsheet!.worksheetById(latestWorksId);
  }

  Future<List<NewsData>> getLatest() async {
    await initLatest();
    final newsData = await latestWorksheet!.values.map.allRows();
    return newsData!.map((json) => NewsData.fromGsheets(json)).toList();
  }

  Future<void> initTrending() async {
    trendingSpreadsheet ??= await gsheets.spreadsheet(trendingSpreadsId);
    trendingWorksheet = trendingSpreadsheet!.worksheetById(trendingWorksId);
  }

  Future<List<NewsData>> getTrending() async {
    await initTrending();
    final newsData = await trendingWorksheet!.values.map.allRows();
    return newsData!.map((json) => NewsData.fromGsheets(json)).toList();
  }

  Future<void> initNews() async {
    newsSpreadsheet ??= await gsheets.spreadsheet(newsSpreadsId);
    newsWorksheet = newsSpreadsheet!.worksheetById(newsWorksId);
  }

  Future<List<NewsData>> getNews() async {
    await initNews();
    final newsData = await newsWorksheet!.values.map.allRows();
    return newsData!.map((json) => NewsData.fromGsheets(json)).toList();
  }
}
