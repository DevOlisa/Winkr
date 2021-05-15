import 'package:flutter/material.dart';
import 'package:winkr/model/message.dart';
import 'package:winkr/model/users.dart';
import 'package:winkr/pages/chat_page.dart';

class ContactListTile extends StatelessWidget {
  final User contact;
  const ContactListTile({
    Key key,
    this.contact,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final user = contact;
    ChatRoom _chatRoom;

    ChatRoom getChatRoom() {
      ChatRoom result;
      chatRooms.forEach((element) {
        if (element.participant == user) {
          print(user.name);
          result = element;
        }
      });
      return result;
    }

    ChatRoom createChatRoom() {
      // Flag as a new chat
      ChatRoom _newChatRoom = new ChatRoom(user);
      return _newChatRoom;
    }

    return InkWell(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          _chatRoom = getChatRoom() ?? createChatRoom();

          return ChatPage(
            chatRoom: _chatRoom,
          );
        }));
      },
      onLongPress: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        height: 80.0,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage('assets/profile_pics/' + user.pic),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                  SizedBox(height: 5.0),
                  Text(
                    "Lorem ipsum sit dolor amet",
                    style: TextStyle(color: Colors.black45),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
