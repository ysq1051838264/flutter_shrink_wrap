import 'package:flutter/material.dart';

import 'HomePage.dart';

class Screen extends StatelessWidget {
  GlobalKey<HomePageState> homePageKey;

  Screen(this.homePageKey);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      width: 250,
      child: Column(
        children: [

          TextButton(onPressed: (){
             clickClose(context);
           },
              child: Text("点击"))

        ],
      ),

    );

  }


  void clickClose(BuildContext context){
    // Navigator.pop(context);
    print("这里点击了。。。。${homePageKey.currentState}");
    homePageKey.currentState?.clickClose();
  }

}

