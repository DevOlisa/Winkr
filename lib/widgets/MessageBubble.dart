import 'package:flutter/material.dart';
import 'package:winkr/model/message.dart';

class MessageBubble extends StatefulWidget {
  final message;
  final isCurrentUser;

  const MessageBubble({Key key, this.message, this.isCurrentUser})
      : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  _buildMessage(Message message, bool isCurrentUser) {
    void toggleLike() {
      message.isLiked = !message.isLiked;
      setState(() {});
    }

    final Container msg = Container(
      constraints: BoxConstraints(
        minWidth: 100.0,
        maxWidth: MediaQuery.of(context).size.width * 0.60,
      ),
      margin: isCurrentUser
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: MediaQuery.of(context).size.width * 0.2)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
          color: isCurrentUser ? Colors.white : Color(0xFFFFEFEE),
          borderRadius: isCurrentUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  bottomLeft: Radius.circular(15.0))
              : BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                color: Color(0x12000000),
                offset: Offset(0.0, -0.0),
                blurRadius: 3.0),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hmm.format(message.created),
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5.0),
          Text(
            message.text,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                wordSpacing: 1.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    if (isCurrentUser) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
            icon: message.isLiked
                ? Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.black26,
                  ),
            onPressed: () {
              toggleLike();
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessage(widget.message, widget.isCurrentUser);
  }
}
