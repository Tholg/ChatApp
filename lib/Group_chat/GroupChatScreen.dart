import 'package:chat_app/Group_chat/Group_chat_room.dart';
import 'package:chat_app/Group_chat/create_group.dart/add_member.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({super.key});

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  List groupList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvailableGroup();
  }

  void getAvailableGroup() async {
    String uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      groupList = value.docs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Group")),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => GroupChatRoom(
                            groupChatName: groupList[index]['name'],
                            groupChatId: groupList[index]['id'],
                          ))),
                  leading: Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMemberInGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
