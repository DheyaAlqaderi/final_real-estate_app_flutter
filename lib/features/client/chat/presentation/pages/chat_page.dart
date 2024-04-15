import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/constant/firebase/firebase_collections_names.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../data/models/message_model.dart';
import '../../domain/repository/chat_repository.dart';
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
  late final ChatRepository chatRepository;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatRepository = ChatRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages found.'));
          }

          final messages = snapshot.data!.docs.map((doc) => Message.fromMap(doc.data())).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMyMessage = message.senderId == "7";

                    if (!isMyMessage && !message.seen) {
                      chatRepository.seenMessage(
                        chatroomId: widget.chatRoomId,
                        messageId: message.messageId,
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: isMyMessage
                          ? SentMessage(message: message)
                          : ReceivedMessage(message: message),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Flexible(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(top: 5.0, start: 70.0, bottom: 5.0, end: 50.0),
                            child: TextField(
                              controller: _messageController,
                              maxLines: null, // Allow the TextField to expand vertically
                              decoration: InputDecoration(
                                hintText: Locales.string(context, "hint_message"),
                                border: InputBorder.none, // Hide the underline
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // Call setState to rebuild the widget tree and update the visibility of the camera icon
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: Locales.isDirectionRTL(context) ? null : 10,
                          right: Locales.isDirectionRTL(context) ? 10 : null,
                          bottom: 0,
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: _messageController.text.isEmpty ? 1.0 : 0.0, // Show the camera icon only if the text field is empty
                                duration: Duration(milliseconds: 200), // Animation duration
                                child: SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: Center(
                                    child: SvgPicture.asset(Images.camIconSvg),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0,),
                              const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: Center(
                                  child: Icon(Icons.more_horiz_rounded),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: Locales.isDirectionRTL(context) ? 10 : null,
                          right: Locales.isDirectionRTL(context) ? null : 10,
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              // Get the message from the controller
                              String messageText = _messageController.text.trim(); // Trim any leading or trailing whitespace

                              // Check if the message is empty
                              if (messageText.isNotEmpty) {
                                // Call sendMessage function from your repository
                                chatRepository.sendMessage(
                                  message: messageText,
                                  chatroomId: widget.chatRoomId,
                                  receiverId: widget.receiverId,
                                ).then((result) {
                                  if (result != null) {
                                    // Handle any errors returned by the sendMessage function
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Failed to send message: $result"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    // Clear the text field after sending the message
                                    _messageController.clear();
                                  }
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );


    // ElevatedButton(
            //   onPressed: () {
            //     // Call sendMessage function from your repository
            //     chatRepository.sendMessage(
            //       message: "Your message", // Provide your message here
            //       chatroomId: widget.chatRoomId, // Provide your chatroom ID here
            //       receiverId: widget.receiverId, // Provide the receiver's ID here
            //     ).then((result) {
            //       if (result != null) {
            //         // Handle any errors returned by the sendMessage function
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content: Text("Failed to send message: $result"),
            //             backgroundColor: Colors.red,
            //           ),
            //         );
            //       } else {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text("Message sent successfully"),
            //             backgroundColor: Colors.green,
            //           ),
            //         );
            //       }
            //     });
            //   },
            //   child: const Center(child: Text("send message")),
            // ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
