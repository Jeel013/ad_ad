import 'package:ad_ad/Helper/ad_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int score = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward Page"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("SCORE: $score"),
            ElevatedButton(
                onPressed: () {
                  AdHelper.adHelper.rewardedAd.show(
                      onUserEarnedReward: (adView, item) {
                    Logger().i("REWARD: ${item.amount}");

                    setState(() {
                      score += item.amount as int;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Reward ${item.amount} earnad...."),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  }).then((value) => AdHelper.adHelper.loadAds());
                },
                child: Text('Get coins'))
          ],
        ),
      ),
    );
  }
}
