import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';

import '../../../../../core/utils/images.dart';

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
          return Text('User not found for ID: ${widget.userId}');
        }
        final userData = snapshot.data!.data()!;
        final userName = userData['fullName'] ?? 'Unknown';
        final isOnline = userData['isOnline'] ?? false;
        final imageUrl = userData['imageUrl'];


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
                        ?  DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl == "null"  || imageUrl == ""
                          ? Images.userImageIfNull
                          : imageUrl),
                      fit: BoxFit.cover,
                    )
                        : null, // Handle empty imageUrl
                  ),
                  child: isOnline
                      ?Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0xFF8BC83F)
                          ),
                        ),
                      )
                    ],
                  ):const SizedBox(),
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
                        Expanded(
                          child: Text(
                            userName,
                            style: fontMediumBold,
                            overflow: TextOverflow.ellipsis, // Add this line
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            widget.time,
                            style: fontSmall,
                          ),
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

