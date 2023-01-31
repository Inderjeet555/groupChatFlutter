import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_chat/pages/group_info.dart';
import 'package:group_chat/service/database_Service.dart';
import 'package:group_chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;
  ChatPage(
      {Key? key,
      required this.userName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String adminName = "";
  Stream<QuerySnapshot>? chats;
  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      chats = value;
    });

    DatabaseService().getAdminName(widget.groupId).then((value) {
      adminName = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatandAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      admiName: adminName,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
    );
  }
}
