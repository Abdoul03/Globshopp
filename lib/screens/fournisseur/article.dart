import 'package:flutter/material.dart';
import 'package:globshopp/screens/_base/constant.dart';
import 'package:remixicon/remixicon.dart';

class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Constant.colorsWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(20),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it a circle
                        border: Border.all(
                          color: Constant.colorsgray,
                          width: 3.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(RemixIcons.notification_2_line),
                        color: Constant.colorsBlack,
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(20),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it a circle
                        border: Border.all(
                          color: Constant.colorsgray,
                          width: 3.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(RemixIcons.history_line),
                        color: Constant.colorsBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
