import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/helper/helperFunctions.dart';
import 'package:group_chat/pages/chat_page.dart';
import 'package:group_chat/service/database_Service.dart';
import 'package:group_chat/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? querySnapshot;
  bool _hasUserSerached = false;
  String _userName = '';
  User? user;
  bool _isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    joinedOrNot(groupName, groupId, userName, admin);    
    print(_isJoined);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Admin: ${admin.substring(admin.indexOf("_") + 1)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupName, groupId, userName)
              .then((value) {
            if (_isJoined) {
              setState(() {
                _isJoined = !_isJoined;
              });
              showSnackBar(
                  context, Colors.green, 'Sucessfully joined the group!');
              Future.delayed(const Duration(seconds: 2), () {
                nextScreen(
                    context,
                    ChatPage(
                        userName: userName,
                        groupName: groupName,
                        groupId: groupId));
              });
            } else {
              setState(() {
                _isJoined = !_isJoined;
              });
              showSnackBar(context, Colors.red, "Left the group$groupName");
            }
          });
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'Joined',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'Join Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUsername().then((value) => {_userName = value!});
    user = FirebaseAuth.instance.currentUser;
  }

  groupList() {
    return _hasUserSerached
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: querySnapshot!.docs.length,
            itemBuilder: ((context, index) {
              return groupTile(
                  _userName,
                  querySnapshot!.docs[index]['groupId'],
                  querySnapshot!.docs[index]['groupName'],
                  querySnapshot!.docs[index]['admin']);
            }),
          )
        : Container();
  }

  joinedOrNot(
      String groupName, String groupId, String userName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchGroup(searchController.text)
          .then((value) => {
                setState(() {
                  _isLoading = false;
                  querySnapshot = value;
                  _hasUserSerached = true;
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Search',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 27),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search groups...',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }
}
