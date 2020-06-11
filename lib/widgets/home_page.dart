import 'package:flutter/material.dart';
import 'package:recipes_app/auth/auth.dart';
import 'package:recipes_app/widgets/foot_top.dart';

import 'food_body.dart';

class HomePageRecipes extends StatefulWidget {
  @override
  _HomePageRecipesState createState() => _HomePageRecipesState();
}

class _HomePageRecipesState extends State<HomePageRecipes> {
  String userID;

  @override
  void initState() {
    super.initState();

    setState(() {
      Auth().currentUser().then((onValue) {
        userID = onValue;
        print('Đã đăng nhập với Id: $userID');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Text(
                'Yêu thích',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FoodTop(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Text(
                'Tổng hợp Công thức',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FoodBody(),
          ),
        ],
      ),
    );
  }
}
