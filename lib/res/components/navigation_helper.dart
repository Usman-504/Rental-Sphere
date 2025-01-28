import 'package:flutter/material.dart';
import '../../utils/routes/routes.dart';

class NavigationHelper {
  static Future<void> navigateWithSlideTransition({
    required BuildContext context,
    required String routeName,
    Object? arguments,
    Offset beginOffset = const Offset(1.0, 0.0),
    Curve curve = Curves.easeInOut,
    bool clearStack = false,
    bool replace = false,
  }) async {
    final pageRoute = PageRouteBuilder(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final route = Routes.generateRoute(RouteSettings(name: routeName, arguments: arguments));
        if (route is MaterialPageRoute) {
          return route.builder(context);
        } else {
          throw Exception("Route must be a MaterialPageRoute.");
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = animation.drive(
          Tween(begin: beginOffset, end: Offset.zero).chain(CurveTween(curve: curve)),
        );

        return
          SlideTransition(position: offsetAnimation, child: child);
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(
        context,
        pageRoute,
        ModalRoute.withName('/'),
      );
    } else if (replace) {
      Navigator.pushReplacement(context, pageRoute);
    } else {

      Navigator.push(context, pageRoute);
    }
  }
}
