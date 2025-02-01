import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/view/all_bookings_view.dart';
import 'package:rental_sphere/view/booking_view.dart';
import 'package:rental_sphere/view/service_detail_view.dart';
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
   AllBookingView(),
    ChatView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_) => BottomNavViewModel(),
      child: Consumer<BottomNavViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: IndexedStack(
              index: vm.myIndex,
              children: widgetList,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.scaffoldColor,
              onTap: vm.changeIndex,
              currentIndex: vm.myIndex,
              unselectedItemColor: AppColors.blackColor,
              selectedItemColor: AppColors.blackColor,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: mediumTextStyle.copyWith(fontSize: 8.5),
              unselectedLabelStyle: mediumTextStyle.copyWith(fontSize: 8.5),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.home, vm.myIndex == 0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.filter_vintage_outlined, vm.myIndex == 1),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.call_to_action, vm.myIndex == 2),
                  label: 'Bookings',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.chat, vm.myIndex == 3),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.account_circle, vm.myIndex == 4),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon, bool isSelected) {
    return Container(
      padding:  EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.black : Colors.transparent,
        shape: BoxShape.rectangle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : AppColors.blackColor,
      ),
    );
  }
}
