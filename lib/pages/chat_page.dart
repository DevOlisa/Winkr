import 'package:flutter/material.dart';
import 'package:winkr/model/message.dart';
import 'package:winkr/model/users.dart';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:winkr/pages/settings_page.dart';
import 'package:winkr/services/camera/camera_app.dart';
import 'package:winkr/widgets/ImageBubble.dart';
import 'package:winkr/widgets/MessageBubble.dart';

class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatPage({Key key, this.chatRoom}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isUserTyping;
  TextEditingController _editingController = TextEditingController();
  ScrollController _chatScrollController;
  Function sendMessage;

  ///Scrolls to the bottom of the ListView or Scrollable Widget
  void _scrollToBottom() {
    double bottom = double.maxFinite;
    print(bottom);
    _chatScrollController.position
        .moveTo(bottom, duration: Duration(milliseconds: 300));
  }

  @override
  void initState() {
    super.initState();
    _chatScrollController = ScrollController(initialScrollOffset: 10000.0);
    _chatScrollController.addListener(() {});
    _editingController.addListener(() {
      isUserTyping = true;
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = widget.chatRoom;
    List<Message> messages = chatRoom.messages ?? [];
    User sender = chatRoom.participant;
    bool isSenderFavourite = user.favourites.contains(sender);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: isSenderFavourite
                  ? Icon(
                      Icons.star_rounded,
                      color: Colors.yellow,
                    )
                  : Icon(Icons.star_outline_rounded),
              onPressed: () {
                user.toggleFavourite(sender);
                setState(() {});
              }),
          PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert_rounded),
              offset: Offset(0.0, -16.0),
              elevation: 2.0,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: Text("Add Shortcut")),
                  PopupMenuItem(
                      height: 1.0, child: PopupMenuDivider(height: 1.0)),
                  PopupMenuItem(child: Text("Block " + sender.name)),
                ];
              }),
        ],
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SettingsPage();
            }));
          },
          highlightColor: Colors.white12,
          splashColor: Colors.white12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            child: Row(children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    AssetImage('assets/profile_pics/' + sender.pic),
              ),
              SizedBox(width: 15.0),
              Text(sender.name),
            ]),
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        // margin: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final Message message = messages[index];
                    final isCurrentUser = message.sender.id == user.id;
                    if (message.imageUrl != null) return ImageBubble();
                    return MessageBubble(
                        message: message, isCurrentUser: isCurrentUser);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color(0x12000000),
                      offset: Offset(0.0, -0.2),
                      blurRadius: 7.0),
                ]),
                // height: ,
                child: Row(
                  children: [
                    SizedBox(
                        // width: 48.0,
                        child: IconButton(
                      icon: Icon(Icons.image),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    )),
                    SizedBox(
                        // width: 48.0,
                        child: IconButton(
                      icon: Icon(Icons.camera_alt_rounded),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          final _cameras =
                              context.read<List<CameraDescription>>();

                          return CameraApp(cameras: _cameras);
                        }));
                      },
                    )),
                    Expanded(
                      child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          controller: _editingController,
                          scrollPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            hintText: "Type a message",
                          )),
                    ),
                    SizedBox(
                        width: 64.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            String textFromInput =
                                _editingController.text.trim();
                            if (textFromInput.isEmpty || textFromInput == null)
                              return;
                            Message messageFromInput =
                                new Message(user, sender, textFromInput);
                            // If the message List is empty, we will create add the
                            if (chatRoom.addMessage(messageFromInput)) {
                              if (chatRoom.messages.length == 1) {
                                chatRooms.add(chatRoom);
                              }
                              _editingController.clear();
                            }
                            setState(() {});
                            _scrollToBottom();
                          },
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
