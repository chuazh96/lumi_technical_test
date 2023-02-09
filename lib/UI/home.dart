import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:lumi_technical_test/UI/newspage.dart';
import 'package:lumi_technical_test/UI/settings.dart';

import 'package:lumi_technical_test/Utilities/config.dart';
import 'package:lumi_technical_test/Utilities/gsheets_integration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _appbarGreeting() {
    List<String> output = [];

    final DateTime currentTime = DateTime.now();
    final DateTime morning =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 6);
    final DateTime noon =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 12);
    final DateTime afternoon =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 14);
    final DateTime evening =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 18);
    final DateTime nextMorning =
        DateTime(currentTime.year, currentTime.month, currentTime.day + 1, 6);

    if (currentTime.compareTo(morning) >= 0 &&
        currentTime.compareTo(noon) < 0) {
      output = ['Good Morning', "Catch up on news you've missed"];
    }
    if (currentTime.compareTo(noon) >= 0 &&
        currentTime.compareTo(afternoon) < 0) {
      output = ['Good Afternoon', ''];
    }
    if (currentTime.compareTo(afternoon) >= 0 &&
        currentTime.compareTo(evening) < 0) {
      output = ['Good Evening', "Here's what you've missed"];
    }
    if (currentTime.compareTo(evening) >= 0 &&
        currentTime.compareTo(nextMorning) < 0) {
      output = ['Good Night', 'Have a good rest!'];
    }
    return output;
  }

  ScrollController _hideButtonController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  int _selectedIndex = 0;

  final List<Widget> _bodyItems = [
    Column(children: const [
      HomePageTabs(),
      NewsListWidget(),
    ]),
    const SettingsPage()
  ];

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _hideButtonController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(_appbarGreeting()[0],
                  style: appTheme.textTheme.titleLarge),
              bottom: PreferredSize(
                  preferredSize: Size.zero,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(_appbarGreeting()[1],
                            style: appTheme.textTheme.titleMedium),
                      ))),
              backgroundColor: const Color(0xFFFAFAFA),
              elevation: 0,
            )
          ];
        },
        body: _bodyItems.elementAt(_selectedIndex),
      ),
      
      // ******************************************************
      // The BottomNavigationBar Scrolling is a bit whack
      // There is a breif period where it overflows when it reappears
      // Probably just need to play with the durations to find the right one
      // However, the problem can be circumvented by just not having animations
      // at all, i.e. Duration(millisecond: 1)
      // ******************************************************

      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: _isVisible ? 60 : 0,
        child: _isVisible
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: _isVisible ? 60 : 0,
                child: _isVisible
                    ? BottomNavigationBar(
                        items: _bottomNavigationBarItems,
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                      )
                    : Container())
            : Container(),
      ),
    );
  }
}

//   _      _     _
//  | |    (_)   | |
//  | |     _ ___| |_ ___ _ __   ___ _ __
//  | |    | / __| __/ _ \ '_ \ / _ \ '__|
//  | |____| \__ \ ||  __/ | | |  __/ |
//  |______|_|___/\__\___|_| |_|\___|_|

int tabSelection = 0;

class TabSelectionNotifier {
  ValueNotifier _notifier = ValueNotifier(tabSelection);

  void updateNotifierValue() {
    _notifier.value = tabSelection;
  }
}

TabSelectionNotifier tabSelectionNotifier = TabSelectionNotifier();

//   _______    _
//  |__   __|  | |
//     | | __ _| |__  ___
//     | |/ _` | '_ \/ __|
//     | | (_| | |_) \__ \
//     |_|\__,_|_.__/|___/

// ******************************************************
// There is a minor detail where if I move to Settings and
// back to Home, the selected tab would be back on Latest
// but the News List would be whatever it was before
// i.e. If I open Trending, go to Settings and back
// the tabs would highlight Latest, but the News List would display Trending
// I think fixing it would entail reworking a significant portion
// of the app, which I do not have time to unfortunately
// ******************************************************

class HomePageTabs extends StatefulWidget {
  const HomePageTabs({super.key});

  @override
  State<HomePageTabs> createState() => _HomePageTabsState();
}

class _HomePageTabsState extends State<HomePageTabs> {
  int? selectedIndex = 0;
  final List<String> chipsData = [];

  choiceChips() {
    chipsData.removeRange(0, chipsData.length);
    if (NewsChips.showLatest == true) {
      chipsData.add('Latest');
    }
    if (NewsChips.showTrending == true) {
      chipsData.add('Trending');
    }
    if (NewsChips.showNews == true) {
      chipsData.add('News');
    }

    List<Widget> chips = [];

    for (var i = 0; i < chipsData.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(8),
        child: ChoiceChip(
          label: Text(chipsData[i]),
          labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          selected: selectedIndex == i,
          selectedColor: primaryColor,
          backgroundColor: secondaryColor,
          labelStyle: TextStyle(
              color:
                  selectedIndex == i ? primaryColorText : secondaryColorText),
          onSelected: (bool selected) {
            setState(() {
              tabSelection = i;
              tabSelectionNotifier.updateNotifierValue();
              selectedIndex = selected ? i : null;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 5,
              children: choiceChips(),
            )
          ],
        ),
      ),
    );
  }
}

//   _   _                     _      _     _
//  | \ | |                   | |    (_)   | |
//  |  \| | _____      _____  | |     _ ___| |_
//  | . ` |/ _ \ \ /\ / / __| | |    | / __| __|
//  | |\  |  __/\ V  V /\__ \ | |____| \__ \ |_
//  |_| \_|\___| \_/\_/ |___/ |______|_|___/\__|

class NewsListWidget extends StatefulWidget {
  const NewsListWidget({super.key});

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: tabSelectionNotifier._notifier,
        builder: (BuildContext context, value, Widget? child) {
          Widget output = Container();
          switch (value) {
            case 0:
              {
                output = const LatestNewsList();
                break;
              }
            case 1:
              {
                output = const TrendingNewsList();
                break;
              }
            case 2:
              {
                output = const NewsList();
                break;
              }
          }
          return output;
        });
  }
}

newsDisplayCard(newsData, index, context) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(4, 4))
        ]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Image.network(
                newsData[index].image,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
            ),
            ClipRRect(
                child: Image.network(
              newsData[index].publisherImage,
              height: 40,
              width: 40,
            ))
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(newsData[index].publisher,
                  style: appTheme.textTheme.bodyMedium),
              Text(
                newsData[index].title,
                style: appTheme.textTheme.bodyLarge,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 8),
              Text(newsData[index].lastUpdated,
                  style: appTheme.textTheme.bodySmall)
            ],
          ),
        )
      ],
    ),
  );
}

// ********************************
// While this code is more compact, it doesn't contribute to good UX
// Therefore it is removed in favour of more dense code
// ********************************

// class NewsList extends StatefulWidget {
//   const NewsList({super.key, required this.newsType});

//   final String newsType;

//   @override
//   State<NewsList> createState() => _NewsListState();
// }

// class _NewsListState extends State<NewsList> {
//   List<dynamic> newsData = [];

//   asyncInitState() async {
//     switch (widget.newsType) {
//       case 'latest':
//         {
//           newsData = await NewsDataManager().getLatest();
//           break;
//         }
//       case 'trending':
//         {
//           newsData = await NewsDataManager().getTrending();
//           break;
//         }
//       case 'news':
//         {
//           newsData = await NewsDataManager().getNews();
//           break;
//         }
//     }
//     return newsData;
//   }

//   Widget progressIndicator() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           CircularProgressIndicator(),
//           SizedBox(height: 20),
//           Center(
//             child: Text('Loading the news . . .',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           )
//         ],
//       )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: asyncInitState(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             return Expanded(
//               child: ListView.builder(
//                   itemCount: newsData.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       clipBehavior: Clip.hardEdge,
//                       child: InkWell(
//                         splashColor: Colors.blue.withAlpha(30),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => NewsPage(
//                                       publisher: newsData[index].publisher,
//                                       publisherImage:
//                                           newsData[index].publisherImage,
//                                       link: newsData[index].link)));
//                         },
//                         child: newsDisplayCard(newsData, index, context),
//                       ),
//                     );
//                   }),
//             );
//           } else {
//             return progressIndicator();
//           }
//         });
//   }
// }

class LatestNewsList extends StatefulWidget {
  const LatestNewsList({super.key});

  @override
  State<LatestNewsList> createState() => _LatestNewsListState();
}

class _LatestNewsListState extends State<LatestNewsList> {
  List<dynamic> newsData = [];

  asyncInitState() async {
    newsData = await NewsDataManager().getLatest();
    return newsData;
  }

  Widget progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Center(
            child: Text('Loading the latest news . . .',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncInitState(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Statistics.lastRead = {
                            'title': newsData[index].title,
                            'publisher': newsData[index].publisher,
                            'image': newsData[index].image,
                            'publisherImage': newsData[index].publisherImage,
                            'publisherRect': newsData[index].publisherRect,
                            'lastUpdated': newsData[index].lastUpdated,
                            'link': newsData[index].link,
                          };
                          Statistics.categories['Latest']++;
                          Statistics.publisherList
                              .add(newsData[index].publisherImage);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsPage(
                                      publisher: newsData[index].publisher,
                                      publisherImage:
                                          newsData[index].publisherImage,
                                      link: newsData[index].link)));
                        },
                        child: newsDisplayCard(newsData, index, context),
                      ),
                    );
                  }),
            );
          } else {
            return progressIndicator();
          }
        });
  }
}

class TrendingNewsList extends StatefulWidget {
  const TrendingNewsList({super.key});

  @override
  State<TrendingNewsList> createState() => _TrendingNewsListState();
}

class _TrendingNewsListState extends State<TrendingNewsList> {
  List<dynamic> newsData = [];

  asyncInitState() async {
    newsData = await NewsDataManager().getTrending();
    return newsData;
  }

  Widget progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Center(
            child: Text('Loading the trending news . . .',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncInitState(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Statistics.lastRead = {
                            'title': newsData[index].title,
                            'publisher': newsData[index].publisher,
                            'image': newsData[index].image,
                            'publisherImage': newsData[index].publisherImage,
                            'publisherRect': newsData[index].publisherRect,
                            'lastUpdated': newsData[index].lastUpdated,
                            'link': newsData[index].link,
                          };
                          Statistics.categories['Trending']++;
                          Statistics.publisherList
                              .add(newsData[index].publisherImage);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsPage(
                                      publisher: newsData[index].publisher,
                                      publisherImage:
                                          newsData[index].publisherImage,
                                      link: newsData[index].link)));
                        },
                        child: newsDisplayCard(newsData, index, context),
                      ),
                    );
                  }),
            );
          } else {
            return progressIndicator();
          }
        });
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<dynamic> newsData = [];

  asyncInitState() async {
    newsData = await NewsDataManager().getNews();
    return newsData;
  }

  Widget progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Center(
            child: Text('Loading the news . . .',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncInitState(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Statistics.lastRead = {
                            'title': newsData[index].title,
                            'publisher': newsData[index].publisher,
                            'image': newsData[index].image,
                            'publisherImage': newsData[index].publisherImage,
                            'publisherRect': newsData[index].publisherRect,
                            'lastUpdated': newsData[index].lastUpdated,
                            'link': newsData[index].link,
                          };
                          Statistics.categories['News']++;
                          Statistics.publisherList
                              .add(newsData[index].publisherImage);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsPage(
                                      publisher: newsData[index].publisher,
                                      publisherImage:
                                          newsData[index].publisherImage,
                                      link: newsData[index].link)));
                        },
                        child: newsDisplayCard(newsData, index, context),
                      ),
                    );
                  }),
            );
          } else {
            return progressIndicator();
          }
        });
  }
}
