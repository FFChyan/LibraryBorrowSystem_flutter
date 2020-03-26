import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loginPage/login_screen.dart';

import 'themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
      SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: ThemeColorBlackberryWine.darkPurpleBlue,
        primaryColorLight: ThemeColorBlackberryWine.lightGray,
        accentColor: ThemeColorBlackberryWine.redWine,
        cursorColor: ThemeColorBlackberryWine.redWine,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 40.0,
            // fontWeight: FontWeight.w400,
            color: ThemeColorBlackberryWine.redWine,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: LoginScreen(),
//      home: ChangeNotifierProvider(
//        create: (context) => BorrowListChange("17370001",'CN0001'),
//        child: Container(
//          decoration: ShapeDecoration(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(15)))),
//          child: ClipRRect(
//            borderRadius: BorderRadius.all(Radius.circular(15)),
//            child: LoginScreen(),
//          ),
//        ),
//      ),
//      ClipRRect(
//        borderRadius: BorderRadius.all(Radius.circular(15)),
//        child: HomePage(),
//      ),
//      navigatorObservers: [TransitionRouteObserver()],
//      routes: {  NAV
//        LoginScreen.routeName: (context) => LoginScreen(),
//        DashboardScreen.routeName: (context) => DashboardScreen(),
//      },

    );
  }
}
