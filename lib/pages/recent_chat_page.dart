import 'package:flutter/material.dart';
import 'package:winkr/model/message.dart';
import 'package:winkr/uiElements/NoRecentChat.dart';
import 'package:winkr/widgets/ChatListTile.dart';
import 'package:winkr/widgets/FavouriteContacts.dart';

class ReccentChatPage extends StatelessWidget {
  const ReccentChatPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatRooms.isEmpty ? SizedBox() : FavouriteContacts(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: chatRooms.isEmpty
                ? SizedBox()
                : Text(
                    "Recent Chat",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                  ),
          ),
          Expanded(
            child: chatRooms.isEmpty
                ? NoRecentChat()
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      chatRooms.sort((a, b) => b.messages.last.created
                          .compareTo(a.messages.last.created));
                      var chatRoom = chatRooms[index];
                      return ChatListTile(
                        chatRoom: chatRoom,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
