import 'package:flutter/material.dart';

import 'package:lumi_technical_test/UI/topics.dart';
import 'package:lumi_technical_test/UI/statistics.dart';

import 'package:lumi_technical_test/Utilities/config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: appTheme.textTheme.titleLarge),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TopicsPage()));
                },
                child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Topics', style: appTheme.textTheme.headlineSmall),
                        const Icon(Icons.arrow_right)
                      ],
                    )),
              )),
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StatisticsPage()));
                },
                child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Statistics',
                            style: appTheme.textTheme.headlineSmall),
                        const Icon(Icons.arrow_right)
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}
