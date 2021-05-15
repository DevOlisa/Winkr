import 'package:intl/intl.dart';
import 'package:winkr/model/users.dart';

DateFormat hmm = DateFormat("HH:mm");

/// {@template winkr/model/message.dart}
/// [Message] class manage the message model. [Message.sender],
/// [Message.recipient]
/// cannot null for any instance of this class and must be provided during
///  instantiation
///
/// `Messsage.image()` constructor creates an Image Message model which contains an
/// [imageUrl] property
///
/// `getCreatedTime()` method return the time the instance was created in HH:MM format
/// {@endtemplate}
///

///Message msg = new Message(people[0], people[5], DateTime.now(), "Hello");

///

class Message {
  final User sender;
  final User recipient;
  final DateTime created = DateTime.now();
  int chatRoomId;
  bool isLiked = false;
  bool isRead;
  String text;
  String imageUrl;
  Message quoted;

  String getCreatedTime() {
    return hmm.format(this.created);
  }

  Message(this.sender, this.recipient, this.text);

  Message.image(this.sender, this.recipient, this.imageUrl);
}

List<Message> messages = [
  Message(people[0], user, "Hi Handsome!"),
  Message(user, people[0], "Hey, sup"),
  Message(people[0], user, "I'm okay"),
  Message(people[0], user, "How are you doing?"),
  Message(user, people[0], "Just...chilling"),
];

class ChatRoom {
  User _participant;

  User get participant => _participant;

  set participant(User participant) {
    _participant = participant;
  }

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  set messages(List<Message> messages) {
    _messages = messages;
  }

  DateTime lastMessageCreated = DateTime.now();
  bool hasUnread;

  ChatRoom(this._participant);

  /// This takes a single argument of type [Message] and appends it to the list
  /// messages
  bool addMessage(Message newMessage) {
    this.messages.add(newMessage);
    if (messages.contains(newMessage)) return true;
    return false;
  }

  /// This will remove the first ocurrence of the [Message] object in the list
  void deleteMessage(Message newMessage) {
    this.messages.remove(newMessage);
    // this.messages.join(',');
  }
}

List<ChatRoom> chatRooms = [];
