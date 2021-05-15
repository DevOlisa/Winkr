import 'package:flutter/material.dart';
import 'package:winkr/widgets/GroupTile.dart';

class GroupGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groups = ["home", "school", "work", "others", "AA", "ToastMasters"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            height: 40.0,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 7 / 8,
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GroupTile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
