import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_chat/pages/chat_page.dart';
import 'package:group_chat/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;
  GroupTile(
      {Key? key,
      required this.userName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage(userName: widget.userName, groupId: widget.groupId, groupName: widget.groupName,));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'join the conversation as ${widget.userName}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
