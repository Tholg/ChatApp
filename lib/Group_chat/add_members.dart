import 'package:chat_app/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMemberToGroups extends StatefulWidget {
  final String groupId, groupName;
  final List memberList;
  const AddMemberToGroups(
      {required this.groupId,
      required this.groupName,
      required this.memberList,
      super.key});

  @override
  State<AddMemberToGroups> createState() => _AddMemberToGroupsState();
}

class _AddMemberToGroupsState extends State<AddMemberToGroups> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;
  List membersList = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersList = widget.memberList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      // print(userMap);
    });
  }

  void onAddMember() async {
    membersList.add({
      "name": userMap!['name'],
      "email": userMap!['email'],
      "uid": userMap!['uid'],
      "isAdmin": false,
    });
    await _firestore.collection('groups').doc(widget.groupId).update({
      "member": membersList,
    });
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .doc(widget.groupId)
        .set({
      "name": widget.groupName,
      "id": widget.groupId,
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      body: isLoading
          ? Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                isLoading
                    ? Container(
                        height: size.height / 20,
                        width: size.width / 20,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: onSearch,
                        child: Text("Search"),
                      ),
                userMap != null
                    ? ListTile(
                        onTap: onAddMember,
                        leading: Icon(Icons.account_box),
                        title: Text(userMap!['name']),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.add),
                      )
                    : SizedBox()
              ],
            )),
    );
  }
}
