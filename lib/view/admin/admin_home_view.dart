import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_header.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';

import '../../view_model/admin/admin_home_view_model.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> AdminHomeViewModel(),
      child: Consumer<AdminHomeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.blackColor,
                child: Icon(Icons.add, color: AppColors.whiteColor,),
                onPressed: (){
                  NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.addService);
                }),
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
               Header(controller: vm.searchController),
                ElevatedButton(onPressed: (){
                  vm.logout(context);
                }, child: Text('Logout')),
              ],
            ),
          );
        },
      ),
    );
  }
}
