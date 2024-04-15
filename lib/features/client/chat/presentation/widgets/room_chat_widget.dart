import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';

class RoomChatWidget extends StatefulWidget {
  const RoomChatWidget({super.key, required this.userId, required this.time, required this.lastMessage});
  final String userId;
  final String time;
  final String lastMessage;
  @override
  State<RoomChatWidget> createState() => _RoomChatWidgetState();
}

class _RoomChatWidgetState extends State<RoomChatWidget> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ChatRepository().getUserByIdStream(widget.userId.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('User not found.');
        }
        final userData = snapshot.data!.data()!;
        final userName = userData['email'] ?? 'Unknown';
        final lastSeenTime = userData['userId'];
        final imageUrl = userData['imageUrl'] as String?;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          height: 70.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme
                .of(context)
                .cardColor,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          image: imageUrl!.isNotEmpty
                              ? DecorationImage(
                            image: CachedNetworkImageProvider("https://as2.ftcdn.net/v2/jpg/06/04/08/91/1000_F_604089168_VAoSVQ3VJkiT3nKrHhX6PZ35YYGPYs2m.jpg"),
                            fit: BoxFit.cover,
                          )
                              : null, // Handle empty imageUrl
                        ),
                      ),
              ),
              const SizedBox(width: 7.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userName, style: fontMediumBold),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(lastSeenTime.toString(),
                              style: fontSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.lastMessage,
                      style: fontSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

