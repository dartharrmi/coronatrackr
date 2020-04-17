import 'package:crownapp/bloc/splash/splash_bloc.dart';
import 'package:crownapp/bloc/splash/splash_event.dart';
import 'package:crownapp/bloc/splash/splash_state.dart';
import 'package:crownapp/model/notifier/country_notifier.dart';
import 'package:crownapp/model/notifier/navigation_model.dart';
import 'package:crownapp/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashBloc>(context).add(CountryListEvent());

    return Scaffold(
      backgroundColor: Color(0xff474775),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: Center(
              child: BlocBuilder<SplashBloc, CountryListState>(
                builder: (context, state) {
                  if (state is CountryListLoading) {
                    return Lottie.asset(
                      'assets/anims/loader_splash.json',
                      fit: BoxFit.fill,
                    );
                  } else if (state is CountryListAvailable) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                  create: (_) => NavigationModel()),
                              ChangeNotifierProvider(
                                create: (_) => CountryNotifier(),
                              )
                            ],
                            child: HomePage(countries: state.countryList),
                          ),
                        ),
                      );
                    });
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
