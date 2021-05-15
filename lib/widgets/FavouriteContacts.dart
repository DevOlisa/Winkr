import 'package:flutter/material.dart';
import 'package:winkr/model/users.dart';

class FavouriteContacts extends StatelessWidget {
  const FavouriteContacts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          child: Text(
            "Favourite Contacts",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 100.0,
          decoration: BoxDecoration(
              // color: Colors.lightBlue,
              ),
          child: ListView.builder(
            itemCount: user.favourites.length,
            itemBuilder: (context, index) {
              User favourite = user.favourites[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 10.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          AssetImage('assets/profile_pics/' + favourite.pic),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      favourite.name,
                      style: TextStyle(color: Colors.black38),
                    ),
                  ],
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        )
        //
      ],
    );
  }
}
