import 'package:flutter/material.dart';
import 'package:leaderboardapp/screens/dashboard.dart';
import 'package:leaderboardapp/screens/userLogin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Leaderboard Game",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int currentIndex;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    currentIndex = _pageController.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(currentIndex.isEven ? "User Register" : "Games"),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          UserRegister(
            scaffoldKey: scaffoldKey,
          ),
          DashBoard(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.jumpToPage(currentIndex);
          });
        },
        items: List.generate(
          2,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              index.isEven ? Icons.people : Icons.score,
            ),
            title: Container(),
          ),
        ),
      ),
    );
  }
}
