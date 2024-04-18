import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';

import '../../../../../core/constant/app_constants.dart';
import '../widgets/room_chat_widget.dart';
import 'chat_page.dart';


class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  late String userId = AppConstants.userIdFake;

  @override
  void initState() {
    super.initState();
    // _loadUserId();
  }

  // Future<void> _loadUserId() async {
  //   final loadedUserId = await SharedPrefManager.getData("user_id");
  //   print(loadedUserId.toString());
  //   setState(() {
  //     userId = loadedUserId ?? '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (userId.isNotEmpty)
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ChatRepository().getChatRoomsForMemberStream(userId),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data available'));
                        } else {

                           Container();
                        }
                        // Extract documents from snapshot
                        final List<DocumentSnapshot<Map<String, dynamic>>> sortedDocs = snapshot.data!.docs.where((doc) => (doc['last_message'] as String).isNotEmpty).toList()
                          ..sort((a, b) {
                            final aLastMessageDate = (a['last_message_ts'] as int?) ?? 0;
                            final bLastMessageDate = (b['last_message_ts'] as int?) ?? 0;
                            return bLastMessageDate.compareTo(aLastMessageDate); // Sorting in descending order
                          });

                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: sortedDocs.map((document) {
                            final data = document.data()!;
                            final chatroomId = data['chatroom_id'] as String;
                            final lastMessage = data['last_message'] as String;
                            final sortedMembers = data['members'] as List<dynamic>;
                            final lastMessageDateInMillis = data['last_message_ts'] as int?;

                            String receiverId = ''; // Initialize receiverId with a default value

                            if (sortedMembers.isNotEmpty) {
                              // If sortedMembers is not empty, find the receiverId
                              receiverId = sortedMembers.firstWhere((member) => member != userId, orElse: () => '');
                              print(receiverId.toString());
                            }

                            // Convert milliseconds to DateTime
                            DateTime? lastMessageDate;
                            if (lastMessageDateInMillis != null) {
                              lastMessageDate = DateTime.fromMillisecondsSinceEpoch(lastMessageDateInMillis);
                            } else {
                              lastMessageDate = DateTime.now(); // or provide a default value as per your application logic
                            }

                            // Get today's date
                            DateTime today = DateTime.now();
                            // Format the date for display
                            String formattedDate = '';

                            if (today.year == lastMessageDate.year && today.month == lastMessageDate.month && today.day == lastMessageDate.day) {
                              formattedDate = 'Today';
                            } else {
                              // Get yesterday's date
                              DateTime yesterday = today.subtract(const Duration(days: 1));
                              if (yesterday.year == lastMessageDate.year && yesterday.month == lastMessageDate.month && yesterday.day == lastMessageDate.day) {
                                formattedDate = 'Yesterday';
                              } else {
                                // Format other dates normally
                                formattedDate = DateFormat('yyyy-MM-dd').format(lastMessageDate);
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(chatRoomId: chatroomId, receiverId: receiverId),
                                  ),
                                );
                              },
                              child: RoomChatWidget(userId: receiverId, lastMessage: lastMessage, time: formattedDate,),
                            );
                          }).toList(),
                        );
                      }
                  )
                else
                  const Center(child: Text("You have to login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


