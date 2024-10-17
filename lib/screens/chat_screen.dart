// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
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

// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late Future<chat_model.Chat?> futureChatRoom;
  final List<types.TextMessage> _messages = [];
  final _user = const types.User(id: '1');
  Timer? _timer;

  bool _showQuickMessages = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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

  bool hasNewMessage(List<message_model.Message> fetchedMessages,
      List<types.Message> messages2) {
    return fetchedMessages.length > messages2.length;
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
      var messages = result.messages;

      // for (var message in messages) {
      //   print('Message [${message.userId}]: ${message.msg}');
      // }

      // If there are new messages, update the chat
      if (messages.isNotEmpty && hasNewMessage(messages, _messages)) {
        _messages.clear();

        for (var message in messages) {
          final textMessage = types.TextMessage(
            author: types.User(id: message.userId.toString()),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: Random().nextDouble().toString(),
            text: message.msg,
          );
          _messages.insert(0, textMessage);
        }

        // Refresh the UI
        setState(() {});
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const MyButton(
              text: "Rýchlo preč",
              onTap: null,
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
                          onAttachmentPressed: _handleAttachmentPressed,
                          onSendPressed: _handleSendPressed,
                          user: const types.User(id: '0'),
                          bubbleBuilder: (child,
                                  {required message,
                                  required nextMessageInGroup}) =>
                              _bubbleBuilder(
                            child,
                            message: message as types.TextMessage,
                            nextMessageInGroup: nextMessageInGroup,
                            // user: types.User(id: message.author.id),
                            user: const types.User(id: '0'),
                          ),
                        ),
                        // Quick Messages Container
                        if (_showQuickMessages)
                          Positioned(
                            top: 0, // Adjust the position above the FAB
                            right: 20,
                            child: FadeTransition(
                              opacity: _animation,
                              child: ScaleTransition(
                                scale: _animation,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed: () => _sendQuickMessage(
                                          "Ako táto aplikácia funguje?"),
                                      label: const Text(
                                          "Ako táto aplikácia funguje?"),
                                    ),
                                    const SizedBox(height: 5),
                                    FloatingActionButton.extended(
                                      onPressed: () =>
                                          _sendQuickMessage("Bojím sa."),
                                      label: const Text("Bojím sa."),
                                    ),
                                    const SizedBox(height: 5),
                                    FloatingActionButton.extended(
                                      onPressed: () => _sendQuickMessage(
                                          "Ďakujem za pomoc."),
                                      label: const Text("Ďakujem za pomoc."),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleQuickMessages,
          child: const Icon(
            Icons.message,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                  // _handleImageSelection(); TODO:
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleFileSelection(); TODO:
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

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: randomString(),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );

  //     print('HandleFileSelection: ');
  //     print(message);
  //     // _addMessage(message);
  //   }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);

  //     final message = types.ImageMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       height: image.height.toDouble(),
  //       id: randomString(),
  //       name: result.name,
  //       size: bytes.length,
  //       uri: result.path,
  //       width: image.width.toDouble(),
  //     );

  //     print('HandleImageSelection: ');
  //     print(message);
  //     // _addMessage(message);
  //   }
  // }

  Future<void> _addMessage(
      types.TextMessage message, int chatId, String msg) async {
    try {
      _messages.insert(0, message);
      setState(() {});

      await RequestHandler.addMsgUser(chatId, msg);
    } catch (e) {
      print('Error adding message: $e');
    }
  }

  // Add a quick message to the chat
  void _sendQuickMessage(String text) async {
    final quickMessage = types.TextMessage(
      author: const types.User(id: '0'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Random().nextDouble().toString(),
      text: text,
    );

    await _addMessage(quickMessage, GlobalVariables.chatId, text);
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: const types.User(id: '0'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Random().nextDouble().toString(),
      text: message.text,
    );

    await _addMessage(textMessage, GlobalVariables.chatId, message.text);
  }
}

Widget _bubbleBuilder(
  Widget child, {
  required types.TextMessage message,
  required bool nextMessageInGroup,
  required types.User user,
}) {
  // Determine if the message should be on the right or left based on message.userId
  bool isCurrentUser = message.author.id == '0';

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
      child: DefaultTextStyle(
        style: TextStyle(color: MyColors.textColor),
        child: child,
      ),
    ),
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
              onPressed: () => sendQuickMessage(emojis[i]),
              label: Text(emojis[i]),
            ),
          ),
          // Check if there is a second emoji in the row
          if (i + 1 < emojis.length)
            Padding(
              padding: const EdgeInsets.all(3),
              child: FloatingActionButton.extended(
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
