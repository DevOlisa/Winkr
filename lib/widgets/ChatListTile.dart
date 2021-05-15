import 'package:flutter/material.dart';
import 'package:winkr/model/message.dart';
import 'package:winkr/model/users.dart';
import 'package:winkr/pages/chat_page.dart';

class ChatListTile extends StatelessWidget {
  final ChatRoom chatRoom;
  const ChatListTile({
    Key key,
    this.chatRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = this.chatRoom;
    User participant = chatRoom.participant;
    Message lastMessage = chatRoom.messages.last;
    int unreadMessageCount = chatRoom.messages
        .where((element) => element.isRead == false)
        .fold(0, (previousValue, element) => previousValue + 1);

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(chatRoom: chatRoom);
        }));
      },
      onLongPress: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        height: 80.0,
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage:
                  AssetImage('assets/profile_pics/' + participant.pic),
            ),
            SizedBox(width: 14.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(participant.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                  SizedBox(height: 5.0),
                  Text(
                    lastMessage.sender.id == user.id
                        ? "You: " + lastMessage.text
                        : lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                unreadMessageCount < 1
                    ? SizedBox(
                        width: 50.0,
                      )
                    : Container(
                        width: 50.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Text(unreadMessageCount.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                SizedBox(height: 8.0),
                Text(lastMessage.getCreatedTime(),
                    style: TextStyle(color: Colors.black45))
              ],
            )
          ],
        ),
      ),
    );
  }
}
