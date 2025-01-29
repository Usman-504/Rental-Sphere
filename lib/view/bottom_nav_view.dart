import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/view/booking_view.dart';
import 'package:rental_sphere/view/chat_view.dart';
import 'package:rental_sphere/view/profile_view.dart';
import 'package:rental_sphere/view/services_view.dart';
import '../res/colors.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';
import '../view_model/bottom_nav_view_model.dart';
import 'home_view.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {


  List<Widget> widgetList = const [
     HomeView(),
     ServicesView(),
    BookingView(),
    ChatView(),
     ProfileView(),
  ];


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_)=>BottomNavViewModel(),
      child: Consumer<BottomNavViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body:
            IndexedStack(
              index: vm.myIndex,
              children: widgetList,
            ),
            bottomNavigationBar: BottomNavigationBar(

                backgroundColor: AppColors.scaffoldColor,
                onTap: vm.changeIndex,
                currentIndex: vm.myIndex,
                unselectedItemColor: AppColors.blackColor,
                selectedItemColor: AppColors.secondaryColor,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: mediumTextStyle.copyWith(fontSize: 8.5,),
                unselectedLabelStyle: mediumTextStyle.copyWith(fontSize: 8.5,),
                items: const[
                   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', ),
                   BottomNavigationBarItem(icon: Icon(Icons.filter_vintage_outlined), label: 'Services', ),
                   BottomNavigationBarItem(icon: Icon(Icons.call_to_action), label: 'Bookings', ),
                   BottomNavigationBarItem(
                      icon: Icon(Icons.chat), label: 'Chat'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: 'Profile'),
                ]),
          );
        },
      ),
    );
  }
}