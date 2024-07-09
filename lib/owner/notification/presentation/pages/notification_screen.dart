import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/utils/images.dart';
import 'package:smart_real_estate/owner/notification/presentation/widgets/notification_widget.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.token});
  final String token;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late WebSocketChannel channel;
  late Stream<dynamic> notificationStream;
  bool isRefreshing = false;
  String? token;

  @override
  void initState() {
    super.initState();

    token = widget.token;
    initializeWebSocket();

  }



  void initializeWebSocket()  {
    channel = IOWebSocketChannel.connect(
      '${AppConstants.baseUrl4}/ws/notifications/',
      headers: {
        'Authorization': "token $token",
      },
    );

    final Map<String, dynamic> body = {
      "command": " ",
      "page_number": 0,
    };

    channel.sink.add(jsonEncode(body));

    notificationStream = channel.stream.asBroadcastStream();
  }

  Future<void> refreshNotifications() async {
    setState(() {
      isRefreshing = true;
    });

    // Re-initialize the WebSocket connection
    initializeWebSocket();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "notification")),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 15),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(Images.trustIcon),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: notificationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final Map<String, dynamic> notificationList = jsonDecode(snapshot.data);
            return RefreshIndicator(
              onRefresh: refreshNotifications,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: notificationList["notifications"].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: NotificationWidget(
                              onTap: () {
                              },
                              notificationList: notificationList,
                              index: index,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
