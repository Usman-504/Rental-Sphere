import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/view/admin/admin_home_view.dart';
import 'package:rental_sphere/view/all_bookings_view.dart';
import 'package:rental_sphere/view/chat_view.dart';
import 'package:rental_sphere/view/profile_view.dart';
import '../../res/colors.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../../view_model/bottom_nav_view_model.dart';
import 'package:badges/badges.dart' as badges;
class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  List<Widget> widgetList = const [
    AdminHomeView(),
    AllBookingView(),
    ChatView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_) {
        var vm = BottomNavViewModel();
        vm.listenForUnreadMessages();
        return vm;
      },
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
                  icon: _buildNavBarIcon(Icons.call_to_action, vm.myIndex == 1),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.chat, vm.myIndex == 2, badgeCount: vm.unreadUserCount),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavBarIcon(Icons.account_circle, vm.myIndex == 3),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildNavBarIcon(IconData icon, bool isSelected) {
  //   return Container(
  //     padding:  EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: isSelected ? AppColors.blackColor : Colors.transparent,
  //       shape: BoxShape.rectangle,
  //     ),
  //     child: Icon(
  //       icon,
  //       color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
  //     ),
  //   );
  // }



  Widget _buildNavBarIcon(IconData icon, bool isSelected, {int badgeCount = 0}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? AppColors.blackColor : Colors.transparent,
            shape: BoxShape.rectangle,
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: badges.Badge(
              badgeContent: Text(
                badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
                elevation: 2,
              ),
            ),
          ),
      ],
    );
  }

}
