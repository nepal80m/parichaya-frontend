import 'package:flutter/material.dart';

import 'package:parichaya_frontend/screens/onboarding_screen.dart';
import 'package:parichaya_frontend/screens/splash.dart';
import 'package:provider/provider.dart';

import './providers/documents.dart';
import 'providers/share_links.dart';
import './providers/theme_provider.dart';

import 'screens/bottom_navigation_base.dart';
import 'screens/add_document.dart';
import 'screens/document_details.dart';
import 'screens/edit_document.dart';
import 'screens/full_screen_image.dart';
import 'screens/select_document.dart';
import 'screens/set_expiry.dart';
import 'screens/share_details.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider()..initialize(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Documents()),
        ChangeNotifierProvider(create: (_) => ShareLinks())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Parichaya',

            // TODO: Customize theme

            // theme: ThemeData(
            //   primarySwatch: Colors.blue,
            //   fontFamily: 'QuickSand',
            //   //brightness: Brightness.dark,
            //   textTheme: ThemeData.light().textTheme.copyWith(
            //         bodyText1:
            //             const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            //         bodyText2:
            //             const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            //         headline1: const TextStyle(
            //             fontSize: 50, fontWeight: FontWeight.bold),
            //         headline2: const TextStyle(fontSize: 45),
            //         headline3: const TextStyle(fontSize: 40),
            //         headline4: const TextStyle(fontSize: 35),
            //         headline5: const TextStyle(fontSize: 30),
            //         headline6: const TextStyle(fontSize: 25),
            //         caption: const TextStyle(fontSize: 20),
            //         overline: const TextStyle(fontSize: 15),
            //         subtitle1: const TextStyle(fontSize: 10),
            //         subtitle2: const TextStyle(fontSize: 10),
            //         button: const TextStyle(fontSize: 10),
            //       ),
            //   // fontFamily: 'Quicksand',
            //   // splashFactory: InkRipple.splashFactory,
            // ),

            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: provider.themeMode,

            //lightTheme: MyThemes.lightTheme,
            home: const Splash(),

            debugShowCheckedModeBanner: false,
            routes: {
              // '/': (ctx) => const BottomNavigationBase(),
              BottomNavigationBase.routeName: (ctx) => BottomNavigationBase(),
              OnboardingScreen.routeName: (ctx) => const OnboardingScreen(),
              AddDocuments.routeName: (ctx) => const AddDocuments(),
              DocumentDetails.routeName: (ctx) => const DocumentDetails(),
              EditDocument.routeName: (ctx) => const EditDocument(),
              FullScreenImage.routeName: (ctx) => const FullScreenImage(),
              SelectDocument.routeName: (ctx) => const SelectDocument(),
              SetExpiry.routeName: (ctx) => const SetExpiry(),
              ShareDetails.routeName: (ctx) => const ShareDetails(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (ctx) => BottomNavigationBase(),
              );
            },
          );
        },
      ),
    );
  }
}
