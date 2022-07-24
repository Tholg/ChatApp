import 'package:chat_app/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> memberList;
  const CreateGroup({required this.memberList, super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    String greoupId = Uuid().v1();
    await _firestore.collection('groups').doc(greoupId).set({
      "member": widget.memberList,
      "id": greoupId,
    });
    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(greoupId)
          .set({
        "name": _groupName.text,
        "id": greoupId,
      });
    }
    await _firestore
        .collection('groups')
        .doc(greoupId)
        .collection('chats')
        .add({
      "message": "${_auth.currentUser!.displayName} Create this Group",
      "type": "notify",
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (router) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Group name")),
      body: isLoading
          ? Container(
              height: size.height / 20,
              width: size.width / 20,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                          hintText: "Enter Group Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                    onPressed: createGroup, child: Text("Create Group")),
              ],
            ),
    );
  }
}
