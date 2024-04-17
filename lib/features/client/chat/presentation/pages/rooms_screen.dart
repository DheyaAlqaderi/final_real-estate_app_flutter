import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Check if collection is empty
                      if (snapshot.data?.docs.isEmpty ?? true) {
                        return const Text('No chat rooms found.');
                      }
                      // Display chat room data
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map(
                              (DocumentSnapshot<Map<String, dynamic>> document) {
                            Map<String, dynamic> data = document.data()!;
                            final chatroomId = data['chatroom_id'] as String;
                            final lastMessage = data['last_message'] as String;
                            final sortedMembers = data['members'] as List<dynamic>;

                            String receiverId = ''; // Initialize receiverId with a default value

                            if (sortedMembers.isNotEmpty) {
                              // If sortedMembers is not empty, find the receiverId
                              receiverId = sortedMembers.firstWhere((member) => member != userId, orElse: () => '');
                              print(receiverId.toString());
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
                              child:  RoomChatWidget(userId: receiverId,lastMessage: lastMessage, time: " ",),
                            );
                          },
                        ).toList(),
                      );
                    },
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


