import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_chat/pages/home_page.dart';
import 'package:group_chat/service/database_Service.dart';
import 'package:group_chat/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String admiName;
  final String groupName;
  final String groupId;
  const GroupInfo(
      {Key? key,
      required this.admiName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  getGroupMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupMembers();
  }

  String getGroupMemberName(String memberName) {
    return memberName.substring(memberName.indexOf("_") + 1);
  }

  getMemberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                getGroupMemberName(
                                        snapshot.data['members'][index])
                                    .substring(0, 1),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(getGroupMemberName(
                                snapshot.data['members'][index]))),
                      );
                    }));
              } else {
                return const Center(
                  child: Text(
                    'No Members',
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'No Members',
                  style: TextStyle(),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Group Info',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Exit'),
                        content: const Text('Are you sure you want to exit?'),
                        actions: [
                          IconButton(
                              onPressed: () async {
                                //print(widget.admiName.substring(widget.admiName.indexOf("_")+1));
                                await DatabaseService(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupJoin(
                                        widget.groupName,
                                        widget.groupId,
                                        widget.admiName.substring(
                                            widget.admiName.indexOf("_") + 1));
                                Navigator.of(context).pop();
                                Future.delayed(const Duration(seconds: 5), () {
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );
                                  nextScreen(context, const HomePage());
                                });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                          IconButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group: ${widget.groupName}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Admin: ${widget.admiName.substring(widget.admiName.indexOf("_") + 1)}")
                      ],
                    ),
                  )
                ],
              ),
            ),
            getMemberList(),
          ],
        ),
      ),
    );
  }
}
