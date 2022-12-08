import 'package:dexter_health/views/add_resident.dart';
import 'package:dexter_health/views/add_todo.dart';
import 'package:dexter_health/views/home.dart';
import 'package:dexter_health/views/register_nurse.dart';
import 'package:dexter_health/views/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerated(RouteSettings settings) {
    //print("Route name is ${settings.name}");
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case Home.id:
        return MaterialPageRoute(builder: (_) => const Home());

      case ResgisterNurse.id:
        return MaterialPageRoute(builder: (_) => const ResgisterNurse());

      case AddResident.id:
        return MaterialPageRoute(builder: (_) => const AddResident());

      case AddTodo.id:
        return MaterialPageRoute(builder: (_) => AddTodo());

      default:
        return onError();
    }
  }

  static Route onError() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                child: Text(
                  "Error Screen",
                  style: Theme.of(_).textTheme.headline1,
                ),
              ),
            ));
  }
}
