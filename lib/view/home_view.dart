import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Center(
              child: ElevatedButton(onPressed: (){
                vm.logout(context);
              }, child: Text('Logout')),
            ),
          );
        },
      ),
    );
  }
}
