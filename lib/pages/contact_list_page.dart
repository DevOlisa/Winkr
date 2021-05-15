import 'package:flutter/material.dart';
import 'package:winkr/model/users.dart';
import 'package:winkr/widgets/ContactListTile.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  var sort = people.sort((a, b) => a.name.compareTo(b.name));
  List<User> contactsToDisplay = people;

  TextEditingController _searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchFieldController.addListener(() {
      print("Calling Search Contact Function");
      searchContacts(_searchFieldController.text);
    });
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //     height: 64.0,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //         // color: Colors.white,
        //         // borderRadius: BorderRadius.all(Radius.circular(15.0),)
        //         ),
        //     margin: EdgeInsets.all(0.0),
        //     child: TextField(
        //       onChanged: (String value) async {
        //         setState(() {
        //           searchContacts(value);
        //         });
        //       },
        //       onEditingComplete: () {
        //         setState(() {});
        //       },
        //       controller: _searchFieldController,
        //       textAlignVertical: TextAlignVertical.center,
        //       cursorHeight: 24.0,
        //       cursorColor: Colors.white,
        //       decoration: InputDecoration(
        //         hintText: "Search Contacts",
        //         prefixIcon: Icon(
        //           Icons.search_rounded,
        //           color: Colors.white,
        //         ),
        //       ),
        //     )),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
          ),
          child: Scrollbar(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: contactsToDisplay.length,
                itemBuilder: (context, index) {
                  final User contact = contactsToDisplay[index];
                  return ContactListTile(contact: contact);
                }),
          ),
        )),
      ],
    );
  }

  void searchContacts(String query) {
    List<User> matches = [];
    RegExp exp = RegExp(query.toLowerCase(), caseSensitive: false);
    if (query.isEmpty || query == null) {
      contactsToDisplay = people;
      return;
    } else {
      people.forEach((element) {
        if (exp.matchAsPrefix(element.name.toLowerCase()) != null) {
          matches.add(element);
          print(element.name);
        }
      });
    }
    setState(() {
      contactsToDisplay = matches;
    });
  }
}
