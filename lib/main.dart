import 'package:crownapp/repository/country_data_repository.dart';
import 'package:crownapp/ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/splash/splash_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: _createMaterialColor(
          Color(0xFF333366),
        ),
      ),
      home: BlocProvider(
        create: (context) => SplashBloc(
          countryDataRepository: DataRepository(),
        ),
        child: SplashPage(),
      ), /*MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationModel()),
          ChangeNotifierProvider(create: (_) => CountryNotifier())
        ],
        //child: HomePage(title: 'Crownapp'),
      )*/
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    print(swatch);
    return MaterialColor(color.value, swatch);
  }
}
