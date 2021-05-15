import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController searchFieldController;
  final Function listener;

  SearchBar({Key key, this.searchFieldController, this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        height: 64.0,
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.close_rounded),
            onPressed: () {},
          ),
          Container(
              height: 64.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: Colors.white,
                  // borderRadius: BorderRadius.all(Radius.circular(15.0),)
                  ),
              margin: EdgeInsets.all(0.0),
              child: TextField(
                onChanged: listener,
                // onEditingComplete: () {
                //   setState(() {});
                // },
                controller: searchFieldController,
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 24.0,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Search Contacts",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
