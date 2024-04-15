import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constant/firebase/firebase_collections_names.dart';
import '../../../../../core/constant/firebase/firebase_field_names.dart';
import '../../data/models/chatRoom_model.dart';
import '../../data/models/message_model.dart';


class ChatRepository {
  late final String myUid;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ChatRepository() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    myUid = prefs.getString('user_id') ?? '';
  }

  Future<String> createChatroom({
    required String userId,
  }) async {
    try {
      if (myUid.isEmpty) {
        throw Exception('User ID is empty');
      }

      final chatRooms = FirebaseFirestore.instance.collection(
        FirebaseCollectionNames.chatRooms,
      );

      // sorted members
      final sortedMembers = [myUid, userId]..sort((a, b) => a.compareTo(b));

      // existing chatRooms
      final existingChatRooms = await chatRooms
          .where(
          FirebaseFieldNames.members,
          isEqualTo: sortedMembers)
          .get();

      if (existingChatRooms.docs.isNotEmpty) {
        return existingChatRooms.docs.first.id;
      } else {
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        Chatroom chatroom = Chatroom(
          chatroomId: chatroomId,
          lastMessage: '',
          lastMessageTs: now,
          members: sortedMembers,
          createdAt: now,
        );

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.chatRooms)
            .doc(chatroomId)
            .set(chatroom.toMap());

        return chatroomId;
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }


  // Send message
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: "7",
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatRooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Send file message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatRooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: 'send a $messageType',
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatRooms)
          .doc(chatroomId)
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .update({
        FirebaseFieldNames.seen: true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }


  // Get chat rooms where a specific user is a member as a stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsForMemberStream(String userId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .where('members', arrayContains: userId)
        .snapshots();
  }

  // Get user by user ID
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByIdStream(String userId) {
    return FirebaseFirestore.instance.collection('Users').doc(userId).snapshots();
  }

  // Get messages in a chat room as a stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesInChatRoomStream(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

}