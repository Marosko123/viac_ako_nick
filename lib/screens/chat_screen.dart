// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/common/my_colors.dart';
import 'package:ViacAkoNick/common/server_handling/request_handler.dart';
import 'package:ViacAkoNick/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:bubble/bubble.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:ViacAkoNick/models/chat.dart' as chat_model;
import 'package:ViacAkoNick/models/message.dart' as message_model;

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late Future<chat_model.Chat?> futureChatRoom;
  final List<types.Message> _messages = [];
  Timer? _timer;

  final types.User _user = const types.User(id: '0');

  bool _showQuickMessages = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // New state variables for the dropdown menu
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    futureChatRoom = RequestHandler.startChatRoom({
      "ignore_required": true,
      "ignore_bot": false,
      "department": [1],
      "fields": {
        "Question": GlobalVariables.question,
        "Username": GlobalVariables.user.name,
        "Phone": GlobalVariables.phone,
        "user_id": GlobalVariables.operatorId,
        "UserId": GlobalVariables.operatorId,
      },
      "main_attr": {"remarks": "New chat request"},
      "status": 1,
      "messages": [
        {
          "msg": GlobalVariables.question,
          "time": DateTime.now().millisecondsSinceEpoch,
          "user_id": 0,
        }
      ]
    }).then((value) {
      RequestHandler.setChatOperatorId(
        GlobalVariables.chatId,
        GlobalVariables.operatorId,
      );
      return value;
    });

    _startFetchingMessages();
  }

  @override
  void dispose() {
    // Dispose of the AnimationController to free up resources
    _animationController.dispose();
    closeTimer();
    super.dispose();
  }

  void _startFetchingMessages() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GlobalVariables.isFetchingMessages == true) {
        return;
      }

      _fetchMessages();
    });
  }

  bool messageExists(
      message_model.Message message, List<types.Message> fetchedMessages) {
    var hasSameId = fetchedMessages.any((m) => m.id == message.id.toString());

    return hasSameId;
  }

  Future<void> _fetchMessages() async {
    // Check if chat has not started yet
    if (GlobalVariables.chatId == -1) {
      print('Chat is not started yet.');
      return;
    }

    // If a fetch operation is already ongoing, return to avoid overlapping requests
    if (GlobalVariables.isFetchingMessages == true) {
      return;
    }

    // Set the fetching flag to true
    GlobalVariables.isFetchingMessages = true;

    try {
      var result = await RequestHandler.fetchChatMessages();
      var fetchedMessages = result.messages;

      if (fetchedMessages.isEmpty) {
        return;
      }

      for (var message in fetchedMessages) {
        // Skip your messages
        if (message.userId == 0 && _messages.isNotEmpty) {
          continue;
        }

        // Check if the message is already in the _messages list (based on its ID)
        bool isMessageExists = messageExists(message, _messages);

        if (!isMessageExists) {
          // If the message is new, add it to the list
          final textMessage = types.TextMessage(
            author: types.User(id: message.userId.toString()),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: message.id.toString(),
            text: message.msg,
          );

          setState(() {
            _messages.insert(0, textMessage); // Add new messages
          });
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      // Reset the flag after the fetch is complete
      GlobalVariables.isFetchingMessages = false;
    }
  }

  void closeTimer() {
    try {
      _timer?.cancel();
    } catch (e) {
      print(e);
    }
  }

  void _toggleQuickMessages() {
    setState(() {
      _showQuickMessages = !_showQuickMessages;
      if (_showQuickMessages) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // New method to toggle the FAB dropdown
  void _toggleFab() {
    // disable dropdown while loading chat
    if (GlobalVariables.chatId == -1) {
      return;
    }

    setState(() {
      _isFabOpen = !_isFabOpen;
      if (_isFabOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const MyButton(
                  text: "Rýchlo preč",
                  onTap: null,
                ),
                if (GlobalVariables.operatorName.isNotEmpty)
                  Text(
                    "Chatuješ s: ${GlobalVariables.operatorName}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Expanded(
                  child: FutureBuilder<chat_model.Chat?>(
                    future: futureChatRoom,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        // When the data is available, show the chat interface
                        return Stack(
                          children: [
                            Chat(
                              messages: _messages,
                              // showUserAvatars: true,
                              onAttachmentPressed: _handleAttachmentPressed,
                              onSendPressed: _handleSendPressed,
                              user: _user,
                              bubbleBuilder: (child,
                                      {required message,
                                      required nextMessageInGroup}) =>
                                  _bubbleBuilder(
                                child,
                                message: message,
                                nextMessageInGroup: nextMessageInGroup,
                                user: _user,
                              ),
                            ),
                            // Quick Messages Container
                            if (_showQuickMessages)
                              Positioned(
                                bottom:
                                    110, // Adjust the position above the FAB
                                left: 3,
                                child: FadeTransition(
                                  opacity: _animation,
                                  child: ScaleTransition(
                                    scale: _animation,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FloatingActionButton.extended(
                                          foregroundColor: MyColors.textColor,
                                          backgroundColor:
                                              MyColors.chatInputColor,
                                          onPressed: () => _sendQuickMessage(
                                              "Ako táto aplikácia funguje?"),
                                          label: const Text(
                                              "Ako táto aplikácia funguje?"),
                                        ),
                                        const SizedBox(height: 5),
                                        FloatingActionButton.extended(
                                          foregroundColor: MyColors.textColor,
                                          backgroundColor:
                                              MyColors.chatInputColor,
                                          onPressed: () =>
                                              _sendQuickMessage("Bojím sa."),
                                          label: const Text("Bojím sa."),
                                        ),
                                        const SizedBox(height: 5),
                                        FloatingActionButton.extended(
                                          foregroundColor: MyColors.textColor,
                                          backgroundColor:
                                              MyColors.chatInputColor,
                                          onPressed: () => _sendQuickMessage(
                                              "Ďakujem za pomoc."),
                                          label:
                                              const Text("Ďakujem za pomoc."),
                                        ),
                                        const SizedBox(height: 5),

                                        // Scrollable list of emojis, horizontally
                                        SizedBox(
                                          height: 200,
                                          width: 260,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: _generateEmojiButtons(
                                                _sendQuickMessage,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        // If no data is available or the future fails, show a fallback message
                        return const Text(
                          'Nepodarilo sa vytvoriť chat.',
                          style: TextStyle(fontSize: 20),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            // Dropdown FAB Positioned at the bottom left
            Positioned(
              left: 5,
              bottom: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown options
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: -1,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        FloatingActionButton(
                          backgroundColor: MyColors.chatInputColor,
                          foregroundColor: MyColors.textColor,
                          heroTag: 'quickMessages',
                          onPressed: _toggleQuickMessages,
                          child: const Icon(Icons.message),
                        ),
                        const SizedBox(height: 5),
                        FloatingActionButton(
                          backgroundColor: MyColors.chatInputColor,
                          foregroundColor: MyColors.textColor,
                          heroTag: 'attachment',
                          onPressed: _handleAttachmentPressed,
                          child: const Icon(Icons.attach_file),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: MyColors.chatInputColor,
                    foregroundColor: MyColors.textColor,
                    heroTag: 'mainFab',
                    onPressed: _toggleFab,
                    elevation: 0,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _animation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      File file = File(result.files.single.path!);
      await RequestHandler.handleFileUpload(file, GlobalVariables.chatId);

      _addFile(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      File file = File(result.path!);
      await RequestHandler.handleFileUpload(file, GlobalVariables.chatId);

      _addFile(message);
    }
  }

  Future<void> _addFile(types.Message message) async {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _addMessage(
      types.Message message, int chatId, String msg) async {
    try {
      _messages.insert(0, message);
      setState(() {});

      await RequestHandler.addMsgUser(chatId, msg);
    } catch (e) {
      print('Error adding message: $e');
    }
  }

  Future<void> _sendQuickMessage(String text) async {
    await _handleSendPressed(types.PartialText(
      text: text,
    ));
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Random().nextDouble().toString(),
      text: message.text,
    );

    await _addMessage(textMessage, GlobalVariables.chatId, message.text);
  }
}

Widget _bubbleBuilder(
  Widget child, {
  required types.Message message,
  required bool nextMessageInGroup,
  required types.User user,
}) {
  // Determine if the message should be on the right or left based on message.userId
  bool isCurrentUser = message.author.id == '0';

  var fileUrl = '';

  if (message.type == types.MessageType.text) {
    var messageText = message as types.TextMessage;

    if (messageText.text.contains('http')) {
      fileUrl = messageText.text;
    }
  }

  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Bubble(
      color: isCurrentUser
          ? MyColors.chatBubbleRightColor
          : MyColors.chatBubbleLeftColor,
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : const BubbleEdges.symmetric(horizontal: 0),
      nip: nextMessageInGroup
          ? BubbleNip.no
          : isCurrentUser
              ? BubbleNip.rightBottom
              : BubbleNip.leftBottom,
      child: fileUrl.isNotEmpty
          ? _buildFilePreview(fileUrl)
          : DefaultTextStyle(
              style: TextStyle(color: MyColors.textColor),
              child: child,
            ),
    ),
  );
}

Widget _buildFilePreview(String fileUrl) {
  return Image.network(
    fileUrl,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      }
    },
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return const Text('Failed to load image');
    },
  );
}

List<Widget> _generateEmojiButtons(Function sendQuickMessage) {
  // List of emojis
  List<String> emojis = [
    "😊",
    "😂",
    "😢",
    "❤️",
    "🙏",
    "💰",
    "😡",
    "👍",
    "🎉",
    "👋",
    "👏",
    "🤔",
    "🤣",
    "🥰",
    "🤩",
    "😍",
    "😎",
    "🤗",
    "😇",
    "😜",
    "🎁",
  ];

  List<Widget> emojiRows = [];

  for (int i = 0; i < emojis.length; i += 2) {
    emojiRows.add(
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: FloatingActionButton.extended(
              foregroundColor: MyColors.textColor,
              backgroundColor: MyColors.chatInputColor,
              onPressed: () => sendQuickMessage(emojis[i]),
              label: Text(emojis[i]),
            ),
          ),
          // Check if there is a second emoji in the row
          if (i + 1 < emojis.length)
            Padding(
              padding: const EdgeInsets.all(3),
              child: FloatingActionButton.extended(
                foregroundColor: MyColors.textColor,
                backgroundColor: MyColors.chatInputColor,
                onPressed: () => sendQuickMessage(emojis[i + 1]),
                label: Text(emojis[i + 1]),
              ),
            ),
        ],
      ),
    );
  }

  return emojiRows;
}
