import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/core/constant/firebase/firebase_collections_names.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/profile_owner_screen.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../data/models/message_model.dart';
import '../../domain/repository/chat_repository.dart';
import '../widgets/message_field_widget.dart';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatRoomId, required this.receiverId});

  final String chatRoomId;
  final String receiverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository  chatRepository = ChatRepository();
  String fcmTokene = "";
  // var userData;
  // bool isIconAppeared = false;

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    print(loadedUserId.toString());
    print(widget.receiverId);
    setState(() {
      userId = loadedUserId ?? '';
    });
  }


  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseCollectionNames.chatRooms)
              .doc(widget.chatRoomId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Extract messages from snapshot
            final messages = snapshot.data?.docs.map((doc) => MessageModel.fromMap(doc.data())).toList() ?? [];

            // Group messages by day
            Map<DateTime, List<MessageModel>> groupedMessages = {};
            for (var message in messages) {
              DateTime messageDate = DateTime(message.timestamp.year, message.timestamp.month, message.timestamp.day);
              if (groupedMessages.containsKey(messageDate)) {
                groupedMessages[messageDate]!.add(message);
              } else {
                groupedMessages[messageDate] = [message];
              }
            }

            // Build UI with grouped messages
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 65.0,
                    width: double.infinity,
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.receiverId)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
                        // Widget code for user data...
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(
                            child: Text('No data found.'),
                          );
                        }
                        // Access data from the snapshot
                        final userData = snapshot.data!.data();
                        if(userData != null && userData['fcmToken'] == null) {
                           fcmTokene = FirebaseMessaging.instance.getToken() as String;
                          chatRepository.updateUserToken(userId!, fcmTokene);
                        }

                        setState(() {
                          fcmTokene = userData!['fcmToken'];
                        });
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_outlined,
                                      size: 20,
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 7.0),
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Theme.of(context).cardColor,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          (userData!['imageUrl'] == "null" || userData['imageUrl'] == "")
                                              ? Images.userImageIfNull
                                              : (userData['imageUrl'].startsWith('http'))
                                              ? userData['imageUrl']
                                              : "${AppConstants.baseUrl3}${userData['imageUrl']}"
                                      ),

                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const SizedBox(),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOwnerScreen(userId: userData['userId'])));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 7.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(userData["fullName"], style: fontMediumBold),
                                    Text(
                                      userData["isOnline"] == null || userData["isOnline"] ? "Online" : _getLastSeenText(userData),
                                      style: fontSmall.copyWith(color: userData["isOnline"]== null || userData["isOnline"] ? Colors.green : Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),


                              ],
                            ),

                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  size: 20,
                                ),
                                onPressed: (){

                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey,
                        image: const DecorationImage(
                          image: AssetImage(Images.chatPageBackground),
                          fit: BoxFit.cover
                        )
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              itemCount: groupedMessages.length,
                              itemBuilder: (context, index) {
                                var entry = groupedMessages.entries.elementAt(index);
                                // Reverse the order of messages within each group
                                List<MessageModel> reversedMessages = entry.value.reversed.toList();
                                // Get today's date
                                DateTime today = DateTime.now();
                                // Get the date of the message
                                DateTime messageDate = entry.key;
                                // Format the date for display
                                String formattedDate = '';

                                if (today.year == messageDate.year && today.month == messageDate.month && today.day == messageDate.day) {
                                  formattedDate = 'Today';
                                } else {
                                  // Get yesterday's date
                                  DateTime yesterday = today.subtract(const Duration(days: 1));
                                  if (yesterday.year == messageDate.year && yesterday.month == messageDate.month && yesterday.day == messageDate.day) {
                                    formattedDate = 'Yesterday';
                                  } else {
                                    // Format other dates normally
                                    formattedDate = DateFormat('yyyy-MM-dd').format(messageDate);
                                  }
                                }

                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: Theme.of(context).primaryColor
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          formattedDate,
                                          style: fontSmallBold.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    // Display messages for the date
                                    ...reversedMessages.map((message) {
                                      final isMyMessage = message.senderId == userId;

                                      if (!isMyMessage && !message.seen) {
                                        chatRepository.seenMessage(
                                          chatroomId: widget.chatRoomId,
                                          messageId: message.messageId,
                                        );
                                      }

                                      return isMyMessage
                                          ? Align(
                                        alignment: Alignment.centerRight,
                                        child: SentMessage(message: message),
                                      )
                                          : ReceivedMessage(message: message);
                                    }),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, right: 4.0, left: 4.0),
                            child: MessageFieldWidget(
                              chatRoomId: widget.chatRoomId,
                              receiverId: widget.receiverId,
                              fcmToken: fcmTokene,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );



          },
        ),
      ),
    );


  }
  String _getLastSeenText(Map<String, dynamic> userData) {
    final lastSeen = (userData['lastSeen'] as Timestamp).toDate();
    final difference = DateTime.now().difference(lastSeen);
    if (difference.inDays > 0) {
      return "Last seen ${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "Last seen ${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "Last seen ${difference.inMinutes} minutes ago";
    } else {
      return "Last seen just now";
    }
  }

}
