import 'package:flutter/material.dart';

import 'package:lumi_technical_test/Utilities/config.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF9BB0FF)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: const TopicsSelectionWidget(),
    );
  }
}

// **********************************************
// I am not exactly sure what widget was used for your topics page
// I used chips, so it kinda looks shabby in comparison.
// But it gets the work done! 
// **********************************************

class TopicsSelectionWidget extends StatefulWidget {
  const TopicsSelectionWidget({super.key});

  @override
  State<TopicsSelectionWidget> createState() => _TopicsSelectionWidgetState();
}

class _TopicsSelectionWidgetState extends State<TopicsSelectionWidget>
    with RestorationMixin {
  final RestorableBool isSelectedTrending =
      RestorableBool(NewsChips.showTrending);
  final RestorableBool isSelectedNews = RestorableBool(NewsChips.showNews);

  @override
  String get restorationId => 'set_topics';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(isSelectedTrending, 'selected_trending');
    registerForRestoration(isSelectedNews, 'selected_news');
  }

  @override
  void dispose() {
    isSelectedTrending.dispose();
    isSelectedNews.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chips = [
      FilterChip(
          label: const Text(
            'Trending',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          labelPadding: const EdgeInsets.all(8),
          selected: isSelectedTrending.value,
          selectedColor: primaryColor,
          backgroundColor: secondaryColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
              color: isSelectedTrending.value
                  ? primaryColorText
                  : secondaryColorText),
          onSelected: (bool selected) {
            setState(() {
              NewsChips.showTrending = !NewsChips.showTrending;
              isSelectedTrending.value = !isSelectedTrending.value;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(
                  child: Text(
                    isSelectedTrending.value
                        ? "You are now following Trending"
                        : "You have stopped following Trending",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                duration: const Duration(seconds: 3),
                backgroundColor: const Color(0xFF303030),
                elevation: 8,
              ));
            });
          }),
      FilterChip(
          label: const Text(
            'News',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          labelPadding: const EdgeInsets.all(8),
          selected: isSelectedNews.value,
          selectedColor: primaryColor,
          backgroundColor: secondaryColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
              color:
                  isSelectedNews.value ? primaryColorText : secondaryColorText),
          onSelected: (bool selected) {
            setState(() {
              NewsChips.showNews = !NewsChips.showNews;
              isSelectedNews.value = !isSelectedNews.value;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(
                  child: Text(
                    isSelectedNews.value
                        ? "You are now following News"
                        : "You have stopped following News",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                duration: const Duration(seconds: 3),
                backgroundColor: const Color(0xFF303030),
                elevation: 8,
              ));
            });
          })
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text('Topics',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                spacing: 20,
                children: chips,
              )
            ],
          ),
        ),
      ],
    );
  }
}
