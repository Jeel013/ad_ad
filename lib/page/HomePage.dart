import 'package:ad_ad/Helper/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'image_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> showAd()async{
    await AdHelper.adHelper.appOpenAd.show();
  }
  Widget build(BuildContext context) {
    showAd();
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ImageStore()));
        },
      ),
       body: Stack(
         children: [
           ListView.builder(itemBuilder: (ctx, index) => Card(
             child: ListTile(
               title: Text("Item: ${index + 1}"),
               subtitle: Text('Subtitle of ${index + 1}'),
               trailing:  IconButton(
                 onPressed: (){
                  AdHelper.adHelper.interstitialAd.show().then((value) {
                    AdHelper.adHelper.loadAds();
                    Navigator.pushNamed(context, '/score_page');
                  }
                  );
                 },
                 icon: Icon(Icons.arrow_forward_ios),
               ),
             ),
           )),
           SizedBox(
             height: AdHelper.adHelper.bannerAd.size.height.toDouble(),
             width: AdHelper.adHelper.bannerAd.size.width.toDouble(),
             child: AdWidget(
               ad: AdHelper.adHelper.bannerAd,
             ),
           ),
         ],
       ),
    );
  }
}
