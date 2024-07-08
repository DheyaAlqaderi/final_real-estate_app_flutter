

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';
import '../../../../../core/constant/firebase/utils.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../../../core/utils/images.dart';

class MessageFieldWidget extends StatefulWidget {
  const MessageFieldWidget({super.key, required this.chatRoomId, required this.receiverId, required this.fcmToken});

  final String chatRoomId;
  final String receiverId;
  final String fcmToken;
  @override
  State<MessageFieldWidget> createState() => _MessageFieldWidgetState();
}
class _MessageFieldWidgetState extends State<MessageFieldWidget> {
  late ChatRepository chatRepository;
  late TextEditingController _messageController;
  bool isIconAppeared = true;
  late String chatroomId; // Declare chatroomId and messageType
  late String receiverId; // Declare receiverId and messageType
  late String messageType;
  bool _uploading = false; // Flag to track whether the upload is in progress
  int currentLines = 1;
  final int maxLines = 6;
  String? userId;



  Future<void> _loadUserId() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    print(loadedUserId.toString());
    setState(() {
      userId = loadedUserId;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserId();
    chatRepository = ChatRepository();
    _messageController = TextEditingController();
    _messageController.addListener(() {
      setState(() {
        isIconAppeared = _messageController.text.isEmpty;

        final lines = _messageController.text.split('\n').length;
        if (lines != currentLines && lines <= maxLines) {
          setState(() {
            currentLines = lines;
          });
        }
      });
    });
    // Initialize chatroomId and receiverId
    chatroomId = widget.chatRoomId;
    receiverId = widget.receiverId;
    messageType = 'image'; // Set messageType to 'image' for image messages
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }


  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  File? imageFile;
  File? _video;
  final picker = ImagePicker();



  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.image, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: fontMediumBold,
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 60.0),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: fontMediumBold,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.video_call, size: 60.0), // Change the icon to a video icon
                          SizedBox(height: 12.0),
                          Text(
                            "Video",
                            textAlign: TextAlign.center,
                            style: fontMediumBold,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _pickAndUploadVideo();// Your method to pick video from gallery
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }



  Future<void> _pickAndUploadVideo() async {
    setState(() {
      _uploading = true; // Start the upload, set flag to true
    });

    File? video = await pickVideo();
    if (video != null) {
      String? error = await chatRepository.sendFileMessage(
        file: video,
        chatroomId: chatroomId,
        receiverId: receiverId,
        messageType: 'video',
      );

      if (error == null) {
        // Message sent successfully
        setState(() {
          _video = null;
          _uploading = false; // Upload finished, set flag to false
        });
      } else {
        // Error occurred while sending message
        print('Error sending message: $error');
        setState(() {
          _uploading = false; // Upload finished with error, set flag to false
        });
      }
    } else {
      setState(() {
        _uploading = false; // Upload canceled or no video selected, set flag to false
      });
    }
  }

  Future<void> _imgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _imgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });

      if (imageFile != null) {
        // Determine the message type based on file extension
        String messageType = imageFile!.path.endsWith('.mp4') ? 'video' : 'image';

        // Start the uploading process
        setState(() {
          _uploading = true;
        });

        // Send the file to the chat repository
        chatRepository.sendFileMessage(
          file: imageFile!,
          chatroomId: chatroomId,
          receiverId: receiverId,
          messageType: messageType,
        ).then((String? success) {
          // Finish the uploading process
          setState(() {
            _uploading = false;
          });

          if (success != null) {
            // Show error message if upload fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload file: $success'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File uploaded successfully.'),
                backgroundColor: Colors.green,
              ),
            );
            // Clear the file after successful upload
            setState(() {
              imageFile = null;
            });
          }
        });
      }
    }
  }



  double _calculateLineHeight(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(text: 'A\n', style: TextStyle(fontSize: 16.0)),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: double.infinity);

    return textPainter.preferredLineHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: !isDarkMode(context)?Colors.white:Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    isIconAppeared
                        ? IconButton(
                          icon: Center(
                            child: SvgPicture.asset(Images.camIconSvg, color: Theme.of(context).hintColor,),
                          ),
                          onPressed: ()async{
                            Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage, Permission.camera,
                            ].request();
                            if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                            showImagePicker(context);
                            } else {
                            if (kDebugMode) {
                              print('no permission provided');
                            }
                            }
                          },
                        )
                        : const SizedBox(),
                    IconButton(
                      icon: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(Images.clipIconBoldSvg, color: Theme.of(context).hintColor,),
                      ),
                      onPressed: (){

                      },
                    )
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 7 * _calculateLineHeight(context)),
                          child: TextField(
                            controller: _messageController,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              hintText: Locales.string(context, "hint_message"),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                (!isIconAppeared)
                    /// sending a message
                    ?IconButton(
                      icon: Icon(Icons.send, color: Theme.of(context).hintColor,),
                      onPressed: () {
                        // Get the message from the controller
                        String messageText =
                        _messageController.text.trim(); // Trim any leading or trailing whitespace
                        _messageController.clear();
                        // Check if the message is empty
                        if (messageText.isNotEmpty) {
                          // Call sendMessage function from your repository
                          chatRepository.sendMessage(
                            message: messageText,
                            chatroomId: widget.chatRoomId,
                            receiverId: widget.receiverId,
                            fcmToken: widget.fcmToken,
                            userId: userId.toString()
                          ).then((result) {
                            if (result != null) {
                              // Handle any errors returned by the sendMessage function
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                  Text("Failed to send message: $result"),
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
                    )
                    /// recording an audio
                    :IconButton(
                      icon: Icon(Icons.mic, color: Theme.of(context).hintColor),
                      onPressed: () {

                          chatRepository.sendNotificationToToken(widget.fcmToken, title: "hello", body: "name");

                      },
                    ),
              ],
            ),
            if (_uploading) // Show progress indicator while uploading
              const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}



