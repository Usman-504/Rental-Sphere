import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/specific_chat_view_model.dart';

class SpecificChatView extends StatefulWidget {
  final Map args;
  const SpecificChatView({super.key, required this.args});

  @override
  _SpecificChatViewState createState() => _SpecificChatViewState();
}

class _SpecificChatViewState extends State<SpecificChatView> {
  late String senderId;
  late String receiverId;
  late String name;
  late String image;

  @override
  void initState() {
    super.initState();
    senderId = widget.args['senderId'];
    receiverId = widget.args['receiverId'];
    name = widget.args['name'];
    image = widget.args['image'];
    // FirebaseFirestore.instance.collection('users').doc(senderId).update({
    //   'status': 'Online',
    // });
  }

  // @override
  // void dispose() {
  //   FirebaseFirestore.instance.collection('users').doc(senderId).update({
  //     'status': 'Offline',
  //     'lastSeen': FieldValue.serverTimestamp(),
  //   });
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    String chatId = senderId.hashCode <= receiverId.hashCode
        ? "${senderId}_$receiverId"
        : "${receiverId}_$senderId";
    return ChangeNotifierProvider(
      create: (_) => SpecificChatViewModel(),
      child: Consumer<SpecificChatViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back,
                    size: 30, color: AppColors.whiteColor),
              ),
              backgroundColor: AppColors.blackColor,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.blackColor,
                    backgroundImage: NetworkImage(image),
                    radius: 18,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: vm.getUserStatus(receiverId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox.shrink();
                          var userData = snapshot.data!;
                          print(userData['status']);
                          String status = userData['status'] ?? 'Offline';
                          Timestamp? lastSeen = userData['lastSeen'];
                          String displayStatus = (status == 'Online')
                              ? 'Online'
                              : (lastSeen != null)
                              ? 'Last Seen ${vm.formatTimestamp(lastSeen)}'
                              : 'Offline';

                          return Text(
                            displayStatus,
                            style: smallTextStyle.copyWith(
                              color: AppColors.greyColor,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: vm.getSpecificChat(chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error Occurred');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Message Sent/Received Yet'));
                      }
                      var messages = snapshot.data!.docs;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (messages.isNotEmpty) {
                          vm.scrollToBottom();
                        }
                      });
                      return ListView.builder(
                        controller: vm.scrollController,
                        itemCount: messages.length + (vm.loading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length && vm.loading) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: SizeConfig.scaleHeight(200),
                                    height: SizeConfig.scaleHeight(200),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  )),
                            );
                          }
                          var message = messages[index];
                          bool isMe = message['senderId'] == senderId;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.scaleHeight(5),
                                  horizontal: SizeConfig.scaleWidth(10)),
                              padding: message['image_url'] != null
                                  ? EdgeInsets.all(SizeConfig.scaleHeight(5))
                                  : EdgeInsets.all(SizeConfig.scaleHeight(10)),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppColors.blueColor.shade300
                                    : AppColors.greyColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: SizeConfig.screenWidth * 0.8,
                                ),
                                child: message['image_url'] != null
                                    ? InkWell(
                                  onTap: (){
                                    NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.fullImage, arguments: {
                                      'image' : message['image_url']
                                    });
                                  },
                                        child: Image.network(
                                          width: SizeConfig.scaleHeight(200),
                                          height: SizeConfig.scaleHeight(200),
                                          message['image_url'],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        message['text'],
                                        style: smallTextStyle.copyWith(
                                          fontSize: 13,
                                          color: isMe
                                              ? AppColors.blackColor
                                              : AppColors.whiteColor,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.scaleHeight(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.image,
                            size: 30, color: AppColors.blackColor),
                        onPressed: () {
                          vm.pickImage(senderId, receiverId, context);
                        },
                      ),
                      Expanded(
                        child: CustomTextField(
                          maxLines: vm.maxLines,
                          bottom: 0,
                          focusNode: vm.chatFocusNode,
                          controller: vm.chatController,
                          keyboardType: TextInputType.text,
                          hintText: 'Message',
                          current: vm.chatFocusNode,
                          next: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send,
                            size: 30, color: AppColors.blackColor),
                        onPressed: () async {
                          vm.sendMessage(senderId, receiverId, context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
