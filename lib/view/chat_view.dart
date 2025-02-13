import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/view_model/chat_view_model.dart';

import '../utils/size_config.dart';
import '../utils/styles.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              centerTitle: true,
              title:  Text("All Chats", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: AppColors.scaffoldColor,
            body: StreamBuilder<QuerySnapshot>(
              stream: vm.getAllChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.data!.docs.isEmpty){
                  return Center(child: Text('No Chat Available', style: smallTextStyle,));
                }

                var chatDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    var chat = chatDocs[index];
                    List users = chat['users'];

                    String receiverId = users.firstWhere((id) => id != vm.getCurrentUserId());

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox();
                        }
                        var userData = userSnapshot.data!;
                        return Dismissible(
                          key: Key(chat.id),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: SizeConfig.scaleHeight(20)),
                              child:const  Icon(Icons.delete, color: AppColors.whiteColor),
                            ),
                          ),
                          secondaryBackground: Container(
                            color:Colors.red,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: SizeConfig.scaleHeight(20)),
                              child:const  Icon(Icons.delete, color: AppColors.whiteColor),
                            ),
                          ),
                          onDismissed: (direction) {
                            vm.deleteChat(chat.id);
                          },
                          child: InkWell(
                            onTap: () {
                              NavigationHelper.navigateWithSlideTransition(
                                context: context,
                                routeName: RoutesName.specificChat,
                                arguments: {
                                  'senderId': vm.getCurrentUserId(),
                                  'receiverId': receiverId,
                                  'name': userData['name'],
                                  'image': userData['image_url'],
                                },
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(userData['image_url']),
                                radius: 25,
                              ),
                              title: Text(
                                userData['name'],
                                style: smallTextStyle.copyWith(fontSize: 17),
                              ),
                              subtitle: Text(
                                chat['lastMessage'],
                                style: smallTextStyle.copyWith(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                vm.formatTime(chat['lastMessageTime']),
                                style: smallTextStyle.copyWith(fontSize: 13, color: AppColors.greyColor),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
