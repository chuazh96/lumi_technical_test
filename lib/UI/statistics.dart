import 'package:flutter/material.dart';

import 'package:lumi_technical_test/UI/newspage.dart';
import 'package:lumi_technical_test/Utilities/config.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

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
      body: Column(
        children: const [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Usage Statistics',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          MostRecentArticle(),
          Favourites(),
          TotalArticlesRead()
        ],
      ),
    );
  }
}

class MostRecentArticle extends StatelessWidget {
  const MostRecentArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsPage(
                          publisher: Statistics.lastRead['publisher'],
                          publisherImage: Statistics.lastRead['publisherImage'],
                          link: Statistics.lastRead['link'])));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(4, 4))
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('Most Recent Article',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Statistics.lastRead.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 5),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Image.network(
                                        Statistics.lastRead['image'],
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    ClipRRect(
                                        child: Image.network(
                                      Statistics.lastRead['publisherImage'],
                                      height: 40,
                                      width: 40,
                                    ))
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(Statistics.lastRead['publisher'],
                                          style: appTheme.textTheme.bodyMedium),
                                      Text(
                                        Statistics.lastRead['title'],
                                        style: appTheme.textTheme.bodyLarge,
                                        overflow: TextOverflow.clip,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(Statistics.lastRead['lastUpdated'],
                                          style: appTheme.textTheme.bodySmall)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Text("No articles read recently",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 3),
                              Text("Go and start right now!",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
      child: Container(
          padding: const EdgeInsets.all(8.0),
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Favourites',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                ),
              ),
              const MostReadCategory(),
              const TopThreePublishers()
            ],
          )),
    );
  }
}

class MostReadCategory extends StatelessWidget {
  const MostReadCategory({super.key});

  @override
  Widget build(BuildContext context) {
    var topCategory = Statistics().topCategory();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Favourite category: ',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
              Text(topCategory.keys.elementAt(0),
                  style: const TextStyle(fontSize: 16.0)),
              const SizedBox(height: 8),
            ],
          ),
          Row(
            children: [
              const Text('Number of Articles Read: ',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
              Text(topCategory.values.elementAt(0).toString(),
                  style: const TextStyle(fontSize: 16.0)),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class TopThreePublishers extends StatelessWidget {
  const TopThreePublishers({super.key});

  @override
  Widget build(BuildContext context) {
    var publisherMap = Statistics().compilePublishers();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Favourite publishers:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          height: 50,
          child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              scrollDirection: Axis.horizontal,
              itemCount: publisherMap.length >= 3 ? 3 : publisherMap.length,
              itemBuilder: ((context, index) {
                return Row(
                  children: [
                    Image.network(
                      publisherMap.keys.elementAt(index),
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 20),
                    Text(publisherMap.values.elementAt(index).toString())
                  ],
                );
              })),
        )
      ],
    );
  }
}

class TotalArticlesRead extends StatelessWidget {
  const TotalArticlesRead({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
      child: Container(
          padding: const EdgeInsets.all(8.0),
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Total Articles Read',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                ),
              ),
              Text(
                  (Statistics.categories['Latest'] +
                          Statistics.categories['Trending'] +
                          Statistics.categories['News'])
                      .toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }
}

// *********************************
// Wanted to implement a live timer to show users how much time
// they have spent enriching themselves about the world.
// But I think this is beyond my abilities right now
// *********************************

// class TimeSpentInApp extends StatefulWidget {
//   const TimeSpentInApp({super.key});

//   @override
//   State<TimeSpentInApp> createState() => _TimeSpentInAppState();
// }

// class _TimeSpentInAppState extends State<TimeSpentInApp>
//     with WidgetsBindingObserver {
//   DateTime startTime = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       startTime = DateTime.now();
//     }

//     if (state == AppLifecycleState.detached ||
//         state == AppLifecycleState.paused) {
//       var usageTime = DateTime.now().difference(startTime);
//       Statistics.appUseDuration += usageTime;
//       print(Statistics.appUseDuration);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(onPressed: () {}, child: Text('press'));
//   }
// }
